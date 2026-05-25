"""Database connection and query utilities for ml_service.

Provides connection pooling and helper functions to query subject and focus data.
"""
import logging
from typing import List, Dict, Any, Optional
from contextlib import contextmanager
import psycopg2
from psycopg2 import pool
from psycopg2.extras import RealDictCursor

logger = logging.getLogger(__name__)


class DatabaseManager:
    """Manages PostgreSQL database connections with connection pooling."""
    
    def __init__(self, database_url: str, min_connections: int = 1, max_connections: int = 10):
        """Initialize database connection pool.
        
        Args:
            database_url: PostgreSQL connection URL
            min_connections: Minimum number of connections in pool
            max_connections: Maximum number of connections in pool
        """
        self.database_url = database_url
        self._pool = None
        self.min_connections = min_connections
        self.max_connections = max_connections
        
    def init_pool(self):
        """Initialize the connection pool."""
        if self._pool is not None:
            logger.warning("Database pool already initialized")
            return
            
        try:
            self._pool = psycopg2.pool.SimpleConnectionPool(
                self.min_connections,
                self.max_connections,
                self.database_url
            )
            logger.info(f"Database connection pool initialized ({self.min_connections}-{self.max_connections} connections)")
        except Exception as e:
            logger.error(f"Failed to initialize database pool: {e}")
            raise
    
    def close_pool(self):
        """Close all connections in the pool."""
        if self._pool:
            self._pool.closeall()
            self._pool = None
            logger.info("Database connection pool closed")
    
    @contextmanager
    def get_connection(self):
        """Get a database connection from the pool.
        
        Yields:
            psycopg2.connection: Database connection
        """
        if self._pool is None:
            raise RuntimeError("Database pool not initialized. Call init_pool() first.")
        
        conn = None
        try:
            conn = self._pool.getconn()
            yield conn
        finally:
            if conn:
                self._pool.putconn(conn)
    
    def get_subjects_with_focus(self, study_program_id: int, limit: Optional[int] = None) -> List[Dict[str, Any]]:
        """Fetch subjects with their focus vectors for a study program.
        
        Args:
            study_program_id: Study program ID (3=INF, 4=Management)
            limit: Optional limit on number of subjects
            
        Returns:
            List of subject dictionaries with focus vectors
        """
        query = """
            SELECT 
                s.subject_id as id,
                s.name,
                s.code,
                s.abbreviation,
                f.math_focus,
                f.logic_focus,
                f.programming_focus,
                f.design_focus,
                f.economics_focus,
                f.management_focus,
                f.hardware_focus,
                f.network_focus,
                f.data_focus,
                f.testing_focus,
                f.language_focus,
                f.physical_focus
            FROM subject s
            INNER JOIN focus f ON s.subject_id = f.subject_id
            INNER JOIN study_program_subject sps ON s.subject_id = sps.subject_id
            WHERE sps.study_program_id = %s
            ORDER BY s.subject_id
        """
        
        if limit:
            query += f" LIMIT {int(limit)}"
        
        try:
            with self.get_connection() as conn:
                with conn.cursor(cursor_factory=RealDictCursor) as cur:
                    cur.execute(query, (study_program_id,))
                    rows = cur.fetchall()
                    
                    # Convert to list of dicts with focus_vector
                    subjects = []
                    for row in rows:
                        subject = dict(row)
                        subject["focus_vector"] = [
                            subject.pop("math_focus"),
                            subject.pop("logic_focus"),
                            subject.pop("programming_focus"),
                            subject.pop("design_focus"),
                            subject.pop("economics_focus"),
                            subject.pop("management_focus"),
                            subject.pop("hardware_focus"),
                            subject.pop("network_focus"),
                            subject.pop("data_focus"),
                            subject.pop("testing_focus"),
                            subject.pop("language_focus"),
                            subject.pop("physical_focus"),
                        ]
                        subjects.append(subject)
                    
                    logger.debug(f"Fetched {len(subjects)} subjects for study program {study_program_id}")
                    return subjects
                    
        except Exception as e:
            logger.error(f"Error fetching subjects: {e}")
            raise
    
    def get_subject_by_id(self, subject_id: int) -> Optional[Dict[str, Any]]:
        """Fetch a single subject with its focus vector.
        
        Args:
            subject_id: Subject ID
            
        Returns:
            Subject dictionary with focus vector, or None if not found
        """
        query = """
            SELECT 
                s.subject_id as id,
                s.name,
                s.code,
                s.abbreviation,
                f.math_focus,
                f.logic_focus,
                f.programming_focus,
                f.design_focus,
                f.economics_focus,
                f.management_focus,
                f.hardware_focus,
                f.network_focus,
                f.data_focus,
                f.testing_focus,
                f.language_focus,
                f.physical_focus
            FROM subject s
            INNER JOIN focus f ON s.subject_id = f.subject_id
            WHERE s.subject_id = %s
        """
        
        try:
            with self.get_connection() as conn:
                with conn.cursor(cursor_factory=RealDictCursor) as cur:
                    cur.execute(query, (subject_id,))
                    row = cur.fetchone()
                    
                    if not row:
                        return None
                    
                    subject = dict(row)
                    subject["focus_vector"] = [
                        subject.pop("math_focus"),
                        subject.pop("logic_focus"),
                        subject.pop("programming_focus"),
                        subject.pop("design_focus"),
                        subject.pop("economics_focus"),
                        subject.pop("management_focus"),
                        subject.pop("hardware_focus"),
                        subject.pop("network_focus"),
                        subject.pop("data_focus"),
                        subject.pop("testing_focus"),
                        subject.pop("language_focus"),
                        subject.pop("physical_focus"),
                    ]
                    
                    return subject
                    
        except Exception as e:
            logger.error(f"Error fetching subject {subject_id}: {e}")
            raise
    
    def test_connection(self) -> bool:
        """Test database connectivity.
        
        Returns:
            True if connection successful, False otherwise
        """
        try:
            with self.get_connection() as conn:
                with conn.cursor() as cur:
                    cur.execute("SELECT 1")
                    result = cur.fetchone()
                    return result[0] == 1
        except Exception as e:
            logger.error(f"Database connection test failed: {e}")
            return False


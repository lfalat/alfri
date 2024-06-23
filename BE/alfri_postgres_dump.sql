--
-- PostgreSQL database dump
--

-- Dumped from database version 16.2 (Debian 16.2-1.pgdg120+2)
-- Dumped by pg_dump version 16.2 (Debian 16.2-1.pgdg120+2)

SET statement_timeout = 0;
SET lock_timeout = 0;
SET idle_in_transaction_session_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SELECT pg_catalog.set_config('search_path', '', false);
SET check_function_bodies = false;
SET xmloption = content;
SET client_min_messages = warning;
SET row_security = off;

SET default_tablespace = '';

SET default_table_access_method = heap;

-- CREATE USER alfri_be WITH PASSWORD 'password123';
GRANT ALL PRIVILEGES ON ALL TABLES IN SCHEMA public TO alfri_be;
GRANT ALL PRIVILEGES ON ALL SEQUENCES IN SCHEMA public TO alfri_be;

--
-- Name: answer_type; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.answer_type
(
    answer_type_id integer               NOT NULL,
    name           character varying(50) NOT NULL
);


ALTER TABLE public.answer_type
    OWNER TO postgres;

--
-- Name: answer_type_answer_type_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.answer_type_answer_type_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.answer_type_answer_type_id_seq OWNER TO postgres;

--
-- Name: answer_type_answer_type_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.answer_type_answer_type_id_seq OWNED BY public.answer_type.answer_type_id;


--
-- Name: focus; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.focus
(
    math_focus        integer NOT NULL,
    logic_focus       integer NOT NULL,
    programming_focus integer NOT NULL,
    design_focus      integer NOT NULL,
    economics_focus   integer NOT NULL,
    management_focus  integer NOT NULL,
    hardware_focus    integer NOT NULL,
    network_focus     integer NOT NULL,
    data_focus        integer NOT NULL,
    testing_focus     integer NOT NULL,
    language_focus    integer NOT NULL,
    physical_focus    integer NOT NULL,
    subject_id        integer NOT NULL
);


ALTER TABLE public.focus
    OWNER TO postgres;

--
-- Name: TABLE focus; Type: COMMENT; Schema: public; Owner: postgres
--

COMMENT ON TABLE public.focus IS 'public.subject''s focuses';


--
-- Name: numeric_answer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.numeric_answer
(
    questionnaire_id integer                                   NOT NULL,
    question_id      integer                                   NOT NULL,
    user_id          integer                                   NOT NULL,
    answer_type_id   integer                                   NOT NULL,
    answer           numeric                                   NOT NULL,
    "timestamp"      timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.numeric_answer
    OWNER TO postgres;

--
-- Name: option; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.option
(
    option_id   integer                NOT NULL,
    question_id integer                NOT NULL,
    name        character varying(100) NOT NULL
);


ALTER TABLE public.option
    OWNER TO postgres;

--
-- Name: option_option_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.option_option_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.option_option_id_seq OWNER TO postgres;

--
-- Name: option_option_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.option_option_id_seq OWNED BY public.option.option_id;


--
-- Name: option_options_answer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.option_options_answer
(
    option_id         integer NOT NULL,
    options_answer_id integer NOT NULL
);


ALTER TABLE public.option_options_answer
    OWNER TO postgres;

--
-- Name: options_answer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.options_answer
(
    answer_type_id    integer                                   NOT NULL,
    questionnaire_id  integer                                   NOT NULL,
    question_id       integer                                   NOT NULL,
    user_id           integer                                   NOT NULL,
    "timestamp"       timestamp without time zone DEFAULT now() NOT NULL,
    options_answer_id integer                                   NOT NULL
);


ALTER TABLE public.options_answer
    OWNER TO postgres;

--
-- Name: options_answer_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.options_answer_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.options_answer_seq OWNER TO postgres;

--
-- Name: question; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.question
(
    question_id               integer NOT NULL,
    questionnaire_id          integer NOT NULL,
    answer_type_id            integer NOT NULL,
    position_in_questionnaire integer NOT NULL,
    content                   text    NOT NULL,
    optional                  boolean NOT NULL
);


ALTER TABLE public.question
    OWNER TO postgres;

--
-- Name: question_question_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.question_question_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.question_question_id_seq OWNER TO postgres;

--
-- Name: question_question_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.question_question_id_seq OWNED BY public.question.question_id;


--
-- Name: questionnaire; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.questionnaire
(
    questionnaire_id integer                                   NOT NULL,
    title            character varying(100)                    NOT NULL,
    description      text                                      NOT NULL,
    date_of_creation timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.questionnaire
    OWNER TO postgres;

--
-- Name: questionnaire_questionnaire_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.questionnaire_questionnaire_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.questionnaire_questionnaire_id_seq OWNER TO postgres;

--
-- Name: questionnaire_questionnaire_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.questionnaire_questionnaire_id_seq OWNED BY public.questionnaire.questionnaire_id;


--
-- Name: role; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.role
(
    role_id integer               NOT NULL,
    name    character varying(50) NOT NULL
);


ALTER TABLE public.role
    OWNER TO postgres;

--
-- Name: role_role_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.role_role_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.role_role_id_seq OWNER TO postgres;

--
-- Name: role_role_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.role_role_id_seq OWNED BY public.role.role_id;


--
-- Name: student; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student
(
    student_id       integer NOT NULL,
    user_id          integer,
    study_program_id integer NOT NULL,
    year             integer NOT NULL
);


ALTER TABLE public.student
    OWNER TO postgres;

--
-- Name: student_id; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.student_id
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.student_id OWNER TO postgres;

--
-- Name: student_id; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.student_id OWNED BY public.student.student_id;


--
-- Name: student_subject; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.student_subject
(
    student_id integer NOT NULL,
    subject_id integer NOT NULL,
    mark       character varying(2),
    year       integer NOT NULL
);


ALTER TABLE public.student_subject
    OWNER TO postgres;

--
-- Name: study_program; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.study_program
(
    study_program_id integer                NOT NULL,
    name             character varying(100) NOT NULL
);


ALTER TABLE public.study_program
    OWNER TO postgres;

--
-- Name: study_program_id_sequence; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.study_program_id_sequence
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.study_program_id_sequence OWNER TO postgres;

--
-- Name: study_program_id_sequence; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.study_program_id_sequence OWNED BY public.study_program.study_program_id;


--
-- Name: study_program_subject; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.study_program_subject
(
    study_program_id integer              NOT NULL,
    subject_id       integer              NOT NULL,
    obligation       character varying(4) NOT NULL,
    recommended_year integer              NOT NULL,
    semester_winter  boolean              NOT NULL
);


ALTER TABLE public.study_program_subject
    OWNER TO postgres;

--
-- Name: subject; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.subject
(
    subject_id   integer                NOT NULL,
    name         character varying(100) NOT NULL,
    code         character varying(50)  NOT NULL,
    abbreviation text                   NOT NULL
);


ALTER TABLE public.subject
    OWNER TO postgres;

--
-- Name: subject_subject_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.subject_subject_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER SEQUENCE public.subject_subject_id_seq OWNER TO postgres;

--
-- Name: subject_subject_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.subject_subject_id_seq OWNED BY public.subject.subject_id;


--
-- Name: text_answer; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public.text_answer
(
    answer_type_id   integer                                   NOT NULL,
    questionnaire_id integer                                   NOT NULL,
    question_id      integer                                   NOT NULL,
    user_id          integer                                   NOT NULL,
    answer           text                                      NOT NULL,
    "timestamp"      timestamp without time zone DEFAULT now() NOT NULL
);


ALTER TABLE public.text_answer
    OWNER TO postgres;

--
-- Name: user; Type: TABLE; Schema: public; Owner: postgres
--

CREATE TABLE public."user"
(
    user_id    integer                NOT NULL,
    role_id    integer                NOT NULL,
    email      character varying(100) NOT NULL,
    first_name character varying(50)  NOT NULL,
    last_name  character varying(50)  NOT NULL,
    password   character varying(72)  NOT NULL
);


ALTER TABLE public."user"
    OWNER TO postgres;

--
-- Name: user_user_id_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE public.user_user_id_seq
    AS integer
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


CREATE TABLE public.subject_grades
(
    subject_id     integer NOT NULL,
    grade_a        real    NOT NULL,
    grade_b        real    NOT NULL,
    grade_c        real    NOT NULL,
    grade_d        real    NOT NULL,
    grade_e        real,
    grade_fx       real,
    students_count integer NOT NULL,
    grade_average  real    NOT NULL
);

ALTER TABLE public."subject_grades"
    OWNER TO postgres;


ALTER SEQUENCE public.user_user_id_seq OWNER TO postgres;

--
-- Name: user_user_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE public.user_user_id_seq OWNED BY public."user".user_id;


--
-- Name: answer_type answer_type_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.answer_type
    ALTER COLUMN answer_type_id SET DEFAULT nextval('public.answer_type_answer_type_id_seq'::regclass);


--
-- Name: option option_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.option
    ALTER COLUMN option_id SET DEFAULT nextval('public.option_option_id_seq'::regclass);


--
-- Name: question question_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question
    ALTER COLUMN question_id SET DEFAULT nextval('public.question_question_id_seq'::regclass);


--
-- Name: questionnaire questionnaire_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questionnaire
    ALTER COLUMN questionnaire_id SET DEFAULT nextval('public.questionnaire_questionnaire_id_seq'::regclass);


--
-- Name: role role_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role
    ALTER COLUMN role_id SET DEFAULT nextval('public.role_role_id_seq'::regclass);


--
-- Name: student student_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ALTER COLUMN student_id SET DEFAULT nextval('public.student_id'::regclass);


--
-- Name: study_program study_program_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_program
    ALTER COLUMN study_program_id SET DEFAULT nextval('public.study_program_id_sequence'::regclass);


--
-- Name: subject subject_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subject
    ALTER COLUMN subject_id SET DEFAULT nextval('public.subject_subject_id_seq'::regclass);


--
-- Name: user user_id; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ALTER COLUMN user_id SET DEFAULT nextval('public.user_user_id_seq'::regclass);

--
-- Name: answer_type_answer_type_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.answer_type_answer_type_id_seq', 3, true);


--
-- Name: option_option_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.option_option_id_seq', 2, true);


--
-- Name: options_answer_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.options_answer_seq', 1, false);


--
-- Name: question_question_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.question_question_id_seq', 4, true);


--
-- Name: questionnaire_questionnaire_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.questionnaire_questionnaire_id_seq', 2, true);


--
-- Name: role_role_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.role_role_id_seq', 5, true);


--
-- Name: student_id; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.student_id', 4, true);


--
-- Name: study_program_id_sequence; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.study_program_id_sequence', 3, true);


--
-- Name: subject_subject_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.subject_subject_id_seq', 175, true);


--
-- Name: user_user_id_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('public.user_user_id_seq', 9, true);


--
-- Name: answer_type answer_type_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.answer_type
    ADD CONSTRAINT answer_type_pk PRIMARY KEY (answer_type_id);


--
-- Name: focus focus_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.focus
    ADD CONSTRAINT focus_pk PRIMARY KEY (subject_id);


--
-- Name: numeric_answer numeric_answer_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.numeric_answer
    ADD CONSTRAINT numeric_answer_pk PRIMARY KEY (question_id, questionnaire_id, user_id);


--
-- Name: option_options_answer option_options_answer_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.option_options_answer
    ADD CONSTRAINT option_options_answer_pk PRIMARY KEY (options_answer_id, option_id);


--
-- Name: option option_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.option
    ADD CONSTRAINT option_pk PRIMARY KEY (option_id);


--
-- Name: options_answer options_answer_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.options_answer
    ADD CONSTRAINT options_answer_pk PRIMARY KEY (options_answer_id);


--
-- Name: question question_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question
    ADD CONSTRAINT question_pk PRIMARY KEY (question_id);


--
-- Name: questionnaire questionnaire_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.questionnaire
    ADD CONSTRAINT questionnaire_pk PRIMARY KEY (questionnaire_id);


--
-- Name: role role_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.role
    ADD CONSTRAINT role_pk PRIMARY KEY (role_id);


--
-- Name: student student_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_pk PRIMARY KEY (student_id);


--
-- Name: student_subject student_subject_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_subject
    ADD CONSTRAINT student_subject_pk PRIMARY KEY (student_id, subject_id);


--
-- Name: study_program study_program_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_program
    ADD CONSTRAINT study_program_pk PRIMARY KEY (study_program_id);


--
-- Name: study_program_subject study_program_subject_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_program_subject
    ADD CONSTRAINT study_program_subject_pk PRIMARY KEY (subject_id, study_program_id);


--
-- Name: subject subject_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.subject
    ADD CONSTRAINT subject_pk PRIMARY KEY (subject_id);


--
-- Name: text_answer text_answer_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.text_answer
    ADD CONSTRAINT text_answer_pk PRIMARY KEY (questionnaire_id, question_id, user_id);


--
-- Name: user user_email_unique; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_email_unique UNIQUE (email);


--
-- Name: user user_pk; Type: CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_pk PRIMARY KEY (user_id);

ALTER TABLE ONLY public.subject_grades
    ADD CONSTRAINT subject_grades_pk PRIMARY KEY (subject_id);

--
-- Name: focus focus_subject_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.focus
    ADD CONSTRAINT focus_subject_id_fk FOREIGN KEY (subject_id) REFERENCES public.subject (subject_id);


--
-- Name: numeric_answer numeric_answer__question_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.numeric_answer
    ADD CONSTRAINT numeric_answer__question_fk FOREIGN KEY (question_id) REFERENCES public.question (question_id);


--
-- Name: numeric_answer numeric_answer__questionnaire_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.numeric_answer
    ADD CONSTRAINT numeric_answer__questionnaire_fk FOREIGN KEY (questionnaire_id) REFERENCES public.questionnaire (questionnaire_id);


--
-- Name: numeric_answer numeric_answer__user_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.numeric_answer
    ADD CONSTRAINT numeric_answer__user_fk FOREIGN KEY (user_id) REFERENCES public."user" (user_id);


--
-- Name: numeric_answer numeric_answer_answer_type_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.numeric_answer
    ADD CONSTRAINT numeric_answer_answer_type_id_fk FOREIGN KEY (answer_type_id) REFERENCES public.answer_type (answer_type_id);


--
-- Name: option_options_answer option_options_answer__answer_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.option_options_answer
    ADD CONSTRAINT option_options_answer__answer_fk FOREIGN KEY (options_answer_id) REFERENCES public.options_answer (options_answer_id);


--
-- Name: option_options_answer option_options_answer__option_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.option_options_answer
    ADD CONSTRAINT option_options_answer__option_fk FOREIGN KEY (option_id) REFERENCES public.option (option_id);


--
-- Name: option option_question_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.option
    ADD CONSTRAINT option_question_id_fk FOREIGN KEY (question_id) REFERENCES public.question (question_id);


--
-- Name: options_answer options_answer_answer_type_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.options_answer
    ADD CONSTRAINT options_answer_answer_type_id_fk FOREIGN KEY (answer_type_id) REFERENCES public.answer_type (answer_type_id);


--
-- Name: options_answer options_answer_question_question_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.options_answer
    ADD CONSTRAINT options_answer_question_question_id_fk FOREIGN KEY (question_id) REFERENCES public.question (question_id);


--
-- Name: options_answer options_answer_questionnaire_questionnaire_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.options_answer
    ADD CONSTRAINT options_answer_questionnaire_questionnaire_id_fk FOREIGN KEY (questionnaire_id) REFERENCES public.questionnaire (questionnaire_id);


--
-- Name: options_answer options_answer_user_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.options_answer
    ADD CONSTRAINT options_answer_user_user_id_fk FOREIGN KEY (user_id) REFERENCES public."user" (user_id);


--
-- Name: question question_answer_type_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question
    ADD CONSTRAINT question_answer_type_fk FOREIGN KEY (answer_type_id) REFERENCES public.answer_type (answer_type_id);


--
-- Name: question question_questionnaire_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.question
    ADD CONSTRAINT question_questionnaire_fk FOREIGN KEY (questionnaire_id) REFERENCES public.questionnaire (questionnaire_id);


--
-- Name: student student_study_program_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_study_program_id_fk FOREIGN KEY (study_program_id) REFERENCES public.study_program (study_program_id);


--
-- Name: student_subject student_subject__student_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_subject
    ADD CONSTRAINT student_subject__student_fk FOREIGN KEY (student_id) REFERENCES public.student (student_id);


--
-- Name: student_subject student_subject__subject_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student_subject
    ADD CONSTRAINT student_subject__subject_fk FOREIGN KEY (subject_id) REFERENCES public.subject (subject_id);


--
-- Name: student student_user_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.student
    ADD CONSTRAINT student_user_id_fk FOREIGN KEY (user_id) REFERENCES public."user" (user_id);


--
-- Name: study_program_subject study_program_subject__study_program_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_program_subject
    ADD CONSTRAINT study_program_subject__study_program_fk FOREIGN KEY (study_program_id) REFERENCES public.study_program (study_program_id);


--
-- Name: study_program_subject study_program_subject__subject_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.study_program_subject
    ADD CONSTRAINT study_program_subject__subject_fk FOREIGN KEY (subject_id) REFERENCES public.subject (subject_id);


--
-- Name: text_answer text_answer_answer_type_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public.text_answer
    ADD CONSTRAINT text_answer_answer_type_id_fk FOREIGN KEY (answer_type_id) REFERENCES public.answer_type (answer_type_id);


--
-- Name: user user_role_id_fk; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY public."user"
    ADD CONSTRAINT user_role_id_fk FOREIGN KEY (role_id) REFERENCES public.role (role_id);


ALTER TABLE ONLY public.subject_grades
    ADD CONSTRAINT subject_grades__subject_id_fk FOREIGN KEY (subject_id) REFERENCES public.subject (subject_id);


--
-- Name: TABLE answer_type; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.answer_type TO alfri_be;


--
-- Name: SEQUENCE answer_type_answer_type_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.answer_type_answer_type_id_seq TO alfri_be;


--
-- Name: TABLE focus; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.focus TO alfri_be;


--
-- Name: TABLE numeric_answer; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.numeric_answer TO alfri_be;


--
-- Name: TABLE option; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.option TO alfri_be;


--
-- Name: SEQUENCE option_option_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.option_option_id_seq TO alfri_be;


--
-- Name: TABLE option_options_answer; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.option_options_answer TO alfri_be;


--
-- Name: TABLE options_answer; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.options_answer TO alfri_be;


--
-- Name: TABLE question; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.question TO alfri_be;


--
-- Name: SEQUENCE question_question_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.question_question_id_seq TO alfri_be;


--
-- Name: TABLE questionnaire; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.questionnaire TO alfri_be;


--
-- Name: SEQUENCE questionnaire_questionnaire_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.questionnaire_questionnaire_id_seq TO alfri_be;


--
-- Name: TABLE role; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.role TO alfri_be;


--
-- Name: SEQUENCE role_role_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.role_role_id_seq TO alfri_be;


--
-- Name: TABLE student; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.student TO alfri_be;


--
-- Name: SEQUENCE student_id; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.student_id TO alfri_be;


--
-- Name: TABLE student_subject; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.student_subject TO alfri_be;


--
-- Name: TABLE study_program; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.study_program TO alfri_be;


--
-- Name: TABLE study_program_subject; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.study_program_subject TO alfri_be;


--
-- Name: TABLE subject; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.subject TO alfri_be;

GRANT ALL ON TABLE public.subject_grades TO alfri_be;


--
-- Name: SEQUENCE subject_subject_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.subject_subject_id_seq TO alfri_be;


--
-- Name: TABLE text_answer; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public.text_answer TO alfri_be;


--
-- Name: TABLE "user"; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON TABLE public."user" TO alfri_be;


--
-- Name: SEQUENCE user_user_id_seq; Type: ACL; Schema: public; Owner: postgres
--

GRANT ALL ON SEQUENCE public.user_user_id_seq TO alfri_be;



INSERT INTO public.answer_type (answer_type_id, name)
VALUES (1, 'numeric');
INSERT INTO public.answer_type (answer_type_id, name)
VALUES (2, 'option');
INSERT INTO public.answer_type (answer_type_id, name)
VALUES (3, 'text');


INSERT INTO public.role (role_id, name)
VALUES (2, 'teacher');
INSERT INTO public.role (role_id, name)
VALUES (1, 'student');
INSERT INTO public.role (role_id, name)
VALUES (3, 'visitor');

INSERT INTO public.study_program (study_program_id, name)
VALUES (3, 'informatika');

INSERT INTO public.questionnaire (questionnaire_id, title, description, date_of_creation)
VALUES (2, 'Úvodný dotazník', 'úvod', '2024-05-23 11:11:21.000000');

INSERT INTO public."user" (user_id, role_id, email, first_name, last_name, password)
VALUES (1, 1, 'nagy1@stud.uniza.sk', 'Adam', 'Nagy', '$2a$10$FWZ7zGzeQGdlMX3Bd.nTTOYyY0n8GtsGdgq53a414w65OPHgOv8Me');
INSERT INTO public."user" (user_id, role_id, email, first_name, last_name, password)
VALUES (2, 1, 'majba@stud.uniza.sk', 'Maroš', 'Majba', '$2a$10$.s7derW1HlXmpRLyTEJjGOZEV6nZEuYYZqAWYXrIauIHLPm9u5mI6');
INSERT INTO public."user" (user_id, role_id, email, first_name, last_name, password)
VALUES (3, 1, 'szathmary@stud.uniza.sk', 'Peter', 'Szathmáry',
        '$2a$10$rcn.t1DBfl67OcbY/5bqmeRGLuSVkueYmp19I/CgfMz0sQuS1UbM2');

INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (89, 'algebra', '6BA0001', 'Alg');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (90, 'matematika pre informatikov', '6BA0009', 'MpInf');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (91, 'úvod do štúdia', '6BH0003', 'ÚŠ');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (92, 'informatika 1', '6BI0011', 'INF1');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (93, 'základy ekonómie', '6BM0027', 'ZE');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (94, 'praktické cvičenia z matematiky 1', '6BA0012', 'PCzM1');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (95, 'praktikum z programovania 1', '6BI0032', 'PrzPr1');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (96, 'slovenský jazyk 1', '6BJ0011', 'JS1');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (97, 'telesná výchova 1', '6BT0001', 'TV1');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (98, 'algoritmická teória grafov', '6BA0002', 'ATG');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (99, 'diskrétna pravdepodobnosť', '6BA0005', 'DPrav');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (100, 'informatika 2', '6BI0012', 'INF2');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (101, 'princípy IKS', '6BI0034', 'PIKS');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (102, 'ekonomické a právne aspekty podnikania', '6BL0001', 'EaPAP');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (103, 'praktické cvičenia z matematiky 2', '6BA0013', 'PCzM2');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (104, 'linux - základy', '6BI0018', 'L-z');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (105, 'praktikum z programovania 2', '6BI0033', 'PrzPr2');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (106, 'úvod do operačných systémov', '6BI0046', 'UdOS');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (107, 'slovenský jazyk 2', '6BJ0012', 'SJ2');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (108, 'telesná výchova 2', '6BT0002', 'TV2');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (109, 'telovýchovné sústredenie 1', '6BT0007', 'TVS1');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (110, 'matematická analýza 1', '6BA0006', 'MatA1');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (111, 'číslicové počítače', '6BI0003', 'ČísPoč');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (112, 'informatika 3', '6BI0013', 'INF3');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (113, 'logické systémy', '6BI0019', 'LogS');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (114, 'strojovo orientované jazyky', '6BI0039', 'SOJaz');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (115, '3D tlač', '6BI0001', '3DT');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (116, 'počítačové siete 1', '6BI0026', 'PS1');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (117, 'analýza procesov', '6UI0005', 'AP');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (118, 'praktické cvičenia z matematiky 3', '6BA0014', 'PCzM3');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (119, 'digitálne meny a blockchain', '6BI0007', 'DMB');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (120, 'otvorené geografické dáta 1', '6BI0023', 'OGD1');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (121, 'UNIX - vývojové prostredie', '6BI0045', 'UNIXVP');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (122, 'jazyk anglický 1', '6BJ0005', 'JA1_inf');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (123, 'ekonómia podniku', '6BM0003', 'EP');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (124, 'povolanie podnikateľ 1', '6BM0019', 'PP1');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (125, 'telesná výchova 3', '6BT0003', 'TV3');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (126, 'telovýchovné sústredenie 2', '6BT0008', 'TVS2');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (127, 'diskrétna optimalizácia', '6BA0004', 'DO');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (128, 'databázové systémy', '6BI0005', 'DS');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (129, 'pravdepodobnosť a štatistika', '6UA0002', 'PaŠ');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (130, 'algoritmy a údajové štruktúry 1', '6UI0004', 'AaUD1');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (131, 'matematická analýza 2', '6BA0007', 'MatA2');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (132, 'jazyk C# a .NET', '6BI0016', 'JCN');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (133, 'počítačové siete 2', '6BI0027', 'PS2');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (134, 'softvérové modelovanie', '6BI0038', 'SF');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (135, 'vývoj aplikácií pre mobilné zariadenia', '6BI0048', 'VAMZ');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (136, 'numerické metódy', '6BA0011', 'NM');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (137, 'sociológia', '6BH0002', 'Soc');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (138, 'metaprogramovanie', '6BI0021', 'MT');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (139, 'otvorené geografické dáta 2', '6BI0024', 'OGD2');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (140, 'techniky programovania 1', '6BI0041', 'TechP1');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (141, 'jazyk anglický 2', '6BJ0006', 'JA2_inf');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (142, 'povolanie podnikateľ 2', '6BM0020', 'PP2');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (143, 'telesná výchova 4', '6BT0004', 'TV4');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (144, 'tabuľkové procesory', '6UI0002', 'TP');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (145, 'elektronické spracovanie a prezentácia dokumentov', '6UI0006', 'ESPD');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (146, 'makroekonómia', '6UM0002', 'ME');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (147, 'princípy operačných systémov', '6BI0035', 'POS');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (148, 'anglický jazyk bc. 1', '6BJ0001', 'AJB1');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (149, 'modelovanie a simulácia', '6UA0003', 'MS');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (150, 'softvérové inžinierstvo', '6UI0010', 'SI');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (151, 'vývoj aplikácií pre internet a intranet', '6UI0012', 'VAII');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (152, 'modelovanie a optimalizácia', '6BA0010', 'ModaOp');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (153, 'počítačové siete 3', '6BI0028', 'PS3');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (154, 'dáta, informácie, znalosti', '6UA0001', 'DIZ');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (155, 'matematická analýza 3', '6BA0008', 'MatA3');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (156, 'python v sieťových aplikáciách', '6BI0037', 'PSA');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (157, 'technické prostriedky PC', '6BI0040', 'TP-PC');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (158, 'techniky programovania 2', '6BI0042', 'TechP2');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (159, 'zabezpečenie sietí zariadeniami Fortinet', '6BI0052', 'ZSZF');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (160, 'základy programovania vo Windows', '6BI0054', 'ZPrvW');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (161, 'základy testovania softvéru', '6BI0055', 'ZTS');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (162, 'ekonómia v praxi', '6BM0029', 'EvP');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (163, 'telesná výchova 5', '6BT0005', 'TV5');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (164, 'internet vecí', '6UI0007', 'IV');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (165, 'dane a rozpočet', '6UM0004', 'DaR');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (166, 'podnikové financie', '6UM0007', 'PF');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (167, 'anglický jazyk bc. 2', '6BJ0002', 'AJB2');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (168, 'prax', '6BX0001', 'Prax');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (169, 'bakalárska práca', '6BZ0001', 'BP');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (170, 'analýza viacrozmerných dát', '6BA0003', 'AVD');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (171, 'implementácie UNIXu-LINUX', '6BI0009', 'IU-Lin');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (172, 'vývoj aplikácií v Unity3D', '6BI0049', 'VAU3D');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (173, 'vývoj pokročilých aplikácií', '6BI0050', 'VPA');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (174, 'telesná výchova 6', '6BT0006', 'TV6');
INSERT INTO public.subject (subject_id, name, code, abbreviation)
VALUES (175, 'manažérska komunikácia', '6UM0005', 'MaKo');

INSERT INTO public.student (student_id, user_id, study_program_id, year)
VALUES (3, 2, 3, 3);
INSERT INTO public.student (student_id, user_id, study_program_id, year)
VALUES (2, 1, 3, 2);
INSERT INTO public.student (student_id, user_id, study_program_id, year)
VALUES (4, 3, 3, 4);


INSERT INTO public.student_subject (student_id, subject_id, mark, year)
VALUES (4, 147, 'B', 3);
INSERT INTO public.student_subject (student_id, subject_id, mark, year)
VALUES (3, 110, 'D', 2);
INSERT INTO public.student_subject (student_id, subject_id, mark, year)
VALUES (2, 108, 'A', 1);
INSERT INTO public.student_subject (student_id, subject_id, mark, year)
VALUES (4, 93, 'C', 1);
INSERT INTO public.student_subject (student_id, subject_id, mark, year)
VALUES (4, 91, 'A', 1);
INSERT INTO public.student_subject (student_id, subject_id, mark, year)
VALUES (4, 89, 'B', 1);
INSERT INTO public.student_subject (student_id, subject_id, mark, year)
VALUES (3, 90, 'A', 1);
INSERT INTO public.student_subject (student_id, subject_id, mark, year)
VALUES (2, 93, 'D', 1);
INSERT INTO public.student_subject (student_id, subject_id, mark, year)
VALUES (2, 90, 'E', 1);
INSERT INTO public.student_subject (student_id, subject_id, mark, year)
VALUES (4, 92, 'B', 1);
INSERT INTO public.student_subject (student_id, subject_id, mark, year)
VALUES (2, 92, 'A', 1);
INSERT INTO public.student_subject (student_id, subject_id, mark, year)
VALUES (2, 91, 'C', 1);
INSERT INTO public.student_subject (student_id, subject_id, mark, year)
VALUES (4, 90, 'A', 1);
INSERT INTO public.student_subject (student_id, subject_id, mark, year)
VALUES (3, 91, 'D', 1);
INSERT INTO public.student_subject (student_id, subject_id, mark, year)
VALUES (2, 89, 'E', 1);
INSERT INTO public.student_subject (student_id, subject_id, mark, year)
VALUES (3, 89, 'C', 1);
INSERT INTO public.student_subject (student_id, subject_id, mark, year)
VALUES (3, 93, 'B', 1);
INSERT INTO public.student_subject (student_id, subject_id, mark, year)
VALUES (3, 92, 'D', 1);

INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 107, 'Výb.', 1, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 96, 'Výb.', 1, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 159, 'Výb.', 3, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 126, 'Výb.', 2, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 140, 'Výb.', 2, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 151, 'Pov.', 3, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 100, 'Pov.', 1, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 95, 'Výb.', 1, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 133, 'P.v.', 2, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 132, 'P.v.', 2, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 173, 'Výb.', 3, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 167, 'Pov.', 3, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 106, 'Výb.', 1, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 125, 'Výb.', 2, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 112, 'Pov.', 2, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 119, 'Výb.', 2, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 118, 'Výb.', 2, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 166, 'Výb.', 3, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 160, 'Výb.', 3, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 108, 'Výb.', 1, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 99, 'Pov.', 1, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 98, 'Pov.', 1, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 117, 'P.v.', 2, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 172, 'Výb.', 3, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 168, 'Pov.', 3, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 162, 'Výb.', 3, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 157, 'Výb.', 3, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 109, 'Výb.', 1, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 153, 'P.v.', 3, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 89, 'Pov.', 1, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 120, 'Výb.', 2, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 101, 'Pov.', 1, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 102, 'Pov.', 1, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 161, 'Výb.', 3, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 94, 'Výb.', 1, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 93, 'Pov.', 1, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 124, 'Výb.', 2, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 175, 'Výb.', 3, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 158, 'Výb.', 3, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 156, 'Výb.', 3, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 152, 'P.v.', 3, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 123, 'Výb.', 2, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 171, 'Výb.', 3, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 169, 'Pov.', 3, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 150, 'Pov.', 3, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 149, 'Pov.', 3, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 148, 'Pov.', 3, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 111, 'Pov.', 2, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 110, 'Pov.', 2, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 170, 'Výb.', 3, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 147, 'Pov.', 3, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 128, 'Pov.', 2, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 91, 'Pov.', 1, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 164, 'Výb.', 3, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 122, 'Výb.', 2, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 155, 'Výb.', 3, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 136, 'Výb.', 2, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 163, 'Výb.', 3, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 103, 'Výb.', 1, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 127, 'Pov.', 2, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 92, 'Pov.', 1, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 114, 'Pov.', 2, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 115, 'P.v.', 2, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 154, 'P.v.', 3, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 146, 'Výb.', 2, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 145, 'Výb.', 2, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 90, 'Pov.', 1, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 121, 'Výb.', 2, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 104, 'Výb.', 1, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 135, 'P.v.', 2, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 144, 'Výb.', 2, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 113, 'Pov.', 2, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 165, 'Výb.', 3, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 116, 'P.v.', 2, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 105, 'Výb.', 1, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 130, 'Pov.', 2, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 142, 'Výb.', 2, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 134, 'P.v.', 2, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 138, 'Výb.', 2, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 129, 'Pov.', 2, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 131, 'P.v.', 2, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 97, 'Výb.', 1, true);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 143, 'Výb.', 2, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 137, 'Výb.', 2, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 139, 'Výb.', 2, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 141, 'Výb.', 2, false);
INSERT INTO public.study_program_subject (study_program_id, subject_id, obligation, recommended_year, semester_winter)
VALUES (3, 174, 'Výb.', 3, false);

INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (10, 8, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 89);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (10, 8, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 90);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (2, 4, 0, 6, 0, 4, 0, 0, 3, 0, 2, 0, 91);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 9, 10, 4, 0, 0, 0, 0, 5, 6, 2, 0, 92);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (6, 6, 0, 0, 10, 3, 0, 0, 2, 0, 0, 0, 93);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (10, 8, 0, 0, 0, 0, 0, 0, 2, 0, 0, 0, 94);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 6, 10, 2, 0, 0, 0, 0, 2, 5, 0, 0, 95);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 4, 0, 0, 0, 5, 0, 0, 0, 0, 10, 0, 96);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 97);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (7, 10, 6, 2, 0, 0, 0, 3, 5, 0, 0, 0, 98);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (10, 7, 0, 0, 0, 0, 0, 0, 8, 0, 0, 0, 99);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 9, 10, 4, 0, 0, 0, 0, 5, 6, 2, 0, 100);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (4, 6, 3, 2, 0, 0, 6, 10, 0, 0, 0, 0, 101);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (2, 4, 0, 8, 10, 10, 0, 0, 0, 0, 0, 0, 102);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (10, 8, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 103);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 8, 8, 0, 0, 0, 4, 7, 0, 0, 0, 0, 104);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 9, 10, 4, 0, 0, 0, 0, 5, 6, 2, 0, 105);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 9, 6, 0, 0, 0, 4, 6, 0, 0, 0, 0, 106);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 4, 0, 0, 0, 5, 0, 0, 0, 0, 10, 0, 107);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 108);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 109);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (10, 8, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 110);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (4, 10, 8, 4, 0, 0, 10, 0, 0, 0, 0, 0, 111);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 9, 10, 4, 0, 0, 0, 0, 5, 6, 2, 0, 112);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (4, 10, 8, 4, 0, 0, 10, 0, 0, 0, 0, 0, 113);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (4, 10, 9, 4, 0, 0, 7, 0, 0, 0, 0, 0, 114);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 4, 0, 10, 0, 0, 10, 0, 0, 0, 0, 0, 115);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 7, 6, 2, 0, 0, 3, 10, 0, 0, 0, 0, 116);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (9, 10, 0, 0, 4, 0, 0, 0, 10, 0, 0, 0, 117);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (10, 8, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 118);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (2, 8, 0, 0, 10, 2, 0, 0, 6, 0, 0, 0, 119);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 4, 2, 8, 0, 0, 0, 0, 6, 0, 0, 0, 120);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 8, 8, 0, 0, 0, 4, 7, 0, 0, 0, 0, 121);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 7, 2, 0, 0, 8, 0, 0, 0, 0, 10, 0, 122);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (2, 4, 0, 6, 10, 10, 0, 0, 0, 0, 0, 0, 123);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (2, 4, 0, 6, 10, 10, 0, 0, 0, 0, 0, 0, 124);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 125);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 126);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (8, 10, 5, 4, 0, 0, 0, 3, 5, 0, 0, 0, 127);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 10, 8, 6, 0, 4, 0, 2, 8, 0, 0, 0, 128);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (9, 10, 0, 0, 4, 2, 0, 0, 10, 0, 0, 0, 129);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (2, 10, 10, 3, 0, 0, 3, 0, 0, 8, 0, 0, 130);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (10, 8, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 131);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 8, 10, 6, 0, 0, 0, 0, 0, 3, 0, 0, 132);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 7, 6, 2, 0, 0, 3, 10, 0, 0, 0, 0, 133);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 6, 3, 10, 0, 6, 0, 2, 0, 6, 0, 0, 134);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 8, 10, 6, 0, 0, 0, 0, 0, 3, 0, 0, 135);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (9, 10, 0, 0, 4, 0, 0, 0, 10, 0, 0, 0, 136);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 6, 0, 4, 7, 10, 0, 0, 4, 0, 0, 0, 137);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 9, 10, 6, 0, 0, 0, 0, 3, 2, 0, 0, 138);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 4, 2, 8, 0, 0, 0, 0, 6, 0, 0, 0, 139);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 9, 10, 8, 0, 0, 0, 0, 2, 4, 0, 0, 140);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 7, 2, 0, 0, 8, 0, 0, 0, 0, 10, 0, 141);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (2, 4, 0, 6, 10, 10, 0, 0, 0, 0, 0, 0, 142);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 143);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (5, 6, 0, 4, 0, 4, 0, 0, 6, 0, 0, 0, 144);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (2, 4, 0, 8, 0, 4, 0, 0, 3, 0, 2, 0, 145);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (5, 4, 0, 6, 10, 7, 0, 0, 3, 0, 0, 0, 146);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 9, 6, 0, 0, 0, 4, 6, 0, 0, 0, 0, 147);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 7, 2, 0, 0, 8, 0, 0, 0, 0, 10, 0, 148);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (3, 9, 4, 7, 3, 5, 0, 0, 10, 6, 0, 0, 149);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 6, 3, 10, 0, 6, 0, 2, 0, 6, 0, 0, 150);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 8, 10, 8, 0, 0, 0, 0, 0, 7, 0, 0, 151);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (3, 6, 4, 5, 2, 5, 0, 0, 10, 6, 0, 0, 152);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 7, 6, 2, 0, 0, 3, 10, 0, 0, 0, 0, 153);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (6, 8, 5, 2, 6, 3, 0, 0, 10, 0, 0, 0, 154);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (10, 8, 0, 0, 0, 0, 0, 0, 4, 0, 0, 0, 155);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 6, 10, 0, 0, 0, 0, 10, 6, 5, 0, 0, 156);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 5, 2, 3, 2, 0, 10, 2, 0, 0, 0, 0, 157);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 9, 10, 8, 0, 0, 0, 0, 2, 4, 0, 0, 158);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 8, 2, 0, 0, 0, 0, 10, 2, 6, 0, 0, 159);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 8, 8, 0, 0, 0, 4, 7, 0, 0, 0, 0, 160);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 4, 7, 0, 0, 0, 0, 0, 0, 10, 0, 0, 161);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (5, 4, 0, 6, 10, 7, 0, 0, 3, 0, 0, 0, 162);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 163);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 8, 8, 7, 0, 0, 9, 10, 0, 3, 0, 0, 164);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (8, 6, 0, 2, 10, 9, 0, 0, 6, 0, 0, 0, 165);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (2, 4, 0, 6, 10, 10, 0, 0, 4, 0, 0, 0, 166);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 7, 2, 0, 0, 8, 0, 0, 0, 0, 10, 0, 167);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 168);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 5, 169);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (7, 9, 3, 0, 7, 0, 0, 0, 10, 5, 0, 0, 170);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 8, 8, 0, 0, 0, 4, 7, 0, 0, 0, 0, 171);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (3, 8, 8, 8, 0, 0, 0, 0, 0, 4, 0, 0, 172);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 10, 9, 6, 0, 0, 4, 8, 0, 4, 0, 0, 173);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 10, 174);
INSERT INTO public.focus (math_focus, logic_focus, programming_focus, design_focus, economics_focus, management_focus,
                          hardware_focus, network_focus, data_focus, testing_focus, language_focus, physical_focus,
                          subject_id)
VALUES (0, 4, 0, 4, 0, 10, 0, 0, 0, 0, 8, 0, 175);

INSERT INTO public.question (question_id, questionnaire_id, answer_type_id, position_in_questionnaire, content,
                             optional)
VALUES (1, 2, 1, 1, '2 plus 2', false);
INSERT INTO public.question (question_id, questionnaire_id, answer_type_id, position_in_questionnaire, content,
                             optional)
VALUES (4, 2, 2, 2, 'Ako sa máš?', true);

INSERT INTO public.option (option_id, question_id, name)
VALUES (1, 4, 'áno');
INSERT INTO public.option (option_id, question_id, name)
VALUES (2, 4, 'nie');

INSERT INTO public.numeric_answer (questionnaire_id, question_id, user_id, answer_type_id, answer, timestamp)
VALUES (2, 1, 1, 1, 4, '2024-05-23 09:15:54.977290');


INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0021'), 0.00, 0.00, 5.88, 0.00, 8.82, 85.29, 34,
        5.7348);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0011'), 3.10, 7.36, 6.98, 14.34, 19.19, 49.03, 516,
        4.8625);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0038'), 5.43, 4.35, 8.70, 20.65, 33.70, 27.17, 92,
        4.5435);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BA0010'), 2.08, 5.21, 13.54, 35.42, 16.67, 27.08, 96,
        4.4063);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BA0004'), 10.81, 2.70, 21.62, 16.22, 10.81, 37.84, 37,
        4.2704);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BA0006'), 8.54, 5.38, 11.39, 14.87, 48.42, 11.39, 316,
        4.2339);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BL0001'), 2.65, 5.30, 19.21, 33.11, 26.49, 13.25, 151,
        4.152699999999999);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6UM0002'), 4.76, 14.29, 14.29, 23.81, 28.57, 14.29, 21,
        4.0004);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6UI0012'), 5.83, 3.33, 20.83, 30.00, 37.50, 2.50, 120,
        3.9748);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0034'), 5.86, 12.55, 18.83, 17.57, 33.89, 11.30, 239,
        3.9498);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6UA0001'), 13.08, 11.21, 14.02, 15.89, 29.91, 15.89, 107,
        3.8601000000000005);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6UA0002'), 16.28, 5.43, 14.73, 17.83, 35.66, 10.08, 129,
        3.8142999999999994);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BA0001'), 12.58, 9.20, 15.34, 22.70, 30.37, 9.82, 326,
        3.7857);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0012'), 8.70, 8.70, 21.74, 23.91, 30.43, 6.52, 46,
        3.7823);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0005'), 4.41, 4.41, 44.12, 22.06, 8.82, 16.18, 68,
        3.7500999999999998);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BA0009'), 7.50, 15.62, 20.00, 23.44, 18.75, 14.69, 320,
        3.7439);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6UI0004'), 1.89, 16.98, 26.42, 30.19, 15.09, 9.43, 53,
        3.6790000000000003);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BT0007'), 46.88, 0.00, 0.00, 0.00, 0.00, 53.12, 64,
        3.6559999999999997);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0026'), 11.76, 13.24, 19.12, 24.26, 22.06, 9.56, 136,
        3.603);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0016'), 6.67, 13.33, 20.00, 33.33, 26.67, 0.00, 15,
        3.6);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BA0008'), 23.08, 7.69, 15.38, 7.69, 38.46, 7.69, 13,
        3.5380000000000003);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0035'), 3.82, 14.01, 33.12, 29.94, 13.38, 5.73, 157,
        3.5224);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0046'), 9.68, 16.13, 16.13, 38.71, 12.90, 6.45, 31,
        3.4837000000000002);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0027'), 21.74, 14.49, 11.59, 15.94, 18.84, 17.39, 69,
        3.4779);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0055'), 11.48, 13.93, 25.41, 27.05, 9.02, 13.11, 122,
        3.4753);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6UI0010'), 7.49, 11.73, 32.57, 27.69, 15.31, 5.21, 307,
        3.4723);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0039'), 21.76, 11.92, 16.58, 11.40, 23.83, 14.51, 193,
        3.4715);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BM0020'), 20.29, 18.84, 20.29, 5.80, 7.25, 27.54, 69,
        3.4353000000000002);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6UM0004'), 16.28, 13.95, 20.93, 23.26, 11.63, 13.95, 43,
        3.4186);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0041'), 0.00, 0.00, 66.67, 33.33, 0.00, 0.00, 3,
        3.3333);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0040'), 16.88, 7.79, 18.18, 40.26, 16.88, 0.00, 77,
        3.3244);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6UI0002'), 22.73, 9.09, 13.64, 22.73, 31.82, 0.00, 22,
        3.3185000000000002);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0042'), 30.77, 15.38, 7.69, 7.69, 15.38, 23.08, 13,
        3.3074);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6UI0005'), 7.14, 17.86, 30.95, 29.76, 10.71, 3.57, 84,
        3.2972);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6UM0007'), 13.48, 16.85, 19.10, 34.83, 11.24, 4.49, 89,
        3.2694);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BA0005'), 8.90, 22.51, 31.41, 15.18, 15.18, 6.81, 191,
        3.2563);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BJ0005'), 5.33, 25.00, 31.97, 23.77, 8.20, 5.74, 244,
        3.2176);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0028'), 8.70, 20.29, 34.78, 15.94, 18.84, 1.45, 69,
        3.2028);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BA0002'), 19.84, 15.87, 23.02, 15.08, 20.63, 5.56, 126,
        3.1746999999999996);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6UA0003'), 10.93, 21.31, 30.05, 21.86, 10.93, 4.92, 183,
        3.1531000000000002);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BJ0006'), 11.92, 21.85, 27.15, 22.52, 12.58, 3.97, 151,
        3.1387);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BM0019'), 22.97, 27.03, 12.16, 6.76, 16.22, 14.86, 74,
        3.1081);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BM0027'), 21.03, 13.10, 29.37, 18.25, 11.90, 6.35, 252,
        3.0594);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6UM0005'), 11.76, 23.53, 29.41, 17.65, 17.65, 0.00, 17,
        3.0589999999999997);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0003'), 9.09, 18.79, 39.39, 26.67, 6.06, 0.00, 165,
        3.0181999999999998);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BZ0001'), 0.00, 0.00, 100.00, 0.00, 0.00, 0.00, 1, 3.0);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0050'), 25.00, 37.50, 0.00, 12.50, 0.00, 25.00, 8, 3.0);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0013'), 28.47, 13.17, 16.01, 21.00, 20.64, 0.71, 281,
        2.943);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BH0003'), 15.44, 23.54, 32.66, 16.71, 8.61, 3.04, 395,
        2.8863);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0001'), 27.33, 19.77, 16.86, 15.12, 18.31, 2.62, 344,
        2.852);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0048'), 30.00, 16.67, 13.33, 26.67, 6.67, 6.67, 30,
        2.8338);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BA0011'), 10.00, 60.00, 10.00, 0.00, 0.00, 20.00, 10,
        2.8);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0019'), 30.41, 17.97, 21.20, 11.98, 17.05, 1.38, 217,
        2.714);;
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BJ0001'), 21.77, 33.58, 27.31, 15.13, 1.48, 0.74, 271,
        2.4322);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0032'), 31.91, 28.72, 17.02, 12.77, 8.51, 1.06, 94,
        2.404);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BA0012'), 51.69, 15.25, 10.59, 4.66, 10.59, 7.20, 236,
        2.2875);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BA0007'), 41.67, 25.00, 12.50, 10.42, 6.25, 4.17, 48,
        2.2712);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0033'), 40.00, 24.00, 20.00, 6.00, 6.00, 4.00, 50,
        2.26);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BH0002'), 42.22, 22.22, 20.00, 2.22, 11.11, 2.22, 45,
        2.2441);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6UI0006'), 40.74, 29.63, 14.81, 3.70, 3.70, 7.41, 27,
        2.2218999999999998);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BA0013'), 48.00, 20.00, 8.00, 20.00, 4.00, 0.00, 25,
        2.12);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BJ0002'), 34.71, 36.36, 19.42, 4.96, 0.83, 3.72, 242,
        2.12);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0049'), 0.00, 100.00, 0.00, 0.00, 0.00, 0.00, 1, 2.0);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BA0014'), 28.07, 54.39, 15.79, 0.00, 1.75, 0.00, 57,
        1.9297);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0024'), 61.54, 15.38, 7.69, 7.69, 7.69, 0.00, 13,
        1.8458);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BM0003'), 69.70, 18.18, 0.00, 3.03, 0.00, 9.09, 33,
        1.7272);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0037'), 76.19, 2.38, 5.95, 7.14, 7.14, 1.19, 84, 1.702);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0009'), 68.42, 21.05, 0.00, 5.26, 0.00, 5.26, 19,
        1.6312);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0045'), 67.27, 18.18, 3.64, 7.27, 3.64, 0.00, 55,
        1.6182999999999998);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0054'), 57.14, 42.86, 0.00, 0.00, 0.00, 0.00, 7,
        1.4286);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0023'), 72.73, 22.73, 0.00, 0.00, 4.55, 0.00, 22,
        1.4094);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0018'), 81.16, 14.01, 3.86, 0.97, 0.00, 0.00, 207,
        1.2464);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BT0001'), 96.12, 0.97, 0.00, 0.49, 0.49, 1.94, 206,
        1.1411);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0007'), 90.71, 6.56, 2.73, 0.00, 0.00, 0.00, 183,
        1.1201999999999999);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BT0003'), 97.27, 0.00, 0.45, 0.45, 0.00, 1.82, 220,
        1.1134);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BT0005'), 98.03, 0.00, 0.00, 0.00, 0.00, 1.97, 152,
        1.0985);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BT0006'), 98.33, 0.83, 0.00, 0.00, 0.00, 0.83, 120,
        1.0497);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BT0002'), 97.96, 1.36, 0.00, 0.00, 0.00, 0.68, 147,
        1.0475999999999999);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6UI0007'), 99.20, 0.00, 0.80, 0.00, 0.00, 0.00, 125,
        1.016);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BT0004'), 99.32, 0.68, 0.00, 0.00, 0.00, 0.00, 148,
        1.0068);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BT0008'), 100.00, 0.00, 0.00, 0.00, 0.00, 0.00, 13, 1.0);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BX0001'), 100.00, 0.00, 0.00, 0.00, 0.00, 0.00, 309, 1.0);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BI0052'), 100.00, 0.00, 0.00, 0.00, 0.00, 0.00, 31, 1.0);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BM0029'), 0, 0, 0, 0, 0, 0, 0, 0.0);
INSERT INTO public.subject_grades (subject_id, grade_a, grade_b, grade_c, grade_d, grade_e, grade_fx, students_count,
                                   grade_average)
VALUES ((SELECT subject_id FROM public.subject WHERE code = '6BA0003'), 0, 0, 0, 0, 0, 0, 0, 0.0);

--
-- PostgreSQL database dump complete
--


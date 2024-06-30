FROM maven:3.9.6-sapmachine-21

# Install Python
RUN apt-get update && \
    apt-get install -y --fix-missing python3.8 python3-pip python3-venv && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Set Python3 as the default python
RUN update-alternatives --install /usr/bin/python python /usr/bin/python3 1


# Set the working directory inside the container
WORKDIR /app

# Create a virtual environment
RUN python3 -m venv /opt/venv

COPY python_scripts /app/python_scripts

# Activate the virtual environment and install the Python dependencies
RUN /opt/venv/bin/pip install --upgrade pip && \
    /opt/venv/bin/pip install --upgrade setuptools && \
    /opt/venv/bin/pip install --upgrade joblib && \
    /opt/venv/bin/pip install --upgrade numpy && \
    /opt/venv/bin/pip install --upgrade scikit-learn

# Verify Python and pip installation
RUN python --version && pip --version

# JAVA

# Copy the jar file from the host machine to the container
COPY target/alfri-3.2.4.jar app.jar


# Expose the port that the application will run on
EXPOSE 8080

# Command to run the application
ENTRYPOINT ["sh", "-c", "java -jar app.jar"]

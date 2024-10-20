# Use the official Python image from the Docker Hub
FROM python:3.12-slim

# Set environment variables to prevent Python from buffering outputs
ENV PYTHONUNBUFFERED=1

# Set the working directory inside the container
WORKDIR /app

# Copy the requirements.txt file into the container
COPY requirements.txt .

# Install the dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the app's code into the container
COPY . .

# Expose port 5000 (Flask default port)
EXPOSE 5000

# Set the command to run the Flask app when the container starts
CMD ["python", "app.py"]

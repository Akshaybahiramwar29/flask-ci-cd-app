# Dockerfile
FROM python:3.9-slim

# Set working directory
WORKDIR /app

# Copy everything from your project
COPY . .

# Install dependencies
RUN python3 -m venv venv && \
    . venv/bin/activate && \
    pip install --no-cache-dir -r requirements.txt

# Expose Flask default port
EXPOSE 5000

# Run the app
CMD ["python3", "app/app.py"]

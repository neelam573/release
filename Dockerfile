# Use the official Python image from the Docker Hub
FROM python:3.9-slim

# Set the working directory in the container
WORKDIR /usr/src/app

# Copy the current directory contents into the container at /usr/src/app
COPY . .

# Install necessary dependencies
RUN pip install --no-cache-dir jinja2

# Run the script and then cat the release_notes.md file
CMD ["sh", "-c", "python generate_release_notes.py /usr/src/app && cat /usr/src/app/release_notes.md"]

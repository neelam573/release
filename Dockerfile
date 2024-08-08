FROM python:3.9-slim

# Set the working directory
WORKDIR /usr/src/app

# Install necessary packages
RUN apt-get update && apt-get install -y git

# Copy the script and other necessary files into the container
COPY . .

# Install the required Python packages
RUN pip install --no-cache-dir jinja2 requests

# Set environment variables for GitLab repository URL and access token
# (You can replace these with actual values or pass them as build args or secrets)
ENV REPO_URL="https://gitlab.com/username/repo"
ENV ACCESS_TOKEN="your_access_token_here"

# Run the Python script to generate and publish the release notes
CMD ["sh", "-c", "python generate_release_notes.py /usr/src/app $REPO_URL $ACCESS_TOKEN && cat /usr/src/app/release_notes.md"]

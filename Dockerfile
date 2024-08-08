# Use a lightweight base image
FROM alpine:latest

# Set the working directory
WORKDIR /usr/src/app

# Install necessary packages
RUN apk add --no-cache \
    curl \
    jq \
    bash

# Copy the Bash script into the container
COPY generate_and_publish_release.sh .

# Make the script executable
RUN chmod +x generate_and_publish_release.sh

# Set environment variables (placeholders)
ENV GITLAB_API_V4_URL=https://gitlab.com/api/v4
ENV GITHUB_API_URL=https://api.github.com/repos/your_github_user/your_repo/releases

# Run the Bash script
CMD ["./generate_and_publish_release.sh"]

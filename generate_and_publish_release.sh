#!/bin/bash

# Environment variables
GITLAB_PROJECT_ID=${GITLAB_PROJECT_ID}
GITLAB_API_TOKEN=${GITLAB_API_TOKEN}
GITLAB_API_V4_URL=${GITLAB_API_V4_URL}
GITLAB_COMMIT_TAG=${GITLAB_COMMIT_TAG}
GITHUB_REPO=${GITHUB_REPO}
GITHUB_API_TOKEN=${GITHUB_API_TOKEN}
RELEASE_NOTES_PATH='/usr/src/app/release_notes.md'

# Fetch release notes from GitLab
echo "Fetching release notes from GitLab..."
curl -H "PRIVATE-TOKEN: $GITLAB_API_TOKEN" \
     "$GITLAB_API_V4_URL/projects/$GITLAB_PROJECT_ID/repository/changelog?version=$GITLAB_COMMIT_TAG" \
     | jq -r .notes > $RELEASE_NOTES_PATH

# Check if the release notes were fetched successfully
if [ ! -s $RELEASE_NOTES_PATH ]; then
  echo "Failed to fetch release notes or no notes available."
  exit 1
fi

echo "Release notes fetched successfully."

# Publish release notes to GitHub
echo "Creating release on GitHub..."
RELEASE_NAME="Release $GITLAB_COMMIT_TAG"
RELEASE_BODY=$(cat $RELEASE_NOTES_PATH)

# GitHub API URL
GITHUB_API_URL="https://api.github.com/repos/$GITHUB_REPO/releases"

# Create GitHub release
curl -X POST $GITHUB_API_URL \
     -H "Authorization: token $GITHUB_API_TOKEN" \
     -H "Accept: application/vnd.github.v3+json" \
     -d @- << EOF
{
  "tag_name": "$GITLAB_COMMIT_TAG",
  "name": "$RELEASE_NAME",
  "body": "$RELEASE_BODY",
  "draft": false,
  "prerelease": false
}
EOF

echo "Release created on GitHub."

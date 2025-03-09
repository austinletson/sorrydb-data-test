#!/bin/bash

set -e  # Exit immediately if a command exits with a non-zero status

# Function to handle errors
handle_error() {
  echo "Error: $1"
  exit 1
}

# Change to the repository directory
if ! cd /home/austin/development/lean/sorry-index/sorry-db-data-test; then
  handle_error "Failed to change to repository directory"
fi

echo "Updating database..."
# Update sorry_database.json
if ! /home/austin/.local/bin/update_db --database sorry_database.json; then
  handle_error "Failed to update the database"
fi

# Get current timestamp
CURRENT_TIME=$(date "+%Y-%m-%d %H:%M:%S")

echo "Staging changes..."
# Add all changes
if ! git add .; then
  handle_error "Failed to stage changes"
fi

# Check if there are changes to commit
if ! git diff --staged --quiet; then
  echo "Committing changes..."
  # Commit with timestamp in message
  if ! git commit -m "Updating SorryDB at ${CURRENT_TIME}"; then
    handle_error "Failed to commit changes"
  fi

  echo "Pushing changes..."
  # Push changes
  if ! git push; then
    handle_error "Failed to push changes"
  fi
  
  echo "Successfully updated, committed, and pushed changes"
else
  echo "No changes to commit"
fi


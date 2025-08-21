#!/bin/bash

# BrightPal Update Version Manager
# Usage: ./update-version.sh <new_version> <release_notes>

set -euo pipefail

if [ $# -lt 1 ]; then
    echo "Usage: $0 <new_version> [release_notes_file]"
    echo "Example: $0 0.2.3"
    echo "Example: $0 0.2.3 release-notes.txt"
    exit 1
fi

NEW_VERSION="$1"
RELEASE_NOTES_FILE="${2:-}"
CURRENT_DATE=$(date -u +"%Y-%m-%dT%H:%M:%SZ")

echo "Updating to version: $NEW_VERSION"
echo "Date: $CURRENT_DATE"

# Update latest.json
echo "Updating latest.json..."
cat > updates/latest.json << EOF
{
  "version": "$NEW_VERSION",
  "notes": "Update to version $NEW_VERSION",
  "pub_date": "$CURRENT_DATE",
  "platforms": {
    "darwin-x86_64": {
      "url": "https://nishanbaral.github.io/brightpal-updates/updates/BrightPal_${NEW_VERSION}_x64.dmg",
      "signature": "placeholder_signature_here",
      "size": 0
    },
    "darwin-aarch64": {
      "url": "https://nishanbaral.github.io/brightpal-updates/updates/BrightPal_${NEW_VERSION}_arm64.dmg",
      "signature": "placeholder_signature_here",
      "size": 0
    },
    "windows-x86_64": {
      "url": "https://nishanbaral.github.io/brightpal-updates/updates/BrightPal_${NEW_VERSION}_x64-setup.exe",
      "signature": "placeholder_signature_here",
      "size": 0
    }
  }
}
EOF

# Update release-notes.json if notes file provided
if [ -n "$RELEASE_NOTES_FILE" ] && [ -f "$RELEASE_NOTES_FILE" ]; then
    echo "Updating release-notes.json with notes from $RELEASE_NOTES_FILE..."
    
    # Read the notes file and escape quotes
    NOTES=$(cat "$RELEASE_NOTES_FILE" | sed 's/"/\\"/g' | tr '\n' ' ' | sed 's/ *$//')
    
    # Create a temporary file for the new entry
    cat > temp_release_notes.json << EOF
{
  "$NEW_VERSION": {
    "version": "$NEW_VERSION",
    "date": "$(date -u +"%Y-%m-%d")",
    "changes": [
      $NOTES
    ]
  }
EOF
    
    # Append existing entries (excluding the first line and last line)
    tail -n +2 updates/release-notes.json >> temp_release_notes.json
    
    # Replace the original file
    mv temp_release_notes.json updates/release-notes.json
    
    echo "Release notes updated!"
else
    echo "No release notes file provided. Please manually update release-notes.json"
fi

echo "Version update complete!"
echo "Next steps:"
echo "1. Add your update files to the updates/ directory"
echo "2. Update the signature and size values in latest.json"
echo "3. Commit and push: git add . && git commit -m 'Update to version $NEW_VERSION' && git push"

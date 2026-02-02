#!/bin/bash

# ElevenLabs Voice Sample Generator
# Generates voice lines for the Fifty Demo audio system
#
# Voice: Rachel (21m00Tcm4TlvDq8ikWAM)
# Model: eleven_turbo_v2_5
#
# Usage:
#   export ELEVENLABS_API_KEY="your_api_key"
#   ./generate_voice_samples.sh

API_KEY="${ELEVENLABS_API_KEY:-YOUR_API_KEY_HERE}"
VOICE_ID="21m00Tcm4TlvDq8ikWAM"
MODEL_ID="eleven_turbo_v2_5"
OUTPUT_DIR="../apps/fifty_demo/assets/audio/voice"

# Navigate to script directory for relative paths
cd "$(dirname "$0")"

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

echo "=== ElevenLabs Voice Sample Generator ==="
echo "Output directory: $OUTPUT_DIR"
echo ""

# Function to generate a voice line
generate_voice() {
    local text="$1"
    local filename="$2"

    echo "Generating: $filename"
    echo "  Text: \"$text\""

    curl -s -X POST "https://api.elevenlabs.io/v1/text-to-speech/$VOICE_ID" \
        -H "xi-api-key: $API_KEY" \
        -H "Content-Type: application/json" \
        -d "{\"text\": \"$text\", \"model_id\": \"$MODEL_ID\"}" \
        --output "$OUTPUT_DIR/$filename"

    if [ -f "$OUTPUT_DIR/$filename" ] && [ -s "$OUTPUT_DIR/$filename" ]; then
        echo "  Success: $filename created"
    else
        echo "  Error: Failed to generate $filename"
    fi
    echo ""
}

# Generate all voice lines
echo "Starting voice generation..."
echo ""

generate_voice "Welcome, adventurer!" "welcome.mp3"
generate_voice "The journey begins here." "journey.mp3"
generate_voice "Watch out for traps ahead." "warning.mp3"
generate_voice "You have found a rare item!" "rare_item.mp3"
generate_voice "Quest completed successfully." "quest_complete.mp3"

echo "=== Generation Complete ==="
echo ""
echo "Generated files:"
ls -la "$OUTPUT_DIR"

#!/bin/bash

# ElevenLabs Battle Voice Announcer Generator
# Generates voice lines for the Tactical Grid battle announcer
#
# Voice: Daniel (onwK4e9ZLuTAKqWW03F9) - deep, authoritative British
# Model: eleven_turbo_v2_5
#
# Usage:
#   export ELEVENLABS_API_KEY="your_api_key"
#   ./generate_battle_voice.sh

API_KEY="${ELEVENLABS_API_KEY:-}"
VOICE_ID="onwK4e9ZLuTAKqWW03F9"
MODEL_ID="eleven_multilingual_v2"
OUTPUT_FORMAT="mp3_44100_128"
OUTPUT_DIR="../apps/tactical_grid/assets/audio/voice"

# Navigate to script directory for relative paths
cd "$(dirname "$0")"

if [ -z "$API_KEY" ]; then
    echo "Error: ELEVENLABS_API_KEY not set."
    echo "Usage: export ELEVENLABS_API_KEY=\"your_key\" && ./generate_battle_voice.sh"
    exit 1
fi

# Create output directory if it doesn't exist
mkdir -p "$OUTPUT_DIR"

echo "=== Tactical Grid - Battle Voice Generator ==="
echo "Voice: Daniel (dramatic, authoritative)"
echo "Model: $MODEL_ID (highest quality, emotional range)"
echo "Format: $OUTPUT_FORMAT"
echo "Output: $OUTPUT_DIR"
echo ""

# Function to generate a voice line (skips if valid file already exists)
generate_voice() {
    local text="$1"
    local filename="$2"
    local filepath="$OUTPUT_DIR/$filename"

    # Skip if file already exists and is valid audio (> 500 bytes)
    if [ -f "$filepath" ] && [ "$(wc -c < "$filepath")" -gt 500 ]; then
        echo "Skipping (exists): $filename"
        return
    fi

    echo "Generating: $filename"
    echo "  Text: \"$text\""

    local tmpfile="${filepath}.tmp"
    local http_code
    http_code=$(curl -s -w "%{http_code}" -X POST "https://api.elevenlabs.io/v1/text-to-speech/$VOICE_ID?output_format=$OUTPUT_FORMAT" \
        -H "xi-api-key: $API_KEY" \
        -H "Content-Type: application/json" \
        -d "{
            \"text\": \"$text\",
            \"model_id\": \"$MODEL_ID\",
            \"voice_settings\": {
                \"stability\": 0.5,
                \"similarity_boost\": 0.85,
                \"style\": 0.55,
                \"use_speaker_boost\": true
            }
        }" \
        --output "$tmpfile")

    if [ "$http_code" = "200" ] && [ -f "$tmpfile" ] && [ "$(wc -c < "$tmpfile")" -gt 500 ]; then
        mv "$tmpfile" "$filepath"
        local size=$(wc -c < "$filepath")
        echo "  OK ($size bytes)"
    else
        echo "  FAILED (HTTP $http_code)"
        [ -f "$tmpfile" ] && cat "$tmpfile" 2>/dev/null && echo ""
        rm -f "$tmpfile"
        FAILED=$((FAILED + 1))
    fi
    echo ""

    # Delay to respect rate limits
    sleep 1
}

FAILED=0

echo "Starting voice generation (17 lines)..."
echo ""

# --- Match events ---
generate_voice "Battle begins!" "match_start.mp3"
generate_voice "Victory is yours!" "victory.mp3"
generate_voice "You have been defeated." "defeat.mp3"

# --- Unit captured lines ---
generate_voice "Commander captured!" "captured_commander.mp3"
generate_voice "Knight captured!" "captured_knight.mp3"
generate_voice "Shield captured!" "captured_shield.mp3"
generate_voice "Archer captured!" "captured_archer.mp3"
generate_voice "Mage captured!" "captured_mage.mp3"
generate_voice "Scout captured!" "captured_scout.mp3"
generate_voice "Unit captured!" "unit_captured.mp3"

# --- Ability lines ---
generate_voice "Rally!" "ability_rally.mp3"
generate_voice "Fire!" "ability_shoot.mp3"
generate_voice "Fireball!" "ability_fireball.mp3"
generate_voice "Block!" "ability_block.mp3"
generate_voice "Reveal!" "ability_reveal.mp3"
generate_voice "Ability activated." "ability_used.mp3"

# --- Status lines ---
generate_voice "Commander in danger!" "commander_in_danger.mp3"
generate_voice "Objective secured!" "objective_secured.mp3"
generate_voice "Ten seconds remaining." "turn_warning.mp3"

echo "=== Generation Complete ==="
echo ""
if [ "$FAILED" -gt 0 ]; then
    echo "WARNING: $FAILED files failed. Re-run script to retry (existing files will be skipped)."
    echo ""
fi
echo "Generated files:"
ls -la "$OUTPUT_DIR"/*.mp3 2>/dev/null
echo ""
echo "Total: $(ls "$OUTPUT_DIR"/*.mp3 2>/dev/null | wc -l | tr -d ' ') files"

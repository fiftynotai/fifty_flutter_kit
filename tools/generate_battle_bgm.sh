#!/bin/bash

# ElevenLabs Battle BGM Generator
# Generates background music tracks for the Tactical Grid battle system
#
# API: /v1/music (Eleven Music)
# Model: music_v1
#
# Usage:
#   export ELEVENLABS_API_KEY="your_api_key"
#   ./generate_battle_bgm.sh

API_KEY="${ELEVENLABS_API_KEY:-}"
OUTPUT_DIR="../apps/tactical_grid/assets/audio/bgm"

# Navigate to script directory for relative paths
cd "$(dirname "$0")"

if [ -z "$API_KEY" ]; then
    echo "Error: ELEVENLABS_API_KEY not set."
    echo "Usage: export ELEVENLABS_API_KEY=\"your_key\" && ./generate_battle_bgm.sh"
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

echo "=== Tactical Grid - Battle BGM Generator ==="
echo "API: ElevenLabs Music v1"
echo "Output: $OUTPUT_DIR"
echo ""

FAILED=0

# Function to generate a music track (skips if valid file already exists)
generate_bgm() {
    local prompt="$1"
    local filename="$2"
    local duration_ms="$3"
    local instrumental="${4:-true}"
    local filepath="$OUTPUT_DIR/$filename"

    # Skip if file already exists and is valid audio (> 5000 bytes)
    if [ -f "$filepath" ] && [ "$(wc -c < "$filepath")" -gt 5000 ]; then
        echo "Skipping (exists): $filename"
        return
    fi

    echo "Generating: $filename"
    echo "  Prompt: \"$prompt\""
    echo "  Duration: $((duration_ms / 1000))s | Instrumental: $instrumental"

    local tmpfile="${filepath}.tmp"
    local http_code
    http_code=$(curl -s -w "%{http_code}" -X POST "https://api.elevenlabs.io/v1/music?output_format=mp3_44100_128" \
        -H "xi-api-key: $API_KEY" \
        -H "Content-Type: application/json" \
        -d "{
            \"prompt\": \"$prompt\",
            \"music_length_ms\": $duration_ms,
            \"force_instrumental\": $instrumental
        }" \
        --output "$tmpfile")

    if [ "$http_code" = "200" ] && [ -f "$tmpfile" ] && [ "$(wc -c < "$tmpfile")" -gt 5000 ]; then
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

    sleep 2
}

echo "Starting BGM generation..."
echo ""

# --- Battle BGM ---
generate_bgm "Epic tactical strategy battle music, orchestral with drums and tension, medieval war chess game, loopable, intense but not overwhelming" "battle_theme.mp3" 60000 true

# --- Menu / Lobby ---
generate_bgm "Calm strategic planning music, ambient orchestral with soft strings and gentle percussion, medieval fantasy war room, contemplative and noble, loopable" "menu_theme.mp3" 45000 true

# --- Victory ---
generate_bgm "Triumphant victory fanfare, heroic orchestral celebration, brass and strings, glorious conquest theme, uplifting and majestic" "victory_fanfare.mp3" 15000 true

# --- Defeat ---
generate_bgm "Somber defeat theme, melancholic strings and piano, fallen warrior lament, reflective and subdued, medieval tragedy" "defeat_theme.mp3" 15000 true

echo "=== Generation Complete ==="
echo ""
if [ "$FAILED" -gt 0 ]; then
    echo "WARNING: $FAILED files failed. Re-run script to retry."
    echo ""
fi
echo "Generated files:"
ls -la "$OUTPUT_DIR"/*.mp3 2>/dev/null
echo ""
echo "Total: $(ls "$OUTPUT_DIR"/*.mp3 2>/dev/null | wc -l | tr -d ' ') files"

#!/bin/bash

# ElevenLabs Battle SFX Generator
# Generates sound effects for the Tactical Grid battle system
#
# API: /v1/sound-generation (text-to-sound-effects)
# Model: eleven_text_to_sound_v2
#
# Usage:
#   export ELEVENLABS_API_KEY="your_api_key"
#   ./generate_battle_sfx.sh

API_KEY="${ELEVENLABS_API_KEY:-}"
OUTPUT_DIR="../apps/tactical_grid/assets/audio/sfx"

# Navigate to script directory for relative paths
cd "$(dirname "$0")"

if [ -z "$API_KEY" ]; then
    echo "Error: ELEVENLABS_API_KEY not set."
    echo "Usage: export ELEVENLABS_API_KEY=\"your_key\" && ./generate_battle_sfx.sh"
    exit 1
fi

mkdir -p "$OUTPUT_DIR"

echo "=== Tactical Grid - Battle SFX Generator ==="
echo "API: ElevenLabs Sound Generation v2"
echo "Output: $OUTPUT_DIR"
echo ""

FAILED=0

# Function to generate a sound effect (skips if valid file already exists)
generate_sfx() {
    local prompt="$1"
    local filename="$2"
    local duration="$3"
    local influence="${4:-0.5}"
    local filepath="$OUTPUT_DIR/$filename"

    # Skip if file already exists and is valid audio (> 500 bytes)
    if [ -f "$filepath" ] && [ "$(wc -c < "$filepath")" -gt 500 ]; then
        echo "Skipping (exists): $filename"
        return
    fi

    echo "Generating: $filename"
    echo "  Prompt: \"$prompt\""
    echo "  Duration: ${duration}s | Influence: $influence"

    local tmpfile="${filepath}.tmp"
    local http_code
    http_code=$(curl -s -w "%{http_code}" -X POST "https://api.elevenlabs.io/v1/sound-generation" \
        -H "xi-api-key: $API_KEY" \
        -H "Content-Type: application/json" \
        -d "{
            \"text\": \"$prompt\",
            \"duration_seconds\": $duration,
            \"prompt_influence\": $influence,
            \"output_format\": \"mp3_44100_128\"
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

    sleep 1
}

echo "Starting SFX generation..."
echo ""

# --- Core battle SFX (replacing placeholders) ---
generate_sfx "Short sharp UI click sound, game menu button press, clean digital tap" "click.mp3" 0.5 0.7
generate_sfx "Quick tactical footsteps on stone floor, two steps, board game piece moving" "footsteps.mp3" 0.8 0.6
generate_sfx "Fast sword slash whoosh, sharp metallic swing, tactical combat hit" "sword_slash.mp3" 0.7 0.6
generate_sfx "Heavy impact hit, body slam thud, unit taking damage in battle" "hit.mp3" 0.6 0.5
generate_sfx "Gentle notification chime, subtle turn end bell, strategic game ding" "notification.mp3" 0.8 0.6
generate_sfx "Achievement unlock triumphant jingle, short victory chime with sparkle" "achievement_unlock.mp3" 1.5 0.5

# --- Ability SFX ---
generate_sfx "Magical energy activation, arcane power surge with shimmer and whoosh, spell cast" "ability_activate.mp3" 1.0 0.5
generate_sfx "War horn blast, short rally trumpet call, medieval battle horn" "rally_horn.mp3" 1.5 0.6
generate_sfx "Bow and arrow release, sharp twang and arrow whoosh, ranged shot" "arrow_shot.mp3" 0.8 0.6
generate_sfx "Fireball cast and explosion, fire magic whoosh into burst of flames" "fireball_cast.mp3" 1.2 0.5
generate_sfx "Metal shield block clang, heavy defensive parry impact, armored deflection" "shield_block.mp3" 0.7 0.6
generate_sfx "Mystical reveal shimmer, magical scanning pulse, ethereal detection sonar" "reveal_pulse.mp3" 1.2 0.5

# --- Timer SFX ---
generate_sfx "Tense clock ticking, single urgent mechanical tick tock, time pressure" "timer_tick.mp3" 0.5 0.7
generate_sfx "Urgent alarm buzzer, short critical time warning beep, game timer expired" "timer_critical.mp3" 1.0 0.6

# --- Turn / Match SFX ---
generate_sfx "Strategic turn transition whoosh, subtle phase change sweep, chess-like turn swap" "turn_change.mp3" 0.8 0.5
generate_sfx "Unit destroyed shatter, chess piece captured crash, tactical defeat crumble" "unit_defeat.mp3" 1.0 0.5

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

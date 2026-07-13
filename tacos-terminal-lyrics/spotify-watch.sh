#!/usr/bin/env bash
LRC_RAW=~/.local/share/lrc-tools/lyrics/raw
LRC_PROC=~/.local/share/lrc-tools/lyrics/processed
TMP_AUDIO=/tmp/lrc-audio-tmp
TMP_LRC=/tmp/lrc-single
CACHE_MAX_AGE=30  # minutes (24 hours)

prev_track=""
last_cleanup=0

while true; do
    # Auto-cleanup every hour
    now=$(date +%s)
    if (( now - last_cleanup > 1800 )); then
        deleted=$(find "$LRC_RAW" "$LRC_PROC" \( -name "*.lrc" -o -name "*.wlrc" \) -mmin +$CACHE_MAX_AGE -print -delete 2>/dev/null | wc -l)
        (( deleted > 0 )) && echo "  ✓ cleaned $deleted old cache files"
        last_cleanup=$now
    fi

    track=$(playerctl -p spotify metadata --format "{{artist}} - {{title}}" 2>/dev/null)

    if [ -n "$track" ] && [ "$track" != "$prev_track" ]; then
        artist=$(playerctl -p spotify metadata xesam:artist 2>/dev/null)
        title=$(playerctl -p spotify metadata xesam:title 2>/dev/null)
        duration=$(playerctl -p spotify metadata mpris:length 2>/dev/null)
        duration_secs=$(echo "$duration / 1000000" | bc 2>/dev/null || echo "0")
        outfile="$LRC_RAW/$track.lrc"

        if [ ! -f "$LRC_PROC/$track.wlrc" ]; then
            echo "Fetching lyrics: $track"
            encoded_artist=$(python3 -c "import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1]))" "$artist")
            encoded_title=$(python3 -c "import urllib.parse,sys; print(urllib.parse.quote(sys.argv[1]))" "$title")
            curl -s "https://lrclib.net/api/get?artist_name=${encoded_artist}&track_name=${encoded_title}&duration=${duration_secs}" \
                -o /tmp/lrc_response.json

            synced=$(python3 -c "
import json
with open('/tmp/lrc_response.json') as f:
    d = json.load(f)
print(d.get('syncedLyrics', '') or '')
" 2>/dev/null)

            if [ -n "$synced" ]; then
                echo "$synced" > "$outfile"
                mkdir -p "$TMP_LRC"
                rm -f "$TMP_LRC"/*.lrc
                cp "$outfile" "$TMP_LRC/"
                echo "  ✓ lyrics saved"

                echo "  Downloading audio for onset detection..."
                mkdir -p "$TMP_AUDIO"
                rm -f "$TMP_AUDIO"/*
                yt-dlp -x --audio-format mp3 \
                    --output "$TMP_AUDIO/$track.%(ext)s" \
                    "ytsearch1:$artist $title official audio" \
                    --quiet --no-warnings 2>/dev/null

                audio_file=$(find "$TMP_AUDIO" -name "$track.*" | head -1)

                if [ -n "$audio_file" ]; then
                    echo "  ✓ audio downloaded, running onset detection..."
                    lrc-processor --lrc-dir "$TMP_LRC" \
                                  --audio-dir "$TMP_AUDIO" \
                                  --output-dir "$LRC_PROC" \
                                  --wlrc --onset-detection --overwrite \
                                  --max-phrase-duration 1.5 \
                                  --max-words 5 --quiet
                    rm -f "$audio_file"
                    echo "  ✓ processed with onset detection"
                else
                    echo "  ✗ audio download failed, falling back to estimate"
                    lrc-processor --lrc-dir "$TMP_LRC" \
                                  --output-dir "$LRC_PROC" \
                                  --wlrc --no-require-audio --overwrite \
                                  --max-phrase-duration 0.8 \
                                  --max-words 3 --quiet
                fi
            else
                echo "  ✗ no synced lyrics found for $track"
            fi
        else
            echo "Already have: $track"
        fi

        prev_track="$track"
    fi

    sleep 3
done

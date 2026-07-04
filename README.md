# spotifyX-tacos-terminal-lyrics

Terminal lyrics visualizer with word-level sync for Spotify on Linux.
Based on [tacos-terminal-lyrics](https://github.com/tacoproz1/tacos-terminal-lyrics) by tacoproz1 — MIT License.

## What this adds
- Auto-fetches and processes lyrics when Spotify changes tracks via `spotify-watch.sh`
- Falls back to plain text rendering for Cyrillic and other non-Latin scripts

## Dependencies
- `spotify` (AUR)
- `playerctl`
- `yt-dlp`
- `curl`
- `python-librosa` (for accurate word-level timing)
- `ffmpeg`
- `pipx install pyyaml mutagen syncedlyrics --break-system-packages`
- `sudo pacman -S python-yaml`
## Install
```bash
git clone https://github.com/fnful97/spotifyX-tacos-terminal-lyrics
cd spotifyX-tacos-terminal-lyrics
bash setup.sh
```

## Usage
Run both at the same time from inside the repo folder:

Terminal 1 — watches Spotify and fetches lyrics automatically
```bash
bash ~/tacos-terminal-lyrics/spotify-watch.sh
```

Terminal 2 — displays lyrics
```bash
lrc-vis --lrc-dir ~/.local/share/lrc-tools/lyrics/processed --wlrc --font block
```

Lyrics are cached per song and auto-cleaned every 30 minutes. Feel free to edit and improve!

## original repo
https://github.com/tacoproz1/tacos-terminal-lyrics

## License
MIT

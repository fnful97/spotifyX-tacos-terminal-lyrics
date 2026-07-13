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
- `bc` (used to calculate track duration for lyrics lookup)
- `python-librosa` (for accurate word-level timing)
- `ffmpeg`
- `python-pip` (needed by `setup.sh` to install the Python packages below)
- `pyyaml`, `mutagen`, `syncedlyrics` — installed automatically by `setup.sh`, or manually via:
```bash
  pip install pyyaml mutagen syncedlyrics --break-system-packages
```
  If `pip` isn't available, install it first with `sudo pacman -S python-pip`.
 
## Install
```bash
git clone https://github.com/fnful97/spotifyX-tacos-terminal-lyrics
cd spotifyX-tacos-terminal-lyrics/tacos-terminal-lyrics
bash setup.sh
```
 
If `setup.sh` fails with `pip: command not found`, install pip first:
```bash
sudo pacman -S python-pip
```
then re-run `bash setup.sh`.
 
After setup finishes, make sure `~/.local/bin` is on your `$PATH` (`setup.sh` will warn you if it isn't). For bash/zsh:
```bash
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc   # or ~/.zshrc
source ~/.bashrc
```
 
## Usage
Run both at the same time, from inside the `tacos-terminal-lyrics` folder (or from anywhere, once `~/.local/bin` is on your PATH):
 
**Terminal 1** — watches Spotify and fetches lyrics automatically
```bash
cd spotifyX-tacos-terminal-lyrics/tacos-terminal-lyrics
bash spotify-watch.sh
```
 
**Terminal 2** — displays lyrics
```bash
lrc-vis --lrc-dir ~/.local/share/lrc-tools/lyrics/processed --wlrc --font block
```
 
> **Note:** Use the installed `lrc-vis` (in `~/.local/bin`), not the raw script inside the repo folder — the raw copy in the repo isn't wired to find the `lrc_tools` package and will fail with `ModuleNotFoundError`. If `lrc-vis` isn't found, either fix your `$PATH` as above, or run it with the full path: `~/.local/bin/lrc-vis --lrc-dir ...`

 
Lyrics are cached per song and auto-cleaned every 30 minutes. Feel free to edit and improve!
 
## Original repo
https://github.com/tacoproz1/tacos-terminal-lyrics
 
## License
MIT
 

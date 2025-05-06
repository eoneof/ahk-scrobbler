# ![scrobbler.svg](src/core/ui/icons/scrobbler-32.png) Autohotkey Scrobbler

> ⚠️ These scripts require AutoHotkey v2. 

> 🎶 Scrobbling works with media players that support [Windows.Media.Control](https://learn.microsoft.com/en-us/uwp/api/windows.media.control?view=winrt-26100) (all modern apps should work though).  


## Features

- Whitelist preferred music player(s).
- Update Now Playing section on last.fm.
- Automatically scrobble played tracks.
- Love current track by clicking tray icon.


## Setup Instructions

0. Download [Autohotkey v2](https://www.autohotkey.com/download/)

1. Get your Last.fm API credentials:
   - Visit https://www.last.fm/api/account/create.
   - Fill in **Application name** (any name you prefer). You may skip other fields.
   - Save your API Key and API Secret.

2. Initial Configuration:
   - Download or clone this repository.
   - Optionally run `git update-index --skip-worktree src/config/user_config.ahk` to prevent accidental commits.
   - Run [Scrobbler.ahk](src/Scrobbler.ahk).
   - Enter your API credentials when prompted.
   - Authorize the scrobbler in your browser.

3. Whitelist your music player:
   - Start music playback in your app of choice.
   - Run [get_current_music_player_id.ahk](src/config/get_current_music_player_id.ahk) to get the current music player ID. It will be copied to clipboard.
   - Paste the obtained ID into [user_config.ahk](src/config/user_config.ahk) and save.
   - Restart the scrobbler.
  
> [!TIP]  
> You can install a web page (e.g. YouTube Music) as a PWA so it would have its unique ID.

4. Done.


## Roadmap

- [x] Go to last.fm profile in tray menu
- [ ] ~~Delete last scrobble (?)~~ (manage it on last.fm)
- [ ] ~~Love previously played tracks alongside with current~~ (manage it on last.fm)
- [ ] Track history persistence across reloads
- [ ] UI-based music app whitelisting
- [ ] Release as binary executable


## Credits

- Windows Media Control access by jNizM's [Media.ahk](https://github.com/jNizM/Media.ahk)  
- String encryption by jNizM's [AHK_CNG](https://github.com/jNizM/AHK_CNG)  
- JSON manipulations based on cocobelgica's [JSON](https://github.com/cocobelgica/AutoHotkey-JSON) and modded by me.
- AHK community and forums.


## License

MIT

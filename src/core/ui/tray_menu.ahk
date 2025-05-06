A_TrayMenu.Delete()
A_TrayMenu.Add("Love current track ❤️", (*) => LoveCurrentTrack())
A_TrayMenu.Default := "Love current track ❤️"
A_TrayMenu.Add("Configure", (*) => ShowConfigDialog())

A_TrayMenu.Add("")

A_TrayMenu.Add("Exit", (*) => ExitApp())
A_TrayMenu.ClickCount := 1

TraySetIcon(".\core\ui\icons\scrobbler-32.png")

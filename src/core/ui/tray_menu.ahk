class TrayMenu {
  __New(mediaMonitor, configDialog, authService, userName) {
    this.MediaMonitor := mediaMonitor
    this.ConfigDialog := configDialog
    this.AuthService := authService
    this.UserName := userName
  }

  Setup() {
    A_TrayMenu.Delete()

    A_TrayMenu.Add("Love current track ❤️", (*) => this.MediaMonitor.LoveCurrentTrack())
    A_TrayMenu.Default := "Love current track ❤️"
    this.ToggleProfileItem()
    A_TrayMenu.Add("Configure", (*) => this.ConfigDialog.Show())
    A_TrayMenu.Add("")
    A_TrayMenu.Add("Exit", (*) => ExitApp())

    A_TrayMenu.ClickCount := 1

    TraySetIcon(".\core\ui\icons\scrobbler-32.png")
  }

  ToggleProfileItem() {
    if (!this.userName) {
      A_TrayMenu.Disable("Open profile")
    } else {
      A_TrayMenu.Add(
        "Open profile",
        (*) => this.authService.OpenProfilePage(this.userName)
      )
    }
  }
}

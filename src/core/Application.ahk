class Application {
  __New(data, modules) {
    this.envVars := data.envVars
    this.apiKey := data.apiKey
    this.apiSecret := data.apiSecret
    this.sessionKey := data.sessionKey
    this.userName := data.userName

    this.authService := modules.authenticator
    this.scrobbleService := modules.scrobbler
    this.mediaMonitor := modules.mediaMonitor
    this.configDialog := modules.configDialog
    this.trayMenu := modules.trayMenu

  }

  Run() {
    if (!this.envVars) {
      this.configDialog.Show()
      return
    }

    if (!this.apiKey && !this.apiSecret) {
      this.configDialog.Show()
    }

    if (!this.sessionKey) {
      this.sessionKey := this.authService.Auth()
    }

    this.trayMenu.Setup()
    this.mediaMonitor.Start()
  }
}

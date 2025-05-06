class Application {
  static EnvVars := ReadEnv(ENV_FILE)
  static API_KEY := Application.EnvVars.Has("API_KEY") ? Application.EnvVars["API_KEY"] : ""
  static API_SECRET := Application.EnvVars.Has("API_SECRET") ? Application.EnvVars["API_SECRET"] : ""
  static SESSION_KEY := Application.EnvVars.Has("SESSION_KEY") ? Application.EnvVars["SESSION_KEY"] : ""
  static USER_NAME := Application.EnvVars.Has("USER_NAME") ? Application.EnvVars["USER_NAME"] : ""

  __New() {
    this.app := Application

    ; temp fallbacks
    global EnvVars := ReadEnv(ENV_FILE)
    global API_KEY := this.app.API_KEY
    global API_SECRET := this.app.API_SECRET
    global SESSION_KEY := this.app.SESSION_KEY
    global USER_NAME := this.app.USER_NAME
  }

  Run() {
    if (!this.app.EnvVars) {
      ShowConfigDialog()

      return
    }

    if (!this.app.API_KEY && !this.app.API_SECRET) {
      ShowConfigDialog()
    }

    if (!this.app.SESSION_KEY) {
      Auth()
    }

    if (!this.app.USER_NAME) {
      A_TrayMenu.Disable("Open profile")
    }

    StartMediaMonitor()
  }
}

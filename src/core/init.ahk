Init() {
  global EnvVars := ReadEnv(ENV_FILE)

  if (!EnvVars) {
    ShowConfigDialog()
    return
  }

  global API_KEY := EnvVars.Has("API_KEY") ? EnvVars["API_KEY"] : ""
  global API_SECRET := EnvVars.Has("API_SECRET") ? EnvVars["API_SECRET"] : ""
  global SESSION_KEY := EnvVars.Has("SESSION_KEY") ? EnvVars["SESSION_KEY"] : ""
  global USER_NAME := EnvVars.Has("USER_NAME") ? EnvVars["USER_NAME"] : ""

  if (!API_KEY && !API_SECRET) {
    ShowConfigDialog()
  }

  if (!SESSION_KEY) {
    Auth()
  }

  if (!USER_NAME) {
    A_TrayMenu.Disable("Open profile")
  }

  StartMediaMonitor()
}

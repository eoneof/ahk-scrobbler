#Requires AutoHotkey v2.0
#SingleInstance force
SetWorkingDir(A_ScriptDir)
Persistent()

#Include ..\vendor\Media\Media.ahk
#Include ..\vendor\AHK_CNG\Class_CNG.ahk
#Include ..\vendor\JSON\JSON.ahk

#Include .\config\default_config.ahk
#Include .\config\user_config.ahk

#Include .\lib\utils\time.ahk
#Include .\lib\utils\url.ahk

#Include .\lib\helpers\http_client.ahk
#Include .\lib\helpers\env_manager.ahk

#Include .\api\constants.ahk
#Include .\api\auth_service.ahk
#Include .\api\scrobble_service.ahk

#Include .\core\ui\config_dialog.ahk
#Include .\core\ui\tray_menu.ahk

#Include .\core\media_monitor.ahk
#Include .\core\Application.ahk

main() {
  data := {}
  data.envVars := ReadEnv(ENV_FILE)
  data.apiKey := data.envVars.Has("API_KEY") ? data.envVars["API_KEY"] : ""
  data.apiSecret := data.envVars.Has("API_SECRET") ? data.envVars["API_SECRET"] : ""
  data.sessionKey := data.envVars.Has("SESSION_KEY") ? data.envVars["SESSION_KEY"] : ""
  data.userName := data.envVars.Has("USER_NAME") ? data.envVars["USER_NAME"] : ""

  modules := {}
  modules.authenticator := Authenticator(ENV_FILE, data.apiKey, data.apiSecret, data.envVars)
  modules.scrobbler := Scrobbler(data.apiKey, data.apiSecret, data.sessionKey)
  modules.mediaMonitor := MediaMonitor(Media, data.scrobbler)
  modules.configDialog := ConfigDialog(REGISTER_API_URL)
  modules.trayMenu := TrayMenu(data.mediaMonitor, data.configDialog, data.authenticator, data.userName)

  app := Application(data, modules)
  app.Run()
}

main()

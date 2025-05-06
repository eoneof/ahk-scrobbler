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
  auth := AuthService
  app := Application(auth)

  app.Run()
}

main()

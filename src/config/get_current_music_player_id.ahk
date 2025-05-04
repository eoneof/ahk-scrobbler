#Requires AutoHotkey v2.0

#Include ..\..\vendor\Media\Media.ahk

try {
  playerID := Media.GetCurrentSession().SourceAppUserModelId

  result := MsgBox(playerID, "Current music app ID")

  if (result == "OK") {
    A_Clipboard := playerID
  }

} catch Error as err {
  MsgBox(err.Message)
}

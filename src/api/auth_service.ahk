GetToken() {
  payload := "method=auth.gettoken"
  payload .= "&api_key=" . API_KEY
  payload .= "&format=json"

  message := HttpRequest(SCROBBLER_API_URL, "POST", payload).message
  token := JSON.Parse(&message)["token"]

  return token
}

GenerateSignature(token) {
  str := "api_key"
  str .= API_KEY
  str .= "methodauth.getsessiontoken"
  str .= token
  str .= API_SECRET

  sig := Hash.String("MD5", str)

  return sig
}

ObtainSessionKey(token, signature) {
  url := SCROBBLER_API_URL
  url .= "?method=auth.getsession"
  url .= "&token=" . token
  url .= "&api_key=" . API_KEY
  url .= "&api_sig=" . signature
  url .= "&format=json"

  message := HttpRequest(url).message

  try {
    sessionKey := JSON.Parse(&message)["session"]["key"]
  } catch Error as err {
    MsgBox("Something went wrong:`n" err.message)

    return
  }

  return sessionKey
}

ConnectApplication(token, signature) {
  url := AUTH_API_URL
  url .= "?api_key" . API_KEY
  url .= "&token" . token

  Run(url)

  res := MsgBox("A browser window will open now.`nAllow access to your last.fm account then return here and click 'Continue'", "Connect app", "Iconi CTC")

  switch res {
    case "Continue":
      sessionKey := ObtainSessionKey(token, signature)
      return sessionKey
    case "TryAgain":
      ConnectApplication(token, signature)
    default:
      return false
  }
}

SaveSessionkey(sessionKey) {
  EnvVars["SESSION_KEY"] := sessionKey

  WriteEnv(ENV_FILE, EnvVars)
}

Auth() {
  token := GetToken()
  signature := GenerateSignature(token)
  sessionKey := ConnectApplication(token, signature)

  SaveSessionKey(sessionKey)
}

OpenProfilePage() {
  url := "https://www.last.fm/user/" . USER_NAME

  Run(url)
}

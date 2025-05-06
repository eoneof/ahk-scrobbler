class AuthService {
  __New(envFilePath, apiKey, apiSecret, envVars) {
    this.envFilePath := envFilePath
    this.apiKey := apiKey
    this.apiSecret := apiSecret
    this.envVars := envVars
  }

  GetToken() {
    payload := "method=auth.gettoken"
    payload .= "&api_key=" . this.apiKey
    payload .= "&format=json"

    message := HttpRequest(SCROBBLER_API_URL, "POST", payload).message
    token := JSON.Parse(&message)["token"]

    return token
  }

  GenerateSignature(token) {
    str := "api_key"
    str .= this.apiKey
    str .= "methodauth.getsessiontoken"
    str .= token
    str .= this.apiSecret

    sig := Hash.String("MD5", str)

    return sig
  }

  ObtainSessionKey(token, signature) {
    url := SCROBBLER_API_URL
    url .= "?method=auth.getsession"
    url .= "&token=" . token
    url .= "&api_key=" . this.apiKey
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
    url .= "?api_key" . this.apiKey
    url .= "&token" . token

    Run(url)

    res := MsgBox("A browser window will open now.`nAllow access to your last.fm account then return here and click 'Continue'", "Connect app", "Iconi CTC")

    switch res {
      case "Continue":
        sessionKey := this.ObtainSessionKey(token, signature)
        return sessionKey
      case "TryAgain":
        this.ConnectApplication(token, signature)
      default:
        return false
    }
  }

  SaveSessionKey(sessionKey) {
    this.envVars["SESSION_KEY"] := sessionKey

    WriteEnv(this.envFilePath, this.envVars)
  }

  Auth() {
    token := this.GetToken()
    signature := this.GenerateSignature(token)
    sessionKey := this.ConnectApplication(token, signature)

    this.SaveSessionKey(sessionKey)
    
    return sessionKey
  }

  OpenProfilePage(userName) {
    url := "https://www.last.fm/user/" . userName

    Run(url)
  }
}

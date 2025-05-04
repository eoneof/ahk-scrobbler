class ConfigDialog {
  static isDialogOpen := false

  __New() {
    this.isDialogOpen := ConfigDialog.isDialogOpen
    this.url := REGISTER_API_URL

    if (this.isDialogOpen) {
      return
    }

    this.Show()
  }

  _isValidInput(str) {
    isAscii := RegExMatch(str, "^[a-zA-Z0-9-_]+$")
    isLongEnough := StrLen(str) == 32

    return (isAscii && isLongEnough)
  }

  _getExistingVars() {
    this.existingVars := ReadEnv(ENV_FILE)

    this.existingApiKey := this.existingVars && this.existingVars.Has("API_KEY") ? this.existingVars["API_KEY"] : ""
    this.existingApiSecret := this.existingVars && this.existingVars.Has("API_SECRET") ? this.existingVars["API_SECRET"] : ""
    this.existingSessionKey := this.existingVars && this.existingVars.Has("SESSION_KEY") ? this.existingVars["SESSION_KEY"] : ""
    this.existingUserName := this.existingVars && this.existingVars.Has("USER_NAME") ? this.existingVars["USER_NAME"] : ""
  }

  _addDescription() {
    this.dialog.SetFont("s10")
    this.dialog.SetFont("s12 bold")
    this.dialog.AddText("x10", "Enter your last.fm API credentials")
    this.dialog.SetFont("s10 norm")
    this.dialog.AddLink("x10", "Get your API credentials here: `n<a href=`"" . this.url . "`">" . this.url . "</a>")
  }

  _bindInputsEvents() {
    this.apiKeyInput.OnEvent("Change", (*) => this._handleInputsChange())
    this.apiSecretInput.OnEvent("Change", (*) => this._handleInputsChange())
    this.userNameInput.OnEvent("Change", (*) => this._handleInputsChange())
  }

  _addInputs() {
    this.dialog.AddText("x10 y+20", "API Key:")
    this.apiKeyInput := this.dialog.AddEdit("x10 y+5 w400", this.existingApiKey)
    this.apiKeyStatus := this.dialog.AddText("x10 y+5 w400 Hidden", "")

    this.dialog.AddText("x10 y+20", "API Secret:")
    this.apiSecretInput := this.dialog.AddEdit("x10 y+5 w400", this.existingApiSecret)
    this.apiSecretStatus := this.dialog.AddText("x10 y+5 w400 Hidden", "")

    this.dialog.AddText("x10 y+20", "User name:")
    this.userNameInput := this.dialog.AddEdit("x10 y+5 w400", this.existingUserName)

    this._bindInputsEvents()
  }

  _bindButtonEvents() {
    this.saveButton.OnEvent("Click", (*) => this.SaveCredentials())
    this.cancelButton.OnEvent("Click", (*) => this.Close())
  }

  _addButtons() {
    this.saveButton := this.dialog.AddButton("x10 y+20 w100", "Save")
    this.cancelButton := this.dialog.AddButton("x+10 w100", "Cancel")

    this._bindButtonEvents()
  }

  _bindDialogEvents() {
    this.dialog.OnEvent("Close", (*) => this.Close())
    this.dialog.OnEvent("Escape", (*) => this.Close())
  }

  _handleInputsChange() {
    this._toggleButtonState()
  }

  Show() {
    this._getExistingVars()

    this.dialog := Gui("+AlwaysOnTop", "last.fm API Credentials")

    this._addDescription()
    this._addInputs()
    this._addButtons()

    if (this.existingApiKey || this.existingApiSecret) {
      this._toggleButtonState()

      this.apiKeyStatus.Opt("-Hidden")
      this.apiSecretStatus.Opt("-Hidden")
    }

    this._bindDialogEvents()
    this.dialog.Show()

    this.isDialogOpen := true
  }

  Close(*) {
    this.dialog.Destroy()

    this.isDialogOpen := false
  }

  _toggleButtonState() {
    this._getExistingVars()

    this.apiKey := this.apiKeyInput.Value
    this.apiSecret := this.apiSecretInput.Value
    this.sessionKey := this.existingSessionKey
    this.userName := this.userNameInput.Value

    this.apiKeyStatus.Opt("-Hidden")
    this.apiSecretStatus.Opt("-Hidden")

    Switch true {
      Case (this.apiKey = 0):
        this.apiKeyStatus.Value := "Required"
        this.apiKeyStatus.Opt("+cRed")
      Case (!this._isValidInput(this.apiKey)):
        this.apiKeyStatus.Value := "× API Key must be 32 characters long"
        this.apiKeyStatus.Opt("+cRed")
      Default:
        this.apiKeyStatus.Value := "✓ Ok"
        this.apiKeyStatus.Opt("+cGreen")
    }

    Switch true {
      Case (this.apiSecret = 0):
        this.apiSecretStatus.Value := "Required"
        this.apiSecretStatus.Opt("+cRed")
      Case (!this._isValidInput(this.apiSecret)):
        this.apiSecretStatus.Value := "× API Secret must be 32 characters long"
        this.apiSecretStatus.Opt("+cRed")
      Default:
        this.apiSecretStatus.Value := "✓ Ok"
        this.apiSecretStatus.Opt("+cGreen")
    }

    this.allRequiredInputsAreValid :=
      this._isValidInput(this.apiKey) &&
      this._isValidInput(this.apiSecret)

    this.areInputsAndSavedEqual :=
      this.existingApiKey == this.apiKey &&
      this.existingApiSecret == this.apiSecret

    this.saveButton.Opt((!this.allRequiredInputsAreValid || this.areInputsAndSavedEqual) ? "+Disabled" : "-Disabled")
  }

  SaveCredentials(*) {
    vars := Map(
      "API_KEY", this.apiKey,
      "API_SECRET", this.apiSecret,
      "SESSION_KEY", this.sessionKey,
      "USER_NAME", this.userName,
    )

    if (WriteEnv(ENV_FILE, vars)) {
      this.Close()
      Reload()
    }
  }
}


global ShowConfigDialog := ConfigDialog

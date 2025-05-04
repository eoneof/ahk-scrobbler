ReadEnv(envFile) {
  if !FileExist(envFile) {
    try {
      FileAppend("", envFile)
    } catch Error as err {
      MsgBox("Failed to create environment file: " err.Message)
      return false
    }
  }

  env := FileRead(envFile)

  if (!env) {
    return false
  }

  vars := Map()
  lines := StrSplit(env, "`n", "`r")

  for line in lines {
    if (line = "" || SubStr(line, 1, 1) = "#")
      continue

    if (pos := InStr(line, "=")) {
      key := Trim(SubStr(line, 1, pos - 1))
      value := Trim(SubStr(line, pos + 1))

      if (SubStr(value, 1, 1) = "" "" && SubStr(value, -1) = "" "") {
        value := SubStr(value, 2, StrLen(value) - 2)
      }

      vars[key] := value
    }
  }

  return vars
}

WriteEnv(envFile, vars) {
  if (!IsObject(vars)) {
    throw ValueError("Expected a Map object of environment variables")
  }

  content := ""

  for key, value in vars {
    if (key = "")
      continue

    if (InStr(value, " ") || InStr(value, "#") || InStr(value, "="))
      value := '"' . value . '"'

    content .= key "=" value "`n"
  }

  try {
    FileDelete(envFile)
    FileAppend(content, envFile, "UTF-8")
    return true
  } catch Error as err {
    MsgBox("Error writing .env file: " err.Message)
    return false
  }
}

UrlEncode(Url, Flags := 0x000C3000) {
  Local CC := 4096, Esc := "", Result := ""
  Loop
    VarSetStrCapacity(&Esc, CC), Result := DllCall("Shlwapi.dll\UrlEscapeW", "Str", Url, "Str", &Esc, "UIntP", &CC, "UInt", Flags, "UInt")
  Until Result != 0x80004003 ; E_POINTER
  Return Esc
}

UrlDecode(Url, Flags := 0x00140000) {
  Return !DllCall("Shlwapi.dll\UrlUnescape", "Ptr", StrPtr(Url), "Ptr", 0, "UInt", 0, "UInt", Flags, "UInt") ? Url : ""
}

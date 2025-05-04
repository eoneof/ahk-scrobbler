HttpRequest(url, method := "GET", payload := "", headers := "") {
  async := true

  try {
    http := ComObject("WinHttp.WinHttpRequest.5.1")
    http.Open(method, url, async)
    http.SetRequestHeader("User-Agent", "Mozilla/5.0")
    http.SetRequestHeader("Accept", "application/json")

    if (headers) {
      for key, value in headers {
        http.SetRequestHeader(key, value)
      }
    }

    if (method = "POST" && payload) {
      http.SetRequestHeader("Content-Type", "application/json")
    }

    payload ? http.Send(payload) : http.Send()

    http.WaitForResponse()

    message := http.ResponseText
    status := http.Status

    return {
      status: status,
      message: message,
      success: (status >= 200 && status < 300)
    }
  } catch Error as err {
    return {
      status: 0,
      message: err.Message,
      success: false,
      error: err
    }
  }
}

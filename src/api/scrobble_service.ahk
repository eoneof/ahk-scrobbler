class Scrobbler {
  __New(apiKey, apiSecret, sessionKey) {
    this.ApiKey := apiKey
    this.ApiSecret := apiSecret
    this.SessionKey := sessionKey
  }

  SendNowPlaying(artist, track, album := "") {
    payload := "method=track.updateNowPlaying"
    payload .= "&sk=" . this.SessionKey
    payload .= "&api_key=" . this.ApiKey
    payload .= "&artist=" . UrlEncode(artist)
    payload .= "&track=" . UrlEncode(track)
    payload .= "&album=" . UrlEncode(album)

    HttpRequest(SCROBBLER_API_URL, "POST", payload)
    }

  Scrobble(artist, track, album := "", timestamp := CurrentUnixTime()) {
    payload := "method=track.scrobble"
    payload .= "&sk=" . this.SessionKey
    payload .= "&api_key=" . this.ApiKey
    payload .= "&artist=" . UrlEncode(artist)
    payload .= "&track=" . UrlEncode(track)
    payload .= "&timestamp=" . timestamp
    payload .= "&album=" . UrlEncode(album)

    signature := "album" . album
    signature .= "api_key" . this.ApiKey
    signature .= "artist" . artist
    signature .= "methodtrack.scrobble"
    signature .= "sk" . this.SessionKey
    signature .= "timestamp" . timestamp
    signature .= "track" . track
    signature .= this.ApiSecret

    payload .= "&api_sig=" . Hash.String("MD5", signature)
    payload .= "&format=json"

    HttpRequest(SCROBBLER_API_URL, "POST", payload)
    }

  LoveTrack(artist, track) {
    payload := "method=track.love"
    payload .= "&sk=" . this.SessionKey
    payload .= "&api_key=" . this.ApiKey
    payload .= "&artist=" . UrlEncode(artist)
    payload .= "&track=" . UrlEncode(track)

    signature := "api_key" . this.ApiKey
    signature .= "artist" . artist
    signature .= "methodtrack.lovesk" . this.SessionKey
    signature .= "track" . track
    signature .= this.ApiSecret

    payload .= "&api_sig=" . Hash.String("MD5", signature)
    payload .= "&format=json"

    HttpRequest(SCROBBLER_API_URL, "POST", payload)
  }
}

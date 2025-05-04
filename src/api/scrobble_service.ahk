SendNowPlaying(artist, track, album := "") {
  payload := "method=track.updateNowPlaying"
  payload .= "&sk=" . SESSION_KEY
  payload .= "&api_key=" . API_KEY
  payload .= "&artist=" . UrlEncode(artist)
  payload .= "&track=" . UrlEncode(track)
  payload .= "&album=" . UrlEncode(album)

  HttpRequest(SCROBBLER_API_URL, "POST", payload)
}

Scrobble(artist, track, album := "", timestamp := CurrentUnixTime()) {
  payload := "method=track.scrobble"
  payload .= "&sk=" . SESSION_KEY
  payload .= "&api_key=" . API_KEY
  payload .= "&artist=" . UrlEncode(artist)
  payload .= "&track=" . UrlEncode(track)
  payload .= "&timestamp=" . timestamp
  payload .= "&album=" . UrlEncode(album)

  signature := "album" . album
  signature .= "api_key" . API_KEY
  signature .= "artist" . artist
  signature .= "methodtrack.scrobble"
  signature .= "sk" . SESSION_KEY
  signature .= "timestamp" . timestamp
  signature .= "track" . track
  signature .= API_SECRET

  payload .= "&api_sig=" . Hash.String("MD5", signature)
  payload .= "&format=json"

  HttpRequest(SCROBBLER_API_URL, "POST", payload)
}

LoveTrack(artist, track) {
  payload := "method=track.love"
  payload .= "&sk=" . SESSION_KEY
  payload .= "&api_key=" . API_KEY
  payload .= "&artist=" . UrlEncode(artist)
  payload .= "&track=" . UrlEncode(track)

  signature := "api_key" . API_KEY
  signature .= "artist" . artist
  signature .= "methodtrack.lovesk" . SESSION_KEY
  signature .= "track" . track
  signature .= API_SECRET

  payload .= "&api_sig=" . Hash.String("MD5", signature)
  payload .= "&format=json"

  return HttpRequest(SCROBBLER_API_URL, "POST", payload)
}

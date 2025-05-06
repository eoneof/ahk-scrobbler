class MediaMonitor {
  __New(media, scrobbleService) {
    this.Media := media
    this.ScrobbleService := scrobbleService
    this.LastTrack := ""
    this.LastArtist := ""
    this.HasScrobbled := false
    this.MediaSession := ""
  }

  GetMediaSessionStatus(session) {
    closed := 0
    playing := 1
    paused := 2
    stopped := 3
    changing := 4
    seeking := 5
    isAllowed := false

    if (!session || !session.HasProp("PlaybackStatus")) {
      return false
    }

    try {
      status := session.PlaybackStatus
      appId := session.SourceAppUserModelId

      for appName in ALLOWED_APPS {
        if (InStr(appId, appName)) {
          isAllowed := true

          break
        }
      }

      if (!isAllowed) {
        return false
      }

      return status !== closed
    } catch Error as err {
      return false
    }
  }

  CheckCurrentTrack() {
    try {
      this.MediaSession := this.Media.GetCurrentSession()
      if (!this.GetMediaSessionStatus(this.MediaSession)) {
        SetTimer(this.CheckCurrentTrack.Bind(this), TRACK_POLLING_INTERVAL)
        return
      }
    } catch {
      this.MediaSession := ""
      SetTimer(this.CheckCurrentTrack.Bind(this), TRACK_POLLING_INTERVAL)
      return
    }

    currentArtist := this.MediaSession.Artist
    currentTrack := this.MediaSession.Title
    currentLength := this.MediaSession.EndTime
    currentPosition := this.MediaSession.Position

    A_IconTip := "▶ " . currentArtist . " — " . currentTrack

    if (
      currentTrack &&
      currentArtist &&
      (
        currentTrack != this.LastTrack ||
        currentArtist != this.LastArtist
      )
    ) {
      this.LastTrack := currentTrack
      this.LastArtist := currentArtist
      this.HasScrobbled := false

      this.ScrobbleService.SendNowPlaying(currentArtist, currentTrack)

      scrobbleDelay := this.CalculateScrobbleDelay(currentLength)

      if (scrobbleDelay > 0) {
        SetTimer(this.ScrobbleCurrentTrack.Bind(this), -scrobbleDelay)
      }
    }
  }

  CalculateScrobbleDelay(trackLength) {
    if (!trackLength) {
      return SCROBBLE_DELAY
    }

    scrobbleAt := Min(trackLength * TRACK_LENGTH_FACTOR, MIN_TIME_BEFORE_SCROBBLE)
    waitAtLeast := Max(scrobbleAt, SCROBBLE_DELAY)

    return waitAtLeast
  }

  ScrobbleCurrentTrack() {
    if (!this.MediaSession || this.HasScrobbled) {
      return
    }

    checkArtist := this.MediaSession.Artist
    checkTrack := this.MediaSession.Title

    if (
      checkTrack = this.LastTrack &&
      checkArtist = this.LastArtist
    ) {
      this.ScrobbleService.Scrobble(checkArtist, checkTrack)
      this.HasScrobbled := true
    }
  }

  LoveCurrentTrack() {
    if (!this.MediaSession) {
      return
    }
    this.ScrobbleService.LoveTrack(this.MediaSession.Artist, this.MediaSession.Title)
  }

  Start() {
    this.LastTrack := ""
    this.LastArtist := ""
    this.HasScrobbled := false
    this.MediaSession := ""

    SetTimer(this.CheckCurrentTrack.Bind(this), TRACK_POLLING_INTERVAL)
  }
}

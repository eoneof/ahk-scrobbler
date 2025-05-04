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
    global MediaSession := Media.GetCurrentSession()

    if (!GetMediaSessionStatus(MediaSession)) {
      SetTimer(CheckCurrentTrack, TRACK_POLLING_INTERVAL)
      return
    }
  } catch {
    global MediaSession := ""
    SetTimer(CheckCurrentTrack, TRACK_POLLING_INTERVAL)
    return
  }

  currentArtist := MediaSession.Artist
  currentTrack := MediaSession.Title
  currentLength := MediaSession.EndTime
  currentPosition := MediaSession.Position

  A_IconTip := "▶ " . currentArtist . " — " . currentTrack

  if (
    currentTrack &&
    currentArtist &&
    (
      currentTrack != LastTrack ||
      currentArtist != LastArtist
    )
  ) {
    global LastTrack := currentTrack
    global LastArtist := currentArtist
    global HasScrobbled := false

    SendNowPlaying(currentArtist, currentTrack)

    scrobbleDelay := CalculateScrobbleDelay(currentLength)

    if (scrobbleDelay > 0) {
      SetTimer(ScrobbleCurrentTrack, -scrobbleDelay)
    }
  }
}

CalculateScrobbleDelay(trackLength) {
  if (!trackLength) {
    return SCROBBLE_DELAY
  }

  ; Scrobble at predefined % of track length or predefined seconds, whichever comes first
  scrobbleAt := Min(trackLength * TRACK_LENGTH_FACTOR, MIN_TIME_BEFORE_SCROBBLE)
  waitAtLeast := Max(scrobbleAt, SCROBBLE_DELAY)

  return waitAtLeast
}

ScrobbleCurrentTrack() {
  if (!MediaSession || HasScrobbled) {
    return
  }

  checkArtist := MediaSession.Artist
  checkTrack := MediaSession.Title

  if (
    checkTrack = LastTrack &&
    checkArtist = LastArtist
  ) {
    Scrobble(checkArtist, checkTrack)
    global HasScrobbled := true
  }
}

LoveCurrentTrack() {
  if (!MediaSession) {
    return
  }

  LoveTrack(MediaSession.Artist, MediaSession.Title)
}

StartMediaMonitor() {
  global LastTrack := ""
  global LastArtist := ""
  global ScrobbleTime := 0
  global HasScrobbled := false
  global MediaSession := ""

  CheckCurrentTrack()

  SetTimer(CheckCurrentTrack, 0)
  SetTimer(CheckCurrentTrack, TRACK_POLLING_INTERVAL)
}

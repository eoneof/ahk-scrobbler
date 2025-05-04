CurrentUnixTime() => DateDiff(A_NowUTC, "1970", "s")

CurrentTimeMillis() => CurrentUnixTime() * 1000 + A_MSec

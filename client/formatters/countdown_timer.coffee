CookingWith.formatters ?= {}

CookingWith.formatters.countdown_timer = (span) ->
    secondsLeft = span / 1000
    days = Math.floor secondsLeft / 86400
    secondsLeft = secondsLeft - days * 86400
    hours = Math.floor secondsLeft / 3600
    secondsLeft = secondsLeft - hours * 3600
    minutes = Math.floor secondsLeft / 60
    secondsLeft = secondsLeft - minutes * 60
    seconds = Math.floor secondsLeft

    str = zeroPad(hours) + ':' + zeroPad(minutes) + ':' + zeroPad(seconds)
    str = zeroPad(days) + ':' + str if days
    str

zeroPad = (str) ->
    str = str.toString()
    if str.length is 1 then '0' + str else str
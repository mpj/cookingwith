F = CookingWith.facade
T = Template.deadline

T.clock = ->
  if F.timeToStart() > 0
    CookingWith.formatters.countdown_timer F.timeToStart()
  else
    CookingWith.formatters.countdown_timer F.timeToEnd()

T.stateIs = (stateName) ->
  state() is stateName

# Interrim Session storage to get a slightly more
# clever caching to prevent hojillions of DOM updates.
# Perhaps try fixing this by implementing bacon.js if we have to do this
# a lot.
state = -> Session.get '__deadline_state'
calculateState = ->
  return 'lacks_start' if not F.timeToStart()?
  return 'lacks_end'   if not F.timeToEnd()?
  return 'waiting'     if F.timeToStart()? and F.timeToStart() > 0
  return 'passed'      if F.timeToEnd() <= 0
  return 'running'

Deps.autorun -> Session.set '__deadline_state', calculateState()



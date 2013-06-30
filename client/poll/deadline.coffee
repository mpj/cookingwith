
Template.deadline.clock = ->
  if CookingWith.facade.timeToStart() > 0
    CookingWith.formatters.countdown_timer CookingWith.facade.timeToStart()
  else
    CookingWith.formatters.countdown_timer CookingWith.facade.timeToEnd()

Template.deadline.waiting = -> CookingWith.facade.timeToStart() > 0
Template.deadline.passed = ->  CookingWith.facade.timeToEnd() <= 0
Template.deadline.running = -> not Template.deadline.waiting() and not Template.deadline.passed()
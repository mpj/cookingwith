
_.extend Template.refill_time,
  is_visible:        -> !!CookingWith.facade.timeToRefill()
  time_until_refill: -> CookingWith.formatters.countdown_timer model.timeToRefill()

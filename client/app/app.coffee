model = CookingWith.model


Template.app.events
  'click .buy_votes': (e) ->
    model.request_vote_buy()
    e.preventDefault()

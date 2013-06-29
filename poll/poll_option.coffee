if Meteor.isClient
  Template.poll_option.events
    'click .vote': (e) ->
      e.preventDefault()
      CookingWith.facade.vote(this)

  Template.poll_option.vote_button_class = ->
    if not CookingWith.facade.can_vote() then 'disabled'
    else 'btn-primary'


Template.poll.isVisible = ->
  CookingWith.router.state().name is 'poll' and CookingWith.facade.poll_current()

Template.poll.my_votes = CookingWith.facade.my_votes
Template.poll.poll_options = CookingWith.facade.list_options
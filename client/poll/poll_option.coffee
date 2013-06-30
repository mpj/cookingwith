
Template.poll_option.events
  'click .vote': (e) ->
    e.preventDefault()
    CookingWith.facade.vote(this)

Template.poll_option.vote_button_class = ->
  Session.get('__vote_button_class')

# Because can_vote updates a LOT and has no smart change
# dispatching, we use Session as interim storage, to keep
# the button from wildly flashing. Slighly hacky, but it works
# for now.
Deps.autorun ->
  Session.set '__vote_button_class',
    if CookingWith.facade.can_vote() then 'btn-primary' else 'disabled'

Template.poll_option.preserve '.poll_option .votes_container .vote'
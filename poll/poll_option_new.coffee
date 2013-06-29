if Meteor.isClient
  Template.poll_option_new.isStateReady = ->
      Session.get('poll_option_new_state') is not 'adding' or not
      Session.get('poll_option_new_state')?

  Template.poll_option_new.isStateAdding = ->
    Session.get('poll_option_new_state') is 'adding'

  Template.poll_option_new.events
    'click .new': (e) ->
      e.preventDefault()
      Session.set 'poll_option_new_state', 'adding'

    'keydown input[type=text]': (e) ->
      isEnter = e.keyCode is 13
      if isEnter and e.target.value.trim().length >= 3
        e.preventDefault()
        console.log "adding value", e.target.value
        CookingWith.facade.addOption e.target.value
        e.target.value = ''
        Session.set 'poll_option_new_state', null
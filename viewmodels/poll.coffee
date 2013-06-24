model = CookingWith.model

zeroPad = (str) -> if str.length is 1 then str else '0' + str

if Meteor.isClient

  Template.hello.my_votes = model.my_votes

  Template.refill_time.is_visible = ->
    !!model.timeToRefill()

  Template.refill_time.time_until_refill = ->
    diff = model.timeToRefill()
    secondsLeft = diff / 1000
    hours = Math.floor secondsLeft / 3600
    secondsLeft = secondsLeft - hours * 3600
    minutes = Math.floor secondsLeft / 60
    secondsLeft = secondsLeft - minutes * 60
    seconds = Math.floor secondsLeft
    zeroPad(hours) + ':' + zeroPad(minutes) + ':' + zeroPad(seconds)


  Template.hello.poll_options = model.list_options

  Template.poll_option.events
    'click .vote': (e) ->
      e.preventDefault()
      model.vote(this)


  Template.poll_option.vote_button_class = ->
    if not model.my_votes()
      'disabled'
    else
      'btn-primary'

  Template.hello.events
    'click .buy_votes': (e) ->
      model.request_vote_buy()
      e.preventDefault()


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
        model.addOption e.target.value
        e.target.value = ''
        Session.set 'poll_option_new_state', null

  Template.poll_settings.isVisible = -> true

  Template.poll_settings.events
    'onchange input': ->
      console.log "change"
    'change input': ->
      console.log "change"
    'changed input': ->
      console.log "change"
    'keydown input': ->
      console.log "change"
    'keyup input': ->
      console.log "change"

  Template.poll_settings.rendered = ->
    $(this.find('.form_datetime')).datetimepicker({
      showMeridian: 0,
      autoclose: true
    }).on 'changeDate', (e) ->
      model.setEndEpoch e.date.valueOf()


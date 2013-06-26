model = CookingWith.model



if Meteor.isClient

  Template.hello.my_votes = model.my_votes

  Template.refill_time.is_visible = ->
    !!model.timeToRefill()

  zeroPad = (str) ->
    str = str.toString()
    if str.length is 1 then '0' + str else str

  countdown_timer = (span) ->
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

  Template.refill_time.time_until_refill = ->
    countdown_timer model.timeToRefill()

  Template.deadline.clock = ->
    countdown_timer model.timeToEnd()

  Template.hello.poll_options = model.list_options

  Template.poll_option.events
    'click .vote': (e) ->
      e.preventDefault()
      model.vote(this)


  Template.poll_option.vote_button_class = ->
    if not model.can_vote() then 'disabled'
    else 'btn-primary'

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


  Template.poll_settings.rendered = ->
    $(this.find('.form_datetime')).datetimepicker({
      showMeridian: 0,
      autoclose: true,
      startDate: new Date(Date.now()),
      initialDate: new Date(model.deadline()),
      minuteStep: 1
    }).on 'changeDate', (e) ->

      UTCToLocalDate = (d) ->
        # bootstrap-timepicker will return the date in UTC. I.e. if you pick
        # 09:00 that will be really be 9AM UTC, not your local time. This is
        # not how we want to interpret things (because it seems messed up) so
        # let's intepret it as local time instead.
        new Date(d.getUTCFullYear(), d.getUTCMonth(), d.getUTCDate(), d.getUTCHours(), d.getUTCMinutes(), d.getUTCSeconds(), 0)

      model.setEndEpoch Number(UTCToLocalDate(e.date))


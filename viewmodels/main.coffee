model = CookingWith.model



if Meteor.isClient

  Template.poll.isVisible = ->
    CookingWith.router.state().name is 'poll' and model.poll_current()

  Template.poll.my_votes = model.my_votes

  Template.poll.poll_options = model.list_options

  Template.poll_title.title = ->
    model.poll_current().title

  Template.poll_title.state_edit =->
    Session.get('poll_title_state') is 'edit'

  Template.poll_title.events =
    'click .title': ->
      Session.set 'poll_title_state', 'edit'
    'blur input[type=text]': ->
      Session.set 'poll_title_state', 'normal'
    'change input[type=text]': (e) ->
      CookingWith.data.polls.update CookingWith.router.state().id,
        $set: title: e.target.value

  Template.poll_title.rendered = ->
    if Template.poll_title.state_edit()
      $(".poll_title input[type='text']").focus()



  Template.poll_list.isVisible = ->
    CookingWith.router.state().name is 'polls'

  Template.poll_list.polls = ->
    model.polls().map (p) ->
      title: p.title
      href: '/p/' + p._id


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
    if model.timeToStart() > 0
      countdown_timer model.timeToStart()
    else
      countdown_timer model.timeToEnd()

  Template.deadline.waiting = -> model.timeToStart() > 0
  Template.deadline.passed = ->  model.timeToEnd() <= 0
  Template.deadline.running = -> not Template.deadline.waiting() and not Template.deadline.passed()




  Template.container.events
    'click .buy_votes': (e) ->
      model.request_vote_buy()
      e.preventDefault()


  Template.poll_settings.isVisible = -> true

  UTCToLocalDate = (d) ->
    # bootstrap-timepicker will return the date in UTC. I.e. if you pick
    # 09:00 that will be really be 9AM UTC, not your local time. This is
    # not how we want to interpret things (because it seems messed up) so
    # let's intepret it as local time instead.
    new Date  d.getUTCFullYear(),
              d.getUTCMonth(),
              d.getUTCDate(),
              d.getUTCHours(),
              d.getUTCMinutes(),
              d.getUTCSeconds(),
              0

  Template.poll_settings.rendered = ->
    $('.poll_settings .end .form_datetime').datetimepicker({
      showMeridian: 0
      autoclose: true
      startDate: new Date(Date.now())
      initialDate: if model.deadline() then new Date(model.deadline())
      minuteStep: 1
    }).on 'changeDate', (e) ->
      model.setEndEpoch Number(UTCToLocalDate(e.date))

    $('.poll_settings .start .form_datetime').datetimepicker({
      showMeridian: 0
      autoclose: true
      startDate: new Date(Date.now())
      initialDate: if model.beginning() then new Date(model.beginning())
      minuteStep: 1
    }).on 'changeDate', (e) ->
      model.setBeginning Number(UTCToLocalDate(e.date))


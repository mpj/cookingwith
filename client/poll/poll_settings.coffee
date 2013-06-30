
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
    initialDate: if CookingWith.facade.deadline() then new Date(CookingWith.facade.deadline())
    minuteStep: 1
  }).on 'changeDate', (e) ->
    CookingWith.facade.setEndEpoch Number(UTCToLocalDate(e.date))

  $('.poll_settings .start .form_datetime').datetimepicker({
    showMeridian: 0
    autoclose: true
    startDate: new Date(Date.now())
    initialDate: if CookingWith.facade.beginning() then new Date(CookingWith.facade.beginning())
    minuteStep: 1
  }).on 'changeDate', (e) ->
    CookingWith.facade.setBeginning Number(UTCToLocalDate(e.date))


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
    'click .vote': model.vote

  Template.poll_option.vote_button_class = ->
    if not model.my_votes()
      'disabled'
    else
      'btn-primary'

  Template.hello.events
    'click .buy_votes': model.request_vote_buy

if Meteor.isServer
  Meteor.startup ->
    # // code to run on server at startup

CookingWith.bootstrap = ->
  poll_options.remove {}
  poll_options.insert
    title: 'Kim Jon Il cooks pasta'
    votes_count: 12
  poll_options.insert
    title: 'Obama shows shows to shop for a hat'
    votes_count: 11
  poll_options.insert
    title: 'Stellan Skarsgård shows how to do a hole in one'
    votes_count: 9


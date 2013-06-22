poll_options = new Meteor.Collection 'poll_options'


if Meteor.isClient
  Template.hello.greeting = ->
    "Welcome to cookingwith."

  Template.hello.poll_options = ->
    poll_options.find()

  Template.hello.events
    'click .clear': -> CookingWith.bootstrap()

  Template.poll_option.events
    'click .vote': ->
      poll_options.update this._id, { $inc: { votes_count: 1 } }

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


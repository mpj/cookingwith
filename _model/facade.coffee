poll_options = new Meteor.Collection 'poll_options'



CookingWith.model =

  my_votes: ->
    return 0 if not Meteor.user()
    Meteor.user().profile.votes_count

  list_options: -> poll_options.find {}, sort: votes_count: -1

  request_vote_buy: ->
    Meteor.users.update Meteor.userId(), $inc: 'profile.votes_count': 25

  vote: ->
    if Meteor.user().profile.votes_count > 0
      poll_options.update this._id,
        $inc: votes_count: 1
      Meteor.users.update Meteor.userId(),
        $inc: 'profile.votes_count': -1
      if Meteor.user().profile.votes_count is 0
        Meteor.users.update Meteor.userId(),
          $set: 'profile.votes_emptied_at':
            CookingWith.ServerTime.instance.epoch()
      else
        console.log "not zero", Meteor.user().profile.votes_count

  timeToRefill: ->
    time = Meteor.user().profile.votes_emptied_at +
    REFILL_TIME_MS -
    CookingWith.ServerTime.instance.reactiveEpoch()
    Math.max time, 0






  options: ->
    [
      {
        title: 'Kim Jon Il cooks pasta'
        votes_count: 12
      },{
          title: 'Obama shows shows to shop for a hat'
        votes_count: 11
      },{
        title: 'Stellan Skarsgård shows how to do a hole in one'
        votes_count: 9
      }
    ]
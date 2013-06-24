poll_options = new Meteor.Collection 'poll_options'
polls = new Meteor.Collection 'polls'

CookingWith.data = {
  poll_options: poll_options
  polls: polls
}

CookingWith.model =

  poll_current: ->
    id = Session.get 'current_poll_id'
    if not id?
      id = polls.insert title: 'Untitled poll'
      Session.set 'current_poll_id', id
    polls.findOne id

  my_votes: ->
    return 0 if not Meteor.user()
    Meteor.user().profile.votes_count

  list_options: ->
    poll_options.find {
      'poll_id': CookingWith.model.poll_current()._id
    }, sort: votes_count: -1

  request_vote_buy: ->
    Meteor.users.update Meteor.userId(), $inc: 'profile.votes_count': 25

  vote: (poll_option) ->
    if Meteor.user().profile.votes_count > 0
      poll_options.update poll_option._id,
        $inc: votes_count: 1
      Meteor.users.update Meteor.userId(),
        $inc: 'profile.votes_count': -1
      if Meteor.user().profile.votes_count is 0
        Meteor.users.update Meteor.userId(),
          $set: 'profile.votes_emptied_at':
            CookingWith.ServerTime.instance.epoch()

  timeToRefill: ->
    time = Meteor.user().profile.votes_emptied_at +
    REFILL_TIME_MS -
    CookingWith.ServerTime.instance.reactiveEpoch()
    Math.max time, 0

  addOption: (title) ->
    poll_options.insert
      title: title
      votes_count: 0
      poll_id: CookingWith.model.poll_current()._id

  setEndEpoch: (epoch) ->
    console.log("setEndEpoch", epoch)
    # TODO check if admin
    # TODO use url navigation instead of session
    id = CookingWith.model.poll_current()._id
    console.log "updating", id
    polls.update id,
      $set: 'end_epoch': epoch



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
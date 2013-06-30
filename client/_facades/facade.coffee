
polls = CookingWith.data.polls
poll_options = CookingWith.data.poll_options

CookingWith.model =

  deadline: -> CookingWith.model.poll_current().end_epoch
  beginning: -> CookingWith.model.poll_current().start_epoch

  polls: -> polls.find {}

  poll_current: -> polls.findOne CookingWith.router.state().id

  my_votes: ->
    return 0 if not Meteor.user()
    Meteor.user().profile.votes_count

  # TODO deprecate
  can_vote: ->
    return false if not CookingWith.model.poll_current()?
    CookingWith.model.my_votes() > 0 &&
    CookingWith.model.poll_current().end_epoch >
      CookingWith.ServerTime.instance.reactiveEpoch()

  can_vote_on: (poll_id, user_id) ->
    user = Meteor.users.findOne user_id
    return false if not user?
    poll = CookingWith.data.polls.findOne poll_id
    return false if not poll?

    user.profile.votes_count > 0 and
    poll.end_epoch > CookingWith.ServerTime.instance.reactiveEpoch()

  list_options: ->
    if CookingWith.model.poll_current()
      poll_options.find {
        'poll_id': CookingWith.model.poll_current()._id
      }, sort: votes_count: -1

  request_vote_buy: ->
    Meteor.users.update Meteor.userId(), $inc: 'profile.votes_count': 25

  vote: (poll_option) ->
    return if not CookingWith.facade.can_vote_on poll_option.poll_id, Meteor.userId()
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
    return 0 if not Meteor.user()?
    time = Meteor.user().profile.votes_emptied_at +
    CookingWith.config.REFILL_TIME_MS -
    CookingWith.ServerTime.instance.reactiveEpoch()
    Math.max time, 0

  timeToEnd: ->
    poll = CookingWith.model.poll_current()
    return 0 if not poll or not poll.end_epoch?
    poll.end_epoch - CookingWith.ServerTime.instance.reactiveEpoch()

  timeToStart: ->
    poll = CookingWith.model.poll_current()
    return 0 if not poll or not poll.start_epoch?
    poll.start_epoch - CookingWith.ServerTime.instance.reactiveEpoch()

  addOption: (title) ->
    poll_options.insert
      title: title
      votes_count: 0
      poll_id: CookingWith.model.poll_current()._id

  # TODO check if admin
  setEndEpoch: (epoch) ->
    polls.update CookingWith.model.poll_current()._id,
      $set: 'end_epoch': epoch
  setBeginning: (epoch) ->
    polls.update CookingWith.model.poll_current()._id,
      $set: 'start_epoch': epoch

CookingWith.facade = CookingWith.model
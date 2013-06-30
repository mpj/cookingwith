Meteor.startup ->


  Meteor.users._ensureIndex 'profile.votes_emptied_at': 1

  refill_votes = ->
    selector =
      'profile.votes_emptied_at':
        $ne: null
        $lt: (Number(new Date()) - CookingWith.config.REFILL_TIME_MS)

    modifier =
      $set:
        'profile.votes_emptied_at': null
        'profile.votes_count': 10

    Meteor.users.update selector, modifier

  Meteor.setInterval refill_votes, 250
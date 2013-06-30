if Meteor.isClient
  Template.poll_list.isVisible = ->
    CookingWith.router.state().name is 'polls'

  Template.poll_list.polls = ->
    CookingWith.facade.polls().map (p) ->
      title: p.title
      href: '/p/' + p._id

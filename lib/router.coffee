if Meteor.isClient
  # The client router, using Backbone routing.
  # http://documentcloud.github.com/backbone/#Router
  #
  state = (value) ->
    if value? then Session.set 'router_state', value
    else Session.get('router_state') ? {}

  CookingWithRouter = Backbone.Router.extend

    routes:
      '':               'root'
      'polls':          'polls'
      'p/:id':          'poll'

    root: -> state null

    poll: (id) -> state name: 'poll', id: id
    polls: () -> state name: 'polls'

    state: state

    current_poll_id: (id) ->
      this.navigate 'p/' + id, trigger: true if id?
      state().id if state().name is 'poll'

  CookingWith.router = new CookingWithRouter()
  Backbone.history.start pushState: true
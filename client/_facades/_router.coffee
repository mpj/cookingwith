
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

  root: ->
    id = CookingWith.data.polls.insert
      title: 'Untitled poll'
    this.navigate 'p/' + id, trigger: true

  poll: (id) -> state name: 'poll', id: id
  polls: () -> state name: 'polls'

  state: state

CookingWith.router = new CookingWithRouter()
Backbone.history.start pushState: true
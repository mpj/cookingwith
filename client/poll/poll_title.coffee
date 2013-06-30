
Template.poll_title.title = ->
  CookingWith.facade.poll_current().title

Template.poll_title.state_edit =->
  Session.get('poll_title_state') is 'edit'

Template.poll_title.events =
  'click .title': ->
    Session.set 'poll_title_state', 'edit'
  'blur input[type=text]': ->
    Session.set 'poll_title_state', 'normal'
  'change input[type=text]': (e) ->
    CookingWith.data.polls.update CookingWith.router.state().id,
      $set: title: e.target.value

Template.poll_title.rendered = ->
  if Template.poll_title.state_edit()
    $(".poll_title input[type='text']").focus()
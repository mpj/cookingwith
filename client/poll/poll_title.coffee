T = Template.poll_title
F = CookingWith.facade
D = CookingWith.data
R = CookingWith.router

T.title = -> F.poll_current().title

T.state_edit = -> Session.get('poll_title_state') is 'edit'

T.events =

  'click .title':          -> Session.set 'poll_title_state', 'edit'
  'blur input[type=text]': -> Session.set 'poll_title_state', 'normal'

  'keydown input[type=text]': (e) ->

    if isEsc = e.keyCode is 27
      e.target.blur()

    if isEnter = e.keyCode is 13
      D.polls.update R.state().id,
        $set: title: e.target.value
      e.target.blur()

T.rendered = -> $(".poll_title input[type='text']").focus() if T.state_edit()
CookingWith = {}

//REFILL_TIME_MS = 24 * 3600 * 1000;
REFILL_TIME_MS = 6000;


CookingWith.data = {
  poll_options: new Meteor.Collection('poll_options'),
  polls: new Meteor.Collection('polls')
}


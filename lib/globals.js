CookingWith = {}

//REFILL_TIME_MS = 24 * 3600 * 1000;
REFILL_TIME_MS = 6000;

Meteor.methods({

  /*
   * Server method that simply returns the time on the server
   * as a unix timestamp. This is used by clients to keep playing
   * in sync even if someones clock is a little off.
   */
  serverTime: function () {
    return Number(new Date());
  }

});

var ignore_files = [
    /~$/, /^\.#/, /^#.*#$/,
    /^\.DS_Store$/, /^ehthumbs\.db$/, /^Icon.$/, /^Thumbs\.db$/,
    /^\.meteor$/, /* avoids scanning N^2 files when bundling all packages */
    /^\.git$/, /* often has too many files to watch */
    /^\flat-ui$/ /* often has too many files to watch */
];

if (Meteor.isServer) {
  Meteor.users._ensureIndex({ 'profile.votes_emptied_at': 1 } );
  Meteor.setInterval(function() {
    Meteor.users.update({
      'profile.votes_emptied_at': {
        $ne: null,
        $lt: (Number(new Date()) - REFILL_TIME_MS)
      }
    }, {
      $set: {
        'profile.votes_emptied_at': null,
        'profile.votes_count': 10
      }
    });
  }, 250);
}

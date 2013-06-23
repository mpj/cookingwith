CookingWith = {}

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
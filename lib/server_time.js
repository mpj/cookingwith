/*
 * The ServerTime class is meant to be used in the client,
 * as a substitute to Number(new Date()). Instead,
 * ServerTime keeps it's internal time in sync with the
 * server so that calls to the epoch() method returns a
 * time very, very close to the real time on the server.
 */

// First set up a method on the server for fetching the time
if (Meteor.isServer) {

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

}

// Then create the client for servertime on the
// client side.
if(Meteor.isClient) {

  CookingWith.ServerTime = function() {
    this._offSet = 0;
  };

  CookingWith.ServerTime.prototype = {

    // Starts calling the server, keeping in sync.
    startSynchronizing: function() {

      this._synchronize();

        // Re-sync time every 2 minutes, just in case the user
        // keeps the window open a very long time.
        var that = this;
        Meteor.setInterval(function() {
          that._synchronize.call(that);
        }, 2*60*100);
    },

    epoch: function() {
      return Number(new Date()) - this._offSet;
    },

    reactiveEpoch: function() {
      var self = this;
      var sKey = '__ServerTime.reactiveEpoch';
      if (!CookingWith.ServerTime.reactiveEpochHandle) {
        CookingWith.ServerTime.reactiveEpochHandle = Meteor.setInterval(function() {
          Session.set(sKey, self.epoch());
        }, 100);
        Session.set(sKey, self.epoch());
      }
      return Session.get(sKey);
    },

    _synchronize: function() {
      var callBegin = Number(new Date());
      var that = this;
        Meteor.call('serverTime', function(error, result) {
          var callEnd = Number(new Date());
          var requestTime = callEnd - callBegin;
          that._updateTime(result, requestTime);
        });
    },

    _updateTime: function(serverEpochNow, requestTime) {
      this._offSet = Number(new Date()) - serverEpochNow;
      if (requestTime) {
        // Compensate for latency. We're
        // guessing that the trip to server is
        // half of the request time.
        this._offSet -= requestTime/2;
      }
    }

  };

  CookingWith.ServerTime.instance = new CookingWith.ServerTime();
  CookingWith.ServerTime.instance.startSynchronizing()
}
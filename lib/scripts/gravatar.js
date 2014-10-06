// Description
//   A Hubot script that returns your gravatar
//
// Configuration:
//   None
//
// Commands:
//   hubot gravatar <email> - returns your gravatar
//
// Author:
//   bouzuya <m@bouzuya.net>
//
module.exports = function(robot) {
  var crypto, getUrl;
  crypto = require('crypto');
  getUrl = function(email) {
    var hash, md5;
    md5 = crypto.createHash('md5');
    md5.update(email);
    hash = md5.digest('hex');
    return "http://www.gravatar.com/avatar/" + hash;
  };
  return robot.respond(/gravatar (.+)$/i, function(res) {
    var email;
    email = res.match[1];
    return res.send(getUrl(email));
  });
};

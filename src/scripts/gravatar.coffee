# Description
#   A Hubot script that returns your gravatar
#
# Configuration:
#   None
#
# Commands:
#   hubot gravatar <email> - returns your gravatar
#
# Author:
#   bouzuya <m@bouzuya.net>
#
module.exports = (robot) ->
  crypto = require 'crypto'

  getUrl = (email) ->
    md5 = crypto.createHash 'md5'
    md5.update email
    hash = md5.digest 'hex'
    "http://www.gravatar.com/avatar/#{hash}"

  robot.respond /gravatar (.+)$/i, (res) ->
    email = res.match[1]
    res.send getUrl email

# Description
# Tells hubot to delete content of the <N> most recent hubot messages (only deletes message content)
#
# Dependencies:
#   None
#
# Configuration:
#   HUBOT_FLOWDOCK_API_TOKEN
#   HUBOT_NAME
#
# Commands:
# hubot abandon ship <#> - Number of most recent hubot messages to delete
# hubot delete <#> - Number of most recent hubot messages to delete
#
# Author:
# Chris Doughty <cdoughty77@gmail.com>
#
module.exports = (robot) ->
  robot.respond /abandon ship|delete(.*)/i, (msg) ->

    # Set the default API url
    default_url = "https://#{process.env.HUBOT_FLOWDOCK_API_TOKEN}@api.flowdock.com/flows"
    hubotName = robot.name
    hubotId = robot.brain.userForName(hubotName).id.toString()
    flowId = msg.message.user.room
    userName = msg.message.user.name
    prefix = "value"
    flowName = "#{prefix}.parameterized_name"
    orgName = "#{prefix}.organization.parameterized_name"
    msgContent = "#{prefix}.content.text"
    msgId = "#{prefix}.id"
    userId = "#{prefix}.user"

    # Parse the json data
    parseJson = (body)->
      try
        JSON.parse(body)
      catch error
        msg.send("Sorry, I wasn't able to parse the JSON data returned from the API call.")

    # Set the counter for messages to delete
    delCounter = ()->
      if (!isFinite(msg.match[1]) or Math.round(msg.match[1]) == 0) then 1 else Math.round(msg.match[1])

    # Search key/values in json response
    getValues = (json, keyId, matchingId, searchValue)->
      resultArray = []
      for key, value of parseJson(json)
        if eval(keyId) is matchingId then resultArray.push(eval(searchValue))
      resultArray

    # Only try if requested in a flow (not 1-on-1 chat)
    if flowId
      # Get all flows hubot knows about
      msg.robot.http(default_url).get() (err, res, body) ->
        org = getValues(body, msgId, flowId, orgName)
        flow = getValues(body, msgId, flowId, flowName)

        # Get 100 (API limit) most recent messages from all users in the current flow
        msg.robot.http("#{default_url}/#{org[0]}/#{flow[0]}/messages?limit=100").get() (err, res, mbody) ->
          hubot_msg_ids = getValues(mbody, userId, hubotId, msgId).reverse()

          # Delete message(s) up to user input or hubot msgs found (whichever is smaller)
          for num in [0..(Math.min.apply @, [delCounter(), hubot_msg_ids.length])-1] by 1
            msg_content = getValues(mbody, msgId, hubot_msg_ids[num], msgContent)
            robot.logger.info("User #{userName} deleted content [#{msg_content[0]}] in flow #{flow[0]}")
            msg.robot.http("#{default_url}/#{org[0]}/#{flow[0]}/messages/#{hubot_msg_ids[num]}").delete() (err, res, body) ->
    else
      msg.send("Sorry, I can't delete messages in 1-on-1 chats.")

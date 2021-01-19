--local inspect = require("inspect")
local internet = require("internet")
--local json = require("json")
json = require "json"
local headers = {}
headers["Content-Type"] = "application/json"
headers["Accept"] = "application/json"
local handle = internet.request(
  'https://cord-glorious-snail.glitch.me/',
  '{"client_id":"client_26cb29a2c00ce6d1795f359c","scopes":["user.basic_profile.read"]}',
  headers)
local result = ""
for chunk in handle do
  result = result..chunk
end
-- Print the body of the HTTP response

function decode(text)
  return json.decode(text)
end

local json = decode(result)
print("Enter this code on the SideQuest website ( https://sdq.st/link ) to continue:")
print(json.code)
-- Grab the metatable for the handle. This contains the
-- internal HTTPRequest object.
local mt = getmetatable(handle)

-- The response method grabs the information for
-- the HTTP response code, the response message, and the
-- response headers.
local code, message, headers = mt.__index.response()
-- print("code = "..tostring(code))
-- print("message = "..tostring(message))
-- print(inspect(headers))

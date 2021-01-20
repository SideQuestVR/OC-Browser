local htmlparser = require("htmlparser")
local shell = require("shell")
local internet = require("internet")
local args, options = shell.parse(...)
options.h = options.h or options.help
if #args <1 or options.h then
    io.write([[Usage: browser -u https://example.com
        -h, --help show this help
    ]])
    return not not options.h
end
local url = options.u
print("Opening Url: "..url)
local handle = internet.request(url)
local result = ""
for chunk in handle do
  result = result..chunk
end
local root = htmlparser.parse(result);
local elements = root:select('.test')
-- Print the body of the HTTP response
-- https://productive-invited-tachometer.glitch.me/
-- Grab the metatable for the handle. This contains the
-- internal HTTPRequest object.
local mt = getmetatable(handle)
for _,e in ipairs(elements) do
	print(string.sub(e.root._text, e._openend + 1, e._closestart - 1))
	local subs = e(subselectorstring)
	for _,sub in ipairs(subs) do
		print("", sub.name)
	end
end

-- The response method grabs the information for
-- the HTTP response code, the response message, and the
-- response headers.
local code, message, headers = mt.__index.response()
print("Code: "..tostring(code))
print("Message: "..tostring(message))
-- print(inspect(headers))

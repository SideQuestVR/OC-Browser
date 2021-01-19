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
print(url)

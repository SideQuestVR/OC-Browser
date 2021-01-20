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
local url = args[1]
print("Opening Url: "..url)

local com = require('component')
local bit32 = require('bit32')
local gpu = com.gpu

local color = {
  back = 0x000000,
  fore = 0xFFFFFF,
  info = 0x335555,
  error = 0xFF3333,
  help = 0x336600,
  gold = 0xFFCC33,
  gray = 0x080808,
  lightgray = 0x333333,
  lightlightgray = 0x666666
}

local _f = gpu.getForeground()
local function foreground(color)
  if color ~= _f then gpu.setForeground(color); _f = color end
end
local _b = gpu.getBackground()
local function background(color)
  if color ~= _b then gpu.setBackground(color); _b = color end
end

local function drawRect(x, y, fill)
  foreground(color.fore)
  background(color.gray)
  gpu.set(x, y,   "╓──────╖")
  gpu.set(x, y+1, "║      ║")
  gpu.set(x, y+2, "╙──────╜")
  foreground(fill)
  gpu.set(x+2, y+1, "████")
end

local handle = internet.request(url)
local result = ""
for chunk in handle do
  result = result..chunk
end
local root = htmlparser.parse(result);
local elements = root:select('body')
-- Print the body of the HTTP response
-- https://productive-invited-tachometer.glitch.me/
-- Grab the metatable for the handle. This contains the
-- internal HTTPRequest object.
local mt = getmetatable(handle)

function trim(s)
    return (string.gsub(s, "^%s*(.-)%s*$", "%1"))
end

function split_str (inputstr, sep)
    if sep == nil then
            sep = "%s"
    end
    local t={}
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
            table.insert(t, str)
    end
    return t
end

local function parseCss(styleStr)
    local rules = split_str(styleStr,";")
    local rulesTable = {}
    for _, v in pairs(rules) do
        local props = split_str(v,":")
        rulesTable[trim(props[1])] = trim(props[2])
    end
    return rulesTable
end

local function renderElement(child, parent)
    print("TagName: ", child.name)
    for _,a in pairs(child.attributes) do
        if _ == "style" then
            print("Styles: ")
            local cssRules = parseCss(a)
            for k, v in pairs(cssRules) do
                print("    ",k,"    ",v)
            end
        else
            print("Attribute: ", _, a)
        end
    end
 --   print("", child.name)
 --   print(string.sub(child.root._text, child._openend + 1, child._closestart - 1))
end
local function walk(element)
--	print("", element.name)
	local children = element.nodes
	for _,child in ipairs(children) do
	    renderElement(child, element)
	    walk(child)
	end
end
for _,e in ipairs(elements) do
	walk(e)
end


-- for _,e in ipairs(elements) do
-- 	print("", e.name)
-- 	local subs = e.nodes
-- 	for _,sub in pairs(subs) do
-- 		print("", sub.name)
-- 		print(string.sub(sub.root._text, sub._openend + 1, sub._closestart - 1))
-- 	end
-- end

-- The response method grabs the information for
-- the HTTP response code, the response message, and the
-- response headers.
local code, message, headers = mt.__index.response()
print("Code: "..tostring(code))
print("Message: "..tostring(message))
-- print(inspect(headers))

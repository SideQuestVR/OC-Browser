local files = {
    "/json.lua",
    "/browser.lua",
    "/api.lua",
    "/htmlparser.lua",
    "/lexer.lua",
    "/css-parser.lua",
    "/htmlparser/ElementNode.lua",
    "/htmlparser/voidelements.lua"
}
local folders = {
    "/htmlparser"
}
local fs = require("filesystem")
local shell = require("shell")
local base_url = "https://raw.githubusercontent.com/SideQuestVR/OC-Browser/master";
for key,value in pairs(folders) do
    fs.makeDirectory(shell.getWorkingDirectory()..value)
end
local wget = loadfile("/bin/wget.lua")
for key,value in pairs(files) do
    wget("-qf",base_url..value,"./"..value)
end

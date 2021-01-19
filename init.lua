local files = {
    "/json.lua",
    "/browser.lua",
    "/api.lua",
    "/htmlparser.lua",
    "/htmlparser/ElementNode.lua",
    "/htmlparser/voidelements.lua"
}
local folders = {
    "htmlparser"
}
local base_url = "https://raw.githubusercontent.com/SideQuestVR/OC-Browser/master";
local mkdir = loadfile("/bin/mkdir.lua")
for key,value in pairs(folders) do
    mkdir("-p",value)
end
local wget = loadfile("/bin/wget.lua")
for key,value in pairs(files) do
    wget("-q",base_url..value,"./"..value)
end

local install_files = {
    "/json.lua",
    "/browser.lua",
    "/api.lua",
    "/htmlparser.lua",
    "/htmlparser/ElementNode.lua",
    "/htmlparser/voidelements.lua"
}
local base_url = "https://raw.githubusercontent.com/SideQuestVR/OC-Browser/master/";
local wget = loadfile("/bin/wget.lua")
for key,value in pairs(_install_files) do
    wget("-q",base_url..value,"./"..path)
end

local csslexer = require('lexer').load("css")
local CssParser = {}
CssParser.__index = CssParser

function CssParser.new()
  local self = setmetatable({}, CssParser)
  -- tokens from each processed source are saved in subtable
  self.tokens = {}
  -- source counter
  self.current_source = 0
  return self
end

function CssParser.tokenize(self, src)
  self.current_source = self.current_source + 1
  local tokens = csslexer:lex(src)
  local start = 1
  for i = 1, #tokens, 2 do
    local token_type, len = tokens[i], tokens[i+1]
    local contents = src:sub(start, len-1)
    self:add_token(token_type, contents)
    -- print(t,len, src:sub(start, len-1))
    start = len
  end
end

function CssParser.add_token(self,token_type, contents)
  -- add token for the current source
  local current = self.current_source or 0
  local tokens = self.tokens[current] or {}
  table.insert(tokens, {type = token_type, contents = contents})
  self.tokens[current] = tokens
end


return CssParser

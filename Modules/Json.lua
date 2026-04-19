--[[
	Json.lua
	Simple JSON encode/decode
--]]

local Json = {}

function Json:Encode(obj)
	local t = type(obj)
	if t == "nil" then return "null"
	elseif t == "boolean" then return obj and "true" or "false"
	elseif t == "number" then return tostring(obj)
	elseif t == "string" then return string.format("%q", obj)
	elseif t == "table" then
		local parts = {}
		for k, v in pairs(obj) do
			if type(k) == "number" then
				table.insert(parts, self:Encode(v))
			else
				table.insert(parts, self:Encode(k) .. ":" .. self:Encode(v))
			end
		end
		return "{" .. table.concat(parts, ",") .. "}"
	end
	return "null"
end

function Json:Decode(str)
	local f = loadstring("return " .. str)
	if f then return f() end
	return nil
end

return Json

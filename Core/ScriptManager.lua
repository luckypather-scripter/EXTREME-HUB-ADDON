--[[
	ScriptManager.lua
	- Checks if a folder exists for given PlaceID
	- Loads Config.json and script files from GitHub
--]]

local HttpService = game:GetService("HttpService")

local ScriptManager = {}
local HUB_USER = "luckypather-scriptor"      -- Your GitHub username
local HUB_REPO = "EXTREME-HUB-ADDON"          -- Your repository name
local BRANCH = "main"

-- Helper: fetch raw file from GitHub
local function fetchRaw(path)
	local url = string.format("https://raw.githubusercontent.com/%s/%s/%s/%s", HUB_USER, HUB_REPO, BRANCH, path)
	local success, result = pcall(game.HttpGet, game, url)
	if success then return result end
	return nil
end

-- Check if a PlaceID folder exists (by trying to fetch its Config.json)
function ScriptManager.PlaceHasScripts(placeId)
	local configPath = "Scripts/" .. tostring(placeId) .. "/Config.json"
	local data = fetchRaw(configPath)
	return data ~= nil
end

-- Get list of scripts for a PlaceID (returns table, empty if none)
function ScriptManager.GetScriptsForPlace(placeId)
	local configPath = "Scripts/" .. tostring(placeId) .. "/Config.json"
	local jsonData = fetchRaw(configPath)
	if not jsonData then return {} end

	local success, decoded = pcall(HttpService.JSONDecode, HttpService, jsonData)
	if success and decoded and decoded.scripts then
		return decoded.scripts
	end
	return {}
end

-- Load a specific script file from a PlaceID folder
function ScriptManager.LoadScript(placeId, fileName)
	local scriptPath = "Scripts/" .. tostring(placeId) .. "/" .. fileName
	return fetchRaw(scriptPath)
end

return ScriptManager

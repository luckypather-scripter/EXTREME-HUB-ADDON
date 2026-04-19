--[[
	Auditor.lua
	Scans game and collects: Players, Remotes, Scripts
--]]

local Players = game:GetService("Players")

local Auditor = {}

local function getScriptSource(obj)
	local s, src = pcall(function() return obj.Source end)
	return s and src or "-- [PROTECTED]"
end

function Auditor.Scan()
	local data = {
		PlaceId = game.PlaceId,
		JobId = game.JobId,
		Players = {},
		Remotes = {},
		Scripts = {}
	}
	
	for _, plr in ipairs(Players:GetPlayers()) do
		local info = { Name = plr.Name, UserId = plr.UserId }
		pcall(function()
			local char = plr.Character
			if char then
				local hum = char:FindFirstChild("Humanoid")
				local root = char:FindFirstChild("HumanoidRootPart")
				info.Health = hum and hum.Health
				info.Position = root and {X=math.floor(root.Position.X), Y=math.floor(root.Position.Y), Z=math.floor(root.Position.Z)}
			end
		end)
		table.insert(data.Players, info)
	end
	
	for _, obj in ipairs(game:GetDescendants()) do
		if obj:IsA("RemoteEvent") or obj:IsA("RemoteFunction") or obj:IsA("BindableEvent") or obj:IsA("BindableFunction") then
			table.insert(data.Remotes, obj:GetFullName())
		elseif obj:IsA("LuaSourceContainer") then
			table.insert(data.Scripts, {
				ClassName = obj.ClassName,
				Path = obj:GetFullName(),
				Source = getScriptSource(obj)
			})
		end
	end
	
	return data
end

function Auditor.GenerateReport(data)
	local r = string.format("=== AUDIT ===\nPlace: %s\nJob: %s\n\n", data.PlaceId, data.JobId)
	r = r .. "PLAYERS:\n"
	for _, p in ipairs(data.Players) do
		r = r .. string.format("  %s (%d) HP:%s\n", p.Name, p.UserId, tostring(p.Health))
	end
	r = r .. "\nREMOTES ("..#data.Remotes.."):\n"
	for i, rem in ipairs(data.Remotes) do
		r = r .. "  "..rem.."\n"
		if i >= 100 then r = r .. "  ...\n" break end
	end
	r = r .. "\nSCRIPTS ("..#data.Scripts.."):\n"
	for i, s in ipairs(data.Scripts) do
		r = r .. string.format("  [%s] %s\n", s.ClassName, s.Path)
		if i >= 50 then r = r .. "  ...\n" break end
	end
	return r
end

function Auditor.CopyToClipboard(text)
	local ok = false
	pcall(function()
		if setclipboard then setclipboard(text); ok = true
		elseif writeclipboard then writeclipboard(text); ok = true
		elseif syn and syn.write_clipboard then syn.write_clipboard(text); ok = true
		end
	end)
	return ok
end

return Auditor

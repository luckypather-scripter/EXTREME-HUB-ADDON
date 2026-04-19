--[[
	HubGUI.lua
	Main window with tabs: Audit, Scripts, AI Assistant.
	Place this file in: Core/HubGUI.lua
--]]

return function(modules)
	local Players = game:GetService("Players")
	local LocalPlayer = Players.LocalPlayer
	local TweenService = game:GetService("TweenService")
	local HttpService = game:GetService("HttpService")

	local Auditor = modules.Auditor
	local AI = modules.AIAssistant
	local ScriptManager = modules.ScriptManager

	-- Create main ScreenGui
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = "ExtremeHub"
	screenGui.ResetOnSpawn = false
	screenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

	-- Main frame
	local main = Instance.new("Frame")
	main.Size = UDim2.new(0, 420, 0, 420)
	main.Position = UDim2.new(0.5, -210, 0.5, -210)
	main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
	main.BorderSizePixel = 0
	main.Active = true
	main.Draggable = true
	main.Parent = screenGui
	Instance.new("UICorner", main).CornerRadius = UDim.new(0, 12)
	Instance.new("UIStroke", main).Color = Color3.fromRGB(60, 60, 60)

	-- Header
	local header = Instance.new("Frame")
	header.Size = UDim2.new(1, 0, 0, 45)
	header.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
	header.BorderSizePixel = 0
	header.Parent = main
	Instance.new("UICorner", header).CornerRadius = UDim.new(0, 12)

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -80, 1, 0)
	title.Position = UDim2.new(0, 15, 0, 0)
	title.BackgroundTransparency = 1
	title.Text = "EXTREME HUB"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.Font = Enum.Font.GothamBlack
	title.TextSize = 24
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = header

	local placeLabel = Instance.new("TextLabel")
	placeLabel.Size = UDim2.new(0, 200, 0, 20)
	placeLabel.Position = UDim2.new(1, -210, 0, 25)
	placeLabel.BackgroundTransparency = 1
	placeLabel.Text = "Place: " .. game.PlaceId
	placeLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
	placeLabel.Font = Enum.Font.Code
	placeLabel.TextSize = 12
	placeLabel.TextXAlignment = Enum.TextXAlignment.Right
	placeLabel.Parent = header

	-- Close button
	local closeBtn = Instance.new("TextButton")
	closeBtn.Size = UDim2.new(0, 30, 0, 30)
	closeBtn.Position = UDim2.new(1, -35, 0, 7)
	closeBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
	closeBtn.Text = "✕"
	closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.TextSize = 20
	closeBtn.Parent = main
	Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)
	closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

	-- Tab buttons
	local tabFrame = Instance.new("Frame")
	tabFrame.Size = UDim2.new(1, -20, 0, 35)
	tabFrame.Position = UDim2.new(0, 10, 0, 55)
	tabFrame.BackgroundTransparency = 1
	tabFrame.Parent = main

	local tabs = {"Audit", "Scripts", "AI"}
	local tabButtons = {}
	local pages = {}

	for i, tabName in ipairs(tabs) do
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(0.3, 0, 1, 0)
		btn.Position = UDim2.new((i-1)*0.35, 0, 0, 0)
		btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
		btn.Text = tabName
		btn.TextColor3 = Color3.fromRGB(200, 200, 200)
		btn.Font = Enum.Font.GothamBold
		btn.TextSize = 18
		btn.Parent = tabFrame
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
		table.insert(tabButtons, btn)
	end

	-- Content area
	local content = Instance.new("Frame")
	content.Size = UDim2.new(1, -20, 1, -100)
	content.Position = UDim2.new(0, 10, 0, 95)
	content.BackgroundTransparency = 1
	content.Parent = main

	-- Create pages
	for i, tabName in ipairs(tabs) do
		local page = Instance.new("Frame")
		page.Size = UDim2.new(1, 0, 1, 0)
		page.Visible = (i == 1)
		page.BackgroundTransparency = 1
		page.Parent = content
		pages[tabName] = page

		-- === AUDIT PAGE ===
		if tabName == "Audit" then
			local runBtn = Instance.new("TextButton")
			runBtn.Size = UDim2.new(0.9, 0, 0, 45)
			runBtn.Position = UDim2.new(0.05, 0, 0, 20)
			runBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
			runBtn.Text = "🔍 RUN FULL AUDIT"
			runBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
			runBtn.Font = Enum.Font.GothamBold
			runBtn.TextSize = 20
			runBtn.Parent = page
			Instance.new("UICorner", runBtn).CornerRadius = UDim.new(0, 8)

			local status = Instance.new("TextLabel")
			status.Size = UDim2.new(1, 0, 0, 30)
			status.Position = UDim2.new(0, 0, 0, 80)
			status.BackgroundTransparency = 1
			status.Text = "Ready to scan"
			status.TextColor3 = Color3.fromRGB(160, 160, 160)
			status.Font = Enum.Font.Gotham
			status.TextSize = 14
			status.Parent = page

			local outputBox = Instance.new("TextBox")
			outputBox.Size = UDim2.new(1, 0, 1, -130)
			outputBox.Position = UDim2.new(0, 0, 0, 120)
			outputBox.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
			outputBox.Text = ""
			outputBox.TextColor3 = Color3.fromRGB(220, 220, 220)
			outputBox.Font = Enum.Font.Code
			outputBox.TextSize = 13
			outputBox.TextWrapped = true
			outputBox.MultiLine = true
			outputBox.ClearTextOnFocus = false
			outputBox.Parent = page
			Instance.new("UICorner", outputBox).CornerRadius = UDim.new(0, 6)

			runBtn.MouseButton1Click:Connect(function()
				runBtn.Interactable = false
				status.Text = "Scanning... Please wait"
				wait(0.5)
				local data = Auditor.Scan()
				local report = Auditor.GenerateReport(data)
				outputBox.Text = report
				if Auditor.CopyToClipboard(report) then
					status.Text = "Report copied to clipboard!"
				else
					status.Text = "Copy failed, but report is shown below"
				end
				runBtn.Interactable = true
			end)

		-- === SCRIPTS PAGE (UPDATED) ===
		elseif tabName == "Scripts" then
			local scriptList = Instance.new("ScrollingFrame")
			scriptList.Size = UDim2.new(1, 0, 1, -50)
			scriptList.Position = UDim2.new(0, 0, 0, 0)
			scriptList.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
			scriptList.BorderSizePixel = 0
			scriptList.CanvasSize = UDim2.new(0, 0, 0, 0)
			scriptList.ScrollBarThickness = 6
			scriptList.Parent = page
			Instance.new("UICorner", scriptList).CornerRadius = UDim.new(0, 6)

			local listLayout = Instance.new("UIListLayout")
			listLayout.Padding = UDim.new(0, 6)
			listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			listLayout.SortOrder = Enum.SortOrder.LayoutOrder
			listLayout.Parent = scriptList

			local status = Instance.new("TextLabel")
			status.Size = UDim2.new(1, 0, 0, 30)
			status.Position = UDim2.new(0, 0, 1, -35)
			status.BackgroundTransparency = 1
			status.Text = "Checking for scripts..."
			status.TextColor3 = Color3.fromRGB(160, 160, 160)
			status.Font = Enum.Font.Gotham
			status.TextSize = 14
			status.Parent = page

			local refreshBtn = Instance.new("TextButton")
			refreshBtn.Size = UDim2.new(0.8, 0, 0, 35)
			refreshBtn.Position = UDim2.new(0.1, 0, 1, -40)
			refreshBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
			refreshBtn.Text = "🔄 Refresh"
			refreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
			refreshBtn.Font = Enum.Font.GothamSemibold
			refreshBtn.TextSize = 16
			refreshBtn.Parent = page
			Instance.new("UICorner", refreshBtn).CornerRadius = UDim.new(0, 6)

			local function loadScripts()
				-- Clear previous list
				for _, child in ipairs(scriptList:GetChildren()) do
					if child:IsA("TextButton") or child:IsA("TextLabel") then child:Destroy() end
				end

				local placeId = game.PlaceId
				local hasScripts = ScriptManager.PlaceHasScripts(placeId)

				if not hasScripts then
					status.Text = "No scripts for this game"
					local noScriptLabel = Instance.new("TextLabel")
					noScriptLabel.Size = UDim2.new(1, -10, 0, 60)
					noScriptLabel.BackgroundTransparency = 1
					noScriptLabel.Text = "No pre-made scripts found.\nUse AI Assistant to create one!"
					noScriptLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
					noScriptLabel.Font = Enum.Font.Gotham
					noScriptLabel.TextSize = 16
					noScriptLabel.TextWrapped = true
					noScriptLabel.Parent = scriptList

					local aiBtn = Instance.new("TextButton")
					aiBtn.Size = UDim2.new(1, -10, 0, 40)
					aiBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 100)
					aiBtn.Text = "🤖 Go to AI Assistant"
					aiBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
					aiBtn.Font = Enum.Font.GothamBold
					aiBtn.TextSize = 18
					aiBtn.Parent = scriptList
					Instance.new("UICorner", aiBtn).CornerRadius = UDim.new(0, 6)

					aiBtn.MouseButton1Click:Connect(function()
						-- Switch to AI tab
						for idx, btn in ipairs(tabButtons) do
							if tabs[idx] == "AI" then
								btn.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
								for name, p in pairs(pages) do p.Visible = false end
								pages["AI"].Visible = true
								local aiInput = pages["AI"]:FindFirstChildOfClass("TextBox")
								if aiInput then
									aiInput.Text = "-- PlaceID: " .. placeId .. "\n-- Request: Create a script for this game\n-- (Paste audit info or describe what you need)"
								end
								break
							end
						end
					end)

					scriptList.CanvasSize = UDim2.new(0, 0, 0, 120)
					return
				end

				-- Has scripts
				local scripts = ScriptManager.GetScriptsForPlace(placeId)
				if #scripts == 0 then
					status.Text = "Config.json is empty"
				else
					status.Text = "Found " .. #scripts .. " script(s)"
					for _, script in ipairs(scripts) do
						local btn = Instance.new("TextButton")
						btn.Size = UDim2.new(1, -10, 0, 60)
						btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
						btn.Text = script.name .. "\n" .. script.description .. "\nby " .. (script.author or "Unknown")
						btn.TextColor3 = Color3.fromRGB(255, 255, 255)
						btn.Font = Enum.Font.Gotham
						btn.TextSize = 14
						btn.Parent = scriptList
						Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)

						btn.MouseButton1Click:Connect(function()
							local code = ScriptManager.LoadScript(placeId, script.file)
							if code then
								local f, err = loadstring(code)
								if f then
									f()
									status.Text = "Executed: " .. script.name
								else
									warn("Script error: " .. err)
									status.Text = "Error running script"
								end
							else
								status.Text = "Failed to load script file"
							end
						end)
					end
				end
				scriptList.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
			end

			refreshBtn.MouseButton1Click:Connect(loadScripts)
			loadScripts()

		-- === AI PAGE ===
		elseif tabName == "AI" then
			local inputBox = Instance.new("TextBox")
			inputBox.Size = UDim2.new(1, 0, 0.5, 0)
			inputBox.Position = UDim2.new(0, 0, 0, 10)
			inputBox.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
			inputBox.Text = "-- Paste obfuscated code or describe what script you need"
			inputBox.TextColor3 = Color3.fromRGB(220, 220, 220)
			inputBox.Font = Enum.Font.Code
			inputBox.TextSize = 14
			inputBox.TextWrapped = true
			inputBox.MultiLine = true
			inputBox.ClearTextOnFocus = false
			inputBox.Parent = page
			Instance.new("UICorner", inputBox).CornerRadius = UDim.new(0, 6)

			local analyzeBtn = Instance.new("TextButton")
			analyzeBtn.Size = UDim2.new(0.9, 0, 0, 40)
			analyzeBtn.Position = UDim2.new(0.05, 0, 0.55, 0)
			analyzeBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 100)
			analyzeBtn.Text = "🤖 ANALYZE / GENERATE"
			analyzeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
			analyzeBtn.Font = Enum.Font.GothamBold
			analyzeBtn.TextSize = 18
			analyzeBtn.Parent = page
			Instance.new("UICorner", analyzeBtn).CornerRadius = UDim.new(0, 8)

			local outputBox = Instance.new("TextBox")
			outputBox.Size = UDim2.new(1, 0, 1, -280)
			outputBox.Position = UDim2.new(0, 0, 0, 230)
			outputBox.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
			outputBox.Text = "-- Result will appear here"
			outputBox.TextColor3 = Color3.fromRGB(220, 220, 220)
			outputBox.Font = Enum.Font.Code
			outputBox.TextSize = 13
			outputBox.TextWrapped = true
			outputBox.MultiLine = true
			outputBox.ClearTextOnFocus = false
			outputBox.Parent = page
			Instance.new("UICorner", outputBox).CornerRadius = UDim.new(0, 6)

			analyzeBtn.MouseButton1Click:Connect(function()
				local input = inputBox.Text
				analyzeBtn.Interactable = false
				analyzeBtn.Text = "Processing..."
				wait(0.5)
				local result
				if input:match("^%-%-") or input:match("obfusc") then
					result = AI.Analyze(input)
				else
					local fakeAudit = { PlaceId = game.PlaceId }
					result = AI.GenerateScript(fakeAudit, input)
				end
				outputBox.Text = result
				analyzeBtn.Interactable = true
				analyzeBtn.Text = "🤖 ANALYZE / GENERATE"
			end)
		end
	end

	-- Tab switching logic
	for i, btn in ipairs(tabButtons) do
		btn.MouseButton1Click:Connect(function()
			for _, b in ipairs(tabButtons) do b.BackgroundColor3 = Color3.fromRGB(45, 45, 50) end
			btn.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
			for name, page in pairs(pages) do page.Visible = false end
			pages[tabs[i]].Visible = true
		end)
	end
	tabButtons[1].BackgroundColor3 = Color3.fromRGB(80, 80, 90)
endecuted: " .. script.name
								else
									warn("Script error: " .. err)
									status.Text = "Error running script"
								end
							else
								status.Text = "Failed to load script file"
							end
						end)
					end
				end
				scriptList.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
			end

			refreshBtn.MouseButton1Click:Connect(loadScripts)
			loadScripts()

		-- === AI PAGE ===
		elseif tabName == "AI" then
			local inputBox = Instance.new("TextBox")
			inputBox.Size = UDim2.new(1, 0, 0.5, 0)
			inputBox.Position = UDim2.new(0, 0, 0, 10)
			inputBox.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
			inputBox.Text = "-- Paste obfuscated code or describe what script you need"
			inputBox.TextColor3 = Color3.fromRGB(220, 220, 220)
			inputBox.Font = Enum.Font.Code
			inputBox.TextSize = 14
			inputBox.TextWrapped = true
			inputBox.MultiLine = true
			inputBox.ClearTextOnFocus = false
			inputBox.Parent = page
			Instance.new("UICorner", inputBox).CornerRadius = UDim.new(0, 6)

			local analyzeBtn = Instance.new("TextButton")
			analyzeBtn.Size = UDim2.new(0.9, 0, 0, 40)
			analyzeBtn.Position = UDim2.new(0.05, 0, 0.55, 0)
			analyzeBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 100)
			analyzeBtn.Text = "🤖 ANALYZE / GENERATE"
			analyzeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
			analyzeBtn.Font = Enum.Font.GothamBold
			analyzeBtn.TextSize = 18
			analyzeBtn.Parent = page
			Instance.new("UICorner", analyzeBtn).CornerRadius = UDim.new(0, 8)

			local outputBox = Instance.new("TextBox")
			outputBox.Size = UDim2.new(1, 0, 1, -280)
			outputBox.Position = UDim2.new(0, 0, 0, 230)
			outputBox.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
			outputBox.Text = "-- Result will appear here"
			outputBox.TextColor3 = Color3.fromRGB(220, 220, 220)
			outputBox.Font = Enum.Font.Code
			outputBox.TextSize = 13
			outputBox.TextWrapped = true
			outputBox.MultiLine = true
			outputBox.ClearTextOnFocus = false
			outputBox.Parent = page
			Instance.new("UICorner", outputBox).CornerRadius = UDim.new(0, 6)

			analyzeBtn.MouseButton1Click:Connect(function()
				local input = inputBox.Text
				analyzeBtn.Interactable = false
				analyzeBtn.Text = "Processing..."
				wait(0.5)
				local result
				if input:match("^%-%-") or input:match("obfusc") then
					result = AI.Analyze(input)
				else
					local fakeAudit = { PlaceId = game.PlaceId }
					result = AI.GenerateScript(fakeAudit, input)
				end
				outputBox.Text = result
				analyzeBtn.Interactable = true
				analyzeBtn.Text = "🤖 ANALYZE / GENERATE"
			end)
		end
	end

	-- Tab switching logic
	for i, btn in ipairs(tabButtons) do
		btn.MouseButton1Click:Connect(function()
			for _, b in ipairs(tabButtons) do b.BackgroundColor3 = Color3.fromRGB(45, 45, 50) end
			btn.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
			for name, page in pairs(pages) do page.Visible = false end
			pages[tabs[i]].Visible = true
		end)
	end
	tabButtons[1].BackgroundColor3 = Color3.fromRGB(80, 80, 90)
end	header.Size = UDim2.new(1, 0, 0, 45)
	header.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
	header.BorderSizePixel = 0
	header.Parent = main
	Instance.new("UICorner", header).CornerRadius = UDim.new(0, 12)

	local title = Instance.new("TextLabel")
	title.Size = UDim2.new(1, -80, 1, 0)
	title.Position = UDim2.new(0, 15, 0, 0)
	title.BackgroundTransparency = 1
	title.Text = "EXTREME HUB"
	title.TextColor3 = Color3.fromRGB(255, 255, 255)
	title.Font = Enum.Font.GothamBlack
	title.TextSize = 24
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = header

	local placeLabel = Instance.new("TextLabel")
	placeLabel.Size = UDim2.new(0, 200, 0, 20)
	placeLabel.Position = UDim2.new(1, -210, 0, 25)
	placeLabel.BackgroundTransparency = 1
	placeLabel.Text = "Place: " .. game.PlaceId
	placeLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
	placeLabel.Font = Enum.Font.Code
	placeLabel.TextSize = 12
	placeLabel.TextXAlignment = Enum.TextXAlignment.Right
	placeLabel.Parent = header

	-- Close button
	local closeBtn = Instance.new("TextButton")
	closeBtn.Size = UDim2.new(0, 30, 0, 30)
	closeBtn.Position = UDim2.new(1, -35, 0, 7)
	closeBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
	closeBtn.Text = "✕"
	closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
	closeBtn.Font = Enum.Font.GothamBold
	closeBtn.TextSize = 20
	closeBtn.Parent = main
	Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)
	closeBtn.MouseButton1Click:Connect(function() screenGui:Destroy() end)

	-- Tab buttons
	local tabFrame = Instance.new("Frame")
	tabFrame.Size = UDim2.new(1, -20, 0, 35)
	tabFrame.Position = UDim2.new(0, 10, 0, 55)
	tabFrame.BackgroundTransparency = 1
	tabFrame.Parent = main

	local tabs = {"Audit", "Scripts", "AI"}
	local tabButtons = {}
	local pages = {}

	for i, tabName in ipairs(tabs) do
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(0.3, 0, 1, 0)
		btn.Position = UDim2.new((i-1)*0.35, 0, 0, 0)
		btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
		btn.Text = tabName
		btn.TextColor3 = Color3.fromRGB(200, 200, 200)
		btn.Font = Enum.Font.GothamBold
		btn.TextSize = 18
		btn.Parent = tabFrame
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
		table.insert(tabButtons, btn)
	end

	-- Content area
	local content = Instance.new("Frame")
	content.Size = UDim2.new(1, -20, 1, -100)
	content.Position = UDim2.new(0, 10, 0, 95)
	content.BackgroundTransparency = 1
	content.Parent = main

	-- Create pages
	for i, tabName in ipairs(tabs) do
		local page = Instance.new("Frame")
		page.Size = UDim2.new(1, 0, 1, 0)
		page.Visible = (i == 1)
		page.BackgroundTransparency = 1
		page.Parent = content
		pages[tabName] = page

		-- === AUDIT PAGE ===
		if tabName == "Audit" then
			local runBtn = Instance.new("TextButton")
			runBtn.Size = UDim2.new(0.9, 0, 0, 45)
			runBtn.Position = UDim2.new(0.05, 0, 0, 20)
			runBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 70)
			runBtn.Text = "🔍 RUN FULL AUDIT"
			runBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
			runBtn.Font = Enum.Font.GothamBold
			runBtn.TextSize = 20
			runBtn.Parent = page
			Instance.new("UICorner", runBtn).CornerRadius = UDim.new(0, 8)

			local status = Instance.new("TextLabel")
			status.Size = UDim2.new(1, 0, 0, 30)
			status.Position = UDim2.new(0, 0, 0, 80)
			status.BackgroundTransparency = 1
			status.Text = "Ready to scan"
			status.TextColor3 = Color3.fromRGB(160, 160, 160)
			status.Font = Enum.Font.Gotham
			status.TextSize = 14
			status.Parent = page

			local outputBox = Instance.new("TextBox")
			outputBox.Size = UDim2.new(1, 0, 1, -130)
			outputBox.Position = UDim2.new(0, 0, 0, 120)
			outputBox.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
			outputBox.Text = ""
			outputBox.TextColor3 = Color3.fromRGB(220, 220, 220)
			outputBox.Font = Enum.Font.Code
			outputBox.TextSize = 13
			outputBox.TextWrapped = true
			outputBox.MultiLine = true
			outputBox.ClearTextOnFocus = false
			outputBox.Parent = page
			Instance.new("UICorner", outputBox).CornerRadius = UDim.new(0, 6)

			runBtn.MouseButton1Click:Connect(function()
				runBtn.Interactable = false
				status.Text = "Scanning... Please wait"
				wait(0.5)
				local data = Auditor.Scan()
				local report = Auditor.GenerateReport(data)
				outputBox.Text = report
				if Auditor.CopyToClipboard(report) then
					status.Text = "Report copied to clipboard!"
				else
					status.Text = "Copy failed, but report is shown below"
				end
				runBtn.Interactable = true
			end)

		-- === SCRIPTS PAGE ===
		elseif tabName == "Scripts" then
			local scriptList = Instance.new("ScrollingFrame")
			scriptList.Size = UDim2.new(1, 0, 1, -50)
			scriptList.Position = UDim2.new(0, 0, 0, 0)
			scriptList.BackgroundColor3 = Color3.fromRGB(25, 25, 30)
			scriptList.BorderSizePixel = 0
			scriptList.CanvasSize = UDim2.new(0, 0, 0, 0)
			scriptList.ScrollBarThickness = 6
			scriptList.Parent = page
			Instance.new("UICorner", scriptList).CornerRadius = UDim.new(0, 6)

			local listLayout = Instance.new("UIListLayout")
			listLayout.Padding = UDim.new(0, 6)
			listLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
			listLayout.SortOrder = Enum.SortOrder.LayoutOrder
			listLayout.Parent = scriptList

			local status = Instance.new("TextLabel")
			status.Size = UDim2.new(1, 0, 0, 30)
			status.Position = UDim2.new(0, 0, 1, -35)
			status.BackgroundTransparency = 1
			status.Text = "Loading scripts..."
			status.TextColor3 = Color3.fromRGB(160, 160, 160)
			status.Font = Enum.Font.Gotham
			status.TextSize = 14
			status.Parent = page

			local function loadScripts()
				for _, child in ipairs(scriptList:GetChildren()) do
					if child:IsA("TextButton") then child:Destroy() end
				end
				local scripts = ScriptManager.GetScriptsForPlace(game.PlaceId)
				if #scripts == 0 then
					status.Text = "No scripts found for this game"
				else
					status.Text = "Found " .. #scripts .. " script(s)"
					for _, script in ipairs(scripts) do
						local btn = Instance.new("TextButton")
						btn.Size = UDim2.new(1, -10, 0, 50)
						btn.BackgroundColor3 = Color3.fromRGB(45, 45, 50)
						btn.Text = script.name .. "\n" .. script.description .. "\nby " .. script.author
						btn.TextColor3 = Color3.fromRGB(255, 255, 255)
						btn.Font = Enum.Font.Gotham
						btn.TextSize = 14
						btn.Parent = scriptList
						Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
						btn.MouseButton1Click:Connect(function()
							local code = ScriptManager.LoadScript(game.PlaceId, script.file)
							if code then
								local f, err = loadstring(code)
								if f then f() else warn(err) end
							end
						end)
					end
				end
				scriptList.CanvasSize = UDim2.new(0, 0, 0, listLayout.AbsoluteContentSize.Y + 10)
			end

			local refreshBtn = Instance.new("TextButton")
			refreshBtn.Size = UDim2.new(0.8, 0, 0, 35)
			refreshBtn.Position = UDim2.new(0.1, 0, 1, -40)
			refreshBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
			refreshBtn.Text = "🔄 Refresh List"
			refreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
			refreshBtn.Font = Enum.Font.GothamSemibold
			refreshBtn.TextSize = 16
			refreshBtn.Parent = page
			Instance.new("UICorner", refreshBtn).CornerRadius = UDim.new(0, 6)
			refreshBtn.MouseButton1Click:Connect(loadScripts)

			loadScripts()

		-- === AI PAGE ===
		elseif tabName == "AI" then
			local inputBox = Instance.new("TextBox")
			inputBox.Size = UDim2.new(1, 0, 0.6, 0)
			inputBox.Position = UDim2.new(0, 0, 0, 10)
			inputBox.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
			inputBox.Text = "-- Paste obfuscated Lua code here"
			inputBox.TextColor3 = Color3.fromRGB(220, 220, 220)
			inputBox.Font = Enum.Font.Code
			inputBox.TextSize = 14
			inputBox.TextWrapped = true
			inputBox.MultiLine = true
			inputBox.ClearTextOnFocus = false
			inputBox.Parent = page
			Instance.new("UICorner", inputBox).CornerRadius = UDim.new(0, 6)

			local analyzeBtn = Instance.new("TextButton")
			analyzeBtn.Size = UDim2.new(0.9, 0, 0, 40)
			analyzeBtn.Position = UDim2.new(0.05, 0, 0.65, 0)
			analyzeBtn.BackgroundColor3 = Color3.fromRGB(70, 70, 100)
			analyzeBtn.Text = "🤖 ANALYZE WITH AI"
			analyzeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
			analyzeBtn.Font = Enum.Font.GothamBold
			analyzeBtn.TextSize = 18
			analyzeBtn.Parent = page
			Instance.new("UICorner", analyzeBtn).CornerRadius = UDim.new(0, 8)

			local outputBox = Instance.new("TextBox")
			outputBox.Size = UDim2.new(1, 0, 1, -280)
			outputBox.Position = UDim2.new(0, 0, 0, 230)
			outputBox.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
			outputBox.Text = "-- AI result will appear here"
			outputBox.TextColor3 = Color3.fromRGB(220, 220, 220)
			outputBox.Font = Enum.Font.Code
			outputBox.TextSize = 13
			outputBox.TextWrapped = true
			outputBox.MultiLine = true
			outputBox.ClearTextOnFocus = false
			outputBox.Parent = page
			Instance.new("UICorner", outputBox).CornerRadius = UDim.new(0, 6)

			analyzeBtn.MouseButton1Click:Connect(function()
				local code = inputBox.Text
				analyzeBtn.Interactable = false
				analyzeBtn.Text = "Processing..."
				wait(0.5)
				local result = AI.Analyze(code)
				outputBox.Text = result
				analyzeBtn.Interactable = true
				analyzeBtn.Text = "🤖 ANALYZE WITH AI"
			end)
		end
	end

	-- Tab switching logic
	for i, btn in ipairs(tabButtons) do
		btn.MouseButton1Click:Connect(function()
			for _, b in ipairs(tabButtons) do b.BackgroundColor3 = Color3.fromRGB(45, 45, 50) end
			btn.BackgroundColor3 = Color3.fromRGB(80, 80, 90)
			for name, page in pairs(pages) do page.Visible = false end
			pages[tabs[i]].Visible = true
		end)
	end
	-- Activate first tab
	tabButtons[1].BackgroundColor3 = Color3.fromRGB(80, 80, 90)
end

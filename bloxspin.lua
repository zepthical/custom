local UIS = game:GetService("UserInputService")
local camera = game.Workspace.CurrentCamera
local TS = game:GetService("TweenService")
local tweenInfo = TweenInfo.new(0.25)
local Players = game:GetService("Players")

function getClosest()
	local closestDistance = math.huge
	local closestPlayer = nil
	for i, v in pairs(game.Players:GetChildren()) do
		if v ~= game.Players.LocalPlayer and v.Team ~= game.Players.LocalPlayer.Team then
			local distance = (game.Players.LocalPlayer.Character.HumanoidRootPart.Position - v.Character.HumanoidRootPart.Position).magnitude
			if distance < closestDistance then
				closestDistance = distance
				closestPlayer = v
			end
		end
	end
	return closestPlayer
end 

_G.aim = false
_G.fastmethod = true
_G.tweenmethod = false

local function tweenMethod()
	if _G.tweenmethod then
		local tween = TS:Create(camera, tweenInfo, {CFrame = CFrame.new(camera.CFrame.Position, getClosest().Character.Head.Position)})
		tween:Play()
		if _G.aim == false then tween:Cancel();return end
	end
end

local function fastMethod()
    if _G.fastmethod then
	    camera.CFrame = CFrame.new(camera.CFrame.Position, getClosest().Character.Head.Position)
	    if _G.aim == false then return end
    end
end

local function aimbotSystem(keybind)
    UIS.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.keybind then
            _G.aim = true

            if _G.tweenMethod then
                while task.wait() do
                    tweenMethod()
                end 
            end

            if _G.fastMethod then
                fastMethod()
            end
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.keybind then
            _G.aim = false
        end
    end)
end

local function getAllCharacter()
	for _, v in ipairs(Players:GetChildren()) do
		if v.Name ~= Players.LocalPlayer.Name then
			return v.Character
		end
	end
	return nil
end











local espEnabled = false

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

local espObjects = {}

local function createESP(player)
    pcall(function()
	    if player == localPlayer then return end
        espObjects[player] = {
            Tracer = Drawing.new("Line"),
            Box = Drawing.new("Square"),
            Name = Drawing.new("Text"),
            Health = Drawing.new("Text"),
        }

        for _, obj in pairs(espObjects[player]) do
            obj.Visible = false
            obj.ZIndex = 2
        end

        espObjects[player].Tracer.Color = Color3.fromRGB(255, 255, 255)
        espObjects[player].Tracer.Thickness = 1

        espObjects[player].Box.Color = Color3.fromRGB(255, 255, 255)
        espObjects[player].Box.Thickness = 1
        espObjects[player].Box.Filled = false

        espObjects[player].Name.Color = Color3.fromRGB(255, 255, 255)
        espObjects[player].Name.Size = 13
        espObjects[player].Name.Center = true
        espObjects[player].Name.Outline = true

        espObjects[player].Health.Color = Color3.fromRGB(0, 255, 0)
        espObjects[player].Health.Size = 13
        espObjects[player].Health.Center = true
        espObjects[player].Health.Outline = true
    end)
end

local function removeESP(player)
    pcall(function()
        if espObjects[player] then
            for _, obj in pairs(espObjects[player]) do
                obj:Remove()
            end
            espObjects[player] = nil
        end
    end)
end

RunService.RenderStepped:Connect(function()
	if not espEnabled then
		for _, drawings in pairs(espObjects) do
			for _, obj in pairs(drawings) do
				obj.Visible = false
			end
		end
		return
	end

	for _, player in pairs(Players:GetPlayers()) do
		if player ~= localPlayer and player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player.Character:FindFirstChild("Head") then
			if not espObjects[player] then
				createESP(player)
			end

			local hrp = player.Character.HumanoidRootPart
			local head = player.Character.Head
			local humanoid = player.Character:FindFirstChildOfClass("Humanoid")

			local screenPos, onScreen = camera:WorldToViewportPoint(hrp.Position)
			local headPos = camera:WorldToViewportPoint(head.Position + Vector3.new(0, 0.5, 0))
			local footPos = camera:WorldToViewportPoint(hrp.Position - Vector3.new(0, 3, 0))

			local boxHeight = math.abs(headPos.Y - footPos.Y)
			local boxWidth = boxHeight / 2

			local box = espObjects[player].Box
			box.Size = Vector2.new(boxWidth, boxHeight)
			box.Position = Vector2.new(screenPos.X - boxWidth / 2, screenPos.Y - boxHeight / 2)
			box.Visible = onScreen

			local tracer = espObjects[player].Tracer
			tracer.From = Vector2.new(camera.ViewportSize.X / 2, camera.ViewportSize.Y)
			tracer.To = Vector2.new(screenPos.X, screenPos.Y)
			tracer.Visible = onScreen

			local nameTag = espObjects[player].Name
			nameTag.Position = Vector2.new(screenPos.X, screenPos.Y - boxHeight / 2 - 14)
			nameTag.Text = player.Name
			nameTag.Visible = onScreen

			local health = humanoid and humanoid.Health or 0
			local maxHealth = humanoid and humanoid.MaxHealth or 100
			local healthBar = espObjects[player].Health
			healthBar.Position = Vector2.new(screenPos.X, screenPos.Y + boxHeight / 2 + 2)
			healthBar.Text = "HP: " .. math.floor(health) .. "/" .. math.floor(maxHealth)
			healthBar.Visible = onScreen
		elseif espObjects[player] then
			for _, obj in pairs(espObjects[player]) do
				obj.Visible = false
			end
		end
	end
end)

Players.PlayerRemoving:Connect(function(player)
	removeESP(player)
end)












local function infstamina()
	for i = 1, 21 do
		game.ReplicatedStorage.Remotes.Send:FireServer(i, "replicate_stamina_bar_1", 99999999999)
	end
end

local function uninfstamina()
	for i = 1, 1000 do
		game.ReplicatedStorage.Remotes.Send:FireServer(i, "replicate_stamina_bar_1", 100)
	end
end









FLYING = false
QEfly = true
iyflyspeed = 1
vehicleflyspeed = 1

local function sFLY(vfly)
	repeat wait() until Players.LocalPlayer and Players.LocalPlayer.Character and getRoot(Players.LocalPlayer.Character) and Players.LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
	repeat wait() until IYMouse
	if flyKeyDown or flyKeyUp then flyKeyDown:Disconnect() flyKeyUp:Disconnect() end

	local T = getRoot(Players.LocalPlayer.Character)
	local CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
	local lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
	local SPEED = 0

	local function FLY()
		FLYING = true
		local BG = Instance.new('BodyGyro')
		local BV = Instance.new('BodyVelocity')
		BG.P = 9e4
		BG.Parent = T
		BV.Parent = T
		BG.maxTorque = Vector3.new(9e9, 9e9, 9e9)
		BG.cframe = T.CFrame
		BV.velocity = Vector3.new(0, 0, 0)
		BV.maxForce = Vector3.new(9e9, 9e9, 9e9)
		task.spawn(function()
			repeat wait()
				if not vfly and Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
					Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = true
				end
				if CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0 then
					SPEED = 50
				elseif not (CONTROL.L + CONTROL.R ~= 0 or CONTROL.F + CONTROL.B ~= 0 or CONTROL.Q + CONTROL.E ~= 0) and SPEED ~= 0 then
					SPEED = 0
				end
				if (CONTROL.L + CONTROL.R) ~= 0 or (CONTROL.F + CONTROL.B) ~= 0 or (CONTROL.Q + CONTROL.E) ~= 0 then
					BV.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (CONTROL.F + CONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(CONTROL.L + CONTROL.R, (CONTROL.F + CONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
					lCONTROL = {F = CONTROL.F, B = CONTROL.B, L = CONTROL.L, R = CONTROL.R}
				elseif (CONTROL.L + CONTROL.R) == 0 and (CONTROL.F + CONTROL.B) == 0 and (CONTROL.Q + CONTROL.E) == 0 and SPEED ~= 0 then
					BV.velocity = ((workspace.CurrentCamera.CoordinateFrame.lookVector * (lCONTROL.F + lCONTROL.B)) + ((workspace.CurrentCamera.CoordinateFrame * CFrame.new(lCONTROL.L + lCONTROL.R, (lCONTROL.F + lCONTROL.B + CONTROL.Q + CONTROL.E) * 0.2, 0).p) - workspace.CurrentCamera.CoordinateFrame.p)) * SPEED
				else
					BV.velocity = Vector3.new(0, 0, 0)
				end
				BG.cframe = workspace.CurrentCamera.CoordinateFrame
			until not FLYING
			CONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
			lCONTROL = {F = 0, B = 0, L = 0, R = 0, Q = 0, E = 0}
			SPEED = 0
			BG:Destroy()
			BV:Destroy()
			if Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
				Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
			end
		end)
	end
	flyKeyDown = IYMouse.KeyDown:Connect(function(KEY)
		if KEY:lower() == 'w' then
			CONTROL.F = (vfly and vehicleflyspeed or iyflyspeed)
		elseif KEY:lower() == 's' then
			CONTROL.B = - (vfly and vehicleflyspeed or iyflyspeed)
		elseif KEY:lower() == 'a' then
			CONTROL.L = - (vfly and vehicleflyspeed or iyflyspeed)
		elseif KEY:lower() == 'd' then 
			CONTROL.R = (vfly and vehicleflyspeed or iyflyspeed)
		elseif QEfly and KEY:lower() == 'e' then
			CONTROL.Q = (vfly and vehicleflyspeed or iyflyspeed)*2
		elseif QEfly and KEY:lower() == 'q' then
			CONTROL.E = -(vfly and vehicleflyspeed or iyflyspeed)*2
		end
		pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Track end)
	end)
	flyKeyUp = IYMouse.KeyUp:Connect(function(KEY)
		if KEY:lower() == 'w' then
			CONTROL.F = 0
		elseif KEY:lower() == 's' then
			CONTROL.B = 0
		elseif KEY:lower() == 'a' then
			CONTROL.L = 0
		elseif KEY:lower() == 'd' then
			CONTROL.R = 0
		elseif KEY:lower() == 'e' then
			CONTROL.Q = 0
		elseif KEY:lower() == 'q' then
			CONTROL.E = 0
		end
	end)
	FLY()
end

local function NOFLY()
	FLYING = false
	if flyKeyDown or flyKeyUp then flyKeyDown:Disconnect() flyKeyUp:Disconnect() end
	if Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid') then
		Players.LocalPlayer.Character:FindFirstChildOfClass('Humanoid').PlatformStand = false
	end
	pcall(function() workspace.CurrentCamera.CameraType = Enum.CameraType.Custom end)
end

local function flytog()
    if localPlayer.Character:WaitForChild("Humanoid") and localPlayer.Character.Humanoid.Health <= 5 then
        sFLY()
    elseif localPlayer.Character:WaitForChild("Humanoid") and localPlayer.Character.Humanoid.Health >= 5 then
        NOFLY()
    end
end

local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "Block Spin ( ENG )",
   Icon = 0,
   LoadingTitle = "English Version",
   LoadingSubtitle = "by Zepthical",
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false,

   ConfigurationSaving = {
      Enabled = true,
      FolderName = "custom ui ไตตั้น", 
      FileName = "block spin (save configurations)"
   },

   Discord = {
      Enabled = false,
      Invite = "noinvitelink",
      RememberJoins = false
   },

   KeySystem = false,
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided",
      FileName = "Key",
      SaveKey = true,
      GrabKeyFromSite = false,
      Key = {"Hello"} 
   }
})

local MainTab = Window:CreateTab("Main", 4483362458)
local InfTab = Window:CreateTab("Infinite", 4483362458)
local MiscTab = Window:CreateTab("Misc", 4483362458)
--local SettingsTab = Window:CreateTab("UI Settings", 4483362458)

local Section = MainTab:CreateSection("Aimbot")

local aimbotToggle = MainTab:CreateToggle({
   Name = "Aimbot",
   CurrentValue = true,
   Flag = "togaimb",
   Callback = function(Value)
        pcall(function()
            _G.aim = Value

            if _G.aim then
                aimbotSystem()
            end
        end)
   end,
})

local aimbotkeybind = MainTab:CreateKeybind({
   Name = "Aimbot Keybind",
   CurrentKeybind = "R",
   HoldToInteract = false,
   Flag = "keybaimb", 
   Callback = function(Keybind)
        pcall(function()
            if _G.aim == true then
                aimbotSystem(aimbotkeybind.CurrentKeybind)
            end
        end)
   end,
})

local amethod = MainTab:CreateDropdown({
   Name = "Aimbot Method",
   Options = {"Instant","Tween"},
   CurrentOption = {"Instant"},
   MultipleOptions = false,
   Flag = "dropmet", 
   Callback = function(Options)
        pcall(function()
            if Options == Instant then
                _G.fastmethod = true
                _G.tweenmethod = false
            elseif Options == Tween then
                _G.fastmethod = false
                _G.tweenmethod = true
            end
        end)
   end,
})

local Divider1 = MainTab:CreateDivider()

local ESPToggle = MainTab:CreateToggle({
   Name = "ESP [Tracer, Boxes, etc.]",
   CurrentValue = true,
   Flag = "togesp", 
   Callback = function(Value)
        espEnabled = Value
   end,
})

local infsta = false

local InfiniteSta = InfTab:CreateToggle({
   Name = "Infinite Stamina",
   CurrentValue = true,
   Flag = "infstam",
   Callback = function(Value)
        pcall(function()
            infsta = Value
            if infsta == true then
                infstamina()
            elseif infsta == false then
                uninfstamina()
            end
        end)
   end,
})

local FlyToggle = MiscTab:CreateToggle({
   Name = "Fly (While dead)",
   CurrentValue = false,
   Flag = "togfly", 
   Callback = function(Value)
        pcall(function()
            FLYING = Value

            flytog()
        end)
   end,
})



Rayfield:LoadConfiguration()

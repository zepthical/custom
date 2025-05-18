local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

local Window = Rayfield:CreateWindow({
   Name = "custom bloxspin",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "bloxspin",
   LoadingSubtitle = "by zepthical",
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "custom bloxspin"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = true, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"ez"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

local MainTab = Window:CreateTab("aimbot", "crosshair")

local Section = MainTab:CreateSection("aimbot")

local maxAimDistance = 100

local UIS = game:GetService("UserInputService")
local camera = game.Workspace.CurrentCamera
local TS = game:GetService("TweenService")
local tweenInfo = TweenInfo.new(0.1)

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

UIS.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        _G.aim = true
        -- aiming loop...
    end
end)

UIS.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then
        _G.aim = false
    end
end)


local Slider = MainTab:CreateSlider({
   Name = "ระยะ aimbot",
   Range = {0, 500}, -- You can raise this range depending on your game
   Increment = 10,
   Suffix = "studs",
   CurrentValue = 100,
   Flag = "AimbotDistance",
   Callback = function(Value)
       pcall(function()
       maxAimDistance = Value -- update the aimbot range dynamically
       end)
   end,
})

local aimbotRunning = false

local KeybindAimbot = MainTab:CreateKeybind({
   Name = "Aimbot",
   CurrentKeybind = "F",
   HoldToInteract = false,
   Flag = "AimbotToggleKeybind",
   Callback = function()
        pcall(function()
       aimbotRunning = not aimbotRunning -- toggle on/off
       
       if aimbotRunning then
           -- Start aiming loop
           task.spawn(function()
               while aimbotRunning do
                   local target, distance = getClosest()

                   if target and target.Character and target.Character:FindFirstChild("Head") and distance <= maxAimDistance then
                       -- Update distance label
                       -- Tween camera
                       local tween = TS:Create(camera, tweenInfo, {
                           CFrame = CFrame.new(camera.CFrame.Position, target.Character.Head.Position)
                       })
                       tween:Play()
                   else
                   end
                   task.wait()
               end
           end)
       else
       end
       end)
   end,
})

local Input = MainTab:CreateInput({
   Name = "ปุ่ม aimbot ( ก็เหมือนกับ aimbot นั้นแหละ )",
   CurrentValue = "F",
   PlaceholderText = "Input Placeholder",
   RemoveTextAfterFocusLost = false,
   Flag = "Input1",
   Callback = function(Text)
        KeybindAimbot:Set(Text)
   end,
})

-- ESP

local espEnabled = false

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local localPlayer = Players.LocalPlayer

local espObjects = {}

function createESP(player)
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
end

function removeESP(player)
    if espObjects[player] then
        for _, obj in pairs(espObjects[player]) do
            obj:Remove()
        end
        espObjects[player] = nil
    end
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

-----------------------------------------------------------------------------------------------------------------------------------------

local ToggleESP = MainTab:CreateToggle({
   Name = "ESP (เส้น, กล่อง, เลือด)",
   CurrentValue = false,
   Flag = "ESPFullToggle",
   Callback = function(Value)
        pcall(function()
       espEnabled = Value
       if not Value then
           for _, player in pairs(Players:GetPlayers()) do
               removeESP(player)
           end
       end end)
   end,
})

local SecondTab = Window:CreateTab("Infinite", "rewind")

local Section = SecondTab:CreateSection("Infinite")

_G.stamina = false

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local function infstamina()
    for i = 1, 20 do
        ReplicatedStorage.Remotes.Send:FireServer(i, "replicate_stamina_bar_1", 99999999999)
    end
end

local Toggle = SecondTab:CreateToggle({
   Name = "Infinite Stamina",
   CurrentValue = false,
   Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
        pcall(function()
        _G.stamina = Value

        while _G.stamina do task.wait()
            infstamina()
        end

        end)
   end,
})

local MiscTab = Window:CreateTab("Misc", "hexagon")

local Section = MiscTab:CreateSection("Misc")

local function fly()
    local player = Players.LocalPlayer
    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")

    local flying = false
    local speed = 50
    local direction = Vector3.zero

    -- Fly body movers
    local bodyGyro = Instance.new("BodyGyro")
    bodyGyro.MaxTorque = Vector3.new(9e9, 9e9, 9e9)
    bodyGyro.P = 9e4
    bodyGyro.D = 500
    bodyGyro.CFrame = hrp.CFrame

    local bodyVelocity = Instance.new("BodyVelocity")
    bodyVelocity.MaxForce = Vector3.new(9e9, 9e9, 9e9)
    bodyVelocity.P = 1e4
    bodyVelocity.Velocity = Vector3.zero

    -- Movement keys
    local keysDown = {
        W = false,
        A = false,
        S = false,
        D = false
    }

    -- Toggle flying
    local function toggleFly()
        flying = not flying

        if flying then
            bodyGyro.Parent = hrp
            bodyVelocity.Parent = hrp
        else
            bodyGyro.Parent = nil
            bodyVelocity.Parent = nil
        end
    end

    -- Handle key input
    UIS.InputBegan:Connect(function(input, gameProcessed)
        if gameProcessed then return end

        if input.KeyCode == Enum.KeyCode.E then
            if char.Humanoid.Health == 0 then
                toggleFly()
            elseif input.KeyCode == Enum.KeyCode.W then
                keysDown.W = true
            elseif input.KeyCode == Enum.KeyCode.A then
                keysDown.A = true
            elseif input.KeyCode == Enum.KeyCode.S then
                keysDown.S = true
            elseif input.KeyCode == Enum.KeyCode.D then
                keysDown.D = true
            end
        end
    end)

    UIS.InputEnded:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.W then
            keysDown.W = false
        elseif input.KeyCode == Enum.KeyCode.A then
            keysDown.A = false
        elseif input.KeyCode == Enum.KeyCode.S then
            keysDown.S = false
        elseif input.KeyCode == Enum.KeyCode.D then
            keysDown.D = false
        end
    end)

    -- Update loop
    RunService.RenderStepped:Connect(function()
        if flying then
            local cam = workspace.CurrentCamera
            local moveVec = Vector3.zero

            if keysDown.W then moveVec += cam.CFrame.LookVector end
            if keysDown.S then moveVec -= cam.CFrame.LookVector end
            if keysDown.A then moveVec -= cam.CFrame.RightVector end
            if keysDown.D then moveVec += cam.CFrame.RightVector end

            bodyVelocity.Velocity = moveVec.Unit * speed
            bodyGyro.CFrame = cam.CFrame
        end
    end)
end

_G.fly = false

local ToggleFLY = MiscTab:CreateToggle({
   Name = "Fly ( ตอนตาย )",
   CurrentValue = false,
   Flag = "Toggle1", -- A flag is the identifier for the configuration file, make sure every element has a different flag if you're using configuration saving to ensure no overlaps
   Callback = function(Value)
        pcall(function()
        _G.fly = Value

        if _G.fly == true then
            fly()
        end
        end)
   end,
})

Rayfield:LoadConfiguration()

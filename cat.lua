-- =========================================================================
-- [ 🌟🌟 BY OUNCOPYBARA - ULTIMATE V7 - INSTANT TP (MODIFIED) 🌟🌟 ]
-- =========================================================================

local success, err = pcall(function()

local Players           = game:GetService("Players")
local RunService        = game:GetService("RunService")
local TweenService      = game:GetService("TweenService")
local UserInputService  = game:GetService("UserInputService")
local SoundService      = game:GetService("SoundService")
local LocalPlayer       = Players.LocalPlayer

local GUIParent
do
    local ok, hui = pcall(function() return gethui() end)
    if ok and hui then GUIParent = hui
    else GUIParent = LocalPlayer:WaitForChild("PlayerGui") end
end

pcall(function()
    for _, gui in pairs(GUIParent:GetChildren()) do
        if string.find(gui.Name, "ouncopybara") then gui:Destroy() end
    end
end)

-- =========================================================================
-- [ 💀 GODMODE ]
-- =========================================================================
local Godmode = { Enabled = true, HealthValue = 999999 }

local function applyGodmode()
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then
            hum.MaxHealth = Godmode.HealthValue
            hum.Health = Godmode.HealthValue
            hum.BreakJointsOnDeath = false
        end
        for _, v in pairs(char:GetDescendants()) do
            if v:IsA("ForceField") then v:Destroy() end
        end
    end)
end

task.spawn(function()
    while task.wait(0.5) do
        if Godmode.Enabled then applyGodmode() end
    end
end)

LocalPlayer.CharacterAdded:Connect(function()
    task.wait(0.5)
    applyGodmode()
end)

-- =========================================================================
-- [ 🛡️ NETWORK OWNERSHIP ]
-- =========================================================================
local AntiTP = { Enabled = true, Active = false }

local function grabNetworkOwnership()
    pcall(function()
        if not LocalPlayer.Character then return end
        for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
            if part:IsA("BasePart") then
                pcall(function() part:SetNetworkOwner(LocalPlayer) end)
            end
        end
    end)
end

task.spawn(function()
    while task.wait(0.1) do
        if AntiTP.Enabled and AntiTP.Active then grabNetworkOwnership() end
    end
end)

-- =========================================================================
-- [ ⚡ INSTANT TELEPORT ]
-- =========================================================================
local function instantTeleport(hrp, targetCFrame)
    if not hrp or not hrp.Parent then return end
    
    AntiTP.Active = true
    grabNetworkOwnership()
    
    for _, part in pairs(hrp.Parent:GetDescendants()) do
        if part:IsA("BasePart") then part.CanCollide = false end
    end
    
    pcall(function()
        hrp.CFrame = targetCFrame
        hrp.AssemblyLinearVelocity = Vector3.zero
        hrp.AssemblyAngularVelocity = Vector3.zero
    end)
    
    grabNetworkOwnership()
end

-- =========================================================================
-- [ 🎵 បទចម្រៀងតាមលីង ]
-- =========================================================================
task.spawn(function()
    pcall(function()
        local SOUND_URL = "https://files.catbox.moe/rtkvkd.mp3"
        local sndFile = "ouncopybara_intro_audio.mp3"
        if isfile and writefile and getcustomasset and game and game.HttpGet then
            if not isfile(sndFile) then
                local ok, data = pcall(function() return game:HttpGet(SOUND_URL, true) end)
                if ok and data and #data > 1000 then writefile(sndFile, data) end
            end
            if isfile(sndFile) then
                local ok, asset = pcall(getcustomasset, sndFile)
                if ok and asset and asset ~= "" then
                    local s = Instance.new("Sound", SoundService)
                    s.SoundId = asset; s.Volume = 2; s:Play()
                    s.Ended:Connect(function() s:Destroy() end)
                end
            end
        end
    end)
end)

-- =========================================================================
-- [ 🖼️ រូបភាព VIP តាមលីង ]
-- =========================================================================
local CustomImage = ""
local IMAGE_URL = "https://files.catbox.moe/ka5x56.jpg"

pcall(function()
    if isfile and writefile and getcustomasset and game and game.HttpGet then
        local imgFile = "vip_icon_custom.jpg"
        if not isfile(imgFile) then
            local ok, data = pcall(function() return game:HttpGet(IMAGE_URL, true) end)
            if ok and data and #data > 1000 then writefile(imgFile, data) end
        end
        if isfile(imgFile) then
            local ok, asset = pcall(getcustomasset, imgFile)
            if ok and asset and asset ~= "" then CustomImage = asset end
        end
    end
end)

-- =========================================================================
-- [ CONFIG ]
-- =========================================================================
local Config = {
    BaseCFrames = {}, ActiveBase = 1, IsAutoOn = false, StiffDuration = 1.0, HoldDelay = 0.2,
    IsSpeedOn = false, SpeedValue = 60, FlySpeed = 100, IsFlyOn = false, IsInfiniteJumpOn = false, IsNoclipOn = false, IsAutoDriveOn = false, IsAntiAFK = true,
    Theme = "Pink",
    Themes = {
        Pink     = {Main = Color3.fromRGB(25, 15, 20),  Accent = Color3.fromRGB(255, 105, 180), Btn = Color3.fromRGB(45, 25, 35),  Text = Color3.fromRGB(255, 255, 255)},
        Purple   = {Main = Color3.fromRGB(20, 15, 25),  Accent = Color3.fromRGB(170, 0, 255),    Btn = Color3.fromRGB(35, 25, 45),  Text = Color3.fromRGB(255, 255, 255)},
        Blue     = {Main = Color3.fromRGB(10, 15, 25),  Accent = Color3.fromRGB(0, 170, 255),    Btn = Color3.fromRGB(20, 35, 55),  Text = Color3.fromRGB(255, 255, 255)},
        Green    = {Main = Color3.fromRGB(10, 20, 15),  Accent = Color3.fromRGB(0, 255, 120),    Btn = Color3.fromRGB(20, 45, 30),  Text = Color3.fromRGB(255, 255, 255)},
        Gold     = {Main = Color3.fromRGB(25, 20, 10),  Accent = Color3.fromRGB(255, 200, 0),    Btn = Color3.fromRGB(45, 35, 15),  Text = Color3.fromRGB(255, 255, 255)},
    }, ToggleKey = Enum.KeyCode.RightControl
}

local flyConn, noclipConn, autoDriveConn, speedConn, updateStatus = nil
local isProcessing = false

-- =========================================================================
-- [ NOTIFICATION ]
-- =========================================================================
local NotifyGui
local function notify(text, color)
    pcall(function()
        if not NotifyGui or not NotifyGui.Parent then NotifyGui = Instance.new("ScreenGui", GUIParent); NotifyGui.Name = "ouncopybara_notify" end
        local frame = Instance.new("Frame", NotifyGui)
        frame.Size = UDim2.new(0, 240, 0, 35)
        frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15); frame.BackgroundTransparency = 0.2; frame.BorderSizePixel = 0
        Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
        local stroke = Instance.new("UIStroke", frame); stroke.Color = color or Config.Themes[Config.Theme].Accent; stroke.Thickness = 1.5
        local lbl = Instance.new("TextLabel", frame)
        lbl.Size = UDim2.new(1, -15, 1, 0); lbl.Position = UDim2.new(0, 10, 0, 0)
        lbl.BackgroundTransparency = 1; lbl.Text = text; lbl.TextColor3 = Color3.new(1, 1, 1); lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 11; lbl.TextXAlignment = Enum.TextXAlignment.Left
        frame.Position = UDim2.new(1, 20, 0, 20 + (#NotifyGui:GetChildren() - 1) * 40)
        TweenService:Create(frame, TweenInfo.new(0.3, Enum.EasingStyle.Quart), {Position = UDim2.new(1, -260, 0, frame.Position.Y.Offset)}):Play()
        task.delay(3, function() pcall(function()
            TweenService:Create(frame, TweenInfo.new(0.3), {BackgroundTransparency = 1}):Play(); TweenService:Create(lbl, TweenInfo.new(0.3), {TextTransparency = 1}):Play(); TweenService:Create(stroke, TweenInfo.new(0.3), {Transparency = 1}):Play()
            task.wait(0.35); frame:Destroy()
        end) end)
    end)
end

local function getCharacter()
    local char = LocalPlayer.Character
    return char and char:FindFirstChild("HumanoidRootPart"), char and char:FindFirstChildOfClass("Humanoid")
end

-- =========================================================================
-- [ AUTO FARM (INSTANT TP) ]
-- =========================================================================
local function triggerPromptOrClick()
    pcall(function()
        for _, v in ipairs(workspace:GetDescendants()) do
            if v:IsA("ProximityPrompt") then
                local part = v.Parent
                if part and part:IsA("BasePart") then
                    local hrp = getCharacter()
                    if hrp and (hrp.Position - part.Position).Magnitude <= (v.MaxActivationDistance or 15) then
                        fireproximityprompt(v)
                    end
                end
            elseif v:IsA("ClickDetector") then
                local part = v.Parent
                if part and part:IsA("BasePart") then
                    local hrp = getCharacter()
                    if hrp and (hrp.Position - part.Position).Magnitude <= (v.MaxActivationDistance or 32) then
                        fireclickdetector(v)
                    end
                end
            end
        end
    end)
end

local function handleSteal()
    if not Config.IsAutoOn or isProcessing then return end
    local baseCF = Config.BaseCFrames[1]
    if not baseCF then notify("📍 កំណត់ Base ជាមុនសិន!", Color3.fromRGB(255,50,50)); return end
    local hrp, hum = getCharacter()
    if not hrp or not hum then return end
    if hum.Health <= 0 then return end
    
    isProcessing = true
    local originalLocation = hrp.CFrame
    updateStatus("កំពុងយកពងស្វ័យប្រវត្តិ...", Color3.fromRGB(255, 200, 100))
    
    task.spawn(function()
        -- 1. ចុចយកពង Auto
        triggerPromptOrClick()
        task.wait(Config.HoldDelay)
        
        -- 2. Teleport ភ្លាមៗទៅ Base
        updateStatus("Teleport ភ្លាមៗទៅ Base...", Color3.fromRGB(100, 200, 255))
        instantTeleport(hrp, baseCF)
        task.wait(Config.StiffDuration)
        
        -- 3. ចុចទម្លាក់ពងស្វ័យប្រវត្តិនៅ Base
        triggerPromptOrClick()
        task.wait(0.2)
        
        -- 4. Teleport ភ្លាមៗត្រលប់មកគោលដៅដើមវិញ
        updateStatus("ត្រលប់មកទីតាំងដើមវិញ...", Color3.fromRGB(100, 255, 100))
        instantTeleport(hrp, originalLocation)
        
        isProcessing = false
        updateStatus("រង់ចាំពងបន្ទាប់...", Config.Themes[Config.Theme].Text)
    end)
end

local function hookInteractions(v)
    pcall(function()
        if v:IsA("ProximityPrompt") then
            v.Triggered:Connect(function(plr) if plr == LocalPlayer then handleSteal() end end)
        elseif v:IsA("ClickDetector") then
            v.MouseClick:Connect(function(plr) if plr == LocalPlayer then handleSteal() end end)
        end
    end)
end
workspace.DescendantAdded:Connect(hookInteractions)
for _, v in ipairs(workspace:GetDescendants()) do hookInteractions(v) end

-- =========================================================================
-- [ MOVEMENT ]
-- =========================================================================
local function toggleSpeed(state)
    Config.IsSpeedOn = state
    if state then
        if speedConn then speedConn:Disconnect() end
        speedConn = RunService.Heartbeat:Connect(function()
            if not Config.IsSpeedOn then return end
            local _, hum = getCharacter()
            if hum then pcall(function() hum.WalkSpeed = Config.SpeedValue end) end
        end)
    else
        if speedConn then speedConn:Disconnect(); speedConn = nil end
        local _, hum = getCharacter()
        if hum then pcall(function() hum.WalkSpeed = 16 end) end
    end
end

local function enableFly()
    local hrp, hum = getCharacter()
    if not hrp or not hum then return end
    Config.IsFlyOn = true; pcall(function() hum.PlatformStand = true end)
    local flyBodyVelocity = Instance.new("BodyVelocity", hrp); flyBodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
    local flyBodyGyro = Instance.new("BodyGyro", hrp); flyBodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge); flyBodyGyro.P = 3000
    if flyConn then flyConn:Disconnect() end
    local cam = workspace.CurrentCamera
    flyConn = RunService.RenderStepped:Connect(function()
        if not Config.IsFlyOn or hum.Health <= 0 then 
            Config.IsFlyOn = false; if flyConn then flyConn:Disconnect(); flyConn=nil end
            if flyBodyVelocity then flyBodyVelocity:Destroy() end; if flyBodyGyro then flyBodyGyro:Destroy() end
            pcall(function() hum.PlatformStand = false end); return 
        end
        local moveDir = hum.MoveDirection
        if moveDir.Magnitude > 0 then
            local cL = cam.CFrame.LookVector; local cR = cam.CFrame.RightVector
            local fL = Vector3.new(cL.X, 0, cL.Z).Unit; local fR = Vector3.new(cR.X, 0, cR.Z).Unit
            flyBodyVelocity.Velocity = (cL * fL:Dot(moveDir) + cR * fR:Dot(moveDir)) * Config.FlySpeed
        else flyBodyVelocity.Velocity = Vector3.zero end
        flyBodyGyro.CFrame = cam.CFrame
    end)
end

local function toggleNoclip(state)
    Config.IsNoclipOn = state
    if state then
        if not noclipConn then noclipConn = RunService.Stepped:Connect(function()
            local char = LocalPlayer.Character
            if char then for _, p in pairs(char:GetDescendants()) do if p:IsA("BasePart") and p.CanCollide then p.CanCollide = false end end end
        end) end
    else if noclipConn then noclipConn:Disconnect(); noclipConn = nil end end
end

local function toggleAutoDrive(state)
    Config.IsAutoDriveOn = state
    if state then
        if not autoDriveConn then autoDriveConn = RunService.Stepped:Connect(function()
            if not Config.IsAutoDriveOn then return end
            local char = LocalPlayer.Character
            local seat = char and char.Humanoid and char.Humanoid.SeatPart
            if seat and seat:IsA("VehicleSeat") then
                local car = seat.Parent
                local hrp = car and (car.PrimaryPart or car:FindFirstChildWhichIsA("BasePart"))
                if hrp then
                    seat.Throttle = 1
                    local rayP = RaycastParams.new(); rayP.FilterDescendantsInstances = {car}; rayP.FilterType = Enum.RaycastFilterType.Exclude
                    local ray = workspace:Raycast(hrp.Position, hrp.CFrame.LookVector * 25, rayP)
                    seat.Steer = ray and 1 or 0
                end
            end
        end) end
    else if autoDriveConn then autoDriveConn:Disconnect(); autoDriveConn = nil end end
end

-- =========================================================================
-- [ UI CREATION ]
-- =========================================================================
local ScreenGui = Instance.new("ScreenGui", GUIParent)
ScreenGui.Name = "ouncopybara_VIP_GUI"; ScreenGui.IgnoreGuiInset = true; ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 350, 0, 420); MainFrame.Position = UDim2.new(0.5, -175, 0.5, -210)
MainFrame.BackgroundColor3 = Color3.fromRGB(0,0,0); MainFrame.BackgroundTransparency = 1; MainFrame.BorderSizePixel = 0

local bgImage = Instance.new("ImageLabel", MainFrame)
bgImage.Size = UDim2.new(1, 0, 1, 0); bgImage.BackgroundTransparency = 1; bgImage.ZIndex = 0
bgImage.ImageTransparency = 0.25; bgImage.ScaleType = Enum.ScaleType.Crop
Instance.new("UICorner", bgImage).CornerRadius = UDim.new(0, 12)

local bgTint = Instance.new("Frame", MainFrame)
bgTint.Size = UDim2.new(1, 0, 1, 0); bgTint.BackgroundColor3 = Config.Themes[Config.Theme].Main; bgTint.BackgroundTransparency = 0.45
Instance.new("UICorner", bgTint).CornerRadius = UDim.new(0, 12); bgTint.ZIndex = 1

local UIStroke = Instance.new("UIStroke", bgTint)
UIStroke.Thickness = 2; UIStroke.Color = Config.Themes[Config.Theme].Accent
task.spawn(function()
    while MainFrame and MainFrame.Parent do
        if not MainFrame.Visible then task.wait(0.5); continue end
        local t = Config.Themes[Config.Theme]
        for i = 0, 1, 0.05 do if not MainFrame.Parent then return end UIStroke.Color = t.Accent:Lerp(Color3.new(1,1,1), math.sin(i*math.pi)); task.wait(0.05) end
    end
end)

local TitleBar = Instance.new("Frame", MainFrame)
TitleBar.Size = UDim2.new(1, 0, 0, 40); TitleBar.BackgroundColor3 = Config.Themes[Config.Theme].Btn; TitleBar.BackgroundTransparency = 0.2; TitleBar.BorderSizePixel = 0
Instance.new("UICorner", TitleBar).CornerRadius = UDim.new(0, 12); TitleBar.ZIndex = 2

local TitleText = Instance.new("TextLabel", TitleBar)
TitleText.Size = UDim2.new(1, -120, 1, 0); TitleText.Position = UDim2.new(0, 15, 0, 0)
TitleText.BackgroundTransparency = 1; TitleText.Text = "✨ ULTRA VIP V7 ✨"
TitleText.TextColor3 = Config.Themes[Config.Theme].Accent; TitleText.Font = Enum.Font.GothamBlack; TitleText.TextSize = 13; TitleText.TextXAlignment = Enum.TextXAlignment.Left; TitleText.ZIndex = 3

local dragging, dragStart, startPos
TitleBar.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true; dragStart = input.Position; startPos = MainFrame.Position end end)
UserInputService.InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + (input.Position - dragStart).X, startPos.Y.Scale, startPos.Y.Offset + (input.Position - dragStart).Y) end end)
UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)

local CloseBtn = Instance.new("TextButton", TitleBar)
CloseBtn.Size = UDim2.new(0, 26, 0, 26); CloseBtn.Position = UDim2.new(1, -34, 0, 7)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 60, 60); CloseBtn.Text = "✕"; CloseBtn.TextColor3 = Color3.new(1, 1, 1); CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 12; CloseBtn.ZIndex = 3
Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(1, 0)
CloseBtn.Activated:Connect(function() ScreenGui:Destroy() end)

local HideBtn = Instance.new("TextButton", TitleBar)
HideBtn.Size = UDim2.new(0, 26, 0, 26); HideBtn.Position = UDim2.new(1, -66, 0, 7)
HideBtn.BackgroundColor3 = Config.Themes[Config.Theme].Accent; HideBtn.Text = "–"; HideBtn.TextColor3 = Color3.new(1, 1, 1); HideBtn.Font = Enum.Font.GothamBold; HideBtn.TextSize = 14; HideBtn.ZIndex = 3
Instance.new("UICorner", HideBtn).CornerRadius = UDim.new(1, 0)

local ReopenBtn = Instance.new("TextButton", ScreenGui)
ReopenBtn.Name = "ouncopybara_reopen"
ReopenBtn.Size = UDim2.new(0, 55, 0, 55)
ReopenBtn.Position = UDim2.new(0, 20, 0.5, -27)
ReopenBtn.BackgroundColor3 = Config.Themes[Config.Theme].Accent
ReopenBtn.Text = ""
ReopenBtn.TextColor3 = Color3.new(1, 1, 1)
ReopenBtn.Font = Enum.Font.GothamBlack
ReopenBtn.TextSize = 12
ReopenBtn.Visible = false
ReopenBtn.ZIndex = 10
ReopenBtn.AutoButtonColor = false
Instance.new("UICorner", ReopenBtn).CornerRadius = UDim.new(1, 0)

local reopenStroke = Instance.new("UIStroke", ReopenBtn)
reopenStroke.Thickness = 2.5
reopenStroke.Color = Color3.new(1, 1, 1)
reopenStroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border

local ReopenImage = Instance.new("ImageLabel", ReopenBtn)
ReopenImage.Name = "IconImage"
ReopenImage.Size = UDim2.new(1, 0, 1, 0)
ReopenImage.Position = UDim2.new(0, 0, 0, 0)
ReopenImage.BackgroundTransparency = 1
ReopenImage.ScaleType = Enum.ScaleType.Crop
ReopenImage.ZIndex = 11
Instance.new("UICorner", ReopenImage).CornerRadius = UDim.new(1, 0)

if CustomImage ~= "" then
    ReopenImage.Image = CustomImage
    bgImage.Image = CustomImage
else
    ReopenImage.Image = ""
    ReopenBtn.Text = "VIP"
    bgImage.Image = "rbxassetid://14257626628"
end

local rDrag, rStart, rPos, rMoved
ReopenBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        rDrag = true; rStart = input.Position; rPos = ReopenBtn.Position; rMoved = false
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if rDrag and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        local d = input.Position - rStart
        if math.abs(d.X) > 3 or math.abs(d.Y) > 3 then rMoved = true end
        ReopenBtn.Position = UDim2.new(rPos.X.Scale, rPos.X.Offset + d.X, rPos.Y.Scale, rPos.Y.Offset + d.Y)
    end
end)
ReopenBtn.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        rDrag = false
    end
end)

local function toggleHide(state)
    if state then
        MainFrame.Visible = false
        ReopenBtn.Visible = true
        TweenService:Create(ReopenBtn, TweenInfo.new(0.3, Enum.EasingStyle.Back), {Size = UDim2.new(0, 55, 0, 55)}):Play()
    else
        MainFrame.Visible = true
        ReopenBtn.Visible = false
    end
end

HideBtn.Activated:Connect(function() toggleHide(true) end)
ReopenBtn.Activated:Connect(function() if not rMoved then toggleHide(false) end end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Config.ToggleKey then
        if MainFrame.Visible then toggleHide(true) else toggleHide(false) end
    end
end)

local TabBar = Instance.new("Frame", MainFrame)
TabBar.Size = UDim2.new(1, -20, 0, 30); TabBar.Position = UDim2.new(0, 10, 0, 48); TabBar.BackgroundTransparency = 1; TabBar.ZIndex = 2

local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1, -20, 1, -125); ContentFrame.Position = UDim2.new(0, 10, 0, 85); ContentFrame.BackgroundTransparency = 1; ContentFrame.ZIndex = 2

local StatusLabel = Instance.new("TextLabel", MainFrame)
StatusLabel.Size = UDim2.new(1, -20, 0, 30); StatusLabel.Position = UDim2.new(0, 10, 1, -36)
StatusLabel.BackgroundColor3 = Config.Themes[Config.Theme].Btn; StatusLabel.Text = " ⚡ Instant TP Ready!"
StatusLabel.TextColor3 = Config.Themes[Config.Theme].Text; StatusLabel.Font = Enum.Font.GothamBold; StatusLabel.TextSize = 11; StatusLabel.ZIndex = 2
Instance.new("UICorner", StatusLabel).CornerRadius = UDim.new(0, 8)
updateStatus = function(txt, col) StatusLabel.Text = " " .. txt; StatusLabel.TextColor3 = col or Config.Themes[Config.Theme].Text end

local tabs = {}
local function createTab(name)
    local tab = Instance.new("TextButton", TabBar)
    tab.Size = UDim2.new(1/3, -2, 1, 0); tab.Position = UDim2.new(#tabs / 3, 1, 0, 0)
    tab.BackgroundColor3 = Config.Themes[Config.Theme].Btn; tab.Text = name; tab.TextColor3 = Config.Themes[Config.Theme].Text
    tab.Font = Enum.Font.GothamBold; tab.TextSize = 11; tab.ZIndex = 3
    Instance.new("UICorner", tab).CornerRadius = UDim.new(0, 6)
    local content = Instance.new("ScrollingFrame", ContentFrame)
    content.Size = UDim2.new(1, 0, 1, 0); content.BackgroundTransparency = 1; content.BorderSizePixel = 0
    content.ScrollBarThickness = 2; content.Visible = false; content.AutomaticCanvasSize = Enum.AutomaticSize.Y; content.ZIndex = 2
    local layout = Instance.new("UIListLayout", content); layout.Padding = UDim.new(0, 6); layout.SortOrder = Enum.SortOrder.LayoutOrder
    Instance.new("UIPadding", content).PaddingTop = UDim.new(0, 2)
    table.insert(tabs, {Button = tab, Content = content, Name = name})
    tab.Activated:Connect(function()
        for _, t in ipairs(tabs) do TweenService:Create(t.Button, TweenInfo.new(0.2), {BackgroundColor3 = Config.Themes[Config.Theme].Btn}):Play(); t.Content.Visible = false end
        TweenService:Create(tab, TweenInfo.new(0.2), {BackgroundColor3 = Config.Themes[Config.Theme].Accent}):Play(); content.Visible = true
    end)
    return content
end

local toggleList = {} 
local function createToggle(parent, text, default, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, 36); btn.BackgroundColor3 = Config.Themes[Config.Theme].Btn; btn.Text = ""; btn.ZIndex = 3
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    local lbl = Instance.new("TextLabel", btn)
    lbl.Size = UDim2.new(1, -60, 1, 0); lbl.Position = UDim2.new(0, 10, 0, 0); lbl.BackgroundTransparency = 1; lbl.Text = text; lbl.TextColor3 = Color3.new(1, 1, 1); lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 11; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.ZIndex = 4
    local switchBg = Instance.new("Frame", btn)
    switchBg.Size = UDim2.new(0, 38, 0, 20); switchBg.Position = UDim2.new(1, -48, 0.5, -10); switchBg.BackgroundColor3 = default and Config.Themes[Config.Theme].Accent or Color3.fromRGB(50, 50, 50); switchBg.ZIndex = 4
    Instance.new("UICorner", switchBg).CornerRadius = UDim.new(1, 0)
    local knob = Instance.new("Frame", switchBg)
    knob.Size = UDim2.new(0, 16, 0, 16); knob.Position = default and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8); knob.BackgroundColor3 = Color3.new(1, 1, 1); knob.ZIndex = 5
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    local isOn = default
    table.insert(toggleList, {bg = switchBg, state = function() return isOn end})
    btn.Activated:Connect(function()
        isOn = not isOn
        TweenService:Create(knob, TweenInfo.new(0.25, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Position = isOn and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)}):Play()
        TweenService:Create(switchBg, TweenInfo.new(0.25), {BackgroundColor3 = isOn and Config.Themes[Config.Theme].Accent or Color3.fromRGB(50, 50, 50)}):Play()
        if callback then callback(isOn) end
    end)
end

local function createSlider(parent, text, min, max, default, callback)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, 0, 0, 50); frame.BackgroundColor3 = Config.Themes[Config.Theme].Btn; frame.ZIndex = 3
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
    local lbl = Instance.new("TextLabel", frame)
    lbl.Size = UDim2.new(1, -20, 0, 20); lbl.Position = UDim2.new(0, 10, 0, 5); lbl.BackgroundTransparency = 1; lbl.Text = text .. ": " .. tostring(default); lbl.TextColor3 = Color3.new(1, 1, 1); lbl.Font = Enum.Font.GothamBold; lbl.TextSize = 11; lbl.TextXAlignment = Enum.TextXAlignment.Left; lbl.ZIndex = 4
    local bar = Instance.new("Frame", frame)
    bar.Size = UDim2.new(1, -20, 0, 6); bar.Position = UDim2.new(0, 10, 0, 32); bar.BackgroundColor3 = Color3.fromRGB(40, 40, 40); bar.ZIndex = 4
    Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)
    local fill = Instance.new("Frame", bar)
    fill.Size = UDim2.new((default - min) / (max - min), 0, 1, 0); fill.BackgroundColor3 = Config.Themes[Config.Theme].Accent; fill.ZIndex = 5
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    local knob = Instance.new("TextButton", bar)
    knob.Size = UDim2.new(0, 14, 0, 14); knob.Position = UDim2.new((default - min) / (max - min), -7, 0.5, -7); knob.BackgroundColor3 = Color3.new(1, 1, 1); knob.Text = ""; knob.ZIndex = 6
    Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)
    local dragging = false
    local function update(input)
        local rel = math.clamp((input.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * rel)
        fill.Size = UDim2.new(rel, 0, 1, 0); knob.Position = UDim2.new(rel, -7, 0.5, -7); lbl.Text = text .. ": " .. tostring(val)
        if callback then callback(val) end
    end
    knob.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true end end)
    UserInputService.InputChanged:Connect(function(input) if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then update(input) end end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
end

local function createButton(parent, text, color, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, 36); btn.BackgroundColor3 = color or Config.Themes[Config.Theme].Accent; btn.Text = text; btn.TextColor3 = Color3.new(1, 1, 1); btn.Font = Enum.Font.GothamBold; btn.TextSize = 11; btn.ZIndex = 3
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 8)
    btn.Activated:Connect(function() if callback then callback() end end)
    return btn
end

local farmTab = createTab("🥚 Farm")
createButton(farmTab, "📍 Set Base Point", nil, function()
    local hrp = getCharacter()
    if hrp then Config.BaseCFrames[1] = hrp.CFrame; notify("📍 Base បានកំណត់!", Color3.fromRGB(0,255,100)) end
end)
createToggle(farmTab, "🌾 Auto Farm Eggs", false, function(s) Config.IsAutoOn = s end)
createSlider(farmTab, "Farm Delay", 0.5, 5, 1, function(v) Config.StiffDuration = v end)
createToggle(farmTab, "🛡️ Network Ownership", true, function(s) AntiTP.Enabled = s end)
createToggle(farmTab, "💀 Godmode", true, function(s) Godmode.Enabled = s end)

local moveTab = createTab("🏃 Move")
createToggle(moveTab, "⚡ Speed Hack", false, function(s) toggleSpeed(s) end)
createSlider(moveTab, "Speed Value", 16, 300, 60, function(v) Config.SpeedValue = v end)
createToggle(moveTab, "🕊️ Smooth Fly", false, function(s) if s then enableFly() else Config.IsFlyOn = false end end)
createSlider(moveTab, "Fly Speed", 20, 500, 100, function(v) Config.FlySpeed = v end)
createToggle(moveTab, "👻 Noclip", false, function(s) toggleNoclip(s) end)
createToggle(moveTab, "🚗 Auto Drive", false, function(s) toggleAutoDrive(s) end)
createToggle(moveTab, "🚀 Inf Jump", false, function(s) Config.IsInfiniteJumpOn = s end)
UserInputService.JumpRequest:Connect(function() if Config.IsInfiniteJumpOn then local _, hum = getCharacter(); if hum then pcall(function() hum:ChangeState(Enum.HumanoidStateType.Jumping) end) end end end)

local setTab = createTab("⚙️ Set")
createToggle(setTab, "💤 Anti-AFK", true, function(s) Config.IsAntiAFK = s end)
createButton(setTab, "🔄 Take Ownership + God", Color3.fromRGB(0, 200, 100), function()
    AntiTP.Active = true
    grabNetworkOwnership()
    applyGodmode()
    notify("✅ Ownership + Godmode!", Color3.fromRGB(0,255,100))
end)
createButton(setTab, "🎨 Change Theme", Color3.fromRGB(150, 50, 200), function()
    local names = {"Pink", "Purple", "Blue", "Green", "Gold"}
    local idx = 1; for i, n in ipairs(names) do if n == Config.Theme then idx = i end end
    Config.Theme = names[(idx % #names) + 1]
    local t = Config.Themes[Config.Theme]
    bgTint.BackgroundColor3 = t.Main; TitleBar.BackgroundColor3 = t.Btn; TitleText.TextColor3 = t.Accent
    StatusLabel.BackgroundColor3 = t.Btn; UIStroke.Color = t.Accent
    HideBtn.BackgroundColor3 = t.Accent; ReopenBtn.BackgroundColor3 = t.Accent
    for _, tb in ipairs(tabs) do if tb.Content.Visible then tb.Button.BackgroundColor3 = t.Accent else tb.Button.BackgroundColor3 = t.Btn end end
    for _, tog in ipairs(toggleList) do if tog.state() then tog.bg.BackgroundColor3 = t.Accent end end
    notify("🎨 Theme ទៅជា " .. Config.Theme, t.Accent)
end)

tabs[1].Button:Activate()
applyGodmode()
updateStatus("System Online - V7 (Instant TP)", Color3.fromRGB(0, 255, 120))
notify("✨ ULTRA VIP V7 Loaded!", Color3.fromRGB(255, 105, 180))

end)
if not success then warn("[Error]: " .. tostring(err)) end

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Camera = workspace.CurrentCamera
local TweenService = game:GetService("TweenService")

--  Variables
local ESPEnabled = false
local NAMETAGSEnabled = false
local updateConnection = nil
local LocalPlayer = Players.LocalPlayer
local Holding = false
local AimbotActive = false
local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local humanoid = character:WaitForChild("Humanoid")

-- Speed-related variables
local increasedWalkSpeed = 20  -- Set your desired speed here
local defaultWalkSpeed = humanoid.WalkSpeed  -- Save the default speed
local speedConnection

-- Function to enable player speed boost
local function PlayerSpeedEnabled()
    if speedConnection then return end  -- Prevent multiple connections
    speedConnection = RunService.RenderStepped:Connect(function()
        humanoid.WalkSpeed = increasedWalkSpeed
    end)
end

-- Function to stop the speed boost and reset to default speed
local function StopPlayerSpeed()
    if speedConnection then
        speedConnection:Disconnect()
        speedConnection = nil
    end
    humanoid.WalkSpeed = defaultWalkSpeed  -- Reset to default speed
end

-- Function to toggle speed based on the value of SpeedEnabled
local function SpeedEnabled(enabled)
    if enabled then
        PlayerSpeedEnabled()
    else
        StopPlayerSpeed()
    end
end

-- Function to apply the Chams effect to a player's character
local function applyChamsEffect(character)
    local highlight = character:FindFirstChild("ChamsHighlight")
    if not highlight then
        highlight = Instance.new("Highlight")
        highlight.Name = "ChamsHighlight"
        highlight.FillColor = Color3.fromRGB(255, 255, 255) -- White fill color
        highlight.FillTransparency = 1
        highlight.OutlineColor = Color3.fromRGB(255, 0, 0) -- Red outline color
        highlight.OutlineTransparency = 0.2
        highlight.Adornee = character
        highlight.Parent = character
    end
end

-- Function to remove Chams effect from a player's character
local function removeChamsEffect(character)
    local highlight = character:FindFirstChild("ChamsHighlight")
    if highlight then
        highlight:Destroy()
    end
end

-- Function to apply Chams to all players
local function applyChamsToAllPlayers()
    if not ESPEnabled then
        return
    end

    -- Apply the Chams effect to all players currently in the game
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            applyChamsEffect(player.Character)
        end
    end
end

-- Function to start Chams updates
local function startChamsUpdates()
    applyChamsToAllPlayers()
    updateConnection = RunService.Heartbeat:Connect(function()
        if ESPEnabled then
            applyChamsToAllPlayers()
        end
    end)
end

-- Function to stop Chams updates
local function stopChamsUpdates()
    if updateConnection then
        updateConnection:Disconnect()
        updateConnection = nil
    end

    -- Hide Chams for all players
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            removeChamsEffect(player.Character)
        end
    end
end

-- Toggle function for ESP
local function toggleESP(enabled)
    ESPEnabled = enabled
    if enabled then
        startChamsUpdates()
    else
        stopChamsUpdates()
    end
end

-- Event listeners for players joining or leaving
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        if ESPEnabled then
            applyChamsEffect(character)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    if player.Character then
        removeChamsEffect(player.Character)
    end
end)
-- NAMETAGS ESP


-- Function to apply the ESP effect to a player's character
local function applyEspEffect(character)
    local esp = character:FindFirstChild("ESP")
    if not esp then
        esp = Instance.new("BillboardGui")
        esp.Name = "ESP"
        esp.Adornee = character:FindFirstChild("Head")
        esp.Parent = character
        esp.Size = UDim2.new(0, 200, 0, 50)
        esp.AlwaysOnTop = true

        local textLabel = Instance.new("TextLabel")
        textLabel.Size = UDim2.new(1, 0, 1, 0)
        textLabel.BackgroundTransparency = 1
        textLabel.TextColor3 = Color3.fromRGB(255, 0, 0) -- Red text color
        textLabel.TextStrokeTransparency = 0.5
        textLabel.Text = character.Name
        textLabel.Parent = esp
    end
end

-- Function to remove ESP effect from a player's character
local function removeEspEffect(character)
    local esp = character:FindFirstChild("ESP")
    if esp then
        esp:Destroy()
    end
end

-- Function to apply ESP to all players
local function applyEspToAllPlayers()
    if not NAMETAGSEnabled then
        return
    end

    -- Apply the ESP effect to all players currently in the game
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character and player.Character:FindFirstChild("Head") then
            applyEspEffect(player.Character)
        end
    end
end

-- Function to start ESP updates
local function startEspUpdates()
    applyEspToAllPlayers()
    updateConnection = RunService.Heartbeat:Connect(function()
        if NAMETAGSEnabled then
            applyEspToAllPlayers()
        end
    end)
end

-- Function to stop ESP updates
local function stopEspUpdates()
    if updateConnection then
        updateConnection:Disconnect()
        updateConnection = nil
    end

    -- Hide ESP for all players
    for _, player in ipairs(Players:GetPlayers()) do
        if player.Character then
            removeEspEffect(player.Character)
        end
    end
end

-- Toggle function for ESP
local function toggleNAMETAGS(enabled)
    NAMETAGSEnabled = enabled
    if enabled then
        startEspUpdates()
    else
        stopEspUpdates()
    end
end

-- Event listeners for players joining or leaving
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        if NAMETAGSEnabled then
            applyEspEffect(character)
        end
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    if player.Character then
        removeEspEffect(player.Character)
    end
end)

-- USEAGE : toggleNAMETAGS(false) OFF
-- USEAGE : toggleNAMETAGS(true) ON

-- NAMETAGS ESP END


-- Aimbot Configuration
local AimbotConfig = {
    TeamCheck = false, -- If set to true, the script would only lock your aim at enemy team members.
    AimPart = "Head", -- Where the aimbot script would lock at.
    Sensitivity = 0, -- How many seconds it takes for the aimbot script to officially lock onto the target's aimpart.
    CircleSides = 64, -- How many sides the FOV circle would have.
    CircleColor = Color3.fromRGB(255, 255, 255), -- (RGB) Color that the FOV circle would appear as.
    CircleTransparency = 0.7, -- Transparency of the circle.
    CircleRadius = 80, -- The radius of the circle / FOV.
    CircleFilled = false, -- Determines whether or not the circle is filled.
    CircleVisible = false, -- Determines whether or not the circle is visible.
    CircleThickness = 0 -- The thickness of the circle.
}

local FOVCircle = Drawing.new("Circle")
    FOVCircle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    FOVCircle.Radius = AimbotConfig.CircleRadius
    FOVCircle.Filled = AimbotConfig.CircleFilled
    FOVCircle.Color = AimbotConfig.CircleColor
    FOVCircle.Visible = AimbotConfig.CircleVisible
    FOVCircle.Transparency = AimbotConfig.CircleTransparency
    FOVCircle.NumSides = AimbotConfig.CircleSides
    FOVCircle.Thickness = AimbotConfig.CircleThickness

-- Function to get the closest player within the FOV circle
local function GetClosestPlayer()
    local MaximumDistance = AimbotConfig.CircleRadius
    local Target = nil

    for _, v in ipairs(Players:GetPlayers()) do
        if v.Name ~= LocalPlayer.Name then
            if AimbotConfig.TeamCheck == true then
                if v.Team ~= LocalPlayer.Team then
                    if v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                        local ScreenPoint = Camera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
                        local VectorDistance = (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(ScreenPoint.X, ScreenPoint.Y)).Magnitude

                        if VectorDistance < MaximumDistance then
                            Target = v
                        end
                    end
                end
            else
                if v.Character and v.Character:FindFirstChild("HumanoidRootPart") and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 then
                    local ScreenPoint = Camera:WorldToScreenPoint(v.Character.HumanoidRootPart.Position)
                    local VectorDistance = (Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y) - Vector2.new(ScreenPoint.X, ScreenPoint.Y)).Magnitude

                    if VectorDistance < MaximumDistance then
                        Target = v
                    end
                end
            end
        end
    end

    return Target
end

-- Function to enable or disable the aimbot
local function AimbotEnabled(enabled)
    AimbotActive = enabled
    FOVCircle.Visible = enabled
end

-- Input listeners
UserInputService.InputBegan:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton2 then
        Holding = true
    end
end)

UserInputService.InputEnded:Connect(function(Input)
    if Input.UserInputType == Enum.UserInputType.MouseButton2 then
        Holding = false
    end
end)

-- Update loop
RunService.RenderStepped:Connect(function()
    -- Update FOV Circle
    FOVCircle.Position = Vector2.new(UserInputService:GetMouseLocation().X, UserInputService:GetMouseLocation().Y)
    FOVCircle.Radius = AimbotConfig.CircleRadius
    FOVCircle.Filled = AimbotConfig.CircleFilled
    FOVCircle.Color = AimbotConfig.CircleColor
    FOVCircle.Transparency = AimbotConfig.CircleTransparency
    FOVCircle.NumSides = AimbotConfig.CircleSides
    FOVCircle.Thickness = AimbotConfig.CircleThickness

    if Holding and AimbotActive then
        local target = GetClosestPlayer()
        if target then
            TweenService:Create(Camera, TweenInfo.new(AimbotConfig.Sensitivity, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), {CFrame = CFrame.new(Camera.CFrame.Position, target.Character[AimbotConfig.AimPart].Position)}):Play()
        end
    end
end)


-- Example usage
-- Enable aimbot AimbotEnabled(true)

-- Disable aimbot later
-- AimbotEnabled(false)









-- UI Library Setup
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/matas3535/gamesneeze/main/Library.lua"))()

local Window = Library:New({
    Name = "Aimware", -- name, Name, title, Title
})

-- Main Page
local MainPage = Window:Page({
    Name = "Main" -- name, Name, title, Title
})

local PageSection1 = MainPage:Section({
    Name = "Main", -- name, Name, title, Title
    Fill = true,
    Side = "Left"
})

-- Toggle for Aimbot
PageSection1:Toggle({
    Name = "Aimbot", -- name, Name, title, Title
    Default = false,
    Callback = function(value)
        AimbotEnabled(value)
    end
})

-- Visuals Page
local Page = Window:Page({
    Name = "Visuals" -- name, Name, title, Title
})

local PageSection1 = Page:Section({
    Name = "Players", -- name, Name, title, Title
    Fill = true,
    Side = "Left"
})

-- Toggle for Chams (ESP)
PageSection1:Toggle({
    Name = "Enable Chams", -- name, Name, title, Title
    Default = false,
    Callback = function(value)
        toggleESP(value)
    end
})

PageSection1:Toggle({
    Name = "Enable Esp", -- name, Name, title, Title
    Default = false,
    Callback = function(value)
        toggleNAMETAGS(value)
        AimbotEnabled(false)
    end
})

-- Player Page
local PlayerPage = Window:Page({
    Name = "Player"
})

local PageSection1 = PlayerPage:Section({
    Name = "Movement", -- name, Name, title, Title
    Fill = true,
    Side = "Left"
})

PageSection1:Toggle({
    Name = "Enable Speed", -- name, Name, title, Title
    Default = false,
    Callback = function(value)
        SpeedEnabled(value)
    end
})

local Slider1 = PageSection1:Slider({
    Name = "Slider (dont Work)", -- name, Name, title, Title
    Min = 1, -- def, Def, default, Default
    Max = 25, -- min, Min, minimum, Minimum
    Default = 1, -- max, Max, maximum, Maximum
    --Suffix = "ms", -- suffix, Suffix, ending, Ending, prefix, Prefix, measurement, Measurement
    --decimals = 0.01,
    --Disabled = false, -- disable, Disable, disabled, Disabled
    callback = function(value)
        print(value)
    end
})

-- Button To Destroy Menu
local Button1 = PageSection1:Button({
    Name = "Destroy Menu", -- name, Name, title, Title
    callback = function(value)
        toggleNAMETAGS(false)
        toggleESP(false)
        SpeedEnabled(false)
        AimbotEnabled(false)
        Window:Fade()
        Wait(5)
        Window:Unload()
    end
})

-- Initialize UI
Window:Initialize() -- DO NOT REMOVE

-- Toggle Menu Visibility with RightShift
local menuVisible = true

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightShift then
        menuVisible = not menuVisible
        if menuVisible then
            Window:Fade() -- or Window:Initialize() if you want to completely reinitialize
        else
            Window:CloseContent()
        end
    end
end)

-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Chams Variables
local ESPEnabled = false
local NAMETAGSEnabled = false
local updateConnection = nil

-- Function to apply the Chams effect to a player's character
local function applyChamsEffect(character)
    local highlight = character:FindFirstChild("ChamsHighlight")
    if not highlight then
        highlight = Instance.new("Highlight")
        highlight.Name = "ChamsHighlight"
        highlight.FillColor = Color3.fromRGB(255, 255, 251) -- White fill color
        highlight.FillTransparency = 5
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
        print(value)
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

--[[
    Remaining UI Elements
]]

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
    end
})

-- Players Page
local PlayerPage = Window:Page({
    Name = "Players"
})

-- Player List
local PlayerList = PlayerPage:PlayerList({})

-- Main Page
local MainPage = Window:Page({
    Name = "Main" -- name, Name, title, Title
})

local PageSection1 = MainPage:Section({
    Name = "Main", -- name, Name, title, Title
    Fill = true,
    Side = "Left"
})

-- Button To Destory Menu
local Button1 = PageSection1:Button({
    Name = "Button", -- name, Name, title, Title
    callback = function(value)
        toggleNAMETAGS(false)
        toggleESP(false)
        
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

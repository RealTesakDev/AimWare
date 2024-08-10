-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Chams Variables
local ESPEnabled = false
local updateConnection = nil

-- Function to apply the Chams effect to a player's character
local function applyChamsEffect(character)
    local highlight = character:FindFirstChild("ChamsHighlight")
    if not highlight then
        highlight = Instance.new("Highlight")
        highlight.Name = "ChamsHighlight"
        highlight.FillColor = Color3.fromRGB(0, 255, 0) -- Green fill color
        highlight.FillTransparency = 0.5
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

-- UI Library Setup
local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/matas3535/gamesneeze/main/Library.lua"))()

local Window = Library:New({
    Name = "Title", -- name, Name, title, Title
})

local Page = Window:Page({
    Name = "Page" -- name, Name, title, Title
})

local PlayerPage = Window:Page({
    Name = "Players"
})

local PageSection1 = Page:Section({
    Name = "Section", -- name, Name, title, Title
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

-- Player List
local PlayerList = PlayerPage:PlayerList({})

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

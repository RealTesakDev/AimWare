-- Services
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

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

-- Label
PageSection1:Label({
    Name = "Label", -- name, Name, title, Title
    Center = true
})

-- TextBox
PageSection1:TextBox({
    Default = "TextBox", 
    Placeholder = "Type Here...", 
    Max = 100,
    Reactive = true,
    Callback = function(value) 
        print(value)
    end
})

-- Example KeyBind Toggle
PageSection1:Toggle({
    Name = "KeyBindToggle", -- name, Name, title, Title
    Default = false,
    Callback = function(value)
        print(value)
    end
}):Keybind({
    Name = "KeybindToggle", -- name, Name, title, Title
    Default = Enum.KeyCode.X, 
    KeybindName = "KeybindToggle", 
    Mode = "Toggle", 
    Callback = function(Input, State) 
        print(Input, State) 
    end
})

-- Button
PageSection1:Button({
    Name = "Button", -- name, Name, title, Title
    Callback = function(value)
        print(value)
    end
})

-- Slider
PageSection1:Slider({
    Name = "Slider", -- name, Name, title, Title
    Min = 1, 
    Max = 100, 
    Default = 1, 
    Callback = function(value)
        print(value)
    end
})

-- Multibox
PageSection1:Multibox({
    Name = "MultiBox", 
    Default = {"1", "2"}, 
    Options = {"1", "2", "3", "4", "5", "6", "7", "8"}, 
    Min = 2, 
    Max = 5, 
    Callback = function(value) 
        print(value) 
    end
})

-- Dropdown
PageSection1:Dropdown({
    Name = "DropDown", -- name, Name, title, Title
    Default = "1",
    Max = "3",
    Options = {"1", "2", "3"},
    Callback = function(value)
        print(value)
    end
})

-- Color Picker
PageSection1:Colorpicker({
    Name = "ColorPicker", -- name, Name, title, Title
    Default = Color3.fromRGB(255, 0, 0),
    Transparency = 0.25,
    Info = "Color",
    Callback = function(value)
        print(value)
    end
})

-- ListBox
PageSection1:Label({
    Name = "ListBox", -- name, Name, title, Title
    Center = true
})

-- List
PageSection1:List({
    Name = "List", -- name, Name, title, Title
    Default = 1,
    Max = 5,
    Options = {"1", "2", "3", "4", "5"}
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

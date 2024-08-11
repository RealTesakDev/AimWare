-- Services
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

-- Variables
local viewModel = Camera:FindFirstChild("ViewModel")
local item = viewModel and viewModel:FindFirstChild("Item")

-- Function to create highlight
local function createHighlight(object)
    if object and not object:FindFirstChildOfClass("Highlight") then
        local highlight = Instance.new("Highlight")
        highlight.Parent = object
        highlight.Adornee = object
        highlight.FillColor = Color3.new(0, 1, 0) -- Green fill color
        highlight.OutlineColor = Color3.new(1, 1, 1) -- White outline color
        highlight.FillTransparency = 0.3 -- Adjust fill transparency (0 is opaque, 1 is fully transparent)
        highlight.OutlineTransparency = 0 -- Adjust outline transparency (0 is opaque, 1 is fully transparent)
    end
end

-- Function to remove highlight
local function removeHighlight(object)
    local highlight = object:FindFirstChildOfClass("Highlight")
    if highlight then
        highlight:Destroy()
    end
end

-- Update function to check and highlight the Item in ViewModel
local function updateHighlight()
    viewModel = Camera:FindFirstChild("ViewModel")
    if viewModel then
        item = viewModel:FindFirstChild("Item")
        if item then
            createHighlight(item)
        else
            removeHighlight(item)
        end
    end
end

-- Connect update function to RunService's RenderStepped
RunService.RenderStepped:Connect(updateHighlight)

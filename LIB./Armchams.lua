-- Services
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")

-- List of object names to highlight
local targetNames = {
    "LeftLowerArm",
    "LeftUpperArm",
    "RightLowerArm",
    "RightUpperArm",
    "LeftHand",
    "Clothing",
    "RightHand"
}

-- Function to create highlight
local function createHighlight(object)
    if object and not object:FindFirstChildOfClass("Highlight") then
        local highlight = Instance.new("Highlight")
        highlight.Parent = object
        highlight.Adornee = object
        highlight.FillColor = Color3.new(0, 1, 0) -- Green fill color
        highlight.OutlineColor = Color3.new(1, 1, 1) -- White outline color
        highlight.FillTransparency = 0.3 -- Adjust fill transparency
        highlight.OutlineTransparency = 0 -- Adjust outline transparency
    end
end

-- Function to highlight specific parts in ViewModel
local function highlightParts()
    local viewModel = Camera:FindFirstChild("ViewModel")
    if viewModel then
        for _, name in ipairs(targetNames) do
            local part = viewModel:FindFirstChild(name)
            if part then
                createHighlight(part)
            end
        end
    end
end

-- Connect update function to RunService's RenderStepped
RunService.RenderStepped:Connect(highlightParts)

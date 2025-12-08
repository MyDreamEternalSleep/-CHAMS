local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local isStudio = RunService:IsStudio()
local player = Players.LocalPlayer
local targetGui = nil

local function getTargetGui()
    if isStudio then
        local success, coreGui = pcall(function()
            return game:GetService("CoreGui")
        end)
        if success and coreGui then
            return coreGui
        end
    end
    
    if player then
        local playerGui = player:FindFirstChild("PlayerGui")
        if not playerGui then
            playerGui = player:WaitForChild("PlayerGui")
        end
        return playerGui
    end
    
    return nil
end

targetGui = getTargetGui()

if not targetGui then
    warn(" ❌- GUI ")
    return
end

print(" ✅ - GUI " .. targetGui.Name)

local LocalPlayer = Players.LocalPlayer

local Settings = {
    Enabled = true,
    Color = Color3.fromRGB(180, 70, 255),
    Transparency = 0.5,
    ThroughWalls = true
}

local PlayerChams = {}

local function createChams(player)
    if player == LocalPlayer then return end
    if not player.Character then return end
    
    if PlayerChams[player] then
        PlayerChams[player]:Destroy()
    end
    
    local success, highlight = pcall(function()
        local h = Instance.new("Highlight")
        h.Name = "Chams_" .. player.Name
        h.FillColor = Settings.Color
        h.FillTransparency = Settings.Transparency
        h.OutlineColor = Settings.Color
        h.OutlineTransparency = 0
        h.Adornee = player.Character
        h.Enabled = Settings.Enabled
        h.DepthMode = Settings.ThroughWalls and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded
        h.Parent = player.Character
        return h
    end)
    
    if success then
        PlayerChams[player] = highlight
    else
        warn(" ⚠️ - Chams " .. player.Name)
    end
end

local function removeChams(player)
    if PlayerChams[player] then
        pcall(function()
            PlayerChams[player]:Destroy()
        end)
        PlayerChams[player] = nil
    end
end

local function updateAllChams()
    for player, highlight in pairs(PlayerChams) do
        if highlight and highlight.Parent then
            pcall(function()
                highlight.FillColor = Settings.Color
                highlight.OutlineColor = Settings.Color
                highlight.FillTransparency = Settings.Transparency
                highlight.Enabled = Settings.Enabled
                highlight.DepthMode = Settings.ThroughWalls and Enum.HighlightDepthMode.AlwaysOnTop or Enum.HighlightDepthMode.Occluded
            end)
        end
    end
end

local function setupPlayer(player)
    if player == LocalPlayer then return end
    
    local function characterAdded(character)
        wait(0.3)
        if Settings.Enabled then
            createChams(player)
        end
    end
    
    player.CharacterAdded:Connect(characterAdded)
    
    player.CharacterRemoving:Connect(function()
        removeChams(player)
    end)
    
    if player.Character then
        wait(0.3)
        if Settings.Enabled then
            createChams(player)
        end
    end
end

for _, player in pairs(Players:GetPlayers()) do
    setupPlayer(player)
end

Players.PlayerAdded:Connect(setupPlayer)

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "ChamsPremiumGUI"
screenGui.DisplayOrder = 999
screenGui.ResetOnSpawn = false
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

local success = pcall(function()
    screenGui.Parent = targetGui
end)

if not success then
    warn(" ❌ - ScreenGui ")
    return
end

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 350, 0, 480)
mainFrame.Position = UDim2.new(0.02, 0, 0.02, 0)
mainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 20)
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 2
mainFrame.BorderColor3 = Color3.fromRGB(140, 70, 255)
mainFrame.Active = true
mainFrame.Draggable = true
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui

local innerGlow = Instance.new("Frame")
innerGlow.Size = UDim2.new(1, -4, 1, -4)
innerGlow.Position = UDim2.new(0, 2, 0, 2)
innerGlow.BackgroundTransparency = 1
innerGlow.BorderSizePixel = 1
innerGlow.BorderColor3 = Color3.fromRGB(160, 90, 255)
innerGlow.Parent = mainFrame

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 40)
titleBar.Position = UDim2.new(0, 0, 0, 0)
titleBar.BackgroundColor3 = Color3.fromRGB(25, 20, 35)
titleBar.BorderSizePixel = 0
titleBar.Parent = mainFrame

local titleGradient = Instance.new("UIGradient")
titleGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(60, 30, 90)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 20, 60))
})
titleGradient.Rotation = 90
titleGradient.Parent = titleBar

local titleText = Instance.new("TextLabel")
titleText.Text = " 🔗 CHAMS "
titleText.Size = UDim2.new(0.7, 0, 1, 0)
titleText.Position = UDim2.new(0, 15, 0, 0)
titleText.BackgroundTransparency = 1
titleText.TextColor3 = Color3.fromRGB(230, 200, 255)
titleText.Font = Enum.Font.GothamBold
titleText.TextSize = 18
titleText.TextXAlignment = Enum.TextXAlignment.Left
titleText.TextStrokeTransparency = 0.7
titleText.TextStrokeColor3 = Color3.fromRGB(100, 50, 180)
titleText.Name = "MainTitle"
titleText.Parent = titleBar

local toggleBtn = Instance.new("TextButton")
toggleBtn.Text = "−"
toggleBtn.Size = UDim2.new(0, 32, 0, 32)
toggleBtn.Position = UDim2.new(1, -40, 0, 4)
toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 40, 90)
toggleBtn.BackgroundTransparency = 0.2
toggleBtn.TextColor3 = Color3.fromRGB(240, 220, 255)
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 22
toggleBtn.BorderSizePixel = 1
toggleBtn.BorderColor3 = Color3.fromRGB(140, 100, 220)
toggleBtn.Name = "ToggleButton"
toggleBtn.Parent = titleBar

toggleBtn.MouseEnter:Connect(function()
    toggleBtn.BackgroundColor3 = Color3.fromRGB(80, 60, 120)
end)

toggleBtn.MouseLeave:Connect(function()
    toggleBtn.BackgroundColor3 = Color3.fromRGB(60, 40, 90)
end)

local separator = Instance.new("Frame")
separator.Size = UDim2.new(1, -20, 0, 1)
separator.Position = UDim2.new(0, 10, 0, 45)
separator.BackgroundColor3 = Color3.fromRGB(100, 60, 180)
separator.BorderSizePixel = 0
separator.Name = "Separator"
separator.Parent = mainFrame

local previewContainer = Instance.new("Frame")
previewContainer.Size = UDim2.new(0, 100, 0, 100)
previewContainer.Position = UDim2.new(0.5, -50, 0, 60)
previewContainer.BackgroundTransparency = 1
previewContainer.Name = "PreviewContainer"
previewContainer.Parent = mainFrame

local glowEffect = Instance.new("ImageLabel")
glowEffect.Size = UDim2.new(1.2, 0, 1.2, 0)
glowEffect.Position = UDim2.new(-0.1, 0, -0.1, 0)
glowEffect.BackgroundTransparency = 1
glowEffect.Image = "rbxassetid://8992230672"
glowEffect.ImageColor3 = Settings.Color
glowEffect.ImageTransparency = 0.8
glowEffect.ScaleType = Enum.ScaleType.Slice
glowEffect.SliceCenter = Rect.new(100, 100, 100, 100)
glowEffect.Name = "GlowEffect"
glowEffect.Parent = previewContainer

local colorPreview = Instance.new("Frame")
colorPreview.Size = UDim2.new(1, 0, 1, 0)
colorPreview.BackgroundColor3 = Settings.Color
colorPreview.BackgroundTransparency = Settings.Transparency
colorPreview.BorderSizePixel = 2
colorPreview.BorderColor3 = Color3.fromRGB(255, 255, 255)
colorPreview.Name = "ColorPreview"
colorPreview.Parent = previewContainer

local previewText = Instance.new("TextLabel")
previewText.Text = "PREVIEW"
previewText.Size = UDim2.new(1, 0, 1, 0)
previewText.BackgroundTransparency = 1
previewText.TextColor3 = Color3.fromRGB(255, 255, 255)
previewText.Font = Enum.Font.GothamMedium
previewText.TextSize = 14
previewText.TextStrokeTransparency = 0.5
previewText.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
previewText.Name = "PreviewText"
previewText.Parent = colorPreview

local hexContainer = Instance.new("Frame")
hexContainer.Size = UDim2.new(1, -40, 0, 25)
hexContainer.Position = UDim2.new(0, 20, 0, 170)
hexContainer.BackgroundColor3 = Color3.fromRGB(30, 25, 40)
hexContainer.BackgroundTransparency = 0.3
hexContainer.BorderSizePixel = 1
hexContainer.BorderColor3 = Color3.fromRGB(80, 60, 120)
hexContainer.Name = "HexContainer"
hexContainer.Parent = mainFrame

local hexIcon = Instance.new("TextLabel")
hexIcon.Text = "#"
hexIcon.Size = UDim2.new(0, 25, 1, 0)
hexIcon.Position = UDim2.new(0, 5, 0, 0)
hexIcon.BackgroundTransparency = 1
hexIcon.TextColor3 = Color3.fromRGB(180, 140, 255)
hexIcon.Font = Enum.Font.GothamBold
hexIcon.TextSize = 18
hexIcon.TextXAlignment = Enum.TextXAlignment.Left
hexIcon.Name = "HexIcon"
hexIcon.Parent = hexContainer

local hexLabel = Instance.new("TextLabel")
hexLabel.Text = string.format("%02X%02X%02X", 
    math.floor(Settings.Color.R * 255), 
    math.floor(Settings.Color.G * 255), 
    math.floor(Settings.Color.B * 255))
hexLabel.Size = UDim2.new(1, -30, 1, 0)
hexLabel.Position = UDim2.new(0, 30, 0, 0)
hexLabel.BackgroundTransparency = 1
hexLabel.TextColor3 = Color3.fromRGB(220, 200, 255)
hexLabel.Font = Enum.Font.GothamMedium
hexLabel.TextSize = 16
hexLabel.TextXAlignment = Enum.TextXAlignment.Left
hexLabel.Name = "HexLabel"
hexLabel.Parent = hexContainer

local settingsContainer = Instance.new("ScrollingFrame")
settingsContainer.Size = UDim2.new(1, -20, 0, 250)
settingsContainer.Position = UDim2.new(0, 10, 0, 205)
settingsContainer.BackgroundTransparency = 1
settingsContainer.BorderSizePixel = 0
settingsContainer.ScrollBarThickness = 4
settingsContainer.ScrollBarImageColor3 = Color3.fromRGB(120, 80, 200)
settingsContainer.CanvasSize = UDim2.new(0, 0, 0, 400)
settingsContainer.Name = "SettingsContainer"
settingsContainer.Parent = mainFrame

local function createToggleSetting(name, settingKey, yPos)
    local toggleFrame = Instance.new("Frame")
    toggleFrame.Size = UDim2.new(1, 0, 0, 40)
    toggleFrame.Position = UDim2.new(0, 0, 0, yPos)
    toggleFrame.BackgroundTransparency = 1
    toggleFrame.Parent = settingsContainer

    local toggleLabel = Instance.new("TextLabel")
    toggleLabel.Text = name
    toggleLabel.Size = UDim2.new(0.7, 0, 1, 0)
    toggleLabel.Position = UDim2.new(0, 0, 0, 0)
    toggleLabel.BackgroundTransparency = 1
    toggleLabel.TextColor3 = Color3.fromRGB(210, 190, 240)
    toggleLabel.Font = Enum.Font.GothamMedium
    toggleLabel.TextSize = 16
    toggleLabel.TextXAlignment = Enum.TextXAlignment.Left
    toggleLabel.Parent = toggleFrame

    local toggleButton = Instance.new("TextButton")
    toggleButton.Size = UDim2.new(0.25, 0, 0.6, 0)
    toggleButton.Position = UDim2.new(0.75, 0, 0.2, 0)
    
    local function updateButtonAppearance()
        local isEnabled = Settings[settingKey]
        if isEnabled then
            toggleButton.BackgroundColor3 = Color3.fromRGB(60, 180, 80)
            toggleButton.BorderColor3 = Color3.fromRGB(40, 150, 60)
            toggleButton.Text = "✅"
            toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        else
            toggleButton.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
            toggleButton.BorderColor3 = Color3.fromRGB(170, 40, 40)
            toggleButton.Text = "❌"
            toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        end
    end
    
    updateButtonAppearance()
    
    toggleButton.BackgroundTransparency = 0.1
    toggleButton.Font = Enum.Font.GothamBold
    toggleButton.TextSize = 18
    toggleButton.BorderSizePixel = 1
    toggleButton.Name = settingKey .. "Toggle"
    toggleButton.Parent = toggleFrame

    toggleButton.MouseButton1Click:Connect(function()
        Settings[settingKey] = not Settings[settingKey]
        updateButtonAppearance()
        updateAllChams()
        
        if settingKey == "Enabled" and isMinimized then
            minimizedTitle.Text = "CHAMS: " .. (Settings.Enabled and "✅" or "❌")
            minimizedTitle.TextColor3 = Settings.Enabled and Color3.fromRGB(80, 255, 80) or Color3.fromRGB(255, 80, 80)
        end
    end)
    
    toggleButton.MouseEnter:Connect(function()
        toggleButton.BackgroundTransparency = 0
        toggleButton.TextSize = 20
    end)
    
    toggleButton.MouseLeave:Connect(function()
        toggleButton.BackgroundTransparency = 0.1
        toggleButton.TextSize = 18
        updateButtonAppearance()
    end)

    return toggleFrame
end

local enabledToggle = createToggleSetting("Enabled", "Enabled", 0)

local wallsToggle = createToggleSetting("Through Walls", "ThroughWalls", 50)

local transparencyFrame = Instance.new("Frame")
transparencyFrame.Size = UDim2.new(1, 0, 0, 60)
transparencyFrame.Position = UDim2.new(0, 0, 0, 110)
transparencyFrame.BackgroundTransparency = 1
transparencyFrame.Parent = settingsContainer

local transparencyLabel = Instance.new("TextLabel")
transparencyLabel.Text = "Transparency: " .. math.floor(Settings.Transparency * 100) .. "%"
transparencyLabel.Size = UDim2.new(1, 0, 0, 25)
transparencyLabel.Position = UDim2.new(0, 0, 0, 0)
transparencyLabel.BackgroundTransparency = 1
transparencyLabel.TextColor3 = Color3.fromRGB(210, 190, 240)
transparencyLabel.Font = Enum.Font.GothamMedium
transparencyLabel.TextSize = 16
transparencyLabel.TextXAlignment = Enum.TextXAlignment.Left
transparencyLabel.Parent = transparencyFrame

local transparencySlider = Instance.new("Frame")
transparencySlider.Size = UDim2.new(1, 0, 0, 12)
transparencySlider.Position = UDim2.new(0, 0, 0, 35)
transparencySlider.BackgroundColor3 = Color3.fromRGB(40, 35, 55)
transparencySlider.BorderSizePixel = 0
transparencySlider.Parent = transparencyFrame

local sliderTrack = Instance.new("Frame")
sliderTrack.Size = UDim2.new(1, 0, 1, 0)
sliderTrack.BackgroundColor3 = Color3.fromRGB(60, 50, 80)
sliderTrack.BorderSizePixel = 0
sliderTrack.Parent = transparencySlider

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(Settings.Transparency, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(160, 100, 255)
sliderFill.BorderSizePixel = 0
sliderFill.Parent = sliderTrack

local sliderGradient = Instance.new("UIGradient")
sliderGradient.Color = ColorSequence.new({
    ColorSequenceKeypoint.new(0, Color3.fromRGB(140, 80, 240)),
    ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 120, 255))
})
sliderGradient.Parent = sliderFill

local sliderButton = Instance.new("TextButton")
sliderButton.Size = UDim2.new(0, 20, 0, 24)
sliderButton.Position = UDim2.new(Settings.Transparency, -10, 0, -6)
sliderButton.BackgroundColor3 = Color3.fromRGB(240, 220, 255)
sliderButton.Text = ""
sliderButton.BorderSizePixel = 1
sliderButton.BorderColor3 = Color3.fromRGB(180, 140, 255)
sliderButton.Parent = transparencySlider

local function updateTransparency(value)
    Settings.Transparency = math.clamp(value, 0, 1)
    sliderFill.Size = UDim2.new(Settings.Transparency, 0, 1, 0)
    sliderButton.Position = UDim2.new(Settings.Transparency, -10, 0, -6)
    transparencyLabel.Text = "Transparency: " .. math.floor(Settings.Transparency * 100) .. "%"
    colorPreview.BackgroundTransparency = Settings.Transparency
    updateAllChams()
end

sliderButton.MouseButton1Down:Connect(function()
    local connection
    connection = UserInputService.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            local xPos = input.Position.X - transparencySlider.AbsolutePosition.X
            local percentage = xPos / transparencySlider.AbsoluteSize.X
            updateTransparency(percentage)
        end
    end)
    
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            connection:Disconnect()
        end
    end)
end)

transparencySlider.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        local xPos = input.Position.X - transparencySlider.AbsolutePosition.X
        local percentage = xPos / transparencySlider.AbsoluteSize.X
        updateTransparency(percentage)
    end
end)

local rgbTitle = Instance.new("TextLabel")
rgbTitle.Text = "Color"
rgbTitle.Size = UDim2.new(1, 0, 0, 30)
rgbTitle.Position = UDim2.new(0, 0, 0, 190)
rgbTitle.BackgroundTransparency = 1
rgbTitle.TextColor3 = Color3.fromRGB(220, 180, 255)
rgbTitle.Font = Enum.Font.GothamBold
rgbTitle.TextSize = 18
rgbTitle.TextXAlignment = Enum.TextXAlignment.Center
rgbTitle.Parent = settingsContainer

local rgbValues = Instance.new("TextLabel")
rgbValues.Text = string.format("R: %3d   G: %3d   B: %3d", 
    math.floor(Settings.Color.R * 255),
    math.floor(Settings.Color.G * 255),
    math.floor(Settings.Color.B * 255))
rgbValues.Size = UDim2.new(1, 0, 0, 25)
rgbValues.Position = UDim2.new(0, 0, 0, 220)
rgbValues.BackgroundTransparency = 1
rgbValues.TextColor3 = Color3.fromRGB(240, 220, 255)
rgbValues.Font = Enum.Font.GothamMedium
rgbValues.TextSize = 16
rgbValues.TextXAlignment = Enum.TextXAlignment.Center
rgbValues.Parent = settingsContainer

local function createHoldButton(button, callback)
    local holding = false
    local repeatCount = 0
    
    button.MouseButton1Down:Connect(function()
        holding = true
        repeatCount = 0
        callback()
        
        wait(0.5)
        
        while holding do
            repeatCount = repeatCount + 1
            local speed = math.min(0.05, 0.3 / (repeatCount * 0.5))
            callback()
            wait(speed)
        end
    end)
    
    button.MouseButton1Up:Connect(function()
        holding = false
    end)
    
    button.MouseLeave:Connect(function()
        holding = false
    end)
end

local function createRGBControl(name, color, index, xPos, yPos)
    local controlFrame = Instance.new("Frame")
    controlFrame.Size = UDim2.new(0.3, 0, 0, 70)
    controlFrame.Position = UDim2.new(xPos, 0, 0, yPos)
    controlFrame.BackgroundColor3 = Color3.fromRGB(35, 30, 45)
    controlFrame.BackgroundTransparency = 0.2
    controlFrame.BorderSizePixel = 1
    controlFrame.BorderColor3 = Color3.fromRGB(70, 60, 90)
    controlFrame.Parent = settingsContainer

    local colorLabel = Instance.new("TextLabel")
    colorLabel.Text = name
    colorLabel.Size = UDim2.new(1, 0, 0.4, 0)
    colorLabel.Position = UDim2.new(0, 0, 0, 0)
    colorLabel.BackgroundTransparency = 1
    colorLabel.TextColor3 = color
    colorLabel.Font = Enum.Font.GothamBold
    colorLabel.TextSize = 20
    colorLabel.TextXAlignment = Enum.TextXAlignment.Center
    colorLabel.Parent = controlFrame

    local buttonFrame = Instance.new("Frame")
    buttonFrame.Size = UDim2.new(1, -10, 0.6, 0)
    buttonFrame.Position = UDim2.new(0, 5, 0.4, 0)
    buttonFrame.BackgroundTransparency = 1
    buttonFrame.Parent = controlFrame

    local minusBtn = Instance.new("TextButton")
    minusBtn.Text = "◀"
    minusBtn.Size = UDim2.new(0.45, 0, 1, 0)
    minusBtn.Position = UDim2.new(0, 0, 0, 0)
    minusBtn.BackgroundColor3 = Color3.fromRGB(60, 50, 80)
    minusBtn.BackgroundTransparency = 0.1
    minusBtn.TextColor3 = Color3.fromRGB(255, 220, 220)
    minusBtn.Font = Enum.Font.GothamBold
    minusBtn.TextSize = 18
    minusBtn.BorderSizePixel = 1
    minusBtn.BorderColor3 = Color3.fromRGB(100, 80, 120)
    minusBtn.Parent = buttonFrame

    local plusBtn = Instance.new("TextButton")
    plusBtn.Text = "▶"
    plusBtn.Size = UDim2.new(0.45, 0, 1, 0)
    plusBtn.Position = UDim2.new(0.55, 0, 0, 0)
    plusBtn.BackgroundColor3 = Color3.fromRGB(60, 50, 80)
    plusBtn.BackgroundTransparency = 0.1
    plusBtn.TextColor3 = Color3.fromRGB(220, 255, 220)
    plusBtn.Font = Enum.Font.GothamBold
    plusBtn.TextSize = 18
    plusBtn.BorderSizePixel = 1
    plusBtn.BorderColor3 = Color3.fromRGB(100, 80, 120)
    plusBtn.Parent = buttonFrame

    local function updateColor(change)
        local r, g, b = Settings.Color.R, Settings.Color.G, Settings.Color.B
        local newValue
        
        if index == 1 then 
            newValue = math.clamp(r + change, 0, 1)
            r = newValue
        elseif index == 2 then 
            newValue = math.clamp(g + change, 0, 1)
            g = newValue
        else 
            newValue = math.clamp(b + change, 0, 1)
            b = newValue
        end
        
        Settings.Color = Color3.new(r, g, b)
        
        colorPreview.BackgroundColor3 = Settings.Color
        glowEffect.ImageColor3 = Settings.Color
        hexLabel.Text = string.format("%02X%02X%02X", 
            math.floor(r * 255), 
            math.floor(g * 255), 
            math.floor(b * 255))
        rgbValues.Text = string.format("R: %3d   G: %3d   B: %3d", 
            math.floor(r * 255),
            math.floor(g * 255),
            math.floor(b * 255))
        
        updateAllChams()
    end

    createHoldButton(minusBtn, function() updateColor(-0.01) end)
    createHoldButton(plusBtn, function() updateColor(0.01) end)

    return controlFrame
end

createRGBControl("R", Color3.fromRGB(255, 100, 100), 1, 0.02, 260)
createRGBControl("G", Color3.fromRGB(100, 255, 100), 2, 0.35, 260)
createRGBControl("B", Color3.fromRGB(100, 100, 255), 3, 0.68, 260)

local authorFrameExpanded = Instance.new("Frame")
authorFrameExpanded.Size = UDim2.new(1, -20, 0, 30)
authorFrameExpanded.Position = UDim2.new(0, 10, 1, -35)
authorFrameExpanded.BackgroundTransparency = 1
authorFrameExpanded.Name = "AuthorExpanded"
authorFrameExpanded.Parent = mainFrame

local authorTextExpanded = Instance.new("TextLabel")
authorTextExpanded.Text = "私の夢永遠の眠り"
authorTextExpanded.Size = UDim2.new(1, 0, 1, 0)
authorTextExpanded.BackgroundTransparency = 1
authorTextExpanded.TextColor3 = Color3.fromRGB(180, 160, 220)
authorTextExpanded.Font = Enum.Font.SourceSans
authorTextExpanded.TextSize = 14
authorTextExpanded.TextXAlignment = Enum.TextXAlignment.Center
authorTextExpanded.TextYAlignment = Enum.TextYAlignment.Center
authorTextExpanded.TextStrokeTransparency = 0.7
authorTextExpanded.TextStrokeColor3 = Color3.fromRGB(80, 60, 120)
authorTextExpanded.Parent = authorFrameExpanded

local minimizedTitle = Instance.new("TextLabel")
minimizedTitle.Text = "CHAMS: " .. (Settings.Enabled and "✅" or "❌")
minimizedTitle.Size = UDim2.new(0.6, 0, 1, 0)
minimizedTitle.Position = UDim2.new(0, 10, 0, 0)
minimizedTitle.BackgroundTransparency = 1
minimizedTitle.TextColor3 = Settings.Enabled and Color3.fromRGB(80, 255, 80) or Color3.fromRGB(255, 80, 80)
minimizedTitle.Font = Enum.Font.GothamBold
minimizedTitle.TextSize = 16
minimizedTitle.TextXAlignment = Enum.TextXAlignment.Left
minimizedTitle.Visible = false
minimizedTitle.Name = "MinimizedTitle"
minimizedTitle.Parent = titleBar

local authorFrameMinimized = Instance.new("TextLabel")
authorFrameMinimized.Text = "私の夢"
authorFrameMinimized.Size = UDim2.new(0.3, 0, 1, 0)
authorFrameMinimized.Position = UDim2.new(0.65, 0, 0, 0)
authorFrameMinimized.BackgroundTransparency = 1
authorFrameMinimized.TextColor3 = Color3.fromRGB(180, 160, 220)
authorFrameMinimized.Font = Enum.Font.SourceSans
authorFrameMinimized.TextSize = 12
authorFrameMinimized.TextXAlignment = Enum.TextXAlignment.Right
authorFrameMinimized.TextYAlignment = Enum.TextYAlignment.Center
authorFrameMinimized.Visible = false
authorFrameMinimized.Name = "AuthorMinimized"
authorFrameMinimized.Parent = titleBar

settingsContainer.CanvasSize = UDim2.new(0, 0, 0, 340)

local isMinimized = false
local minimizedSize = UDim2.new(0, 200, 0, 40)
local originalSize = mainFrame.Size

local function updateMinimizedStatus()
    if isMinimized then
        minimizedTitle.Text = "CHAMS: " .. (Settings.Enabled and "✅" or "❌")
        minimizedTitle.TextColor3 = Settings.Enabled and Color3.fromRGB(80, 255, 80) or Color3.fromRGB(255, 80, 80)
    end
end

local function toggleMinimize()
    isMinimized = not isMinimized
    
    if isMinimized then
        mainFrame.Size = minimizedSize
        toggleBtn.Text = "+"
        
        updateMinimizedStatus()
        
        minimizedTitle.Visible = true
        authorFrameMinimized.Visible = true
        
        titleText.Visible = false
        authorFrameExpanded.Visible = false
        separator.Visible = false
        previewContainer.Visible = false
        hexContainer.Visible = false
        settingsContainer.Visible = false
    else
        mainFrame.Size = originalSize
        toggleBtn.Text = "−"
        
        minimizedTitle.Visible = false
        authorFrameMinimized.Visible = false
        
        titleText.Visible = true
        authorFrameExpanded.Visible = true
        separator.Visible = true
        previewContainer.Visible = true
        hexContainer.Visible = true
        settingsContainer.Visible = true
    end
end

toggleBtn.MouseButton1Click:Connect(toggleMinimize)

print("私の夢永遠の眠り")

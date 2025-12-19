-- Full Script: Draggable GUI + Minimize + Custom Stretch Res + Info Text

local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TopBar = Instance.new("Frame")
local Title = Instance.new("TextLabel")
local CloseButton = Instance.new("TextButton")
local MinimizeButton = Instance.new("TextButton")

ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- Main Frame
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.Position = UDim2.new(0.5, -150, 0.5, -140)
MainFrame.Size = UDim2.new(0, 300, 0, 310)  -- Dinaikin lagi biar muat text info
MainFrame.AnchorPoint = Vector2.new(0.5, 0.5)
MainFrame.ClipsDescendants = true

local Corner = Instance.new("UICorner")
Corner.CornerRadius = UDim.new(0, 8)
Corner.Parent = MainFrame

-- Top Bar
TopBar.Parent = MainFrame
TopBar.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
TopBar.Size = UDim2.new(1, 0, 0, 30)

local TopCorner = Instance.new("UICorner")
TopCorner.CornerRadius = UDim.new(0, 8)
TopCorner.Parent = TopBar

-- Title
Title.Parent = TopBar
Title.BackgroundTransparency = 1
Title.Position = UDim2.new(0, 10, 0, 0)
Title.Size = UDim2.new(1, -90, 1, 0)
Title.Font = Enum.Font.Gotham
Title.Text = "PIXELWAR HUB"
Title.TextColor3 = Color3.new(1,1,1)
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Minimize Button
MinimizeButton.Parent = TopBar
MinimizeButton.BackgroundColor3 = Color3.fromRGB(128, 128, 128)
MinimizeButton.Position = UDim2.new(1, -60, 0, 2)
MinimizeButton.Size = UDim2.new(0, 26, 0, 26)
MinimizeButton.Text = "-"
MinimizeButton.TextColor3 = Color3.new(1,1,1)
MinimizeButton.TextSize = 20
MinimizeButton.Font = Enum.Font.GothamBold
MinimizeButton.BackgroundTransparency = 1

local MinCorner = Instance.new("UICorner")
MinCorner.CornerRadius = UDim.new(0, 6)
MinCorner.Parent = MinimizeButton

-- Close Button
CloseButton.Parent = TopBar
CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseButton.Position = UDim2.new(1, -30, 0, 2)
CloseButton.Size = UDim2.new(0, 26, 0, 26)
CloseButton.Text = "X"
CloseButton.TextColor3 = Color3.new(255, 0, 0)
CloseButton.TextSize = 16
CloseButton.Font = Enum.Font.GothamBold
CloseButton.BackgroundTransparency = 1

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 6)
CloseCorner.Parent = CloseButton

-- === DRAG LOGIC ===
local dragging = false
local dragStart = nil
local startPos = nil

local function updatePosition(input)
    if not dragging then return end
    local delta = input.Position - dragStart
    MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        updatePosition(input)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

-- === MINIMIZE LOGIC ===
local minimized = false
local normalSize = MainFrame.Size
local normalTitleText = Title.Text

MinimizeButton.MouseButton1Click:Connect(function()
    minimized = not minimized
    if minimized then
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Size = UDim2.new(0, 300, 0, 30)}):Play()
        Title.Text = "PIXELWAR HUB (minimized)"
        MinimizeButton.Text = "+"
    else
        TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quint), {Size = normalSize}):Play()
        Title.Text = normalTitleText
        MinimizeButton.Text = "–"
    end
end)

-- === CUSTOM STRETCH RESOLUTION ===
local stretched = false
local stretchConnection = nil
local stretchAmount = 0.8

-- Toggle Button
local StretchButton = Instance.new("TextButton")
StretchButton.Parent = MainFrame
StretchButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
StretchButton.Position = UDim2.new(0, 10, 0, 40)
StretchButton.Size = UDim2.new(1, -20, 0, 45)
StretchButton.Text = "Stretched Res: OFF"
StretchButton.TextColor3 = Color3.new(1,1,1)
StretchButton.TextSize = 16
StretchButton.Font = Enum.Font.GothamBold

local StretchCorner = Instance.new("UICorner")
StretchCorner.CornerRadius = UDim.new(0, 6)
StretchCorner.Parent = StretchButton

-- TextBox Custom Amount
local StretchTextBox = Instance.new("TextBox")
StretchTextBox.Parent = MainFrame
StretchTextBox.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
StretchTextBox.Position = UDim2.new(0, 15, 0, 95)
StretchTextBox.Size = UDim2.new(1, -30, 0, 35)
StretchTextBox.Text = "0.8"
StretchTextBox.TextColor3 = Color3.new(1,1,1)
StretchTextBox.PlaceholderText = "Enter stretch (0.1-1.0)"
StretchTextBox.TextSize = 16
StretchTextBox.Font = Enum.Font.Gotham
StretchTextBox.TextXAlignment = Enum.TextXAlignment.Center

local TextBoxCorner = Instance.new("UICorner")
TextBoxCorner.CornerRadius = UDim.new(0, 6)
TextBoxCorner.Parent = StretchTextBox


local InfoLabel = Instance.new("TextLabel")
InfoLabel.Parent = MainFrame
InfoLabel.BackgroundTransparency = 1
InfoLabel.Position = UDim2.new(0, 0, 0, 140)
InfoLabel.Size = UDim2.new(1, 0, 0, 30)
InfoLabel.Font = Enum.Font.Gotham
InfoLabel.Text = "0.8 is recommended"
InfoLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
InfoLabel.TextSize = 14
InfoLabel.TextXAlignment = Enum.TextXAlignment.Center

-- Validasi TextBox
StretchTextBox.FocusLost:Connect(function(enterPressed)
    local num = tonumber(StretchTextBox.Text)
    if num and num >= 0.1 and num <= 1.0 then
        stretchAmount = num
        StretchButton.Text = stretched and ("Stretched Res: ON (" .. stretchAmount .. ")") or "Stretched Res: OFF"
    else
        StretchTextBox.Text = tostring(stretchAmount)
    end
end)

-- Toggle Logic
StretchButton.MouseButton1Click:Connect(function()
    stretched = not stretched
    if stretched then
        StretchButton.Text = "Stretched Res: ON (" .. stretchAmount .. ")"
        StretchButton.BackgroundColor3 = Color3.fromRGB(50, 150, 50)
        
        stretchConnection = RunService.RenderStepped:Connect(function()
            local cam = workspace.CurrentCamera
            if cam then
                cam.CFrame = cam.CFrame * CFrame.new(0, 0, 0, 1, 0, 0, 0, stretchAmount, 0, 0, 0, 1)
            end
        end)
    else
        StretchButton.Text = "Stretched Res: OFF"
        StretchButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        
        if stretchConnection then
            stretchConnection:Disconnect()
            stretchConnection = nil
        end
    end
end)

-- === CLOSE ===
CloseButton.MouseButton1Click:Connect(function()
    if stretchConnection then
        stretchConnection:Disconnect()
    end
    ScreenGui:Destroy()
end)


local InfoLabel = Instance.new("TextLabel")
InfoLabel.Parent = MainFrame
InfoLabel.BackgroundTransparency = 1
InfoLabel.Position = UDim2.new(0, 0, 0, 160)
InfoLabel.Size = UDim2.new(1, 0, 0, 30)
InfoLabel.Font = Enum.Font.Gotham
InfoLabel.Text = "with this script you can make your"
InfoLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
InfoLabel.TextSize = 14
InfoLabel.TextXAlignment = Enum.TextXAlignment.Center


local InfoLabel = Instance.new("TextLabel")
InfoLabel.Parent = MainFrame
InfoLabel.BackgroundTransparency = 1
InfoLabel.Position = UDim2.new(0, 0, 0, 180)
InfoLabel.Size = UDim2.new(1, 0, 0, 30)
InfoLabel.Font = Enum.Font.Gotham
InfoLabel.Text = "resolution STRETCHED"
InfoLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
InfoLabel.TextSize = 14
InfoLabel.TextXAlignment = Enum.TextXAlignment.Center


local InfoLabel = Instance.new("TextLabel")
InfoLabel.Parent = MainFrame
InfoLabel.BackgroundTransparency = 1
InfoLabel.Position = UDim2.new(0, 0, 0, 200)
InfoLabel.Size = UDim2.new(1, 0, 0, 30)
InfoLabel.Font = Enum.Font.Gotham
InfoLabel.Text = "open source script so dont worry"
InfoLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
InfoLabel.TextSize = 14
InfoLabel.TextXAlignment = Enum.TextXAlignment.Center


local InfoLabel = Instance.new("TextLabel")
InfoLabel.Parent = MainFrame
InfoLabel.BackgroundTransparency = 1
InfoLabel.Position = UDim2.new(0, 0, 0, 220)
InfoLabel.Size = UDim2.new(1, 0, 0, 30)
InfoLabel.Font = Enum.Font.Gotham
InfoLabel.Text = "about your robux being grabbed"
InfoLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
InfoLabel.TextSize = 14
InfoLabel.TextXAlignment = Enum.TextXAlignment.Center

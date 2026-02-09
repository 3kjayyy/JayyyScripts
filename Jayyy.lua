local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [[ CONFIGURATION ]]
local espEnabled = false
local aimbotEnabled = false
local fovRadius = 50 
local maxFOV = 350

-- [[ DRAWING FOV ]]
local fov_circle = Drawing.new("Circle")
fov_circle.Thickness = 1
fov_circle.Radius = fovRadius
fov_circle.Color = Color3.fromRGB(255, 255, 255)
fov_circle.Visible = false

-- [[ UI SETUP ]]
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "Jayyy_Final_v13"

-- Dragging Logic
local function makeMovable(obj)
    local dragging, dragStart, startPos
    obj.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = obj.Position
        end
    end)
    obj.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            obj.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
end

-- Main Frame (Black & White Graffiti Design)
local Main = Instance.new("ImageLabel", ScreenGui)
Main.Size = UDim2.new(0, 240, 0, 260)
Main.Position = UDim2.new(0.5, -120, 0.5, -130)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 0
Main.Image = "rbxassetid://10850255319" -- Corrected Graffiti Pattern ID
Main.ScaleType = Enum.ScaleType.Crop
Main.ImageColor3 = Color3.fromRGB(130, 130, 130) -- Matches your grey/dark look
local MainCorner = Instance.new("UICorner", Main)
MainCorner.CornerRadius = UDim.new(0, 10)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Color3.fromRGB(80, 150, 255)
MainStroke.Thickness = 1.5
MainStroke.Transparency = 0.4
makeMovable(Main)

-- Scroll Area (Top)
local SliderBack = Instance.new("Frame", Main)
SliderBack.Size = UDim2.new(1, -30, 0, 45); SliderBack.Position = UDim2.new(0, 15, 0, 15)
SliderBack.BackgroundColor3 = Color3.fromRGB(0, 0, 0); SliderBack.BackgroundTransparency = 0.7; Instance.new("UICorner", SliderBack)

local SliderText = Instance.new("TextLabel", SliderBack)
SliderText.Size = UDim2.new(1, 0, 1, 0); SliderText.Text = "SCROLL TO RESIZE\nFOV: 50"; SliderText.TextColor3 = Color3.new(1,1,1)
SliderText.BackgroundTransparency = 1; SliderText.Font = Enum.Font.Code; SliderText.TextSize = 13

-- ESP Button (Grey - Middle)
local eBtn = Instance.new("TextButton", Main)
eBtn.Size = UDim2.new(1, -30, 0, 40)
eBtn.Position = UDim2.new(0, 15, 0, 75)
eBtn.Text = "ESP: OFF [K]"
eBtn.BackgroundColor3 = Color3.fromRGB(120, 120, 120) -- Matched Grey
eBtn.TextColor3 = Color3.new(1,1,1)
eBtn.Font = Enum.Font.Code; eBtn.TextSize = 15
Instance.new("UICorner", eBtn)

-- AIM Button (Blue - Bottom)
local aBtn = Instance.new("TextButton", Main)
aBtn.Size = UDim2.new(1, -30, 0, 40)
aBtn.Position = UDim2.new(0, 15, 0, 130)
aBtn.Text = "AIM: OFF [L]"
aBtn.BackgroundColor3 = Color3.fromRGB(0, 135, 230) -- Matched Blue
aBtn.TextColor3 = Color3.new(1,1,1)
aBtn.Font = Enum.Font.Code; aBtn.TextSize = 15
Instance.new("UICorner", aBtn)

-- Credit (Centered at the Bottom)
local Credits = Instance.new("TextLabel", Main)
Credits.Size = UDim2.new(1, 0, 0, 30)
Credits.Position = UDim2.new(0, 0, 1, -35)
Credits.Text = "Jayyy Luvs You"
Credits.TextColor3 = Color3.fromRGB(255, 255, 255)
Credits.BackgroundTransparency = 1; Credits.Font = Enum.Font.Code; Credits.TextSize = 16

-- [[ FUNCTIONALITY ]]
local function toggleK()
    espEnabled = not espEnabled
    eBtn.Text = "ESP: " .. (espEnabled and "ON [K]" or "OFF [K]")
    eBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(180, 50, 50) or Color3.fromRGB(120, 120, 120)
end

local function toggleL()
    aimbotEnabled = not aimbotEnabled
    aBtn.Text = "AIM: " .. (aimbotEnabled and "ON [L]" or "OFF [L]")
    aBtn.BackgroundColor3 = aimbotEnabled and Color3.fromRGB(0, 100, 200) or Color3.fromRGB(0, 135, 230)
end

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.K then toggleK() end
    if input.KeyCode == Enum.KeyCode.L then toggleL() end
end)

Main.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseWheel then
        fovRadius = math.clamp(fovRadius + (input.Position.Z * 7), 10, maxFOV)
        SliderText.Text = "SCROLL TO RESIZE\nFOV: " .. fovRadius
    end
end)

eBtn.MouseButton1Click:Connect(toggleK)
aBtn.MouseButton1Click:Connect(toggleL)

-- Render Loop for FOV Circle
RunService.RenderStepped:Connect(function()
    fov_circle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    fov_circle.Visible = aimbotEnabled
    fov_circle.Radius = fovRadius
end)

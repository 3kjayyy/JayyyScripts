local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [[ CONFIGURATION ]]
local espEnabled = false
local aimbotEnabled = false
local fovRadius = 75 
local maxFOV = 400

-- [[ DRAWING FOV ]]
local fov_circle = Drawing.new("Circle")
fov_circle.Thickness = 1.5
fov_circle.Radius = fovRadius
fov_circle.Color = Color3.fromRGB(0, 200, 255)
fov_circle.Visible = false

-- [[ UI SETUP ]]
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "Jayyy_Y2K_Chrome"

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

-- Main Frame (Y2K Chrome Design)
local Main = Instance.new("ImageLabel", ScreenGui)
Main.Size = UDim2.new(0, 320, 0, 350) -- Made the script bigger
Main.Position = UDim2.new(0.5, -160, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.BorderSizePixel = 0
Main.Image = "rbxassetid://13580435850" -- Custom Chrome/Y2K Pattern ID
Main.ScaleType = Enum.ScaleType.Crop
local MainCorner = Instance.new("UICorner", Main)
MainCorner.CornerRadius = UDim.new(0, 20)
local MainStroke = Instance.new("UIStroke", Main)
MainStroke.Color = Color3.fromRGB(0, 255, 255)
MainStroke.Thickness = 2
makeMovable(Main)

-- Content Holder (Centers everything inside)
local Holder = Instance.new("Frame", Main)
Holder.Size = UDim2.new(1, 0, 1, 0)
Holder.BackgroundTransparency = 1

local Layout = Instance.new("UIListLayout", Holder)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.VerticalAlignment = Enum.VerticalAlignment.Center
Layout.Padding = UDim.new(0, 15)

-- Header
local Title = Instance.new("TextLabel", Holder)
Title.Size = UDim2.new(0, 200, 0, 40)
Title.Text = "JAYYY ON TOP"
Title.TextColor3 = Color3.fromRGB(200, 100, 255) -- Y2K Purple/Pink
Title.Font = Enum.Font.GothamBold
Title.TextSize = 22
Title.BackgroundTransparency = 1

-- ESP Button
local eBtn = Instance.new("TextButton", Holder)
eBtn.Size = UDim2.new(0, 220, 0, 45)
eBtn.Text = "ESP: OFF [K]"
eBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
eBtn.TextColor3 = Color3.new(1,1,1)
eBtn.Font = Enum.Font.Code
eBtn.TextSize = 16
Instance.new("UICorner", eBtn)
local eStroke = Instance.new("UIStroke", eBtn)
eStroke.Color = Color3.fromRGB(255, 50, 50)

-- AIM Button
local aBtn = Instance.new("TextButton", Holder)
aBtn.Size = UDim2.new(0, 220, 0, 45)
aBtn.Text = "AIM: OFF [L]"
aBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
aBtn.TextColor3 = Color3.new(1,1,1)
aBtn.Font = Enum.Font.Code
aBtn.TextSize = 16
Instance.new("UICorner", aBtn)
local aStroke = Instance.new("UIStroke", aBtn)
aStroke.Color = Color3.fromRGB(0, 255, 255)

-- Scroll Info
local SliderText = Instance.new("TextLabel", Holder)
SliderText.Size = UDim2.new(0, 250, 0, 40)
SliderText.Text = "SCROLL TO RESIZE FOV: " .. fovRadius
SliderText.TextColor3 = Color3.new(1,1,1)
SliderText.BackgroundTransparency = 1
SliderText.Font = Enum.Font.Code
SliderText.TextSize = 14

-- Footer
local Credits = Instance.new("TextLabel", Holder)
Credits.Size = UDim2.new(0, 200, 0, 30)
Credits.Text = "Jayyy Luvs You"
Credits.TextColor3 = Color3.fromRGB(255, 255, 255)
Credits.BackgroundTransparency = 1
Credits.Font = Enum.Font.Code
Credits.TextSize = 16

-- [[ LOGIC ]]
local function toggleK()
    espEnabled = not espEnabled
    eBtn.Text = "ESP: " .. (espEnabled and "ON [K]" or "OFF [K]")
    eBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(100, 20, 20) or Color3.fromRGB(50, 50, 50)
end

local function toggleL()
    aimbotEnabled = not aimbotEnabled
    aBtn.Text = "AIM: " .. (aimbotEnabled and "ON [L]" or "OFF [L]")
    aBtn.BackgroundColor3 = aimbotEnabled and Color3.fromRGB(0, 80, 180) or Color3.fromRGB(0, 120, 215)
end

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.K then toggleK() end
    if input.KeyCode == Enum.KeyCode.L then toggleL() end
end)

Main.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseWheel then
        fovRadius = math.clamp(fovRadius + (input.Position.Z * 10), 10, maxFOV)
        SliderText.Text = "SCROLL TO RESIZE FOV: " .. fovRadius
    end
end)

eBtn.MouseButton1Click:Connect(toggleK)
aBtn.MouseButton1Click:Connect(toggleL)

RunService.RenderStepped:Connect(function()
    fov_circle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    fov_circle.Visible = aimbotEnabled
    fov_circle.Radius = fovRadius
end)

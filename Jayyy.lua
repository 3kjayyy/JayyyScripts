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
fov_circle.Color = Color3.fromRGB(0, 255, 255)
fov_circle.Visible = false

-- [[ UI SETUP ]]
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "Jayyy_Landscape_v15"

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

-- Main Frame (Landscape Size)
local Main = Instance.new("ImageLabel", ScreenGui)
Main.Size = UDim2.new(0, 450, 0, 300) -- Landscape Ratio
Main.Position = UDim2.new(0.5, -225, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.BorderSizePixel = 0
Main.Image = "rbxassetid://13580435850" -- Y2K Background
Main.ScaleType = Enum.ScaleType.Crop
local MainCorner = Instance.new("UICorner", Main); MainCorner.CornerRadius = UDim.new(0, 15)
local MainStroke = Instance.new("UIStroke", Main); MainStroke.Color = Color3.fromRGB(0, 255, 255); MainStroke.Thickness = 2
makeMovable(Main)

-- Top Tab Bar (Table Style)
local TabBar = Instance.new("Frame", Main)
TabBar.Size = UDim2.new(1, 0, 0, 45)
TabBar.BackgroundTransparency = 0.5
TabBar.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
local TabCorner = Instance.new("UICorner", TabBar); TabCorner.CornerRadius = UDim.new(0, 15)

local MainTabBtn = Instance.new("TextLabel", TabBar)
MainTabBtn.Size = UDim2.new(0, 150, 1, 0)
MainTabBtn.Position = UDim2.new(0, 15, 0, 0)
MainTabBtn.Text = "MAIN CHEAT"
MainTabBtn.TextColor3 = Color3.fromRGB(0, 255, 255)
MainTabBtn.Font = Enum.Font.GothamBold
MainTabBtn.TextSize = 18
MainTabBtn.BackgroundTransparency = 1

-- Content Container (Centered)
local Container = Instance.new("Frame", Main)
Container.Size = UDim2.new(1, -40, 1, -70)
Container.Position = UDim2.new(0, 20, 0, 60)
Container.BackgroundTransparency = 1

local Layout = Instance.new("UIListLayout", Container)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
Layout.VerticalAlignment = Enum.VerticalAlignment.Center
Layout.Padding = UDim.new(0, 12)

-- ESP Toggle
local eBtn = Instance.new("TextButton", Container)
eBtn.Size = UDim2.new(0, 300, 0, 45)
eBtn.Text = "ESP: OFF [K]"
eBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
eBtn.TextColor3 = Color3.new(1,1,1)
eBtn.Font = Enum.Font.Code; eBtn.TextSize = 16
Instance.new("UICorner", eBtn)
Instance.new("UIStroke", eBtn).Color = Color3.fromRGB(255, 255, 255)

-- AIM Toggle
local aBtn = Instance.new("TextButton", Container)
aBtn.Size = UDim2.new(0, 300, 0, 45)
aBtn.Text = "AIM: OFF [L]"
aBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
aBtn.TextColor3 = Color3.new(1,1,1)
aBtn.Font = Enum.Font.Code; aBtn.TextSize = 16
Instance.new("UICorner", aBtn)
Instance.new("UIStroke", aBtn).Color = Color3.fromRGB(0, 255, 255)

-- FOV Info
local SliderText = Instance.new("TextLabel", Container)
SliderText.Size = UDim2.new(0, 300, 0, 40)
SliderText.Text = "SCROLL OVER HERE: FOV [" .. fovRadius .. "]"
SliderText.TextColor3 = Color3.new(1,1,1)
SliderText.BackgroundTransparency = 1
SliderText.Font = Enum.Font.Code; SliderText.TextSize = 14

-- Footer Credit
local Credits = Instance.new("TextLabel", Main)
Credits.Size = UDim2.new(1, 0, 0, 30)
Credits.Position = UDim2.new(0, 0, 1, -30)
Credits.Text = "Developed by: Jayyy"
Credits.TextColor3 = Color3.fromRGB(200, 200, 200)
Credits.BackgroundTransparency = 1; Credits.Font = Enum.Font.Code; Credits.TextSize = 14

-- [[ LOGIC ]]
local function toggleK()
    espEnabled = not espEnabled
    eBtn.Text = "ESP: " .. (espEnabled and "ON [K]" or "OFF [K]")
    eBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(100, 20, 20) or Color3.fromRGB(40, 40, 40)
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
        SliderText.Text = "SCROLL OVER HERE: FOV [" .. fovRadius .. "]"
    end
end)

eBtn.MouseButton1Click:Connect(toggleK)
aBtn.MouseButton1Click:Connect(toggleL)

RunService.RenderStepped:Connect(function()
    fov_circle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    fov_circle.Visible = aimbotEnabled
    fov_circle.Radius = fovRadius
end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [[ CONFIGURATION ]]
local CorrectKey = "JAY-39MF-7XQ5-2LY8" --
local espEnabled, aimbotEnabled = false, false
local fovRadius = 75 
local maxFOV = 400

-- [[ DRAWING FOV CIRCLE ]]
local fov_circle = Drawing.new("Circle")
fov_circle.Thickness = 1
fov_circle.Radius = fovRadius
fov_circle.Color = Color3.fromRGB(0, 255, 255)
fov_circle.Visible = false
fov_circle.Filled = false

-- [[ UI ROOT ]]
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "Jayyy_Functional_v21"

-- [[ KEY SYSTEM ]]
local KeyFrame = Instance.new("Frame", ScreenGui)
KeyFrame.Size = UDim2.new(0, 300, 0, 150)
KeyFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
KeyFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UICorner", KeyFrame)
local KeyStroke = Instance.new("UIStroke", KeyFrame); KeyStroke.Color = Color3.fromRGB(0, 255, 255)

local KeyInput = Instance.new("TextBox", KeyFrame)
KeyInput.Size = UDim2.new(0, 240, 0, 35); KeyInput.Position = UDim2.new(0.5, -120, 0, 50)
KeyInput.PlaceholderText = "Enter Key..."; KeyInput.Text = ""
KeyInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30); KeyInput.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", KeyInput)

local KeyBtn = Instance.new("TextButton", KeyFrame)
KeyBtn.Size = UDim2.new(0, 100, 0, 30); KeyBtn.Position = UDim2.new(0.5, -50, 0, 100)
KeyBtn.Text = "CHECK"; KeyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215); KeyBtn.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", KeyBtn)

-- [[ MAIN MENU ]]
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 550, 0, 320) 
Main.Position = UDim2.new(0.5, -275, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.Visible = false
Instance.new("UICorner", Main)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(45, 45, 45)

-- Header
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, -20, 0, 40); Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "JAYYY---------------------------------------------MENU" 
Title.TextColor3 = Color3.new(1,1,1); Title.Font = Enum.Font.Code; Title.BackgroundTransparency = 1; Title.TextXAlignment = 0; Title.TextSize = 13

-- Sidebar (Clean/Empty)
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 150, 1, -50); Sidebar.Position = UDim2.new(0, 5, 0, 45)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UICorner", Sidebar)
local SidebarTitle = Instance.new("TextLabel", Sidebar)
SidebarTitle.Size = UDim2.new(1, 0, 0, 40); SidebarTitle.Text = "MAIN MENU"; SidebarTitle.TextColor3 = Color3.new(1,1,1)
SidebarTitle.Font = Enum.Font.GothamBold; SidebarTitle.TextSize = 12; SidebarTitle.BackgroundTransparency = 1

-- Center Display
local CenterContainer = Instance.new("Frame", Main)
CenterContainer.Size = UDim2.new(1, -170, 1, -60); CenterContainer.Position = UDim2.new(0, 160, 0, 50)
CenterContainer.BackgroundTransparency = 1
local Layout = Instance.new("UIListLayout", CenterContainer)
Layout.HorizontalAlignment = 1; Layout.VerticalAlignment = 1; Layout.Padding = UDim.new(0, 12)

-- Centered Toggles
local eBtn = Instance.new("TextButton", CenterContainer)
eBtn.Size = UDim2.new(0, 260, 0, 40); eBtn.Text = "ESP: OFF [K]"; eBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
eBtn.TextColor3 = Color3.new(1,1,1); eBtn.TextSize = 11; eBtn.Font = Enum.Font.Code 
Instance.new("UICorner", eBtn); Instance.new("UIStroke", eBtn).Color = Color3.fromRGB(80, 80, 80)

local aBtn = Instance.new("TextButton", CenterContainer)
aBtn.Size = UDim2.new(0, 260, 0, 40); aBtn.Text = "AIM: OFF [L]"; aBtn.BackgroundColor3 = Color3.fromRGB(0, 70, 140)
aBtn.TextColor3 = Color3.new(1,1,1); aBtn.TextSize = 11; aBtn.Font = Enum.Font.Code 
Instance.new("UICorner", aBtn); Instance.new("UIStroke", aBtn).Color = Color3.fromRGB(0, 200, 255)

local SliderText = Instance.new("TextLabel", CenterContainer)
SliderText.Size = UDim2.new(0, 260, 0, 35); SliderText.Text = "SCROLL TO ADJUST FOV: " .. fovRadius
SliderText.TextColor3 = Color3.new(1,1,1); SliderText.TextSize = 11; SliderText.BackgroundTransparency = 1; SliderText.Font = Enum.Font.Code

-- [[ LOGIC FUNCTIONS ]]
local function toggleK()
    espEnabled = not espEnabled
    eBtn.Text = "ESP: " .. (espEnabled and "ON [K]" or "OFF [K]")
    eBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(130, 0, 0) or Color3.fromRGB(35, 35, 35)
end

local function toggleL()
    aimbotEnabled = not aimbotEnabled
    aBtn.Text = "AIM: " .. (aimbotEnabled and "ON [L]" or "OFF [L]")
    aBtn.BackgroundColor3 = aimbotEnabled and Color3.fromRGB(0, 40, 90) or Color3.fromRGB(0, 70, 140)
    fov_circle.Visible = aimbotEnabled
end

-- Key Verification
KeyBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == CorrectKey then
        KeyFrame.Visible = false
        Main.Visible = true
    else
        KeyInput.PlaceholderText = "WRONG KEY"; KeyInput.Text = ""
    end
end)

-- Keybinds & Scrolling
UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe or not Main.Visible then return end
    if input.KeyCode == Enum.KeyCode.K then toggleK() end
    if input.KeyCode == Enum.KeyCode.L then toggleL() end
end)

Main.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseWheel then
        fovRadius = math.clamp(fovRadius + (input.Position.Z * 10), 10, maxFOV)
        SliderText.Text = "SCROLL TO ADJUST FOV: " .. fovRadius
        fov_circle.Radius = fovRadius
    end
end)

eBtn.MouseButton1Click:Connect(toggleK)
aBtn.MouseButton1Click:Connect(toggleL)

-- Render Loop for FOV Circle Position
RunService.RenderStepped:Connect(function()
    if aimbotEnabled then
        fov_circle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    end
end)

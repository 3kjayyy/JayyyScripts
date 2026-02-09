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

-- [[ FOV CIRCLE ]]
local fov_circle = Drawing.new("Circle")
fov_circle.Thickness = 1
fov_circle.Radius = fovRadius
fov_circle.Color = Color3.fromRGB(0, 255, 255)
fov_circle.Visible = false

-- [[ DRAGGING FUNCTION ]]
local function makeDraggable(frame)
    local dragging, dragInput, dragStart, startPos
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = frame.Position
            input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
        end
    end)
    frame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

-- [[ UI SETUP ]]
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))

-- Key System (Movable)
local KeyFrame = Instance.new("Frame", ScreenGui)
KeyFrame.Size = UDim2.new(0, 300, 0, 150); KeyFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
KeyFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Instance.new("UICorner", KeyFrame)
Instance.new("UIStroke", KeyFrame).Color = Color3.fromRGB(0, 255, 255)
makeDraggable(KeyFrame)

local KeyInput = Instance.new("TextBox", KeyFrame)
KeyInput.Size = UDim2.new(0, 240, 0, 35); KeyInput.Position = UDim2.new(0.5, -120, 0, 50)
KeyInput.PlaceholderText = "Enter Key..."; KeyInput.Text = ""; KeyInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
KeyInput.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", KeyInput)

local KeyBtn = Instance.new("TextButton", KeyFrame)
KeyBtn.Size = UDim2.new(0, 100, 0, 30); KeyBtn.Position = UDim2.new(0.5, -50, 0, 100)
KeyBtn.Text = "CHECK"; KeyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
KeyBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", KeyBtn)

-- Main Menu (Movable)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 550, 0, 320); Main.Position = UDim2.new(0.5, -275, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10); Main.Visible = false; Instance.new("UICorner", Main)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(45, 45, 45)
makeDraggable(Main)

-- Header
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, -20, 0, 40); Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "JAYYY---------------------------------------------MENU" 
Title.TextColor3 = Color3.new(1,1,1); Title.Font = Enum.Font.Code; Title.BackgroundTransparency = 1; Title.TextXAlignment = 0; Title.TextSize = 13

-- Sidebar
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 150, 1, -50); Sidebar.Position = UDim2.new(0, 5, 0, 45)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Instance.new("UICorner", Sidebar)
local SideTitle = Instance.new("TextLabel", Sidebar)
SideTitle.Size = UDim2.new(1, 0, 0, 40); SideTitle.Text = "MAIN MENU"; SideTitle.TextColor3 = Color3.new(1,1,1)
SideTitle.Font = Enum.Font.GothamBold; SideTitle.TextSize = 12; SideTitle.BackgroundTransparency = 1

-- Centered Toggles
local Center = Instance.new("Frame", Main)
Center.Size = UDim2.new(1, -170, 1, -60); Center.Position = UDim2.new(0, 160, 0, 50); Center.BackgroundTransparency = 1
local Layout = Instance.new("UIListLayout", Center); Layout.HorizontalAlignment = 1; Layout.VerticalAlignment = 1; Layout.Padding = UDim.new(0, 12)

local eBtn = Instance.new("TextButton", Center)
eBtn.Size = UDim2.new(0, 260, 0, 40); eBtn.Text = "ESP: OFF [K]"; eBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
eBtn.TextColor3 = Color3.new(1,1,1); eBtn.TextSize = 11; eBtn.Font = Enum.Font.Code; Instance.new("UICorner", eBtn)

local aBtn = Instance.new("TextButton", Center)
aBtn.Size = UDim2.new(0, 260, 0, 40); aBtn.Text = "AIM: OFF [L]"; aBtn.BackgroundColor3 = Color3.fromRGB(0, 70, 140)
aBtn.TextColor3 = Color3.new(1,1,1); aBtn.TextSize = 11; aBtn.Font = Enum.Font.Code; Instance.new("UICorner", aBtn)

local SliderText = Instance.new("TextLabel", Center)
SliderText.Size = UDim2.new(0, 260, 0, 35); SliderText.Text = "SCROLL TO ADJUST FOV: " .. fovRadius
SliderText.TextColor3 = Color3.new(1,1,1); SliderText.TextSize = 11; SliderText.BackgroundTransparency = 1; SliderText.Font = Enum.Font.Code

-- [[ LOGIC ]]
KeyBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == CorrectKey then KeyFrame.Visible = false; Main.Visible = true else KeyInput.Text = ""; KeyInput.PlaceholderText = "WRONG KEY" end
end)

local function toggleK() espEnabled = not espEnabled; eBtn.Text = "ESP: "..(espEnabled and "ON [K]" or "OFF [K]"); eBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(130,0,0) or Color3.fromRGB(35,35,35) end
local function toggleL() aimbotEnabled = not aimbotEnabled; aBtn.Text = "AIM: "..(aimbotEnabled and "ON [L]" or "OFF [L]"); aBtn.BackgroundColor3 = aimbotEnabled and Color3.fromRGB(0,40,90) or Color3.fromRGB(0,70,140); fov_circle.Visible = aimbotEnabled end

eBtn.MouseButton1Click:Connect(toggleK); aBtn.MouseButton1Click:Connect(toggleL)

UserInputService.InputBegan:Connect(function(i, g) if g or not Main.Visible then return end if i.KeyCode == Enum.KeyCode.K then toggleK() elseif i.KeyCode == Enum.KeyCode.L then toggleL() end end)
Main.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseWheel then fovRadius = math.clamp(fovRadius + (i.Position.Z * 10), 10, maxFOV); SliderText.Text = "SCROLL TO ADJUST FOV: "..fovRadius; fov_circle.Radius = fovRadius end end)
RunService.RenderStepped:Connect(function() if aimbotEnabled then fov_circle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2) end end)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [[ CONFIGURATION ]]
local CorrectKey = "JAY-39MF-7XQ5-2LY8" --
local espEnabled, aimbotEnabled = false, false
local fovRadius = 75 

-- [[ UI ROOT ]]
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "Jayyy_Clean_v19"

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
Main.Size = UDim2.new(0, 500, 0, 300) -- Clean Landscape Size
Main.Position = UDim2.new(0.5, -250, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.Visible = false
Instance.new("UICorner", Main)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(40, 40, 40)

-- Header
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, -20, 0, 40); Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "JAYYY---------------------------------------------MENU" 
Title.TextColor3 = Color3.new(1,1,1); Title.Font = Enum.Font.Code; Title.BackgroundTransparency = 1; Title.TextXAlignment = 0; Title.TextSize = 14

-- Sidebar (Now just for branding/Main Menu)
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 140, 1, -50); Sidebar.Position = UDim2.new(0, 5, 0, 45)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UICorner", Sidebar)

local MainTabBtn = Instance.new("TextButton", Sidebar)
MainTabBtn.Size = UDim2.new(1, 0, 0, 40); MainTabBtn.BackgroundTransparency = 1
MainTabBtn.Text = "MAIN MENU"; MainTabBtn.TextColor3 = Color3.new(1,1,1)
MainTabBtn.Font = Enum.Font.GothamBold; MainTabBtn.TextSize = 12

-- Centered Content Area
local CenterFrame = Instance.new("Frame", Main)
CenterFrame.Size = UDim2.new(1, -160, 1, -60); CenterFrame.Position = UDim2.new(0, 155, 0, 50)
CenterFrame.BackgroundTransparency = 1

local Layout = Instance.new("UIListLayout", CenterFrame)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center; Layout.VerticalAlignment = Enum.VerticalAlignment.Center
Layout.Padding = UDim.new(0, 15)

-- Small Text Toggles
local eBtn = Instance.new("TextButton", CenterFrame)
eBtn.Size = UDim2.new(0, 240, 0, 35); eBtn.Text = "ESP: OFF [K]"; eBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
eBtn.TextColor3 = Color3.new(1,1,1); eBtn.TextSize = 12; eBtn.Font = Enum.Font.Code -- Smaller Text Size
Instance.new("UICorner", eBtn); Instance.new("UIStroke", eBtn).Color = Color3.fromRGB(100, 100, 100)

local aBtn = Instance.new("TextButton", CenterFrame)
aBtn.Size = UDim2.new(0, 240, 0, 35); aBtn.Text = "AIM: OFF [L]"; aBtn.BackgroundColor3 = Color3.fromRGB(0, 80, 160)
aBtn.TextColor3 = Color3.new(1,1,1); aBtn.TextSize = 12; aBtn.Font = Enum.Font.Code -- Smaller Text Size
Instance.new("UICorner", aBtn); Instance.new("UIStroke", aBtn).Color = Color3.fromRGB(0, 255, 255)

-- Key Logic
KeyBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == CorrectKey then
        KeyFrame.Visible = false
        Main.Visible = true
    else
        KeyInput.PlaceholderText = "INVALID KEY"; KeyInput.Text = ""
    end
end)

-- Toggle Logic
local function toggleK()
    espEnabled = not espEnabled
    eBtn.Text = "ESP: " .. (espEnabled and "ON [K]" or "OFF [K]")
    eBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(150, 0, 0) or Color3.fromRGB(40, 40, 40)
end
local function toggleL()
    aimbotEnabled = not aimbotEnabled
    aBtn.Text = "AIM: " .. (aimbotEnabled and "ON [L]" or "OFF [L]")
    aBtn.BackgroundColor3 = aimbotEnabled and Color3.fromRGB(0, 50, 100) or Color3.fromRGB(0, 80, 160)
end

eBtn.MouseButton1Click:Connect(toggleK); aBtn.MouseButton1Click:Connect(toggleL)

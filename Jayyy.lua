local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [[ CONFIGURATION ]]
local CorrectKey = "JAY-39MF-7XQ5-2LY8"
local espEnabled, aimbotEnabled = false, false
local fovRadius = 75 

-- [[ UI ROOT ]]
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = "Jayyy_Final_v18"

-- [[ KEY SYSTEM GUI ]]
local KeyFrame = Instance.new("Frame", ScreenGui)
KeyFrame.Size = UDim2.new(0, 300, 0, 150)
KeyFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
KeyFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Instance.new("UICorner", KeyFrame)
Instance.new("UIStroke", KeyFrame).Color = Color3.fromRGB(0, 255, 255)

local KeyTitle = Instance.new("TextLabel", KeyFrame)
KeyTitle.Size = UDim2.new(1, 0, 0, 40); KeyTitle.Text = "ENTER KEY"; KeyTitle.TextColor3 = Color3.new(1,1,1)
KeyTitle.BackgroundTransparency = 1; KeyTitle.Font = Enum.Font.GothamBold

local KeyInput = Instance.new("TextBox", KeyFrame)
KeyInput.Size = UDim2.new(0, 240, 0, 35); KeyInput.Position = UDim2.new(0.5, -120, 0, 50)
KeyInput.PlaceholderText = "Paste Key Here..."; KeyInput.Text = ""
KeyInput.BackgroundColor3 = Color3.fromRGB(30, 30, 30); KeyInput.TextColor3 = Color3.new(1,1,1)
Instance.new("UICorner", KeyInput)

local KeyBtn = Instance.new("TextButton", KeyFrame)
KeyBtn.Size = UDim2.new(0, 100, 0, 30); KeyBtn.Position = UDim2.new(0.5, -50, 0, 100)
KeyBtn.Text = "CHECK"; KeyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
KeyBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", KeyBtn)

-- [[ MAIN MENU GUI (Hidden at start) ]]
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 600, 0, 350)
Main.Position = UDim2.new(0.5, -300, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.Visible = false
Instance.new("UICorner", Main)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(50, 50, 50)

-- Sidebar (Fixed inside Main)
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 150, 1, -50); Sidebar.Position = UDim2.new(0, 5, 0, 45)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Sidebar.BorderSizePixel = 0
Instance.new("UICorner", Sidebar)

local SideLayout = Instance.new("UIListLayout", Sidebar)
SideLayout.Padding = UDim.new(0, 5); SideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center

-- Top Bar Style
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, -20, 0, 40); Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "JAYYY---------------------------------------------MENU" 
Title.TextColor3 = Color3.new(1,1,1); Title.Font = Enum.Font.Code; Title.BackgroundTransparency = 1; Title.TextXAlignment = 0

-- Content Area
local MainCheatPage = Instance.new("Frame", Main)
MainCheatPage.Size = UDim2.new(1, -170, 1, -60); MainCheatPage.Position = UDim2.new(0, 160, 0, 50)
MainCheatPage.BackgroundTransparency = 1; MainCheatPage.Visible = false
local Layout = Instance.new("UIListLayout", MainCheatPage)
Layout.HorizontalAlignment = 1; Layout.VerticalAlignment = 1; Layout.Padding = UDim.new(0, 20)

-- Buttons
local function createSideBtn(text, isMain)
    local b = Instance.new("TextButton", Sidebar)
    b.Size = UDim2.new(0, 140, 0, 35); b.Text = text; b.BackgroundTransparency = 1; b.TextColor3 = Color3.fromRGB(180,180,180)
    b.Font = Enum.Font.GothamBold; b.TextSize = 12
    b.MouseButton1Click:Connect(function() MainCheatPage.Visible = isMain end)
    return b
end

local mainTabBtn = createSideBtn("MAIN MENU", true)
createSideBtn("AIMBOT MENU", false); createSideBtn("PLAYER MENU", false); createSideBtn("SETTINGS", false)

local eBtn = Instance.new("TextButton", MainCheatPage)
eBtn.Size = UDim2.new(0, 280, 0, 45); eBtn.Text = "ESP: OFF [K]"; eBtn.BackgroundColor3 = Color3.fromRGB(40,40,40)
Instance.new("UICorner", eBtn); Instance.new("UIStroke", eBtn).Color = Color3.new(1,1,1)

local aBtn = Instance.new("TextButton", MainCheatPage)
aBtn.Size = UDim2.new(0, 280, 0, 45); aBtn.Text = "AIM: OFF [L]"; aBtn.BackgroundColor3 = Color3.fromRGB(0, 80, 160)
Instance.new("UICorner", aBtn); Instance.new("UIStroke", aBtn).Color = Color3.new(0, 1, 1)

-- Key Logic
KeyBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == CorrectKey then
        KeyFrame.Visible = false
        Main.Visible = true
    else
        KeyInput.Text = ""; KeyInput.PlaceholderText = "WRONG KEY!"
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
UserInputService.InputBegan:Connect(function(i, p) if p then return end if i.KeyCode == Enum.KeyCode.K then toggleK() end if i.KeyCode == Enum.KeyCode.L then toggleL() end end)

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
ScreenGui.Name = "Jayyy_Final_Logic"

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

-- Main Landscape Frame
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 600, 0, 350)
Main.Position = UDim2.new(0.5, -300, 0.5, -175)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
Main.BorderSizePixel = 0
local MainCorner = Instance.new("UICorner", Main); MainCorner.CornerRadius = UDim.new(0, 10)
local MainStroke = Instance.new("UIStroke", Main); MainStroke.Color = Color3.fromRGB(50, 50, 50); MainStroke.Thickness = 2
makeMovable(Main)

-- Top Bar Branding
local TopBar = Instance.new("Frame", Main)
TopBar.Size = UDim2.new(1, 0, 0, 40)
TopBar.BackgroundTransparency = 1
local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, -20, 1, 0); Title.Position = UDim2.new(0, 15, 0, 0)
Title.Text = "JAYYY---------------------------------------------MENU" 
Title.TextColor3 = Color3.new(1,1,1); Title.Font = Enum.Font.Code; Title.TextSize = 16; Title.TextXAlignment = Enum.TextXAlignment.Left; Title.BackgroundTransparency = 1

-- Sidebar Setup
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 150, 1, -40); Sidebar.Position = UDim2.new(0, 0, 0, 40)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
local SidebarCorner = Instance.new("UICorner", Sidebar); SidebarCorner.CornerRadius = UDim.new(0, 10)

local SideLayout = Instance.new("UIListLayout", Sidebar)
SideLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center; SideLayout.Padding = UDim.new(0, 5)

-- Main Cheat Container (The target area)
local MainCheatPage = Instance.new("Frame", Main)
MainCheatPage.Size = UDim2.new(1, -170, 1, -60); MainCheatPage.Position = UDim2.new(0, 160, 0, 50)
MainCheatPage.BackgroundTransparency = 1
MainCheatPage.Visible = false -- Starts hidden

local Layout = Instance.new("UIListLayout", MainCheatPage)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center; Layout.VerticalAlignment = Enum.VerticalAlignment.Center; Layout.Padding = UDim.new(0, 20)

-- Sidebar Button Creator
local function createSideBtn(text, isMain)
    local b = Instance.new("TextButton", Sidebar)
    b.Size = UDim2.new(0, 140, 0, 40); b.Text = text; b.BackgroundTransparency = 1
    b.TextColor3 = Color3.fromRGB(200, 200, 200); b.Font = Enum.Font.GothamBold; b.TextSize = 13
    
    b.MouseButton1Click:Connect(function()
        -- Reset all buttons color
        for _, child in pairs(Sidebar:GetChildren()) do
            if child:IsA("TextButton") then child.TextColor3 = Color3.fromRGB(200, 200, 200) end
        end
        b.TextColor3 = Color3.fromRGB(255, 255, 255) -- Highlight active
        
        -- Toggle visibility of the Main Cheat page
        MainCheatPage.Visible = isMain
    end)
    return b
end

local mainTabBtn = createSideBtn("MAIN MENU", true) -- This button shows the cheat
createSideBtn("AIMBOT MENU", false)
createSideBtn("PLAYER MENU", false)
createSideBtn("SETTINGS", false)

-- [[ CHEAT BUTTONS (Inside Main Menu) ]]
local eBtn = Instance.new("TextButton", MainCheatPage)
eBtn.Size = UDim2.new(0, 280, 0, 45); eBtn.Text = "ESP: OFF [K]"; eBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
eBtn.TextColor3 = Color3.new(1,1,1); eBtn.Font = Enum.Font.Code; eBtn.TextSize = 15
Instance.new("UICorner", eBtn); Instance.new("UIStroke", eBtn).Color = Color3.fromRGB(255, 255, 255)

local aBtn = Instance.new("TextButton", MainCheatPage)
aBtn.Size = UDim2.new(0, 280, 0, 45); aBtn.Text = "AIM: OFF [L]"; aBtn.BackgroundColor3 = Color3.fromRGB(0, 60, 120)
aBtn.TextColor3 = Color3.new(1,1,1); aBtn.Font = Enum.Font.Code; aBtn.TextSize = 15
Instance.new("UICorner", aBtn); Instance.new("UIStroke", aBtn).Color = Color3.fromRGB(0, 255, 255)

local SliderText = Instance.new("TextLabel", MainCheatPage)
SliderText.Size = UDim2.new(0, 280, 0, 40); SliderText.Text = "SCROLL TO RESIZE FOV: " .. fovRadius
SliderText.TextColor3 = Color3.new(1,1,1); SliderText.BackgroundTransparency = 1; SliderText.Font = Enum.Font.Code; SliderText.TextSize = 13

-- [[ LOGIC FUNCTIONS ]]
local function toggleK()
    espEnabled = not espEnabled
    eBtn.Text = "ESP: " .. (espEnabled and "ON [K]" or "OFF [K]")
    eBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(120, 30, 30) or Color3.fromRGB(30, 30, 30)
end
local function toggleL()
    aimbotEnabled = not aimbotEnabled
    aBtn.Text = "AIM: " .. (aimbotEnabled and "ON [L]" or "OFF [L]")
    aBtn.BackgroundColor3 = aimbotEnabled and Color3.fromRGB(0, 40, 90) or Color3.fromRGB(0, 60, 120)
end

UserInputService.InputBegan:Connect(function(input, gpe)
    if gpe then return end
    if input.KeyCode == Enum.KeyCode.K then toggleK() end
    if input.KeyCode == Enum.KeyCode.L then toggleL() end
end)

Main.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseWheel and MainCheatPage.Visible then
        fovRadius = math.clamp(fovRadius + (input.Position.Z * 10), 10, maxFOV)
        SliderText.Text = "SCROLL TO RESIZE FOV: " .. fovRadius
    end
end)

eBtn.MouseButton1Click:Connect(toggleK); aBtn.MouseButton1Click:Connect(toggleL)

RunService.RenderStepped:Connect(function()
    fov_circle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    fov_circle.Visible = aimbotEnabled; fov_circle.Radius = fovRadius
end)

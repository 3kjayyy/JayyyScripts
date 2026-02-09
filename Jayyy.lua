local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [[ CONFIGURATION ]]
local CorrectKey = "JAY-39MF-7XQ5-2LY8"
local espEnabled, aimbotEnabled = false, false
local fovRadius = 100
local smoothIntensity = 0.2 -- Speed of the lock

-- [[ UI ROOT ]]
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))

-- [[ CENTER LOCK AIMBOT ENGINE ]]
local function getClosestToCenter()
    local target = nil
    local shortestDistance = fovRadius
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, v in pairs(Players:GetPlayers()) do
        if v ~= LocalPlayer and v.Character and v.Character:FindFirstChild("Humanoid") and v.Character.Humanoid.Health > 0 and v.Character:FindFirstChild("Head") then
            local pos, onScreen = Camera:WorldToViewportPoint(v.Character.Head.Position)
            if onScreen then
                local distance = (Vector2.new(pos.X, pos.Y) - screenCenter).Magnitude
                if distance < shortestDistance then
                    target = v
                    shortestDistance = distance
                end
            end
        end
    end
    return target
end

-- [[ FULL PLAYER GLOW (Wallhack) ]]
local function applyChams(plr)
    local function setup(char)
        local highlight = Instance.new("Highlight")
        highlight.Name = "JayyyGlow"
        highlight.FillColor = Color3.fromRGB(0, 255, 255)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.5
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop -- Makes it work through walls
        highlight.Parent = char
        
        RunService.RenderStepped:Connect(function()
            highlight.Enabled = espEnabled
        end)
    end
    if plr.Character then setup(plr.Character) end
    plr.CharacterAdded:Connect(setup)
end

for _, p in pairs(Players:GetPlayers()) do applyChams(p) end
Players.PlayerAdded:Connect(applyChams)

-- [[ MOVABLE GUI SETUP ]]
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 500, 0, 300); Main.Position = UDim2.new(0.5, -250, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10); Main.Visible = false; Main.Active = true; Main.Draggable = true
Instance.new("UICorner", Main)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(50, 50, 50)

-- Header
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 40); Title.Text = "JAYYY---------------------------------------------MENU" 
Title.TextColor3 = Color3.new(1,1,1); Title.Font = Enum.Font.Code; Title.BackgroundTransparency = 1; Title.TextSize = 12

-- Sidebar (Clean/Empty)
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 140, 1, -50); Sidebar.Position = UDim2.new(0, 5, 0, 45)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Instance.new("UICorner", Sidebar)
local STitle = Instance.new("TextLabel", Sidebar); STitle.Size = UDim2.new(1,0,0,40); STitle.Text = "MAIN MENU"; STitle.TextColor3 = Color3.new(1,1,1); STitle.Font = Enum.Font.GothamBold; STitle.TextSize = 11; STitle.BackgroundTransparency = 1

-- Centered Toggles
local Center = Instance.new("Frame", Main)
Center.Size = UDim2.new(1, -160, 1, -60); Center.Position = UDim2.new(0, 155, 0, 50); Center.BackgroundTransparency = 1
local Layout = Instance.new("UIListLayout", Center); Layout.HorizontalAlignment = 1; Layout.VerticalAlignment = 1; Layout.Padding = UDim.new(0, 15)

local eBtn = Instance.new("TextButton", Center); eBtn.Size = UDim2.new(0, 220, 0, 35); eBtn.Text = "GLOW ESP: OFF [K]"; eBtn.BackgroundColor3 = Color3.fromRGB(30,30,30); eBtn.TextColor3 = Color3.new(1,1,1); eBtn.TextSize = 10; eBtn.Font = Enum.Font.Code; Instance.new("UICorner", eBtn)
local aBtn = Instance.new("TextButton", Center); aBtn.Size = UDim2.new(0, 220, 0, 35); aBtn.Text = "CENTER AIM: OFF [L]"; aBtn.BackgroundColor3 = Color3.fromRGB(0, 80, 160); aBtn.TextColor3 = Color3.new(1,1,1); aBtn.TextSize = 10; aBtn.Font = Enum.Font.Code; Instance.new("UICorner", aBtn)
local SliderText = Instance.new("TextLabel", Center); SliderText.Size = UDim2.new(0, 220, 0, 30); SliderText.Text = "SCROLL: FOV ["..fovRadius.."]"; SliderText.TextColor3 = Color3.new(1,1,1); SliderText.TextSize = 10; SliderText.BackgroundTransparency = 1; SliderText.Font = Enum.Font.Code

-- [[ KEY SYSTEM ]]
local KeyFrame = Instance.new("Frame", ScreenGui); KeyFrame.Size = UDim2.new(0, 300, 0, 140); KeyFrame.Position = UDim2.new(0.5, -150, 0.5, -70); KeyFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15); KeyFrame.Active = true; KeyFrame.Draggable = true; Instance.new("UICorner", KeyFrame)
local KeyInput = Instance.new("TextBox", KeyFrame); KeyInput.Size = UDim2.new(0, 200, 0, 30); KeyInput.Position = UDim2.new(0.5, -100, 0.3, 0); KeyInput.PlaceholderText = "Key..."; KeyInput.BackgroundColor3 = Color3.fromRGB(25, 25, 25); KeyInput.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", KeyInput)
local KeyBtn = Instance.new("TextButton", KeyFrame); KeyBtn.Size = UDim2.new(0, 80, 0, 30); KeyBtn.Position = UDim2.new(0.5, -40, 0.65, 0); KeyBtn.Text = "LOGIN"; KeyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215); KeyBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", KeyBtn)

-- [[ RUNTIME LOGIC ]]
KeyBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == CorrectKey then KeyFrame.Visible = false; Main.Visible = true end
end)

local function toggleK() espEnabled = not espEnabled; eBtn.Text = "GLOW ESP: "..(espEnabled and "ON [K]" or "OFF [K]") end
local function toggleL() aimbotEnabled = not aimbotEnabled; aBtn.Text = "CENTER AIM: "..(aimbotEnabled and "ON [L]" or "OFF [L]") end

eBtn.MouseButton1Click:Connect(toggleK); aBtn.MouseButton1Click:Connect(toggleL)
UserInputService.InputBegan:Connect(function(i, g) if g then return end if i.KeyCode == Enum.KeyCode.K then toggleK() elseif i.KeyCode == Enum.KeyCode.L then toggleL() end end)
Main.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseWheel then fovRadius = math.clamp(fovRadius + (i.Position.Z * 10), 20, 600); SliderText.Text = "SCROLL: FOV ["..fovRadius.."]" end end)

RunService.RenderStepped:Connect(function()
    if aimbotEnabled then
        local target = getClosestToCenter()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Character.Head.Position), smoothIntensity)
        end
    end
end)

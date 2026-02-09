local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local Mouse = LocalPlayer:GetMouse()

-- [[ CONFIGURATION ]]
local CorrectKey = "JAY-39MF-7XQ5-2LY8"
local espEnabled, aimbotEnabled = false, false
local fovRadius = 75 
local smoothing = 0.2 -- Lower = faster/snappier

-- [[ DRAWING OBJECTS ]]
local fovCircle = Drawing.new("Circle")
fovCircle.Thickness = 1
fovCircle.Color = Color3.fromRGB(0, 255, 255)
fovCircle.Visible = false

-- [[ AIMBOT ENGINE ]]
local function getClosestPlayer()
    local target = nil
    local dist = fovRadius
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local pos, onScreen = Camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
            local mouseDist = (Vector2.new(pos.X, pos.Y) - Vector2.new(Mouse.X, Mouse.Y)).Magnitude
            if onScreen and mouseDist < dist then
                dist = mouseDist
                target = plr
            end
        end
    end
    return target
end

-- [[ ESP ENGINE ]]
local function createESP(plr)
    local box = Drawing.new("Square")
    box.Thickness = 1
    box.Filled = false
    box.Color = Color3.fromRGB(255, 255, 255)
    
    local updater
    updater = RunService.RenderStepped:Connect(function()
        if espEnabled and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local rootPos, onScreen = Camera:WorldToViewportPoint(plr.Character.HumanoidRootPart.Position)
            if onScreen then
                box.Size = Vector2.new(2000 / rootPos.Z, 2500 / rootPos.Z)
                box.Position = Vector2.new(rootPos.X - box.Size.X / 2, rootPos.Y - box.Size.Y / 2)
                box.Visible = true
            else
                box.Visible = false
            end
        else
            box.Visible = false
            if not plr or not plr.Parent then
                box:Remove()
                updater:Disconnect()
            end
        end
    end)
end

-- Initialize ESP for players
for _, p in pairs(Players:GetPlayers()) do if p ~= LocalPlayer then createESP(p) end end
Players.PlayerAdded:Connect(createESP)

-- [[ UI & DRAGGING ]]
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 550, 0, 320); Main.Position = UDim2.new(0.5, -275, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10); Main.Visible = false; Instance.new("UICorner", Main)
local MainStroke = Instance.new("UIStroke", Main); MainStroke.Color = Color3.fromRGB(45, 45, 45)

-- Sidebar & Buttons (Layout as requested)
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 150, 1, -50); Sidebar.Position = UDim2.new(0, 5, 0, 45)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Instance.new("UICorner", Sidebar)
local STitle = Instance.new("TextLabel", Sidebar); STitle.Size = UDim2.new(1,0,0,40); STitle.Text = "MAIN MENU"; STitle.TextColor3 = Color3.new(1,1,1); STitle.Font = Enum.Font.GothamBold; STitle.TextSize = 12; STitle.BackgroundTransparency = 1

local Center = Instance.new("Frame", Main)
Center.Size = UDim2.new(1, -170, 1, -60); Center.Position = UDim2.new(0, 160, 0, 50); Center.BackgroundTransparency = 1
local Layout = Instance.new("UIListLayout", Center); Layout.HorizontalAlignment = 1; Layout.VerticalAlignment = 1; Layout.Padding = UDim.new(0, 12)

local eBtn = Instance.new("TextButton", Center); eBtn.Size = UDim2.new(0, 260, 0, 40); eBtn.Text = "ESP: OFF [K]"; eBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35); eBtn.TextColor3 = Color3.new(1,1,1); eBtn.TextSize = 11; eBtn.Font = Enum.Font.Code; Instance.new("UICorner", eBtn)
local aBtn = Instance.new("TextButton", Center); aBtn.Size = UDim2.new(0, 260, 0, 40); aBtn.Text = "AIM: OFF [L]"; aBtn.BackgroundColor3 = Color3.fromRGB(0, 70, 140); aBtn.TextColor3 = Color3.new(1,1,1); aBtn.TextSize = 11; aBtn.Font = Enum.Font.Code; Instance.new("UICorner", aBtn)
local SliderText = Instance.new("TextLabel", Center); SliderText.Size = UDim2.new(0, 260, 0, 35); SliderText.Text = "SCROLL TO ADJUST FOV: " .. fovRadius; SliderText.TextColor3 = Color3.new(1,1,1); SliderText.TextSize = 11; SliderText.BackgroundTransparency = 1; SliderText.Font = Enum.Font.Code

-- [[ MAIN LOOP ]]
RunService.RenderStepped:Connect(function()
    if aimbotEnabled then
        fovCircle.Position = Vector2.new(Mouse.X, Mouse.Y + 36)
        fovCircle.Visible = true
        fovCircle.Radius = fovRadius
        
        local target = getClosestPlayer()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            local targetPos = Camera:WorldToViewportPoint(target.Character.Head.Position)
            mousemoverel((targetPos.X - Mouse.X) * smoothing, (targetPos.Y - Mouse.Y) * smoothing)
        end
    else
        fovCircle.Visible = false
    end
end)

-- Functionality & Keybinds
local function toggleK() espEnabled = not espEnabled; eBtn.Text = "ESP: "..(espEnabled and "ON [K]" or "OFF [K]"); eBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(130,0,0) or Color3.fromRGB(35,35,35) end
local function toggleL() aimbotEnabled = not aimbotEnabled; aBtn.Text = "AIM: "..(aimbotEnabled and "ON [L]" or "OFF [L]"); aBtn.BackgroundColor3 = aimbotEnabled and Color3.fromRGB(0,40,90) or Color3.fromRGB(0,70,140) end

eBtn.MouseButton1Click:Connect(toggleK); aBtn.MouseButton1Click:Connect(toggleL)
UserInputService.InputBegan:Connect(function(i, g) if g then return end if i.KeyCode == Enum.KeyCode.K then toggleK() elseif i.KeyCode == Enum.KeyCode.L then toggleL() end end)
Main.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseWheel then fovRadius = math.clamp(fovRadius + (i.Position.Z * 10), 10, maxFOV); SliderText.Text = "SCROLL TO ADJUST FOV: "..fovRadius end end)

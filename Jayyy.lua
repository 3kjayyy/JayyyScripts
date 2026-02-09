local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [[ CONFIGURATION ]]
local CorrectKey = "JAY-39MF-7XQ5-2LY8"
local espEnabled, aimbotEnabled = false, false
local fovRadius = 100
local smoothing = 0.15 -- Adjust for "snap" speed

-- [[ FOV CIRCLE (Center of Screen) ]]
local fov_circle = Drawing.new("Circle")
fov_circle.Thickness = 1
fov_circle.Color = Color3.fromRGB(0, 255, 255)
fov_circle.Transparency = 0.7
fov_circle.Filled = false
fov_circle.Visible = false

-- [[ AIMBOT LOGIC (Center Lock) ]]
local function getClosestToCenter()
    local target = nil
    local shortestDist = fovRadius
    local screenCenter = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") and plr.Character:FindFirstChild("Humanoid") and plr.Character.Humanoid.Health > 0 then
            local pos, onScreen = Camera:WorldToViewportPoint(plr.Character.Head.Position)
            if onScreen then
                local dist = (Vector2.new(pos.X, pos.Y) - screenCenter).Magnitude
                if dist < shortestDist then
                    shortestDist = dist
                    target = plr
                end
            end
        end
    end
    return target
end

-- [[ HIGHLIGHT ESP (No Boxes) ]]
local function applyWallhack(plr)
    local function setup(char)
        local highlight = Instance.new("Highlight")
        highlight.Name = "JayyyWallhack"
        highlight.FillColor = Color3.fromRGB(0, 255, 255)
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
        highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
        highlight.Parent = char
        
        RunService.RenderStepped:Connect(function()
            highlight.Enabled = espEnabled
        end)
    end
    if plr.Character then setup(plr.Character) end
    plr.CharacterAdded:Connect(setup)
end

for _, p in pairs(Players:GetPlayers()) do applyWallhack(p) end
Players.PlayerAdded:Connect(applyWallhack)

-- [[ UI SETUP ]]
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))

-- Main Menu (Movable)
local Main = Instance.new("Frame", ScreenGui)
Main.Size = UDim2.new(0, 500, 0, 300); Main.Position = UDim2.new(0.5, -250, 0.5, -150)
Main.BackgroundColor3 = Color3.fromRGB(10, 10, 10); Main.Visible = false; Main.Active = true; Main.Draggable = true
Instance.new("UICorner", Main)
Instance.new("UIStroke", Main).Color = Color3.fromRGB(50, 50, 50)

-- Sidebar Branding
local Sidebar = Instance.new("Frame", Main)
Sidebar.Size = UDim2.new(0, 140, 1, -50); Sidebar.Position = UDim2.new(0, 5, 0, 45)
Sidebar.BackgroundColor3 = Color3.fromRGB(15, 15, 15); Instance.new("UICorner", Sidebar)
local STitle = Instance.new("TextLabel", Sidebar); STitle.Size = UDim2.new(1,0,0,40); STitle.Text = "MAIN MENU"; STitle.TextColor3 = Color3.new(1,1,1); STitle.Font = Enum.Font.GothamBold; STitle.TextSize = 11; STitle.BackgroundTransparency = 1

-- Center Toggles
local CenterContainer = Instance.new("Frame", Main)
CenterContainer.Size = UDim2.new(1, -160, 1, -60); CenterContainer.Position = UDim2.new(0, 155, 0, 50); CenterContainer.BackgroundTransparency = 1
local Layout = Instance.new("UIListLayout", CenterContainer); Layout.HorizontalAlignment = 1; Layout.VerticalAlignment = 1; Layout.Padding = UDim.new(0, 15)

local eBtn = Instance.new("TextButton", CenterContainer); eBtn.Size = UDim2.new(0, 220, 0, 35); eBtn.Text = "WALLHACK: OFF [K]"; eBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30); eBtn.TextColor3 = Color3.new(1,1,1); eBtn.TextSize = 10; eBtn.Font = Enum.Font.Code; Instance.new("UICorner", eBtn)
local aBtn = Instance.new("TextButton", CenterContainer); aBtn.Size = UDim2.new(0, 220, 0, 35); aBtn.Text = "AIMLOCK: OFF [L]"; aBtn.BackgroundColor3 = Color3.fromRGB(0, 80, 160); aBtn.TextColor3 = Color3.new(1,1,1); aBtn.TextSize = 10; aBtn.Font = Enum.Font.Code; Instance.new("UICorner", aBtn)
local SliderText = Instance.new("TextLabel", CenterContainer); SliderText.Size = UDim2.new(0, 220, 0, 30); SliderText.Text = "SCROLL: FOV ["..fovRadius.."]"; SliderText.TextColor3 = Color3.new(1,1,1); SliderText.TextSize = 10; SliderText.BackgroundTransparency = 1; SliderText.Font = Enum.Font.Code

-- [[ KEY SYSTEM ]]
local KeyFrame = Instance.new("Frame", ScreenGui); KeyFrame.Size = UDim2.new(0, 300, 0, 140); KeyFrame.Position = UDim2.new(0.5, -150, 0.5, -70); KeyFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15); KeyFrame.Active = true; KeyFrame.Draggable = true; Instance.new("UICorner", KeyFrame)
local KeyInput = Instance.new("TextBox", KeyFrame); KeyInput.Size = UDim2.new(0, 200, 0, 30); KeyInput.Position = UDim2.new(0.5, -100, 0.3, 0); KeyInput.PlaceholderText = "Paste Key..."; KeyInput.BackgroundColor3 = Color3.fromRGB(25, 25, 25); KeyInput.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", KeyInput)
local KeyBtn = Instance.new("TextButton", KeyFrame); KeyBtn.Size = UDim2.new(0, 80, 0, 30); KeyBtn.Position = UDim2.new(0.5, -40, 0.65, 0); KeyBtn.Text = "LOGIN"; KeyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215); KeyBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", KeyBtn)

-- [[ EXECUTION ]]
KeyBtn.MouseButton1Click:Connect(function()
    if KeyInput.Text == CorrectKey then KeyFrame.Visible = false; Main.Visible = true end
end)

local function toggleK() espEnabled = not espEnabled; eBtn.Text = "WALLHACK: "..(espEnabled and "ON [K]" or "OFF [K]") end
local function toggleL() aimbotEnabled = not aimbotEnabled; aBtn.Text = "AIMLOCK: "..(aimbotEnabled and "ON [L]" or "OFF [L]"); fov_circle.Visible = aimbotEnabled end

eBtn.MouseButton1Click:Connect(toggleK); aBtn.MouseButton1Click:Connect(toggleL)
UserInputService.InputBegan:Connect(function(i, g) if g then return end if i.KeyCode == Enum.KeyCode.K then toggleK() elseif i.KeyCode == Enum.KeyCode.L then toggleL() end end)
Main.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseWheel then fovRadius = math.clamp(fovRadius + (i.Position.Z * 10), 20, 600); SliderText.Text = "SCROLL: FOV ["..fovRadius.."]" end end)

RunService.RenderStepped:Connect(function()
    fov_circle.Position = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    fov_circle.Radius = fovRadius
    if aimbotEnabled then
        local target = getClosestToCenter()
        if target and target.Character and target.Character:FindFirstChild("Head") then
            Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Character.Head.Position), smoothing)
        end
    end
end)

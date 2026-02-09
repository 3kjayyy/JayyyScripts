local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [[ CONFIGURATION ]]
local CorrectKey = "JAY-39MF-7XQ5-2LY8"
local espEnabled, aimbotEnabled = false, false
local fovRadius = 80 
local maxFOV = 400
local stickiness = 0.5 -- Higher = More sticky/snappy (0.1 to 1.0)

-- [[ FOV CIRCLE ]]
local fov_circle = Drawing.new("Circle")
fov_circle.Thickness = 1
fov_circle.Color = Color3.new(1, 1, 1)
fov_circle.Visible = false

-- [[ UI ROOT ]]
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))

-- [[ KEY SYSTEM ]]
local KeyFrame = Instance.new("Frame", ScreenGui)
KeyFrame.Size = UDim2.new(0, 300, 0, 150); KeyFrame.Position = UDim2.new(0.5, -150, 0.5, -75)
KeyFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15); KeyFrame.Active = true; KeyFrame.Draggable = true; Instance.new("UICorner", KeyFrame)
local KeyInput = Instance.new("TextBox", KeyFrame)
KeyInput.Size = UDim2.new(0, 240, 0, 35); KeyInput.Position = UDim2.new(0.5, -120, 0, 50); KeyInput.PlaceholderText = "Enter Key..."
KeyInput.BackgroundColor3 = Color3.fromRGB(25, 25, 25); KeyInput.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", KeyInput)
local KeyBtn = Instance.new("TextButton", KeyFrame)
KeyBtn.Size = UDim2.new(0, 100, 0, 30); KeyBtn.Position = UDim2.new(0.5, -50, 0, 100); KeyBtn.Text = "LOGIN"; KeyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215); KeyBtn.TextColor3 = Color3.new(1,1,1); Instance.new("UICorner", KeyBtn)

-- [[ MAIN MENU ]]
local Main = Instance.new("ImageLabel", ScreenGui)
Main.Size = UDim2.new(0, 550, 0, 320); Main.Position = UDim2.new(0.5, -275, 0.5, -160)
Main.Image = "rbxassetid://10850255319"; Main.ImageColor3 = Color3.fromRGB(120, 120, 120); Main.BackgroundColor3 = Color3.fromRGB(15,15,15)
Main.ScaleType = Enum.ScaleType.Crop; Main.Visible = false; Main.Active = true; Main.Draggable = true; Instance.new("UICorner", Main)

local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, -20, 0, 40); Title.Position = UDim2.new(0, 15, 0, 0); Title.Text = "JAYYY---------------------------------------------MENU" 
Title.TextColor3 = Color3.new(1,1,1); Title.Font = Enum.Font.Code; Title.BackgroundTransparency = 1; Title.TextXAlignment = 0; Title.TextSize = 13

local Content = Instance.new("Frame", Main)
Content.Size = UDim2.new(1, -170, 1, -60); Content.Position = UDim2.new(0, 160, 0, 50); Content.BackgroundTransparency = 1
local Layout = Instance.new("UIListLayout", Content); Layout.HorizontalAlignment = 1; Layout.VerticalAlignment = 1; Layout.Padding = UDim.new(0, 15)

local function createBtn(text)
    local b = Instance.new("TextButton", Content); b.Size = UDim2.new(0, 240, 0, 40); b.Text = text; b.BackgroundColor3 = Color3.fromRGB(0,0,0); b.BackgroundTransparency = 0.6
    b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.Code; b.TextSize = 11; Instance.new("UICorner", b); Instance.new("UIStroke", b).Color = Color3.fromRGB(80,80,80)
    return b
end

local eBtn = createBtn("ESP: OFF [K]"); local aBtn = createBtn("AIM: OFF [L]")
local SliderText = Instance.new("TextLabel", Content); SliderText.Size = UDim2.new(0, 240, 0, 30); SliderText.Text = "SCROLL: FOV ["..fovRadius.."]"; SliderText.TextColor3 = Color3.new(1,1,1); SliderText.TextSize = 10; SliderText.BackgroundTransparency = 1; SliderText.Font = Enum.Font.Code

-- [[ COMBAT ENGINE ]]
local function createSkeleton(char)
    local lines = {}
    local parts = {{"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"}, {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}}
    for i = 1, #parts do
        local l = Drawing.new("Line"); l.Thickness = 1.5; l.Color = Color3.new(0, 0, 0); l.Visible = false; lines[i] = l
    end
    RunService.RenderStepped:Connect(function()
        if not char.Parent then for _, l in pairs(lines) do l:Remove() end return end
        for i, p in pairs(parts) do
            local p1, p2 = char:FindFirstChild(p[1]), char:FindFirstChild(p[2])
            if p1 and p2 and espEnabled then
                local v1, o1 = Camera:WorldToViewportPoint(p1.Position); local v2, o2 = Camera:WorldToViewportPoint(p2.Position)
                if o1 and o2 then lines[i].From = Vector2.new(v1.X, v1.Y); lines[i].To = Vector2.new(v2.X, v2.Y); lines[i].Visible = true else lines[i].Visible = false end
            else lines[i].Visible = false end
        end
    end)
end

local function setupESP(p)
    if p == LocalPlayer then return end
    local bgui = Instance.new("BillboardGui", ScreenGui); bgui.AlwaysOnTop = true; bgui.Size = UDim2.new(0, 100, 0, 50); bgui.StudsOffset = Vector3.new(0, 3, 0)
    local nL = Instance.new("TextLabel", bgui); nL.Size = UDim2.new(1, 0, 0.3, 0); nL.BackgroundTransparency = 1; nL.TextColor3 = Color3.new(1,1,1); nL.Font = Enum.Font.Code; nL.TextSize = 9
    
    local highlight = Instance.new("Highlight")
    highlight.FillColor = Color3.new(1, 0, 0); highlight.FillTransparency = 0.5; highlight.OutlineColor = Color3.new(1, 1, 1); highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

    RunService.RenderStepped:Connect(function()
        if p.Character and p.Character:FindFirstChild("Head") and espEnabled then
            bgui.Adornee = p.Character.Head; bgui.Enabled = true; nL.Text = p.DisplayName:upper().."\n"..math.floor(p.Character.Humanoid.Health).."HP"
            highlight.Parent = p.Character; highlight.Enabled = true
        else bgui.Enabled = false; highlight.Enabled = false end
    end)
    if p.Character then createSkeleton(p.Character) end
    p.CharacterAdded:Connect(createSkeleton)
end

for _, p in ipairs(Players:GetPlayers()) do setupESP(p) end
Players.PlayerAdded:Connect(setupESP)

-- [[ INTERACTION ]]
KeyBtn.MouseButton1Click:Connect(function() if KeyInput.Text == CorrectKey then KeyFrame.Visible = false; Main.Visible = true end end)
local function toggleK() espEnabled = not espEnabled; eBtn.Text = "ESP: "..(espEnabled and "ON [K]" or "OFF [K]"); eBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(150, 0, 0) or Color3.fromRGB(0,0,0) end
local function toggleL() aimbotEnabled = not aimbotEnabled; aBtn.Text = "AIM: "..(aimbotEnabled and "ON [L]" or "OFF [L]"); aBtn.BackgroundColor3 = aimbotEnabled and Color3.fromRGB(0, 100, 200) or Color3.fromRGB(0,0,0) end

eBtn.MouseButton1Click:Connect(toggleK); aBtn.MouseButton1Click:Connect(toggleL)
UserInputService.InputBegan:Connect(function(i, g) if g then return end if i.KeyCode == Enum.KeyCode.K then toggleK() elseif i.KeyCode == Enum.KeyCode.L then toggleL() end end)
Main.InputChanged:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseWheel then fovRadius = math.clamp(fovRadius + (i.Position.Z * 10), 10, maxFOV); SliderText.Text = "SCROLL: FOV ["..fovRadius.."]" end end)

RunService.RenderStepped:Connect(function()
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    fov_circle.Position = center; fov_circle.Visible = aimbotEnabled; fov_circle.Radius = fovRadius
    if aimbotEnabled then
        local target, dist = nil, fovRadius
        for _, p in ipairs(Players:GetPlayers()) do
            if p ~= LocalPlayer and p.Character and p.Character:FindFirstChild("Head") and p.Character.Humanoid.Health > 0 then
                local pos, vis = Camera:WorldToViewportPoint(p.Character.Head.Position)
                if vis then
                    local m = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if m < dist then target = p.Character.Head; dist = m end
                end
            end
        end
        if target then Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Position), stickiness) end
    end
end)

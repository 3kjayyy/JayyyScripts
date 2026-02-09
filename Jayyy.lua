-- [[ JAYYY PREMIUM v10 ]]
-- Keybinds: [K] ESP | [L] AIMBOT

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera

-- [[ CONFIGURATION ]]
local espEnabled = false
local aimbotEnabled = false
local fovRadius = 50 
local maxFOV = 350
local brandName = "JAYYY"

-- [[ DRAWING FOV ]]
local fov_circle = Drawing.new("Circle")
fov_circle.Thickness = 1
fov_circle.Radius = fovRadius
fov_circle.Color = Color3.fromRGB(255, 255, 255)
fov_circle.Visible = false

-- [[ UI SETUP ]]
local ScreenGui = Instance.new("ScreenGui", game:GetService("CoreGui"))
ScreenGui.Name = brandName .. "_Final_v10"

-- Custom Dragging Function
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

-- Main Frame
local Main = Instance.new("ImageLabel", ScreenGui)
Main.Size = UDim2.new(0, 220, 0, 260)
Main.Position = UDim2.new(0.05, 0, 0.4, 0)
Main.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
Main.BorderSizePixel = 0
Main.Image = "rbxassetid://10850255319" 
Main.ImageColor3 = Color3.fromRGB(120, 120, 120)
Main.ScaleType = Enum.ScaleType.Crop
Instance.new("UICorner", Main)
makeMovable(Main)

-- Title
local Title = Instance.new("TextLabel", Main)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.Text = brandName .. " PREMIUM"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.BackgroundTransparency = 1

-- Credits
local Credits = Instance.new("TextLabel", Main)
Credits.Size = UDim2.new(1, 0, 0, 30)
Credits.Position = UDim2.new(0, 0, 1, -30)
Credits.Text = "Developed by: " .. brandName
Credits.TextColor3 = Color3.fromRGB(200, 200, 200)
Credits.BackgroundTransparency = 1
Credits.Font = Enum.Font.Code
Credits.TextSize = 12

-- Minimize/Open Buttons
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 80, 0, 30); OpenBtn.Visible = false; OpenBtn.Text = "OPEN"
OpenBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 20); OpenBtn.TextColor3 = Color3.new(1,1,1)
OpenBtn.Font = Enum.Font.Code; Instance.new("UICorner", OpenBtn); makeMovable(OpenBtn)

local MinBtn = Instance.new("TextButton", Main)
MinBtn.Size = UDim2.new(0, 25, 0, 25); MinBtn.Position = UDim2.new(1, -30, 0, 5)
MinBtn.Text = "-"; MinBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40); MinBtn.TextColor3 = Color3.new(1,1,1)
MinBtn.BackgroundTransparency = 0.5; Instance.new("UICorner", MinBtn)

-- Toggle Button Creator
local function createBtn(text, pos)
    local b = Instance.new("TextButton", Main)
    b.Size = UDim2.new(0, 200, 0, 35); b.Position = pos; b.Text = text
    b.BackgroundColor3 = Color3.fromRGB(0, 0, 0); b.BackgroundTransparency = 0.6
    b.TextColor3 = Color3.new(1,1,1); b.Font = Enum.Font.Code; b.TextSize = 11
    Instance.new("UICorner", b)
    local s = Instance.new("UIStroke", b); s.Color = Color3.fromRGB(80, 80, 80); s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
    return b
end

local eBtn = createBtn("ESP: OFF [K]", UDim2.new(0, 10, 0, 50))
local aBtn = createBtn("AIM: OFF [L]", UDim2.new(0, 10, 0, 95))

-- FOV Slider Setup
local SliderBack = Instance.new("Frame", Main)
SliderBack.Size = UDim2.new(0, 200, 0, 45); SliderBack.Position = UDim2.new(0, 10, 0, 150)
SliderBack.BackgroundColor3 = Color3.fromRGB(0, 0, 0); SliderBack.BackgroundTransparency = 0.7; Instance.new("UICorner", SliderBack)

local SliderFill = Instance.new("Frame", SliderBack)
SliderFill.Size = UDim2.new(fovRadius/maxFOV, 0, 1, 0); SliderFill.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
SliderFill.BackgroundTransparency = 0.8; Instance.new("UICorner", SliderFill)

local SliderText = Instance.new("TextLabel", SliderBack)
SliderText.Size = UDim2.new(1, 0, 1, 0); SliderText.Text = "SCROLL OVER HERE\nFOV: 50"; SliderText.TextColor3 = Color3.new(1,1,1)
SliderText.BackgroundTransparency = 1; SliderText.Font = Enum.Font.Code; SliderText.TextSize = 10

-- [[ LOGIC FUNCTIONS ]]
local function toggleK()
    espEnabled = not espEnabled
    eBtn.Text = "ESP: " .. (espEnabled and "ON [K]" or "OFF [K]")
    eBtn.BackgroundColor3 = espEnabled and Color3.fromRGB(150, 0, 0) or Color3.fromRGB(0, 0, 0)
end

local function toggleL()
    aimbotEnabled = not aimbotEnabled
    aBtn.Text = "AIM: " .. (aimbotEnabled and "ON [L]" or "OFF [L]")
    aBtn.BackgroundColor3 = aimbotEnabled and Color3.fromRGB(0, 100, 200) or Color3.fromRGB(0, 0, 0)
end

-- [[ INPUT HANDLING ]]
MinBtn.MouseButton1Click:Connect(function() Main.Visible = false; OpenBtn.Position = Main.Position; OpenBtn.Visible = true end)
OpenBtn.MouseButton1Click:Connect(function() OpenBtn.Visible = false; Main.Position = OpenBtn.Position; Main.Visible = true end)

local isHovering = false
SliderBack.MouseEnter:Connect(function() isHovering = true end)
SliderBack.MouseLeave:Connect(function() isHovering = false end)

UserInputService.InputBegan:Connect(function(input, processed)
    if processed then return end
    if input.KeyCode == Enum.KeyCode.K then toggleK() end
    if input.KeyCode == Enum.KeyCode.L then toggleL() end
end)

UserInputService.InputChanged:Connect(function(input)
    if isHovering and input.UserInputType == Enum.UserInputType.MouseWheel then
        fovRadius = math.clamp(fovRadius + (input.Position.Z * 7), 10, maxFOV)
        TweenService:Create(SliderFill, TweenInfo.new(0.1), {Size = UDim2.new(fovRadius/maxFOV, 0, 1, 0)}):Play()
        SliderText.Text = "SCROLL OVER HERE\nFOV: " .. fovRadius
    end
end)

-- [[ ESP & SKELETON ]]
local function createSkeleton(char)
    local lines = {}
    local parts = {{"Head", "UpperTorso"}, {"UpperTorso", "LowerTorso"}, {"UpperTorso", "LeftUpperArm"}, {"LeftUpperArm", "LeftLowerArm"}, {"UpperTorso", "RightUpperArm"}, {"RightUpperArm", "RightLowerArm"}, {"LowerTorso", "LeftUpperLeg"}, {"LeftUpperLeg", "LeftLowerLeg"}, {"LowerTorso", "RightUpperLeg"}, {"RightUpperLeg", "RightLowerLeg"}}
    for i = 1, #parts do
        local l = Drawing.new("Line"); l.Thickness = 2; l.Color = Color3.new(0, 0, 0); l.Visible = false
        lines[i] = l
    end
    RunService.RenderStepped:Connect(function()
        if not char.Parent then for _, l in pairs(lines) do l:Remove() end return end
        for i, p in pairs(parts) do
            local p1, p2 = char:FindFirstChild(p[1]), char:FindFirstChild(p[2])
            if p1 and p2 and espEnabled then
                local v1, o1 = Camera:WorldToViewportPoint(p1.Position)
                local v2, o2 = Camera:WorldToViewportPoint(p2.Position)
                if o1 and o2 then lines[i].From = Vector2.new(v1.X, v1.Y); lines[i].To = Vector2.new(v2.X, v2.Y); lines[i].Visible = true else lines[i].Visible = false end
            else lines[i].Visible = false end
        end
    end)
end

local playerESP = {}
local function setupESP(p)
    if p == LocalPlayer then return end
    local folder = Instance.new("Folder", ScreenGui)
    local bgui = Instance.new("BillboardGui", folder); bgui.AlwaysOnTop = true; bgui.Size = UDim2.new(0, 100, 0, 50); bgui.StudsOffset = Vector3.new(0, 3, 0)
    local nL = Instance.new("TextLabel", bgui); nL.Size = UDim2.new(1, 0, 0.3, 0); nL.BackgroundTransparency = 1; nL.TextColor3 = Color3.new(1,1,1); nL.Font = Enum.Font.GothamBold; nL.TextSize = 10
    local hL = Instance.new("TextLabel", bgui); hL.Size = UDim2.new(1, 0, 0.3, 0); hL.Position = UDim2.new(0, 0, 0.4, 0); hL.BackgroundTransparency = 1; hL.TextColor3 = Color3.new(1,1,1); hL.Font = Enum.Font.Code; hL.TextSize = 9
    playerESP[p] = {Folder = folder, BGui = bgui, Name = nL, Num = hL}
    if p.Character then createSkeleton(p.Character) end
    p.CharacterAdded:Connect(createSkeleton)
end

for _, p in ipairs(Players:GetPlayers()) do setupESP(p) end
Players.PlayerAdded:Connect(setupESP)

-- [[ MAIN RENDER LOOP ]]
RunService.RenderStepped:Connect(function()
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)
    fov_circle.Position = center
    fov_circle.Visible = aimbotEnabled
    if fov_circle.Radius ~= fovRadius then fov_circle.Radius = fov_circle.Radius + (fovRadius - fov_circle.Radius) * 0.15 end
    
    local target, dist = nil, fovRadius
    for _, p in ipairs(Players:GetPlayers()) do
        if p ~= LocalPlayer and p.Character then
            local head, hum = p.Character:FindFirstChild("Head"), p.Character:FindFirstChild("Humanoid")
            local data = playerESP[p]
            if data and head and hum then
                data.Folder.Parent = espEnabled and ScreenGui or nil
                data.BGui.Adornee = head; data.Name.Text = p.DisplayName:upper(); data.Num.Text = math.floor(hum.Health) .. " / " .. math.floor(hum.MaxHealth)
                local hl = p.Character:FindFirstChild("T_HL") or Instance.new("Highlight", p.Character)
                hl.Name = "T_HL"; hl.Enabled = espEnabled; hl.FillColor = Color3.new(1,0,0); hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
            end
            if aimbotEnabled and head and hum and hum.Health > 0 then
                local pos, vis = Camera:WorldToViewportPoint(head.Position)
                if vis then
                    local m = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                    if m < dist then target = head; dist = m end
                end
            end
        end
    end
    if target and aimbotEnabled then Camera.CFrame = Camera.CFrame:Lerp(CFrame.new(Camera.CFrame.Position, target.Position), 0.8) end
end)

eBtn.MouseButton1Click:Connect(toggleK)
aBtn.MouseButton1Click:Connect(toggleL)

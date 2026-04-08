local Players = game:GetService("Players")
local lp = Players.LocalPlayer
local UIS = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TeleportService = game:GetService("TeleportService")

local attackEnabled = false
local attackRange = 30
local isMinimized = false
local lastAttackTime = 0
local attackCooldown = 0.25

local orbitEnabled = false
local orbitSpeed = 5.0
local orbitRadius = 5
local currentOrbitTarget = nil
local orbitAngle = 0

local screenGui = Instance.new("ScreenGui")
screenGui.Name = "AttackGUI"
screenGui.Parent = lp.PlayerGui
screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
screenGui.ResetOnSpawn = false

local mainFrame = Instance.new("Frame")
mainFrame.Size = UDim2.new(0, 240, 0, 240)
mainFrame.Position = UDim2.new(0.02, 0, 0.2, 0)
mainFrame.BackgroundColor3 = Color3.new(0.12, 0.12, 0.16)
mainFrame.BorderSizePixel = 0
mainFrame.ClipsDescendants = true
mainFrame.Parent = screenGui
mainFrame.Active = true
mainFrame.Draggable = true

local corner = Instance.new("UICorner")
corner.CornerRadius = UDim.new(0, 6)
corner.Parent = mainFrame

local titleBar = Instance.new("Frame")
titleBar.Size = UDim2.new(1, 0, 0, 26)
titleBar.BackgroundColor3 = Color3.new(0.18, 0.18, 0.24)
titleBar.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Size = UDim2.new(0.7, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = "NH 戒网瘾中心"
title.TextColor3 = Color3.new(1,1,1)
title.TextSize = 14
title.Font = Enum.Font.GothamBold
title.Parent = titleBar

local miniBtn = Instance.new("TextButton")
miniBtn.Size = UDim2.new(0, 24, 0, 24)
miniBtn.Position = UDim2.new(1, -50, 0, 1)
miniBtn.BackgroundTransparency = 1
miniBtn.Text = "—"
miniBtn.TextColor3 = Color3.new(1,1,1)
miniBtn.TextSize = 16
miniBtn.Parent = titleBar

local closeBtn = Instance.new("TextButton")
closeBtn.Size = UDim2.new(0, 24, 0, 24)
closeBtn.Position = UDim2.new(1, -26, 0, 1)
closeBtn.BackgroundTransparency = 1
closeBtn.Text = "×"
closeBtn.TextColor3 = Color3.new(1,0.3,0.3)
closeBtn.TextSize = 16
closeBtn.Parent = titleBar

local content = Instance.new("Frame")
content.Size = UDim2.new(1, 0, 1, -26)
content.Position = UDim2.new(0, 0, 0, 26)
content.BackgroundTransparency = 1
content.Parent = mainFrame

local statusLabel = Instance.new("TextLabel")
statusLabel.Size = UDim2.new(1, 0, 0, 22)
statusLabel.Position = UDim2.new(0, 0, 0, 4)
statusLabel.BackgroundTransparency = 1
statusLabel.Text = "状态：已关闭"
statusLabel.TextColor3 = Color3.new(0.9, 0.2, 0.2)
statusLabel.TextSize = 13
statusLabel.Font = Enum.Font.Gotham
statusLabel.Parent = content

local toggleButton = Instance.new("TextButton")
toggleButton.Size = UDim2.new(0, 80, 0, 28)
toggleButton.Position = UDim2.new(0.5, -40, 0, 30)
toggleButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.4)
toggleButton.Text = "关闭"
toggleButton.TextColor3 = Color3.new(1,1,1)
toggleButton.TextSize = 14
toggleButton.Font = Enum.Font.GothamBold
local toggleCorner = Instance.new("UICorner")
toggleCorner.CornerRadius = UDim.new(0, 4)
toggleCorner.Parent = toggleButton
toggleButton.Parent = content

local rangeLabel = Instance.new("TextLabel")
rangeLabel.Size = UDim2.new(1, 0, 0, 22)
rangeLabel.Position = UDim2.new(0, 0, 0, 62)
rangeLabel.BackgroundTransparency = 1
rangeLabel.Text = "当前范围："..attackRange
rangeLabel.TextColor3 = Color3.new(0.85,0.85,0.85)
rangeLabel.TextSize = 13
rangeLabel.Font = Enum.Font.Gotham
rangeLabel.Parent = content

local rangeInputBox = Instance.new("TextBox")
rangeInputBox.Size = UDim2.new(0, 80, 0, 25)
rangeInputBox.Position = UDim2.new(0, 10, 0, 86)
rangeInputBox.BackgroundColor3 = Color3.new(0.2, 0.2, 0.25)
rangeInputBox.TextColor3 = Color3.new(1,1,1)
rangeInputBox.Text = tostring(attackRange)
rangeInputBox.PlaceholderText = "数字"
rangeInputBox.TextSize = 13
rangeInputBox.Font = Enum.Font.Gotham
local inputCorner = Instance.new("UICorner")
inputCorner.CornerRadius = UDim.new(0, 4)
inputCorner.Parent = rangeInputBox
rangeInputBox.Parent = content

local confirmRangeBtn = Instance.new("TextButton")
confirmRangeBtn.Size = UDim2.new(0, 60, 0, 25)
confirmRangeBtn.Position = UDim2.new(1, -70, 0, 86)
confirmRangeBtn.BackgroundColor3 = Color3.new(0.25, 0.4, 0.65)
confirmRangeBtn.Text = "确认"
confirmRangeBtn.TextColor3 = Color3.new(1,1,1)
confirmRangeBtn.TextSize = 13
confirmRangeBtn.Font = Enum.Font.GothamBold
local btnCorner = Instance.new("UICorner")
btnCorner.CornerRadius = UDim.new(0, 4)
btnCorner.Parent = confirmRangeBtn
confirmRangeBtn.Parent = content

local orbitToggleButton = Instance.new("TextButton")
orbitToggleButton.Size = UDim2.new(0, 100, 0, 28)
orbitToggleButton.Position = UDim2.new(0.5, -50, 0, 118)
orbitToggleButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.4)
orbitToggleButton.Text = "环绕: 关"
orbitToggleButton.TextColor3 = Color3.new(1,1,1)
orbitToggleButton.TextSize = 13
orbitToggleButton.Font = Enum.Font.GothamBold
local orbitCorner = Instance.new("UICorner")
orbitCorner.CornerRadius = UDim.new(0, 4)
orbitCorner.Parent = orbitToggleButton
orbitToggleButton.Parent = content

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(0.5, 0, 0, 20)
speedLabel.Position = UDim2.new(0, 10, 0, 152)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "环绕速度: " .. orbitSpeed
speedLabel.TextColor3 = Color3.new(0.85,0.85,0.85)
speedLabel.TextSize = 12
speedLabel.Font = Enum.Font.Gotham
speedLabel.Parent = content

local speedSlider = Instance.new("TextBox")
speedSlider.Size = UDim2.new(0, 100, 0, 25)
speedSlider.Position = UDim2.new(1, -110, 0, 150)
speedSlider.BackgroundColor3 = Color3.new(0.2, 0.2, 0.25)
speedSlider.TextColor3 = Color3.new(1,1,1)
speedSlider.Text = tostring(orbitSpeed)
speedSlider.PlaceholderText = "1-1000"
speedSlider.TextSize = 13
speedSlider.Font = Enum.Font.Gotham
local speedCorner = Instance.new("UICorner")
speedCorner.CornerRadius = UDim.new(0, 4)
speedCorner.Parent = speedSlider
speedSlider.Parent = content

local confirmSpeedBtn = Instance.new("TextButton")
confirmSpeedBtn.Size = UDim2.new(0, 50, 0, 25)
confirmSpeedBtn.Position = UDim2.new(1, -55, 0, 150)
confirmSpeedBtn.BackgroundColor3 = Color3.new(0.25, 0.4, 0.65)
confirmSpeedBtn.Text = "设速"
confirmSpeedBtn.TextColor3 = Color3.new(1,1,1)
confirmSpeedBtn.TextSize = 12
confirmSpeedBtn.Font = Enum.Font.GothamBold
local speedBtnCorner = Instance.new("UICorner")
speedBtnCorner.CornerRadius = UDim.new(0, 4)
speedBtnCorner.Parent = confirmSpeedBtn
confirmSpeedBtn.Parent = content

local tipLabel = Instance.new("TextLabel")
tipLabel.Size = UDim2.new(1, 0, 0, 18)
tipLabel.Position = UDim2.new(0, 0, 0, 185)
tipLabel.BackgroundTransparency = 1
tipLabel.Text = "攻击开关:0 | 环绕开关: 按钮"
tipLabel.TextColor3 = Color3.new(0.55,0.55,0.6)
tipLabel.TextSize = 11
tipLabel.Font = Enum.Font.Gotham
tipLabel.Parent = content

local function updateUI()
    if attackEnabled then
        statusLabel.Text = "状态：已开启"
        statusLabel.TextColor3 = Color3.new(0.2, 0.9, 0.3)
        toggleButton.Text = "开启"
        toggleButton.BackgroundColor3 = Color3.new(0.2, 0.6, 0.2)
    else
        statusLabel.Text = "状态：已关闭"
        statusLabel.TextColor3 = Color3.new(0.9, 0.2, 0.2)
        toggleButton.Text = "关闭"
        toggleButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.4)
    end
    rangeLabel.Text = "当前范围：" .. attackRange
    rangeInputBox.Text = tostring(attackRange)
    speedLabel.Text = "环绕速度: " .. string.format("%.2f", orbitSpeed)
end

toggleButton.MouseButton1Click:Connect(function()
    attackEnabled = not attackEnabled
    updateUI()
end)

confirmRangeBtn.MouseButton1Click:Connect(function()
    local num = tonumber(rangeInputBox.Text)
    if num and num > 0 then
        attackRange = math.floor(num)
        if attackRange > 200 then attackRange = 200 end
        if attackRange < 5 then attackRange = 5 end
        updateUI()
    else
        rangeInputBox.Text = tostring(attackRange)
    end
end)

orbitToggleButton.MouseButton1Click:Connect(function()
    orbitEnabled = not orbitEnabled
    if orbitEnabled then
        orbitToggleButton.Text = "环绕: 开"
        orbitToggleButton.BackgroundColor3 = Color3.new(0.2, 0.6, 0.2)
        currentOrbitTarget = nil
        orbitAngle = 0
    else
        orbitToggleButton.Text = "环绕: 关"
        orbitToggleButton.BackgroundColor3 = Color3.new(0.3, 0.3, 0.4)
        currentOrbitTarget = nil
    end
end)

confirmSpeedBtn.MouseButton1Click:Connect(function()
    local num = tonumber(speedSlider.Text)
    if num then
        orbitSpeed = math.clamp(num, 1, 1000)
        speedSlider.Text = tostring(orbitSpeed)
        updateUI()
    else
        speedSlider.Text = tostring(orbitSpeed)
    end
end)

miniBtn.MouseButton1Click:Connect(function()
    isMinimized = not isMinimized
    if isMinimized then
        mainFrame.Size = UDim2.new(0, 240, 0, 26)
        miniBtn.Text = "+"
        content.Visible = false
    else
        mainFrame.Size = UDim2.new(0, 240, 0, 240)
        miniBtn.Text = "—"
        content.Visible = true
    end
end)

closeBtn.MouseButton1Click:Connect(function()
    screenGui:Destroy()
end)

UIS.InputBegan:Connect(function(input, gameProcessed)
    if gameProcessed then return end
    if input.KeyCode == Enum.KeyCode.Zero then
        attackEnabled = not attackEnabled
        updateUI()
    end
end)

local function getWeapon()
    local weapon = lp.Backpack:FindFirstChild("拳头")
    if not weapon then
        weapon = lp.Character:FindFirstChild("拳头")
    end
    return weapon
end

local function getAttackRemote(weapon)
    if weapon and weapon:FindFirstChild("Attack") and weapon.Attack.ClassName == "RemoteEvent" then
        return weapon.Attack
    end
    return nil
end

local function findNearestEnemy()
    if not lp.Character or not lp.Character:FindFirstChild("HumanoidRootPart") then
        return nil
    end
    local myRoot = lp.Character.HumanoidRootPart
    local nearest = nil
    local minDist = math.huge
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= lp and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local plrRoot = plr.Character.HumanoidRootPart
            local dist = (myRoot.Position - plrRoot.Position).Magnitude
            if dist < minDist and dist <= attackRange then
                minDist = dist
                nearest = plr
            end
        end
    end
    return nearest
end

local function getNearestAlivePlayer()
    local nearest = nil
    local minDist = math.huge
    local myPos = lp.Character and lp.Character:FindFirstChild("HumanoidRootPart") and lp.Character.HumanoidRootPart.Position
    if not myPos then return nil end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= lp and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local humanoid = plr.Character:FindFirstChild("Humanoid")
            if humanoid and humanoid.Health > 0 then
                local targetPos = plr.Character.HumanoidRootPart.Position
                local dist = (myPos - targetPos).Magnitude
                if dist < minDist then
                    minDist = dist
                    nearest = plr
                end
            end
        end
    end
    return nearest
end

local function updateOrbitTarget()
    if not orbitEnabled then
        currentOrbitTarget = nil
        return
    end
    if not currentOrbitTarget or not currentOrbitTarget.Character or not currentOrbitTarget.Character:FindFirstChild("Humanoid") or currentOrbitTarget.Character.Humanoid.Health <= 0 then
        currentOrbitTarget = getNearestAlivePlayer()
    end
end

local lastFrame = tick()
RunService.RenderStepped:Connect(function(deltaTime)
    local dt = math.min(0.05, deltaTime)
    
    if attackEnabled then
        local currentTime = tick()
        if currentTime - lastAttackTime >= attackCooldown then
            local weapon = getWeapon()
            if weapon then
                local attackRemote = getAttackRemote(weapon)
                if attackRemote then
                    local target = findNearestEnemy()
                    if target then
                        lastAttackTime = currentTime
                        attackRemote:FireServer(target)
                        attackCooldown = math.random(20, 35) / 100
                    end
                end
            end
        end
    end
    
    if orbitEnabled then
        updateOrbitTarget()
        if currentOrbitTarget and currentOrbitTarget.Character then
            local targetChar = currentOrbitTarget.Character
            local targetRoot = targetChar:FindFirstChild("HumanoidRootPart")
            local myChar = lp.Character
            if targetRoot and myChar then
                local myRoot = myChar:FindFirstChild("HumanoidRootPart")
                local humanoid = myChar:FindFirstChild("Humanoid")
                if myRoot and humanoid and humanoid.Health > 0 then
                    orbitAngle = orbitAngle + orbitSpeed * dt * 60
                    if orbitAngle > 360 then orbitAngle = orbitAngle - 360 end
                    local angleRad = math.rad(orbitAngle)
                    local offsetX = math.cos(angleRad) * orbitRadius
                    local offsetZ = math.sin(angleRad) * orbitRadius
                    local targetPos = targetRoot.Position
                    local newPos = targetPos + Vector3.new(offsetX, 0, offsetZ)
                    newPos = Vector3.new(newPos.X, targetPos.Y + 1, newPos.Z)
                    myRoot.CFrame = CFrame.new(newPos, targetPos)
                end
            end
        end
    end
end)

local function fakeActivity()
    if math.random(1, 100) > 90 then
        local _ = workspace.CurrentCamera.CFrame
        local _ = math.random()
        task.wait(math.random(1, 3) / 10)
    end
end

spawn(function()
    while true do
        task.wait(math.random(45, 75))
        fakeActivity()
    end
end)

local oldNamecall
oldNamecall = hookmetamethod(game, "__namecall", function(self, ...)
    local method = getnamecallmethod()
    if method == "FireServer" and tostring(self):find("Attack") and attackEnabled then
        if math.random(1, 100) > 97 then
            return oldNamecall(self, ...)
        end
    end
    return oldNamecall(self, ...)
end)

local function antiKick()
    local oldKick = game.Players.LocalPlayer.Kick
    game.Players.LocalPlayer.Kick = function(...) end
    local oldTeleport = TeleportService.Teleport
    TeleportService.Teleport = function(...) end
end
pcall(antiKick)

local function randomizeInputs()
    local mouse = lp:GetMouse()
    if mouse then
        local originalMove = mouse.Move
        mouse.Move = function(...) end
    end
end
pcall(randomizeInputs)

updateUI()
-- 如果你想要学习的话，你就全部复制就行了

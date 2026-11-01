-- ============================================================
-- 🦅 ARCANIX v2.0 (Part 1: Key System & Anti-Kick)
-- ============================================================

local P = game:GetService("Players")
local U = game:GetService("UserInputService")
local R = game:GetService("RunService")
local T = game:GetService("TweenService")
local L = game:GetService("Lighting")
local W = game:GetService("Workspace")
local C = game:GetService("CoreGui")
local LP = P.LocalPlayer
local Camera = W.CurrentCamera

-- ANTI-KICK (Защита от выкидывания)
pcall(function()
    local mt = getrawmetatable(game)
    local old = mt.__namecall
    setreadonly(mt, false)
    mt.__namecall = newcclosure(function(self, ...)
        local method = getnamecallmethod()
        if method == "Kick" and not checkcaller() then
            return nil
        end
        return old(self, ...)
    end)
    setreadonly(mt, true)
end)

local function protect(gui)
    if gethui then pcall(function() gui.Parent = gethui() end) 
    elseif syn and syn.protect_gui then pcall(function() syn.protect_gui(gui) end) 
    else gui.Parent = C end
end

local function corner(o, r) local c = Instance.new("UICorner") c.CornerRadius = UDim.new(0, r) c.Parent = o end
local function stroke(o, c, t, tr) local s = Instance.new("UIStroke") s.Color = c s.Thickness = t s.Transparency = tr or 0 s.Parent = o return s end

-- ==========================================
-- СИСТЕМА КЛЮЧА И БАНА
-- ==========================================
local banFile = "ArcanixBanV5.txt"
local isBanned = false
local banEndTime = 0
local hasFS = writefile and readfile and isfile

if hasFS and isfile(banFile) then
    local s, t = pcall(function() return tonumber(readfile(banFile)) end)
    if s and t and t > os.time() then isBanned = true; banEndTime = t end
end
if not isBanned and getgenv().ArcBan and getgenv().ArcBan > os.time() then isBanned = true; banEndTime = getgenv().ArcBan end

local keyGui = Instance.new("ScreenGui")
keyGui.IgnoreGuiInset = true
protect(keyGui)

local bg = Instance.new("Frame")
bg.Size = UDim2.new(1,0,1,0)
bg.BackgroundColor3 = Color3.fromRGB(10,10,15)
bg.Parent = keyGui

local tnt = Instance.new("ImageLabel")
tnt.Size = UDim2.new(0,100,0,100)
tnt.AnchorPoint = Vector2.new(0.5,0.5)
tnt.Position = UDim2.new(0.5,0,-0.2,0)
tnt.BackgroundTransparency = 1
tnt.Image = "rbxassetid://1007305922"
tnt.Parent = keyGui

local flash = Instance.new("Frame")
flash.Size = UDim2.new(1,0,1,0)
flash.BackgroundColor3 = Color3.fromRGB(255,255,255)
flash.BackgroundTransparency = 1
flash.Parent = keyGui

local kFrame = Instance.new("Frame")
kFrame.Size = UDim2.new(0,300,0,200)
kFrame.Position = UDim2.new(0.5,-150,0.5,-100)
kFrame.BackgroundColor3 = Color3.fromRGB(25,25,30)
kFrame.Visible = false
kFrame.Parent = keyGui
corner(kFrame, 12)
stroke(kFrame, Color3.fromRGB(80, 150, 255), 2)

local kTitle = Instance.new("TextLabel")
kTitle.Size = UDim2.new(1,0,0,40)
kTitle.BackgroundTransparency = 1
kTitle.Text = "🔒 ARCANIX KEY"
kTitle.TextColor3 = Color3.fromRGB(255,255,255)
kTitle.Font = Enum.Font.GothamBold
kTitle.TextSize = 18
kTitle.Parent = kFrame

local kTimer = Instance.new("TextLabel")
kTimer.Size = UDim2.new(1,0,0,20)
kTimer.Position = UDim2.new(0,0,0,35)
kTimer.BackgroundTransparency = 1
kTimer.TextColor3 = Color3.fromRGB(255,200,50)
kTimer.Font = Enum.Font.GothamBold
kTimer.TextSize = 14
kTimer.Parent = kFrame

local kInput = Instance.new("TextBox")
kInput.Size = UDim2.new(0,260,0,40)
kInput.Position = UDim2.new(0,20,0,60)
kInput.BackgroundColor3 = Color3.fromRGB(40,40,45)
kInput.TextColor3 = Color3.fromRGB(255,255,255)
kInput.Font = Enum.Font.Gotham
kInput.TextSize = 16
kInput.Parent = kFrame
corner(kInput, 6)

local kBtn = Instance.new("TextButton")
kBtn.Size = UDim2.new(0,260,0,40)
kBtn.Position = UDim2.new(0,20,0,110)
kBtn.BackgroundColor3 = Color3.fromRGB(80, 150, 255)
kBtn.Text = "ПРОВЕРИТЬ"
kBtn.TextColor3 = Color3.fromRGB(255,255,255)
kBtn.Font = Enum.Font.GothamBold
kBtn.TextSize = 16
kBtn.Parent = kFrame
corner(kBtn, 6)

local kErr = Instance.new("TextLabel")
kErr.Size = UDim2.new(1,0,0,20)
kErr.Position = UDim2.new(0,0,1,-25)
kErr.BackgroundTransparency = 1
kErr.TextColor3 = Color3.fromRGB(255,80,80)
kErr.Font = Enum.Font.Gotham
kErr.TextSize = 12
kErr.Parent = kFrame

-- Анимация динамита
task.spawn(function()
    task.wait(0.5)
    T:Create(tnt, TweenInfo.new(0.6, Enum.EasingStyle.Bounce), {Position = UDim2.new(0.5,0,0.5,0)}):Play()
    task.wait(0.8)
    T:Create(flash, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
    T:Create(tnt, TweenInfo.new(0.3), {Size = UDim2.new(0,300,0,300), ImageTransparency = 1}):Play()
    task.wait(0.3)
    T:Create(flash, TweenInfo.new(0.4), {BackgroundTransparency = 1}):Play()
    kFrame.Visible = true
    tnt:Destroy()
end)

local attempts = 0
local function showBanUI()
    kInput.Text = "🔒"
    kInput.TextEditable = false
    kInput.BackgroundColor3 = Color3.fromRGB(50,50,50)
    kBtn.Active = false
    kBtn.Text = "ЗАБЛОКИРОВАНО"
    kBtn.BackgroundColor3 = Color3.fromRGB(100,50,50)
    kErr.Text = "ВЫ ЗАБЛОКИРОВАНЫ НА 24 ЧАСА"
    
    task.spawn(function()
        while isBanned do
            local t = banEndTime - os.time()
            if t <= 0 then
                isBanned = false
                if hasFS and isfile(banFile) then pcall(function() delfile(banFile) end) end
                getgenv().ArcBan = nil
                kInput.Text = ""
                kInput.TextEditable = true
                kInput.BackgroundColor3 = Color3.fromRGB(40,40,45)
                kBtn.Active = true
                kBtn.Text = "ПРОВЕРИТЬ"
                kBtn.BackgroundColor3 = Color3.fromRGB(80, 150, 255)
                kErr.Text = ""
                kTimer.Text = ""
                attempts = 0
                break
            end
            kTimer.Text = string.format("⏳ %02d:%02d:%02d", math.floor(t/3600), math.floor((t%3600)/60), t%60)
            task.wait(1)
        end
    end)
end
if isBanned then task.wait(2.5); showBanUI() end

local function LoadArcanix()
    print("Ключ верный. Запуск меню...")
    keyGui:Destroy()
    -- Сюда будет вставлена Часть 2
end

kBtn.MouseButton1Click:Connect(function()
    if isBanned then return end
    if kInput.Text == "free" then
        kBtn.Text = "УСПЕХ!"
        kBtn.BackgroundColor3 = Color3.fromRGB(80,255,130)
        task.wait(0.5)
        LoadArcanix()
    else
        attempts = attempts + 1
        kErr.Text = "Неверный ключ! Попытка " .. attempts .. "/10"
        kInput.Text = ""
        
        if attempts >= 10 then
            isBanned = true
            banEndTime = os.time() + 86400
            if hasFS then pcall(function() writefile(banFile, tostring(banEndTime)) end) else getgenv().ArcBan = banEndTime end
            showBanUI()
        else
            local op = kFrame.Position
            for i = 1, 4 do
                T:Create(kFrame, TweenInfo.new(0.05), {Position = op + UDim2.new(0,10,0,0)}):Play()
                task.wait(0.05)
                T:Create(kFrame, TweenInfo.new(0.05), {Position = op - UDim2.new(0,10,0,0)}):Play()
                task.wait(0.05)
            end
            T:Create(kFrame, TweenInfo.new(0.05), {Position = op}):Play()
        end
    end
end)
-- ============================================================
-- 🦅 ARCANIX v2.0 (Part 2: Main UI & Profile)
-- ============================================================

local ESP_Enabled = false
local RoleESP_Enabled = false
local Names_Enabled = false
local TeamCheck = false
local AutoGun_Enabled = false
local FPS_Boost_Enabled = false

local Accent = Color3.fromRGB(130, 80, 255)
local Theme = "Dark"
local Themes = {
    Dark = { Bg = Color3.fromRGB(20, 20, 25), Side = Color3.fromRGB(25, 25, 30), Text = Color3.fromRGB(240, 240, 240), Sub = Color3.fromRGB(35, 35, 40) },
    Light = { Bg = Color3.fromRGB(240, 240, 245), Side = Color3.fromRGB(220, 220, 225), Text = Color3.fromRGB(30, 30, 30), Sub = Color3.fromRGB(255, 255, 255) }
}

local gui = Instance.new("ScreenGui")
gui.Name = "ArcanixMain"
gui.IgnoreGuiInset = true
protect(gui)

-- НОВАЯ КНОПКА (БЕЗ ВОРОНА)
local toggleBtn = Instance.new("TextButton")
toggleBtn.Size = UDim2.new(0, 75, 0, 60)
toggleBtn.Position = UDim2.new(0, 15, 0.5, -30)
toggleBtn.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
toggleBtn.Text = "ARCANIX\nv2.0"
toggleBtn.TextColor3 = Accent
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.TextSize = 13
toggleBtn.TextWrapped = true
toggleBtn.AutoButtonColor = false
toggleBtn.Parent = gui
corner(toggleBtn, 12)
stroke(toggleBtn, Accent, 2)

-- ГЛАВНОЕ ОКНО (CanvasGroup для плавности)
local win = Instance.new("CanvasGroup")
win.AnchorPoint = Vector2.new(0.5, 0.5)
win.Position = UDim2.new(0.5, 0, 0.5, 0)
win.Size = UDim2.new(0, 520, 0, 340)
win.BackgroundColor3 = Themes[Theme].Bg
win.GroupTransparency = 1
win.Visible = false
win.ClipsDescendants = true
win.Parent = gui
corner(win, 12)
stroke(win, Color3.fromRGB(50, 50, 60), 1.5)

local uiScale = Instance.new("UIScale")
uiScale.Scale = 1
uiScale.Parent = win

local winGrad = Instance.new("UIGradient")
winGrad.Color = ColorSequence.new(Themes[Theme].Bg, Themes[Theme].Bg)
winGrad.Rotation = 90
winGrad.Parent = win

-- САЙДБАР
local side = Instance.new("Frame")
side.Size = UDim2.new(0, 150, 1, 0)
side.BackgroundColor3 = Themes[Theme].Side
side.BorderSizePixel = 0
side.Parent = win

local logo = Instance.new("TextLabel")
logo.Size = UDim2.new(1, 0, 0, 45)
logo.BackgroundTransparency = 1
logo.Text = "ARCANIX"
logo.TextColor3 = Accent
logo.Font = Enum.Font.GothamBold
logo.TextSize = 20
logo.Parent = side

-- ПРОФИЛЬ ИГРОКА (Ник и Аватарка внизу слева)
local profileFrame = Instance.new("Frame")
profileFrame.Size = UDim2.new(1, -20, 0, 45)
profileFrame.Position = UDim2.new(0, 10, 1, -55)
profileFrame.BackgroundColor3 = Themes[Theme].Sub
profileFrame.Parent = side
corner(profileFrame, 8)

local avatar = Instance.new("ImageLabel")
avatar.Size = UDim2.new(0, 30, 0, 30)
avatar.Position = UDim2.new(0, 8, 0.5, -15)
avatar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
avatar.Image = "rbxthumb://type=AvatarHeadShot&id=" .. LP.UserId .. "&w=150&h=150"
avatar.Parent = profileFrame
corner(avatar, 15)

local pName = Instance.new("TextLabel")
pName.Size = UDim2.new(1, -45, 1, 0)
pName.Position = UDim2.new(0, 45, 0, 0)
pName.BackgroundTransparency = 1
pName.Text = LP.Name -- Скрипт сам подставит PUSKAPUSKA
pName.TextColor3 = Accent
pName.Font = Enum.Font.GothamBold
pName.TextSize = 13
pName.TextXAlignment = Enum.TextXAlignment.Left
pName.TextTruncate = Enum.TextTruncate.AtEnd
pName.Parent = profileFrame

-- КОНТЕНТ
local content = Instance.new("Frame")
content.Size = UDim2.new(1, -160, 1, -20)
content.Position = UDim2.new(0, 155, 0, 10)
content.BackgroundTransparency = 1
content.Parent = win

local pages = {}
local function makePage(name, visible)
    local p = Instance.new("ScrollingFrame")
    p.Size = UDim2.new(1, 0, 1, 0)
    p.BackgroundTransparency = 1
    p.ScrollBarThickness = 2
    p.ScrollBarImageColor3 = Accent
    p.CanvasSize = UDim2.new(0, 0, 0, 0)
    p.AutomaticCanvasSize = Enum.AutomaticSize.Y
    p.Visible = visible
    p.Parent = content
    local l = Instance.new("UIListLayout")
    l.Padding = UDim.new(0, 8)
    l.SortOrder = Enum.SortOrder.LayoutOrder
    l.Parent = p
    pages[name] = p
end

makePage("ESP", true)
makePage("AimBot", false)
makePage("Misc", false)
makePage("Settings", false)

-- ВКЛАДКИ
local tabESP, tabAim, tabMisc, tabSet
local function makeTab(name, text, yPos)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -20, 0, 35)
    btn.Position = UDim2.new(0, 10, 0, yPos)
    btn.BackgroundColor3 = Themes[Theme].Sub
    btn.Text = text
    btn.TextColor3 = Themes[Theme].Text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    btn.Parent = side
    corner(btn, 8)
    
    btn.MouseButton1Click:Connect(function()
        for _, p in pairs(pages) do p.Visible = false end
        pages[name].Visible = true
        for _, v in pairs(side:GetChildren()) do
            if v:IsA("TextButton") and v ~= toggleBtn then
                T:Create(v, TweenInfo.new(0.2), {BackgroundColor3 = Themes[Theme].Sub, TextColor3 = Themes[Theme].Text}):Play()
            end
        end
        T:Create(btn, TweenInfo.new(0.2), {BackgroundColor3 = Accent, TextColor3 = Color3.fromRGB(255,255,255)}):Play()
    end)
    return btn
end

tabESP = makeTab("ESP", "Визуалы", 50)
tabAim = makeTab("AimBot", "Aimbot", 90)
tabMisc = makeTab("Misc", "Misc", 130)
tabSet = makeTab("Settings", "Настройки", 170)

tabESP.BackgroundColor3 = Accent
tabESP.TextColor3 = Color3.fromRGB(255, 255, 255)

-- АНИМАЦИЯ ОТКРЫТИЯ
local isOpen = false
local function toggleMenu(open)
    if open and not isOpen then
        isOpen = true
        win.Visible = true
        win.GroupTransparency = 1
        uiScale.Scale = 0.3
        T:Create(win, TweenInfo.new(0.4, Enum.EasingStyle.Quint), {GroupTransparency = 0}):Play()
        T:Create(uiScale, TweenInfo.new(0.5, Enum.EasingStyle.Elastic), {Scale = 1}):Play()
    elseif not open and isOpen then
        isOpen = false
        local t1 = T:Create(win, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {GroupTransparency = 1})
        local t2 = T:Create(uiScale, TweenInfo.new(0.3, Enum.EasingStyle.Quad), {Scale = 0.3})
        t1:Play(); t2:Play()
        t1.Completed:Connect(function()
            if not isOpen then win.Visible = false end
        end)
    end
end

toggleBtn.MouseButton1Click:Connect(function()
    toggleMenu(not isOpen)
end)

-- ПЕРЕТАСКИВАНИЕ
local function drag(frame, target)
    local d, s, p
    target.InputBegan:Connect(function(i) 
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then 
            d = true; s = i.Position; p = frame.Position 
        end 
    end)
    U.InputChanged:Connect(function(i) 
        if d and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then 
            local delta = i.Position - s 
            frame.Position = UDim2.new(p.X.Scale, p.X.Offset + delta.X, p.Y.Scale, p.Y.Offset + delta.Y) 
        end 
    end)
    U.InputEnded:Connect(function(i) 
        if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then 
            d = false 
        end 
    end)
end
drag(win, side)

-- Привязка к ключу из Части 1
local originalLoadArcanix = LoadArcanix
LoadArcanix = function()
    originalLoadArcanix()
    toggleMenu(true)
end
-- ============================================================
-- 🦅 ARCANIX v2.0 (Part 3: ESP, Role ESP & FPS Boost)
-- ============================================================

-- Функция создания тумблера (для меню)
local function createToggle(parent, txt, default, cb)
    local h = Instance.new("Frame")
    h.Size = UDim2.new(1, 0, 0, 38)
    h.BackgroundColor3 = Themes[Theme].Sub
    h.Parent = parent
    corner(h, 8)

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -50, 1, 0)
    l.Position = UDim2.new(0, 12, 0, 0)
    l.BackgroundTransparency = 1
    l.Text = txt
    l.TextColor3 = Themes[Theme].Text
    l.Font = Enum.Font.Gotham
    l.TextSize = 13
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = h

    local sw = Instance.new("Frame")
    sw.Size = UDim2.new(0, 34, 0, 18)
    sw.Position = UDim2.new(1, -46, 0.5, -9)
    sw.BackgroundColor3 = default and Accent or Color3.fromRGB(60, 60, 65)
    sw.Parent = h
    corner(sw, 9)

    local kn = Instance.new("Frame")
    kn.Size = UDim2.new(0, 14, 0, 14)
    kn.Position = default and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    kn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    kn.Parent = sw
    corner(kn, 7)

    local isOn = default
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = h
    btn.MouseButton1Click:Connect(function()
        isOn = not isOn
        local tp = isOn and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        local tc = isOn and Accent or Color3.fromRGB(60, 60, 65)
        T:Create(kn, TweenInfo.new(0.2), {Position = tp}):Play()
        T:Create(sw, TweenInfo.new(0.2), {BackgroundColor3 = tc}):Play()
        if cb then cb(isOn) end
    end)
    return h
end

-- ДОБАВЛЯЕМ ТУМБЛЕРЫ В ИНТЕРФЕЙС
createToggle(pages["ESP"], "Включить ESP", false, function(v) ESP_Enabled = v end)
createToggle(pages["ESP"], "Role ESP (MM2)", false, function(v) RoleESP_Enabled = v end)
createToggle(pages["ESP"], "Показывать Ники", false, function(v) Names_Enabled = v end)
createToggle(pages["ESP"], "Игнорировать союзников", false, function(v) TeamCheck = v end)

createToggle(pages["Misc"], "MAX FPS BOOST", false, function(v) 
    FPS_Boost_Enabled = v 
    if v then
        L.GlobalShadows = false
        L.FogEnd = 100000
        L.Brightness = 2
        L.EnvironmentDiffuseScale = 0
        L.EnvironmentSpecularScale = 0
        task.spawn(function()
            for _, obj in ipairs(W:GetDescendants()) do
                if obj:IsA("ParticleEmitter") or obj:IsA("Smoke") or obj:IsA("Fire") or obj:IsA("Sparkles") then
                    obj.Enabled = false
                elseif obj:IsA("Decal") or obj:IsA("Texture") then
                    obj.Transparency = 1
                end
            end
            if W:FindFirstChildOfClass("Terrain") then
                W.Terrain.WaterWaveSize = 0
                W.Terrain.WaterTransparency = 1
            end
        end)
    else
        L.GlobalShadows = true
        L.FogEnd = 10000
        L.Brightness = 3
        L.EnvironmentDiffuseScale = 0.5
        L.EnvironmentSpecularScale = 0.5
    end
end)

-- ==========================================
-- ЛОГИКА ESP И ROLE ESP
-- ==========================================
local ActiveESP = {}
local RoleColors = {
    Murderer = Color3.fromRGB(255, 50, 50),
    Sheriff = Color3.fromRGB(50, 100, 255),
    Innocent = Color3.fromRGB(50, 255, 100)
}

local function getRole(plr)
    if not RoleESP_Enabled then return "Innocent" end
    local char = plr.Character
    if not char then return "Innocent" end
    
    -- Проверка рук
    if char:FindFirstChild("Knife") then return "Murderer" end
    if char:FindFirstChild("Gun") or char:FindFirstChild("Revolver") then return "Sheriff" end
    
    -- Проверка рюкзака
    local bp = plr:FindFirstChild("Backpack")
    if bp then
        if bp:FindFirstChild("Knife") then return "Murderer" end
        if bp:FindFirstChild("Gun") or bp:FindFirstChild("Revolver") then return "Sheriff" end
    end
    
    -- Проверка атрибутов (для некоторых версий)
    if plr:GetAttribute("Role") == "Murderer" then return "Murderer" end
    if plr:GetAttribute("Role") == "Sheriff" then return "Sheriff" end
    
    return "Innocent"
end

-- Цикл обновления ESP
R.Heartbeat:Connect(function()
    for _, plr in ipairs(P:GetPlayers()) do
        if plr ~= LP and plr.Character and plr.Character:FindFirstChild("HumanoidRootPart") then
            local role = getRole(plr)
            local isTeam = TeamCheck and plr.Team == LP.Team
            local shouldShow = (ESP_Enabled or RoleESP_Enabled) and not isTeam

            if not shouldShow then
                if ActiveESP[plr] then
                    ActiveESP[plr].hl:Destroy()
                    ActiveESP[plr].bb:Destroy()
                    ActiveESP[plr] = nil
                end
            else
                if not ActiveESP[plr] or ActiveESP[plr].hl.Adornee ~= plr.Character then
                    if ActiveESP[plr] then
                        ActiveESP[plr].hl:Destroy()
                        ActiveESP[plr].bb:Destroy()
                    end
                    local hl = Instance.new("Highlight")
                    hl.Adornee = plr.Character
                    hl.FillTransparency = 0.5
                    hl.OutlineTransparency = 0
                    hl.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    hl.Parent = C

                    local bb = Instance.new("BillboardGui")
                    bb.Size = UDim2.new(0, 200, 0, 50)
                    bb.StudsOffset = Vector3.new(0, 2.5, 0)
                    bb.AlwaysOnTop = true
                    bb.Adornee = plr.Character:FindFirstChild("Head") or plr.Character
                    bb.Parent = C

                    local nl = Instance.new("TextLabel")
                    nl.Size = UDim2.new(1, 0, 1, 0)
                    nl.BackgroundTransparency = 1
                    nl.Text = plr.Name
                    nl.TextStrokeTransparency = 0
                    nl.TextSize = 14
                    nl.Font = Enum.Font.Arcade
                    nl.Parent = bb

                    ActiveESP[plr] = { hl = hl, bb = bb, nl = nl }
                end
                
                -- Применяем цвет в зависимости от роли
                local currentColor = RoleESP_Enabled and RoleColors[role] or Accent
                ActiveESP[plr].hl.FillColor = currentColor
                ActiveESP[plr].hl.OutlineColor = currentColor
                ActiveESP[plr].nl.TextColor3 = currentColor
                ActiveESP[plr].bb.Enabled = Names_Enabled
            end
        end
    end
end)

P.PlayerRemoving:Connect(function(p)
    if ActiveESP[p] then
        ActiveESP[p].hl:Destroy()
        ActiveESP[p].bb:Destroy()
        ActiveESP[p] = nil
    end
end)
-- ============================================================
-- 🦅 ARCANIX v2.0 (Part 4: Auto Gun & Settings)
-- ============================================================

-- ==========================================
-- AUTO GUN ЛОГИКА (Для MM2 и подобных)
-- ==========================================
local isTPing = false

task.spawn(function()
    while task.wait(0.5) do
        if AutoGun_Enabled and not isTPing and LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            local myHRP = LP.Character.HumanoidRootPart
            
            -- Ищем упавшее оружие в Workspace (Knife, Gun, Revolver)
            for _, obj in ipairs(W:GetChildren()) do
                if obj:IsA("Tool") or (obj:IsA("Model") and (obj.Name == "Knife" or obj.Name == "Gun" or obj.Name == "Revolver")) then
                    -- Проверяем, не в руках ли оно у кого-то (если Parent = Character)
                    if not obj.Parent:IsA("Model") then
                        isTPing = true
                        local originalPos = myHRP.CFrame
                        
                        -- Телепорт к оружию
                        local targetPos = obj:IsA("Model") and obj:GetPivot().Position or obj.Handle.Position
                        myHRP.CFrame = CFrame.new(targetPos)
                        task.wait(0.1)
                        
                        -- Подбираем (если это Tool)
                        pcall(function()
                            if obj:IsA("Tool") then
                                obj.Parent = LP.Backpack
                            end
                        end)
                        task.wait(0.1)
                        
                        -- Возврат на место
                        myHRP.CFrame = originalPos
                        task.wait(1) -- Кулдаун, чтобы не спамить
                        isTPing = false
                        break
                    end
                end
            end
        end
    end
end)

-- Включаем Auto Gun в меню Misc
createToggle(pages["Misc"], "Auto Gun (MM2)", false, function(v) 
    AutoGun_Enabled = v 
end)

-- ==========================================
-- НАСТРОЙКИ (СМЕНА ТЕМЫ)
-- ==========================================
local themeBtn = Instance.new("TextButton")
themeBtn.Size = UDim2.new(1, 0, 0, 38)
themeBtn.BackgroundColor3 = Themes[Theme].Sub
themeBtn.Text = "Тема: " .. Theme
themeBtn.TextColor3 = Themes[Theme].Text
themeBtn.Font = Enum.Font.GothamBold
themeBtn.TextSize = 14
themeBtn.Parent = pages["Settings"]
corner(themeBtn, 8)

local function updateTheme()
    T:Create(win, TweenInfo.new(0.3), {BackgroundColor3 = Themes[Theme].Bg}):Play()
    T:Create(side, TweenInfo.new(0.3), {BackgroundColor3 = Themes[Theme].Side}):Play()
    T:Create(profileFrame, TweenInfo.new(0.3), {BackgroundColor3 = Themes[Theme].Sub}):Play()
    winGrad.Color = ColorSequence.new(Themes[Theme].Bg, Themes[Theme].Bg)
    
    -- Обновляем все элементы в меню
    for _, p in pairs(pages) do
        for _, child in ipairs(p:GetChildren()) do
            if child:IsA("Frame") then
                child.BackgroundColor3 = Themes[Theme].Sub
                local lbl = child:FindFirstChildOfClass("TextLabel")
                if lbl then lbl.TextColor3 = Themes[Theme].Text end
            end
        end
    end
    
    for _, child in ipairs(side:GetChildren()) do
        if child:IsA("TextButton") and child ~= tabESP and child ~= tabAim and child ~= tabMisc and child ~= tabSet then
            child.BackgroundColor3 = Themes[Theme].Sub
            child.TextColor3 = Themes[Theme].Text
        end
    end
    T:Create(themeBtn, TweenInfo.new(0.3), {BackgroundColor3 = Themes[Theme].Sub, TextColor3 = Themes[Theme].Text}):Play()
end

themeBtn.MouseButton1Click:Connect(function()
    Theme = (Theme == "Dark") and "Light" or "Dark"
    themeBtn.Text = "Тема: " .. Theme
    updateTheme()
end)

-- ==========================================
-- ЗАПУСК СКРИПТА (Привязка к ключу)
-- ==========================================
-- Переопределяем функцию из Части 1, чтобы она открывала наше меню
local baseLoad = LoadArcanix
LoadArcanix = function()
    baseLoad() -- Удаляет KeyGui
    toggleMenu(true) -- Открывает меню
end

print("ARCANIX v2.0 Fully Loaded") 
-- ============================================================
-- 🦅 ARCANIX v2.0 (Part 5: AimBot & Fly Functions)
-- ============================================================

-- Функция создания слайдера (для FOV и Fly Speed)
local function createSlider(parent, txt, minV, maxV, default, cb)
    local h = Instance.new("Frame")
    h.Size = UDim2.new(1, 0, 0, 46)
    h.BackgroundColor3 = Themes[Theme].Sub
    h.Parent = parent
    corner(h, 8)

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -80, 0, 18)
    l.Position = UDim2.new(0, 12, 0, 4)
    l.BackgroundTransparency = 1
    l.Text = txt
    l.TextColor3 = Themes[Theme].Text
    l.Font = Enum.Font.Arcade
    l.TextSize = 14
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = h

    local vl = Instance.new("TextLabel")
    vl.Size = UDim2.new(0, 60, 0, 18)
    vl.Position = UDim2.new(1, -70, 0, 4)
    vl.BackgroundTransparency = 1
    vl.Text = tostring(default)
    vl.TextColor3 = Accent
    vl.Font = Enum.Font.Arcade
    vl.TextSize = 14
    vl.TextXAlignment = Enum.TextXAlignment.Right
    vl.Parent = h

    local tr = Instance.new("Frame")
    tr.Size = UDim2.new(1, -24, 0, 6)
    tr.Position = UDim2.new(0, 12, 1, -14)
    tr.BackgroundColor3 = Color3.fromRGB(60, 60, 65)
    tr.Parent = h
    corner(tr, 3)

    local fl = Instance.new("Frame")
    fl.Size = UDim2.new((default - minV) / (maxV - minV), 0, 1, 0)
    fl.BackgroundColor3 = Accent
    fl.Parent = tr
    corner(fl, 3)

    local kn = Instance.new("Frame")
    kn.Size = UDim2.new(0, 14, 0, 14)
    kn.AnchorPoint = Vector2.new(0.5, 0.5)
    kn.Position = UDim2.new((default - minV) / (maxV - minV), 0, 0.5, 0)
    kn.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    kn.Parent = tr
    corner(kn, 7)

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(1, -24, 0, 24)
    btn.Position = UDim2.new(0, 12, 1, -24)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    btn.Parent = h

    local drag = false
    local function update(x)
        local rel = math.clamp((x - tr.AbsolutePosition.X) / tr.AbsoluteSize.X, 0, 1)
        local val = math.floor(minV + (maxV - minV) * rel + 0.5)
        fl.Size = UDim2.new(rel, 0, 1, 0)
        kn.Position = UDim2.new(rel, 0, 0.5, 0)
        vl.Text = tostring(val)
        if cb then cb(val) end
    end

    btn.InputBegan:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = true; update(i.Position.X) end end)
    U.InputChanged:Connect(function(i) if drag and (i.UserInputType == Enum.UserInputType.MouseMovement or i.UserInputType == Enum.UserInputType.Touch) then update(i.Position.X) end end)
    U.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 or i.UserInputType == Enum.UserInputType.Touch then drag = false end end)
end

-- Функция выбора режима Аимбота
local function createAimModeSelector(parent)
    local h = Instance.new("Frame")
    h.Size = UDim2.new(1, 0, 0, 60)
    h.BackgroundColor3 = Themes[Theme].Sub
    h.Parent = parent
    corner(h, 8)

    local l = Instance.new("TextLabel")
    l.Size = UDim2.new(1, -20, 0, 18)
    l.Position = UDim2.new(0, 12, 0, 4)
    l.BackgroundTransparency = 1
    l.Text = "Режим:"
    l.TextColor3 = Themes[Theme].Text
    l.Font = Enum.Font.Arcade
    l.TextSize = 14
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Parent = h

    local bh = Instance.new("Frame")
    bh.Size = UDim2.new(1, -24, 0, 24)
    bh.Position = UDim2.new(0, 12, 0, 26)
    bh.BackgroundTransparency = 1
    bh.Parent = h
    local lay = Instance.new("UIListLayout")
    lay.FillDirection = Enum.FillDirection.Horizontal
    lay.Padding = UDim.new(0, 4)
    lay.Parent = bh

    local function makeBtn(name, mode)
        local b = Instance.new("TextButton")
        b.Size = UDim2.new(0, 100, 1, 0)
        b.BackgroundColor3 = Aim_Mode == mode and Accent or Color3.fromRGB(60, 60, 65)
        b.Text = name
        b.TextColor3 = Color3.fromRGB(255, 255, 255)
        b.Font = Enum.Font.Arcade
        b.TextSize = 12
        b.Parent = bh
        corner(b, 6)
        
        b.MouseButton1Click:Connect(function()
            Aim_Mode = mode
            for _, v in ipairs(bh:GetChildren()) do
                if v:IsA("TextButton") then
                    T:Create(v, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 65)}):Play()
                end
            end
            T:Create(b, TweenInfo.new(0.2), {BackgroundColor3 = Accent}):Play()
        end)
    end
    makeBtn("ShiftLock", "ShiftLock")
    makeBtn("RMB", "RMB")
    makeBtn("Всегда", "Always")
end

-- ПЕРЕМЕННЫЕ АИМБОТА И ФЛАЯ
local Aim_Enabled = false
local Aim_Mode = "ShiftLock"
local Aim_FOV = 150
local Aim_Smooth = 50
local Aim_WallCheck = true
local CurrentTarget = nil

local Fly_Enabled = false
local Fly_Speed = 50
local flyVel = nil

-- КРУЖОК FOV
local fovCircle = Instance.new("Frame")
fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
fovCircle.Position = UDim2.new(0.5, 0, 0.5, 0)
fovCircle.Size = UDim2.new(0, Aim_FOV * 2, 0, Aim_FOV * 2)
fovCircle.BackgroundTransparency = 1
fovCircle.Visible = false
fovCircle.Parent = gui
corner(fovCircle, 9999)
local fovStroke = stroke(fovCircle, Accent, 1.5, 0.3)

-- ДОБАВЛЯЕМ В UI
createToggle(pages["AimBot"], "Включить AimBot", false, function(v) Aim_Enabled = v; fovCircle.Visible = v end)
createToggle(pages["AimBot"], "Wall-Check", true, function(v) Aim_WallCheck = v end)
createAimModeSelector(pages["AimBot"])
createSlider(pages["AimBot"], "FOV (Радиус)", 50, 400, 150, function(v) 
    Aim_FOV = v
    fovCircle.Size = UDim2.new(0, v*2, 0, v*2)
end)
createSlider(pages["AimBot"], "Сила лока (100 = СНАП)", 1, 100, 50, function(v) Aim_Smooth = v end)

local flySlider
createToggle(pages["Misc"], "Fly (Полет)", false, function(v) 
    Fly_Enabled = v 
    if flySlider then flySlider.Visible = v end 
end)
flySlider = createSlider(pages["Misc"], "Скорость полета", 10, 200, 50, function(v) Fly_Speed = v end)
flySlider.Visible = false

-- ==========================================
-- ЛОГИКА АИМБОТА
-- ==========================================
local isAiming = false
U.InputBegan:Connect(function(i, gp) 
    if gp then return end
    if Aim_Enabled and Aim_Mode == "RMB" and i.UserInputType == Enum.UserInputType.MouseButton2 then isAiming = true end 
end)
U.InputEnded:Connect(function(i) 
    if i.UserInputType == Enum.UserInputType.MouseButton2 then isAiming = false end 
end)

local function hasLineOfSight(targetPart)
    if not Aim_WallCheck then return true end
    local origin = Camera.CFrame.Position
    local direction = (targetPart.Position - origin)
    local rayParams = RaycastParams.new()
    rayParams.FilterType = Enum.RaycastFilterType.Exclude
    rayParams.FilterDescendantsInstances = {LP.Character, Camera}
    local rayResult = W:Raycast(origin, direction, rayParams)
    if not rayResult then return true end
    if rayResult.Instance:IsDescendantOf(targetPart.Parent) then return true end
    return false
end

local function getTarget()
    if CurrentTarget and CurrentTarget.Parent and CurrentTarget.Parent:FindFirstChildOfClass("Humanoid") and CurrentTarget.Parent.Humanoid.Health > 0 then
        if hasLineOfSight(CurrentTarget) then return CurrentTarget end
    end
    CurrentTarget = nil
    local closest, shortest = nil, Aim_FOV
    local center = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    
    for _, plr in ipairs(P:GetPlayers()) do
        if plr ~= LP and (not TeamCheck or plr.Team ~= LP.Team) then
            local char = plr.Character
            if char then
                local targetPart = char:FindFirstChild("Head") or char:FindFirstChild("HumanoidRootPart")
                local hum = char:FindFirstChildOfClass("Humanoid")
                if targetPart and hum and hum.Health > 0 then
                    local pos, onScreen = Camera:WorldToViewportPoint(targetPart.Position)
                    if onScreen then
                        local d = (Vector2.new(pos.X, pos.Y) - center).Magnitude
                        if d < shortest then
                            if hasLineOfSight(targetPart) then
                                shortest = d
                                closest = targetPart
                            end
                        end
                    end
                end
            end
        end
    end
    CurrentTarget = closest
    return CurrentTarget
end

R.RenderStepped:Connect(function(dt)
    if not Aim_Enabled then CurrentTarget = nil; return end
    local active = false
    if Aim_Mode == "Always" then active = true
    elseif Aim_Mode == "RMB" then active = isAiming
    elseif Aim_Mode == "ShiftLock" then active = (U.MouseBehavior == Enum.MouseBehavior.LockCenter) end
    
    if not active then CurrentTarget = nil; return end
    
    local target = getTarget()
    if target then
        local current = Camera.CFrame
        local desired = CFrame.new(current.Position, target.Position)
        if Aim_Smooth >= 99 then
            Camera.CFrame = desired
        else
            local smooth = Aim_Smooth / 100
            local alpha = 1 - math.pow(1 - smooth, dt * 60)
            Camera.CFrame = current:Lerp(desired, alpha)
        end
    end
end)

-- ==========================================
-- ЛОГИКА ФЛАЯ
-- ==========================================
R.RenderStepped:Connect(function()
    if Fly_Enabled then
        if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = LP.Character.HumanoidRootPart
            if not flyVel then
                flyVel = Instance.new("BodyVelocity")
                flyVel.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                flyVel.Velocity = Vector3.zero
                flyVel.Parent = hrp
            end
            
            local moveDir = Vector3.zero
            local camLook = Camera.CFrame.LookVector
            local camRight = Camera.CFrame.RightVector
            
            if U:IsKeyDown(Enum.KeyCode.W) then moveDir += camLook end
            if U:IsKeyDown(Enum.KeyCode.S) then moveDir -= camLook end
            if U:IsKeyDown(Enum.KeyCode.A) then moveDir -= camRight end
            if U:IsKeyDown(Enum.KeyCode.D) then moveDir += camRight end
            if U:IsKeyDown(Enum.KeyCode.Space) then moveDir += Vector3.new(0,1,0) end
            
            local hum = LP.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.MoveDirection.Magnitude > 0.1 then
                local flatLook = Vector3.new(camLook.X, 0, camLook.Z).Unit
                local flatRight = Vector3.new(camRight.X, 0, camRight.Z).Unit
                moveDir += (camLook * hum.MoveDirection:Dot(flatLook)) + (camRight * hum.MoveDirection:Dot(flatRight))
            end

            if moveDir.Magnitude > 0 then
                flyVel.Velocity = moveDir.Unit * Fly_Speed
            else
                flyVel.Velocity = Vector3.zero
            end
        end
    else
        if flyVel then flyVel:Destroy(); flyVel = nil end
    end
end)

print("ARCANIX v2.0 Fully Loaded (All Parts Included)")

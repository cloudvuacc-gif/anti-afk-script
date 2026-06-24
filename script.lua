--[[ V0.0 ANTI AFK - cloudvuacc ]]
local HttpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = game:GetService("CoreGui")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local VirtualUser = game:GetService("VirtualUser")
local StarterGui = game:GetService("StarterGui")

local LINK = "https://link-center.net/6819549/eLZPTLtWBC8k"
local StartTime = tick()
local AntiAFK_Enabled = true

-- Auto-load config
local ConfigLoaded = false
local ConfigLoadSource = ""
local SavedWebhookURL = ""
pcall(function()
    if getgenv().AntiAFK_WebhookURL and getgenv().AntiAFK_WebhookURL ~= "" then
        SavedWebhookURL = getgenv().AntiAFK_WebhookURL
        ConfigLoaded = true; ConfigLoadSource = "Memory"
    end
end)
if not ConfigLoaded then
    pcall(function()
        if isfile and readfile and isfile("AntiAFK_Config.json") then
            local Config = HttpService:JSONDecode(readfile("AntiAFK_Config.json"))
            if Config and Config.WebhookURL and Config.WebhookURL ~= "" then
                SavedWebhookURL = Config.WebhookURL
                ConfigLoaded = true; ConfigLoadSource = "File"
            end
        end
    end)
end

local WebhookURL = SavedWebhookURL
local LastWebhookSent = 0
local UpdateInterval = 300
local DisconnectSent = false
local PlayerName = LocalPlayer.Name
local GameName = "Unknown Game"
pcall(function() GameName = game:GetService("MarketplaceService"):GetProductInfo(game.PlaceId).Name end)

-- Auto-load key config
local ACTIVATED = false
local ACTIVATED_TIME = 0
pcall(function()
    if getgenv().AntiAFK_ActivatedTime and getgenv().AntiAFK_ActivatedTime > 0 then
        ACTIVATED_TIME = getgenv().AntiAFK_ActivatedTime
        if os.time() - ACTIVATED_TIME < 86400 then ACTIVATED = true end
    end
end)
if not ACTIVATED then
    pcall(function()
        if isfile and readfile and isfile("AntiAFK_Activated.txt") then
            local data = HttpService:JSONDecode(readfile("AntiAFK_Activated.txt"))
            if data and data.time and data.userId == LocalPlayer.UserId then
                ACTIVATED_TIME = data.time
                if os.time() - ACTIVATED_TIME < 86400 then ACTIVATED = true end
            end
        end
    end)
end

-- Cleanup
for _, v in ipairs(CoreGui:GetChildren()) do
    if v:IsA("ScreenGui") then v:Destroy() end
end

-- Key check
local function CheckKey(k)
    k = k:gsub("%s+", ""):upper()
    if not k:match("^DEDSEC%-") then return false end
    local parts = {}
    for p in k:gmatch("[^-]+") do table.insert(parts, p) end
    if #parts ~= 4 then return false end
    local keyUserId = tonumber(parts[2], 36)
    if not keyUserId or keyUserId ~= LocalPlayer.UserId then return false end
    if #parts[3] ~= 10 or not parts[3]:match("^%d+$") then return false end
    local t = os.date("*t")
    local cur = string.format("%04d%02d%02d%02d", t.year, t.month, t.day, t.hour)
    if parts[3] == cur then return true end
    t.hour = t.hour - 1
    if t.hour < 0 then t.hour = 23; t.day = t.day - 1 end
    if parts[3] == string.format("%04d%02d%02d%02d", t.year, t.month, t.day, t.hour) then return true end
    return false
end

-- Save functions
local function SaveConfig(URL)
    WebhookURL = URL
    getgenv().AntiAFK_WebhookURL = URL
    pcall(function()
        if isfile and writefile then
            writefile("AntiAFK_Config.json", HttpService:JSONEncode({WebhookURL = URL, PlayerName = PlayerName}))
        end
    end)
end

local function SaveActivation()
    getgenv().AntiAFK_ActivatedTime = ACTIVATED_TIME
    pcall(function()
        if isfile and writefile then
            writefile("AntiAFK_Activated.txt", HttpService:JSONEncode({userId = LocalPlayer.UserId, time = ACTIVATED_TIME}))
        end
    end)
end

local function FormatTime(s)
    return string.format("%02d:%02d:%02d", math.floor(s/3600), math.floor((s%3600)/60), math.floor(s%60))
end

-- Webhook
local function SendWebhook(Title, Desc, Color)
    if WebhookURL == "" then return false end
    return pcall(function()
        local Payload = {
            ["content"] = "",
            ["embeds"] = {{
                ["title"] = Title,
                ["description"] = Desc,
                ["color"] = Color or 65280,
                ["footer"] = {["text"] = "V0.0 | " .. PlayerName}
            }}
        }
        local Body = HttpService:JSONEncode(Payload)
        local Response = request or http_request or syn.request
        if Response then
            Response({Url = WebhookURL, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = Body})
        end
    end)
end

local function SendMenuCloseNotification()
    if WebhookURL == "" then return end
    SendWebhook("🔒 Menu Closed", "**Account:** " .. PlayerName, 16753920)
end

local function SendToggleNotification(Enabled)
    if WebhookURL == "" then return end
    SendWebhook(Enabled and "🟢 AFK ON" or "🔴 AFK OFF", "**Account:** " .. PlayerName, Enabled and 65280 or 16711680)
end

-- Anti-AFK
local function AntiAFK_Action()
    if not AntiAFK_Enabled then return end
    pcall(function()
        VirtualUser:CaptureController()
        VirtualUser:ClickButton2(Vector2.new(math.random(100,600), math.random(100,400)))
    end)
end

-- Block AFK Kick
pcall(function()
    local OldKick = hookfunction(LocalPlayer.Kick, newcclosure(function(self, Msg)
        if not AntiAFK_Enabled then return OldKick(self, Msg) end
        if type(Msg) == "string" and (Msg:lower():find("afk") or Msg:lower():find("idle")) then return nil end
        return OldKick(self, Msg)
    end))
end)

local function R(obj, r) Instance.new("UICorner", obj).CornerRadius = UDim.new(0, r or 8) end

--============================================
-- MAIN MENU
--============================================
local function ShowMainMenu()
    for _, v in ipairs(CoreGui:GetChildren()) do
        if v.Name == "AFK_Key" then v:Destroy() end
    end

    local Gui = Instance.new("ScreenGui")
    Gui.Name = "AntiAFK_Final"
    Gui.ResetOnSpawn = false
    Gui.Parent = CoreGui

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 320, 0, 310)
    Frame.Position = UDim2.new(0.5, -160, 0.3, 0)
    Frame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
    Frame.BorderSizePixel = 0
    Frame.Parent = Gui
    R(Frame, 10)

    local TopBar = Instance.new("Frame")
    TopBar.Size = UDim2.new(1, 0, 0, 35)
    TopBar.BackgroundColor3 = Color3.fromRGB(22, 22, 22)
    TopBar.BorderSizePixel = 0
    TopBar.Parent = Frame
    R(TopBar, 10)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, -50, 1, 0)
    Title.Position = UDim2.new(0, 12, 0, 0)
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.GothamBold
    Title.Text = "🛡️ V0.0 ANTI AFK"
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 12
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.Parent = TopBar

    local CloseBtn = Instance.new("TextButton")
    CloseBtn.Size = UDim2.new(0, 28, 0, 28)
    CloseBtn.Position = UDim2.new(1, -34, 0, 3)
    CloseBtn.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    CloseBtn.BorderSizePixel = 0
    CloseBtn.Font = Enum.Font.Code
    CloseBtn.Text = "X"
    CloseBtn.TextColor3 = Color3.fromRGB(220, 220, 220)
    CloseBtn.TextSize = 16
    CloseBtn.Parent = TopBar
    R(CloseBtn, 4)
    CloseBtn.MouseButton1Click:Connect(function()
        SendMenuCloseNotification()
        Gui:Destroy()
    end)

    -- Key Status
    local KeyStatus = Instance.new("TextLabel")
    KeyStatus.Size = UDim2.new(1, -24, 0, 14)
    KeyStatus.Position = UDim2.new(0, 12, 0, 40)
    KeyStatus.BackgroundTransparency = 1
    KeyStatus.Font = Enum.Font.GothamMedium
    KeyStatus.TextSize = 9
    KeyStatus.TextXAlignment = Enum.TextXAlignment.Center
    KeyStatus.Parent = Frame
    if ACTIVATED_TIME > 0 then
        local rem = 86400 - (os.time() - ACTIVATED_TIME)
        if rem > 0 then
            KeyStatus.Text = "🔑 " .. math.floor(rem/3600) .. "h " .. math.floor((rem%3600)/60) .. "m left"
            KeyStatus.TextColor3 = Color3.fromRGB(0, 255, 0)
        else
            KeyStatus.Text = "🔑 Expired!"
            KeyStatus.TextColor3 = Color3.fromRGB(255, 100, 100)
        end
    else
        KeyStatus.Text = "🔑 Activated ✓"
        KeyStatus.TextColor3 = Color3.fromRGB(0, 255, 0)
    end

    -- User Info
    local UserFrame = Instance.new("Frame")
    UserFrame.Size = UDim2.new(1, -24, 0, 26)
    UserFrame.Position = UDim2.new(0, 12, 0, 56)
    UserFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
    UserFrame.BorderSizePixel = 0
    UserFrame.Parent = Frame
    R(UserFrame, 6)

    local UserLabel = Instance.new("TextLabel")
    UserLabel.Size = UDim2.new(1, -60, 1, 0)
    UserLabel.Position = UDim2.new(0, 8, 0, 0)
    UserLabel.BackgroundTransparency = 1
    UserLabel.Font = Enum.Font.GothamMedium
    UserLabel.Text = "👤 " .. PlayerName .. " | ID: " .. LocalPlayer.UserId
    UserLabel.TextColor3 = Color3.fromRGB(180, 180, 255)
    UserLabel.TextSize = 10
    UserLabel.TextXAlignment = Enum.TextXAlignment.Left
    UserLabel.Parent = UserFrame

    local CopyID = Instance.new("TextButton")
    CopyID.Size = UDim2.new(0, 50, 0, 16)
    CopyID.Position = UDim2.new(1, -56, 0, 5)
    CopyID.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
    CopyID.BorderSizePixel = 0
    CopyID.Font = Enum.Font.GothamMedium
    CopyID.Text = "COPY ID"
    CopyID.TextColor3 = Color3.fromRGB(255, 255, 255)
    CopyID.TextSize = 9
    CopyID.Parent = UserFrame
    R(CopyID, 4)
    CopyID.MouseButton1Click:Connect(function()
        pcall(function() setclipboard(tostring(LocalPlayer.UserId)) end)
    end)

    -- Uptime
    local UptimeFrame = Instance.new("Frame")
    UptimeFrame.Size = UDim2.new(1, -24, 0, 34)
    UptimeFrame.Position = UDim2.new(0, 12, 0, 86)
    UptimeFrame.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    UptimeFrame.BorderSizePixel = 0
    UptimeFrame.Parent = Frame
    R(UptimeFrame, 6)

    local UptimeValue = Instance.new("TextLabel")
    UptimeValue.Size = UDim2.new(1, -10, 1, 0)
    UptimeValue.Position = UDim2.new(0, 5, 0, 0)
    UptimeValue.BackgroundTransparency = 1
    UptimeValue.Font = Enum.Font.GothamBold
    UptimeValue.Text = "⏱️ 00:00:00"
    UptimeValue.TextColor3 = Color3.fromRGB(0, 255, 200)
    UptimeValue.TextSize = 14
    UptimeValue.TextXAlignment = Enum.TextXAlignment.Center
    UptimeValue.Parent = UptimeFrame

    -- Webhook Input
    local WebhookLabel = Instance.new("TextLabel")
    WebhookLabel.Size = UDim2.new(1, -24, 0, 14)
    WebhookLabel.Position = UDim2.new(0, 12, 0, 124)
    WebhookLabel.BackgroundTransparency = 1
    WebhookLabel.Font = Enum.Font.GothamBold
    WebhookLabel.Text = "📡 WEBHOOK URL:"
    WebhookLabel.TextColor3 = Color3.fromRGB(100, 200, 255)
    WebhookLabel.TextSize = 10
    WebhookLabel.TextXAlignment = Enum.TextXAlignment.Left
    WebhookLabel.Parent = Frame

    local InputContainer = Instance.new("Frame")
    InputContainer.Size = UDim2.new(1, -24, 0, 28)
    InputContainer.Position = UDim2.new(0, 12, 0, 140)
    InputContainer.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    InputContainer.BorderSizePixel = 0
    InputContainer.ClipsDescendants = true
    InputContainer.Parent = Frame
    R(InputContainer, 6)

    local WebhookInput = Instance.new("TextBox")
    WebhookInput.Size = UDim2.new(1, -12, 1, -6)
    WebhookInput.Position = UDim2.new(0, 6, 0, 3)
    WebhookInput.BackgroundTransparency = 1
    WebhookInput.BorderSizePixel = 0
    WebhookInput.Font = Enum.Font.Code
    WebhookInput.Text = WebhookURL or ""
    WebhookInput.TextColor3 = Color3.fromRGB(255, 255, 255)
    WebhookInput.TextSize = 10
    WebhookInput.TextXAlignment = Enum.TextXAlignment.Left
    WebhookInput.TextTruncate = Enum.TextTruncate.AtEnd
    WebhookInput.ClearTextOnFocus = false
    WebhookInput.Parent = InputContainer

    -- Buttons
    local SaveBtn = Instance.new("TextButton")
    SaveBtn.Size = UDim2.new(0.5, -18, 0, 26)
    SaveBtn.Position = UDim2.new(0, 12, 0, 172)
    SaveBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
    SaveBtn.BorderSizePixel = 0
    SaveBtn.Font = Enum.Font.GothamBold
    SaveBtn.Text = "💾 SAVE"
    SaveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SaveBtn.TextSize = 10
    SaveBtn.Parent = Frame
    R(SaveBtn, 6)
    SaveBtn.MouseButton1Click:Connect(function()
        SaveConfig(WebhookInput.Text)
        ConfigStatus.Text = WebhookURL ~= "" and "💾 Config: Saved ✓" or "💾 Config: No URL"
        ConfigStatus.TextColor3 = WebhookURL ~= "" and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 180, 50)
    end)

    local TestBtn = Instance.new("TextButton")
    TestBtn.Size = UDim2.new(0.5, -18, 0, 26)
    TestBtn.Position = UDim2.new(0.5, 6, 0, 172)
    TestBtn.BackgroundColor3 = Color3.fromRGB(255, 160, 0)
    TestBtn.BorderSizePixel = 0
    TestBtn.Font = Enum.Font.GothamBold
    TestBtn.Text = "🧪 TEST"
    TestBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    TestBtn.TextSize = 10
    TestBtn.Parent = Frame
    R(TestBtn, 6)
    TestBtn.MouseButton1Click:Connect(function()
        if WebhookInput.Text ~= "" then SaveConfig(WebhookInput.Text) end
        if WebhookURL ~= "" then
            SendWebhook("🧪 Test", "✅ Webhook active!\n**" .. PlayerName .. "**", 3447003)
        end
    end)

    -- Config Status
    local ConfigStatus = Instance.new("TextLabel")
    ConfigStatus.Size = UDim2.new(1, -24, 0, 12)
    ConfigStatus.Position = UDim2.new(0, 12, 0, 202)
    ConfigStatus.BackgroundTransparency = 1
    ConfigStatus.Font = Enum.Font.GothamMedium
    ConfigStatus.Text = WebhookURL ~= "" and "💾 Config: Saved ✓" or "💾 Config: No URL"
    ConfigStatus.TextColor3 = WebhookURL ~= "" and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(255, 180, 50)
    ConfigStatus.TextSize = 9
    ConfigStatus.TextXAlignment = Enum.TextXAlignment.Left
    ConfigStatus.Parent = Frame

    -- AFK Status
    local StatusSection = Instance.new("Frame")
    StatusSection.Size = UDim2.new(1, -24, 0, 22)
    StatusSection.Position = UDim2.new(0, 12, 0, 216)
    StatusSection.BackgroundColor3 = Color3.fromRGB(10, 10, 10)
    StatusSection.BorderSizePixel = 0
    StatusSection.Parent = Frame
    R(StatusSection, 6)

    local StatusDot = Instance.new("Frame")
    StatusDot.Size = UDim2.new(0, 8, 0, 8)
    StatusDot.Position = UDim2.new(0, 8, 0, 7)
    StatusDot.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
    StatusDot.BorderSizePixel = 0
    StatusDot.Parent = StatusSection
    R(StatusDot, 4)

    local StatusText = Instance.new("TextLabel")
    StatusText.Size = UDim2.new(1, -20, 1, 0)
    StatusText.Position = UDim2.new(0, 20, 0, 0)
    StatusText.BackgroundTransparency = 1
    StatusText.Font = Enum.Font.GothamMedium
    StatusText.Text = "PROTECTION: ACTIVE"
    StatusText.TextColor3 = Color3.fromRGB(0, 255, 0)
    StatusText.TextSize = 10
    StatusText.TextXAlignment = Enum.TextXAlignment.Left
    StatusText.Parent = StatusSection

    -- Toggle
    local ToggleBtn = Instance.new("TextButton")
    ToggleBtn.Size = UDim2.new(1, -24, 0, 28)
    ToggleBtn.Position = UDim2.new(0, 12, 0, 242)
    ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    ToggleBtn.BorderSizePixel = 0
    ToggleBtn.Font = Enum.Font.GothamBold
    ToggleBtn.Text = "🟢 ANTI-AFK: ON"
    ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ToggleBtn.TextSize = 11
    ToggleBtn.Parent = Frame
    R(ToggleBtn, 6)

    local function UpdateToggle()
        if AntiAFK_Enabled then
            ToggleBtn.Text = "🟢 ANTI-AFK: ON"
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
            StatusDot.BackgroundColor3 = Color3.fromRGB(0, 255, 0)
            StatusText.Text = "PROTECTION: ACTIVE"
            StatusText.TextColor3 = Color3.fromRGB(0, 255, 0)
        else
            ToggleBtn.Text = "🔴 ANTI-AFK: OFF"
            ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
            StatusDot.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            StatusText.Text = "PROTECTION: DISABLED"
            StatusText.TextColor3 = Color3.fromRGB(255, 50, 50)
        end
    end
    ToggleBtn.MouseButton1Click:Connect(function()
        AntiAFK_Enabled = not AntiAFK_Enabled
        UpdateToggle()
        SendToggleNotification(AntiAFK_Enabled)
    end)

    -- Credit
    local Credit = Instance.new("TextLabel")
    Credit.Size = UDim2.new(1, -24, 0, 14)
    Credit.Position = UDim2.new(0, 12, 0, 274)
    Credit.BackgroundTransparency = 1
    Credit.Font = Enum.Font.GothamMedium
    Credit.Text = "Shift: Hide | F4: Toggle | X: Close | Made by cloudvuacc"
    Credit.TextColor3 = Color3.fromRGB(80, 80, 80)
    Credit.TextSize = 9
    Credit.TextXAlignment = Enum.TextXAlignment.Center
    Credit.Parent = Frame

    -- Drag
    local dragging, dragStart, startPos = false, Vector2.new(0, 0), Frame.Position
    TopBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true; dragStart = input.Position; startPos = Frame.Position
        end
    end)
    UserInputService.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local delta = input.Position - dragStart
            Frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    -- Updates
    spawn(function()
        while Gui and Gui.Parent do
            UptimeValue.Text = "⏱️ " .. FormatTime(tick() - StartTime)
            if WebhookURL ~= "" and AntiAFK_Enabled and (tick() - LastWebhookSent) >= UpdateInterval then
                SendWebhook("⏱️ Uptime", "**" .. PlayerName .. "**\n⏱️ " .. FormatTime(tick() - StartTime), 16776960)
                LastWebhookSent = tick()
            end
            task.wait(0.1)
        end
    end)
    spawn(function()
        while Gui and Gui.Parent do
            if AntiAFK_Enabled then
                StatusDot.BackgroundColor3 = Color3.fromRGB(0, 255 * (math.sin(tick() * 4) * 0.4 + 0.6), 0)
            end
            task.wait(0.05)
        end
    end)
    spawn(function()
        while Gui and Gui.Parent do
            AntiAFK_Action()
            task.wait(math.random(25, 45))
        end
    end)

    LocalPlayer.CharacterAdded:Connect(function(char)
        local hum = char:FindFirstChildOfClass("Humanoid")
        if hum then hum.Idled:Connect(function() if AntiAFK_Enabled then AntiAFK_Action() end end) end
    end)
    if LocalPlayer.Character then
        local hum = LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
        if hum then hum.Idled:Connect(function() if AntiAFK_Enabled then AntiAFK_Action() end end) end
    end

    UserInputService.InputBegan:Connect(function(input, gp)
        if not gp then
            if input.KeyCode == Enum.KeyCode.F4 then
                AntiAFK_Enabled = not AntiAFK_Enabled
                UpdateToggle()
                SendToggleNotification(AntiAFK_Enabled)
            elseif input.KeyCode == Enum.KeyCode.LeftShift or input.KeyCode == Enum.KeyCode.RightShift then
                Frame.Visible = not Frame.Visible
            end
        end
    end)
end

--============================================
-- KEY GUI
--============================================
local function ShowKeyGUI()
    local Gui = Instance.new("ScreenGui")
    Gui.Name = "AFK_Key"
    Gui.ResetOnSpawn = false
    Gui.Parent = CoreGui

    local Frame = Instance.new("Frame")
    Frame.Size = UDim2.new(0, 360, 0, 210)
    Frame.Position = UDim2.new(0.5, -180, 0.4, -105)
    Frame.BackgroundColor3 = Color3.fromRGB(18, 18, 22)
    Frame.BorderSizePixel = 0
    Frame.Parent = Gui
    R(Frame, 12)

    local CloseX = Instance.new("TextButton")
    CloseX.Size = UDim2.new(0, 26, 0, 26)
    CloseX.Position = UDim2.new(1, -32, 0, 6)
    CloseX.BackgroundColor3 = Color3.fromRGB(220, 40, 40)
    CloseX.BorderSizePixel = 0
    CloseX.Font = Enum.Font.GothamBold
    CloseX.Text = "✕"
    CloseX.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseX.TextSize = 13
    CloseX.Parent = Frame
    R(CloseX, 6)
    CloseX.MouseButton1Click:Connect(function() Gui:Destroy() end)

    local Title = Instance.new("TextLabel")
    Title.Size = UDim2.new(1, 0, 0, 24)
    Title.Position = UDim2.new(0, 0, 0, 10)
    Title.BackgroundTransparency = 1
    Title.Font = Enum.Font.GothamBold
    Title.Text = "🔑 ENTER KEY"
    Title.TextColor3 = Color3.fromRGB(0, 255, 150)
    Title.TextSize = 15
    Title.Parent = Frame

    local UserFrame = Instance.new("Frame")
    UserFrame.Size = UDim2.new(1, -40, 0, 26)
    UserFrame.Position = UDim2.new(0, 20, 0, 38)
    UserFrame.BackgroundColor3 = Color3.fromRGB(12, 12, 16)
    UserFrame.BorderSizePixel = 0
    UserFrame.Parent = Frame
    R(UserFrame, 6)

    local UserLabel = Instance.new("TextLabel")
    UserLabel.Size = UDim2.new(1, -55, 1, 0)
    UserLabel.Position = UDim2.new(0, 8, 0, 0)
    UserLabel.BackgroundTransparency = 1
    UserLabel.Font = Enum.Font.GothamMedium
    UserLabel.Text = "👤 ID: " .. LocalPlayer.UserId
    UserLabel.TextColor3 = Color3.fromRGB(180, 180, 255)
    UserLabel.TextSize = 10
    UserLabel.TextXAlignment = Enum.TextXAlignment.Left
    UserLabel.Parent = UserFrame

    local CopyBtn = Instance.new("TextButton")
    CopyBtn.Size = UDim2.new(0, 45, 0, 16)
    CopyBtn.Position = UDim2.new(1, -50, 0, 5)
    CopyBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
    CopyBtn.BorderSizePixel = 0
    CopyBtn.Font = Enum.Font.GothamMedium
    CopyBtn.Text = "COPY"
    CopyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    CopyBtn.TextSize = 8
    CopyBtn.Parent = UserFrame
    R(CopyBtn, 4)
    CopyBtn.MouseButton1Click:Connect(function()
        pcall(function() setclipboard(tostring(LocalPlayer.UserId)) end)
        Status.Text = "✅ ID copied!"
        Status.TextColor3 = Color3.fromRGB(0, 255, 0)
    end)

    local GetKeyBtn = Instance.new("TextButton")
    GetKeyBtn.Size = UDim2.new(1, -40, 0, 32)
    GetKeyBtn.Position = UDim2.new(0, 20, 0, 70)
    GetKeyBtn.BackgroundColor3 = Color3.fromRGB(255, 140, 0)
    GetKeyBtn.BorderSizePixel = 0
    GetKeyBtn.Font = Enum.Font.GothamBold
    GetKeyBtn.Text = "🔗 GET KEY"
    GetKeyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    GetKeyBtn.TextSize = 12
    GetKeyBtn.Parent = Frame
    R(GetKeyBtn, 6)
    GetKeyBtn.MouseButton1Click:Connect(function()
        pcall(function() setclipboard(LINK) end)
        Status.Text = "✅ Link copied!"
        Status.TextColor3 = Color3.fromRGB(0, 255, 0)
    end)

    local Input = Instance.new("TextBox")
    Input.Size = UDim2.new(1, -40, 0, 32)
    Input.Position = UDim2.new(0, 20, 0, 108)
    Input.BackgroundColor3 = Color3.fromRGB(10, 10, 14)
    Input.BorderSizePixel = 0
    Input.Font = Enum.Font.Code
    Input.Text = ""
    Input.TextColor3 = Color3.fromRGB(0, 255, 150)
    Input.TextSize = 12
    Input.Parent = Frame
    R(Input, 6)

    local SubmitBtn = Instance.new("TextButton")
    SubmitBtn.Size = UDim2.new(1, -40, 0, 32)
    SubmitBtn.Position = UDim2.new(0, 20, 0, 146)
    SubmitBtn.BackgroundColor3 = Color3.fromRGB(0, 180, 100)
    SubmitBtn.BorderSizePixel = 0
    SubmitBtn.Font = Enum.Font.GothamBold
    SubmitBtn.Text = "✅ SUBMIT"
    SubmitBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    SubmitBtn.TextSize = 13
    SubmitBtn.Parent = Frame
    R(SubmitBtn, 6)

    local Status = Instance.new("TextLabel")
    Status.Size = UDim2.new(1, -40, 0, 18)
    Status.Position = UDim2.new(0, 20, 0, 182)
    Status.BackgroundTransparency = 1
    Status.Font = Enum.Font.GothamMedium
    Status.Text = "Copy ID → Website → Get key → Paste"
    Status.TextColor3 = Color3.fromRGB(150, 150, 150)
    Status.TextSize = 9
    Status.TextXAlignment = Enum.TextXAlignment.Center
    Status.Parent = Frame

    local Credit2 = Instance.new("TextLabel")
    Credit2.Size = UDim2.new(1, -40, 0, 12)
    Credit2.Position = UDim2.new(0, 20, 0, 198)
    Credit2.BackgroundTransparency = 1
    Credit2.Font = Enum.Font.GothamMedium
    Credit2.Text = "Made by cloudvuacc"
    Credit2.TextColor3 = Color3.fromRGB(60, 60, 80)
    Credit2.TextSize = 8
    Credit2.TextXAlignment = Enum.TextXAlignment.Center
    Credit2.Parent = Frame

    local function ProcessKey(k)
        k = k:gsub("%s+", ""):upper()
        if k == "" then Status.Text = "❌ Enter key!"; return end
        if CheckKey(k) then
            if not getgenv().AntiAFK_ActivatedTime or getgenv().AntiAFK_ActivatedTime == 0 then
                ACTIVATED_TIME = os.time()
                SaveActivation()
            end
            Status.Text = "✅ Valid!"; Status.TextColor3 = Color3.fromRGB(0, 255, 0)
            task.wait(1); Gui:Destroy(); ShowMainMenu()
        else
            Status.Text = "❌ Invalid!"; Status.TextColor3 = Color3.fromRGB(255, 50, 50)
        end
    end

    SubmitBtn.MouseButton1Click:Connect(function() ProcessKey(Input.Text) end)
    Input.FocusLost:Connect(function(EP) if EP then ProcessKey(Input.Text) end end)
end

-- START
if ACTIVATED then ShowMainMenu() else ShowKeyGUI() end

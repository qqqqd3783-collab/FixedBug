local MacUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Zennakub123456789/Apple-Library/refs/heads/main/Main_Fixed_WithWhiteBorder.lua"))()

local imageUrl = "https://raw.githubusercontent.com/Zennakub123456789/picture/main/TadHub-Icon.png"
local imageName = "TadHub-Icon.png"

if not isfile(imageName) then
    local imageData = game:HttpGet(imageUrl)
    writefile(imageName, imageData)
end

local iconPath = getcustomasset(imageName)

local Window = MacUI:Window({
    Title = "Tad Hub | PvB",
    Size = UDim2.new(0, 600, 0, 350),
    Theme = "Dark",
    Icon = iconPath,
    LoadingTitle = "MacUI",
    LoadingSubtitle = "Loading...",
    ToggleUIKeybind = "K",
    ShowToggleButton = true,
    ToggleIcon = iconPath,
    NotifyFromBottom = true,
    ConfigurationSaving = {
        Enabled = true,
        FileName = "MacUI_Config"
    },
    KeySystem = false,
    KeySettings = {
        Title = "Tad Hub | Key System",
        Subtitle = "เข้าดิสคอสต์เพื่อเอาคีย์ คีย์จะรีเซ็ตทุก24ชั่วโมง (เดี๋ยวตื่นจะมาปิดระบบคีย์ให้ ตอนนี้คนในดิสมันเงียบ55) / Join Discord to get key And Keys reset every 24 H",
        Key = {"Key_TadHub_P0xLr7aQmZ", "TadHub67"},
        KeyLink = "https://discord.gg/VA35fm4r8f",
        SaveKey = true
    }
})

local infoTab = Window:Tab("Info", "rbxassetid://76311199408449")

infoTab:Section("Update")

local UpdateCode = infoTab:Code({
    Title = "Script Update",
    Code = [[# PvB Script Update! (v1.9.7)

## What’s new:

- [+] Added Auto Merge Madness Event (Toggle)
- [+] Added Favorite Only (Toggle) For Auto Merge Madness Event
- [+] Added  Auto Add XP (Toggle)
- [+] Added Auto Reset Merge Madness Event (Toggle) ]]
})

infoTab:Section("Discord")

local DiscordLabel = infoTab:Label({
    Text = "If you Found a bug or want to create a different map script, please let us know on Discord. We listen to all your problems."
})

local CopyDiscordButton = infoTab:Button({
    Title = "Copy Discord Link",
    Desc = "Click to copy the Discord invite link.",
    Callback = function()
        local link = "https://discord.gg/cQywVqjcyj"
        if setclipboard then
            setclipboard(link)
            MacUI:Notify({
                Title = "คัดลอกแล้ว!",
                Content = "ลิงก์ Discord ถูกคัดลอกไปยังคลิปบอร์ดแล้ว",
                Icon = "copy",
                Duration = 3
            })
        else
            MacUI:Notify({
                Title = "ไม่รองรับการคัดลอก",
                Content = "ตัวรันของคุณไม่รองรับฟังก์ชัน setclipboard",
                Icon = "alert-triangle",
                Duration = 3
            })
        end
    end
})

infoTab:Section("Feedback")

local FeedBackLabel = infoTab:Label({
    Text = "Send Feedback / Report Bug (Don't Spam)"
})

local webhookURL = "https://discord.com/api/webhooks/1427371338032484374/o0WHwtI8Pw7GwjVQl5XdLkRa_oIGjrOOs9dSg8Z5W7lX6A_Fj25AdgO-Uqn8AJuF35Fd"

local httpService = game:GetService("HttpService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local FeedBackInput = infoTab:Input({
    Placeholder = "Enter your feedback...",
    Default = "",
    Flag = "UserFeedback",
    Callback = function(text)
        _G.UserFeedback = text
    end
})

local lastSentTime = 0
local cooldown = 300

local FeedBackButton = infoTab:Button({
    Title = "Send Feedback",
    Desc = "Send your feedback to the Dev",
    Callback = function()
        local feedback = _G.UserFeedback or ""
        if feedback == "" then
            MacUI:Notify({
                Title = "No message!",
                Content = "Please enter your feedback before sending.",
                Duration = 3
            })
            return
        end

        local now = tick()
        if now - lastSentTime < cooldown then
            local timeLeft = cooldown - (now - lastSentTime)
            local minutes = math.floor(timeLeft / 60)
            local seconds = math.floor(timeLeft % 60)
            MacUI:Notify({
                Title = "Please wait!",
                Content = string.format("You are in cooldown. Please wait %d minute(s) %d second(s) before sending again.", minutes, seconds),
                Duration = 4
            })
            return
        end

        local data = {
            ["embeds"] = {{
                ["title"] = "Feedback Received",
                ["color"] = 3447003,
                ["fields"] = {
                    {
                        ["name"] = "Username",
                        ["value"] = LocalPlayer.Name .. " (" .. LocalPlayer.UserId .. ")",
                        ["inline"] = false
                    },
                    {
                        ["name"] = "Message",
                        ["value"] = feedback,
                        ["inline"] = false
                    },
                    {
                        ["name"] = "Time",
                        ["value"] = os.date("%Y-%m-%d %H:%M:%S"),
                        ["inline"] = true
                    }
                }
            }}
        }

        task.spawn(function()
            local success, err = pcall(function()
                request({
                    Url = webhookURL,
                    Method = "POST",
                    Headers = {
                        ["Content-Type"] = "application/json"
                    },
                    Body = httpService:JSONEncode(data)
                })
            end)

            if success then
                lastSentTime = tick()
            end
        end)

        MacUI:Notify({
            Title = "Sent!",
            Content = "Thank you for your feedback.",
            Duration = 3
        })

        _G.UserFeedback = ""
        FeedBackInput:SetValue("")
    end
})

local MainTab = Window:Tab("Main", "rbxassetid://128706247346129")

MainTab:Section("Anti AFK")

local Players = game:GetService("Players")
local VirtualUser = game:GetService("VirtualUser")
local player = Players.LocalPlayer

local idledConnection = nil

getgenv().AntiAFK = false

local AntiAFKToggle = MainTab:Toggle({
    Title = "Anti AFK",
    Default = false,
    Flag = "AntiAFK",
    Callback = function(value)
        getgenv().AntiAFK = value

        if value then
            task.spawn(function()
                idledConnection = player.Idled:Connect(function()
                    if getgenv().AntiAFK then
                        VirtualUser:CaptureController()
                        VirtualUser:ClickButton2(Vector2.new())
                    end
                end)
                
                while getgenv().AntiAFK do
                    VirtualUser:CaptureController()
                    VirtualUser:ClickButton2(Vector2.new())
                    task.wait(60)
                end
            end)

        else
            if idledConnection then
                idledConnection:Disconnect()
                idledConnection = nil
            end
        end
    end
})

MainTab:Section("Auto Reconnect")

repeat wait() until game.Players.LocalPlayer
local plr = game.Players.LocalPlayer

if not getgenv().tvk then getgenv().tvk = {} end
for k, v in pairs(getgenv().tvk) do v.On = false end

local queue_on_teleport = queue_on_teleport
if syn then queue_on_teleport = syn.queue_on_teleport end

queue_on_teleport([[
    if not game:IsLoaded() then
        game.Loaded:Wait()
    end
    repeat task.wait() until game.Players and game.Players.LocalPlayer
    loadstring(game:HttpGet("https://raw.githubusercontent.com/Zennakub123456789/MacOS_Script/refs/heads/main/Plants_vs_Brainrots.lua"))()
]])

local isTeleporting = false
local reconnectTask = nil
local enabled = false

local function startReconnectWatcher()
    reconnectTask = task.spawn(function()
        repeat wait() until game.CoreGui:FindFirstChild("RobloxPromptGui")
        local promptOverlay = game.CoreGui.RobloxPromptGui.promptOverlay
        promptOverlay.ChildAdded:Connect(function(child)
            if child.Name == "ErrorPrompt" and not isTeleporting then
                isTeleporting = true
                repeat
                    game:GetService("TeleportService"):Teleport(game.PlaceId, plr)
                    wait(2)
                until false
            end
        end)
    end)

    game:GetService("GuiService").ErrorMessageChanged:Connect(function(errorMessage)
        if errorMessage and errorMessage ~= "" and not isTeleporting then
            isTeleporting = true
            game:GetService("TeleportService"):Teleport(game.PlaceId, plr)
        end
    end)
end

local function stopReconnectWatcher()
    if reconnectTask then
        task.cancel(reconnectTask)
        reconnectTask = nil
    end
    isTeleporting = false
end

local ReconnectToggle = MainTab:Toggle({
    Title = "Auto Reconnect",
    Default = false,
    Callback = function(state)
        enabled = state
        if enabled then
            startReconnectWatcher()
            print(".")
        else
            stopReconnectWatcher()
            print(".")
        end
    end
})

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local PlayersTab = Window:Tab("Players", "rbxassetid://117259180607823")

PlayersTab:Section("Teleport To Players")

local function GetPlayerNames()
    local t = {}
    for _, p in pairs(Players:GetPlayers()) do
        table.insert(t, p.Name)
    end
    return t
end

local function findCharacterRoot(character)
    if not character then return nil end
    return character:FindFirstChild("HumanoidRootPart")
        or character:FindFirstChild("LowerTorso")
        or character:FindFirstChild("Torso")
end

getgenv().SelectedPlayer = nil

local PlayerDropdown = PlayersTab:Dropdown({
    Title = "Select Player",
    Options = GetPlayerNames(),
    Default = nil,
    Flag = "SelectedPlayer",
    Callback = function(selected)
        getgenv().SelectedPlayer = selected
    end
})

local function updatePlayerList()
    if PlayerDropdown and PlayerDropdown.SetOptions then
        PlayerDropdown:SetOptions(GetPlayerNames())
    end
end
Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)

local TeleportButton = PlayersTab:Button({
    Title = "Teleport to Selected Player",
    Desc = "Goto the player selected in the Dropdown.",
    Callback = function()
        local selected = getgenv().SelectedPlayer
        
        if not selected or selected == "" then
            return
        end

        local targetPlayer = Players:FindFirstChild(selected)

        if not targetPlayer then return end
        if targetPlayer == LocalPlayer then return end

        local targetRoot = findCharacterRoot(targetPlayer.Character)
        if not targetRoot then return end

        local myChar = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
        local myRoot = findCharacterRoot(myChar)
        if not myRoot then return end

        pcall(function()
            myRoot.CFrame = targetRoot.CFrame + Vector3.new(0, 3, 0)
        end)
    end
})

local player = game:GetService("Players").LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

local IsFlying = false
local CurrentSpeed = 10
local BodyGyro = nil
local BodyVelocity = nil

local function GetRootPart()
    local char = player.Character
    if not char then return nil end
    local hum = char:FindFirstChildWhichIsA("Humanoid")
    if not hum then return nil end
    
    if hum.RigType == Enum.HumanoidRigType.R6 then
        return char:FindFirstChild("Torso")
    else
        return char:FindFirstChild("UpperTorso")
    end
end

local function SetHumanoidState(hum, state, value)
    pcall(function()
        hum:SetStateEnabled(state, value)
    end)
end

local function StartFlying()
    local char = player.Character
    local hum = char and char:FindFirstChildWhichIsA("Humanoid")
    local rootPart = GetRootPart()
    
    if IsFlying or not hum or not rootPart then return end
    IsFlying = true

    SetHumanoidState(hum, Enum.HumanoidStateType.Climbing, false)
    SetHumanoidState(hum, Enum.HumanoidStateType.FallingDown, false)
    SetHumanoidState(hum, Enum.HumanoidStateType.Flying, false)
    SetHumanoidState(hum, Enum.HumanoidStateType.Freefall, false)
    SetHumanoidState(hum, Enum.HumanoidStateType.GettingUp, false)
    SetHumanoidState(hum, Enum.HumanoidStateType.Jumping, false)
    SetHumanoidState(hum, Enum.HumanoidStateType.Landed, false)
    SetHumanoidState(hum, Enum.HumanoidStateType.Physics, false)
    SetHumanoidState(hum, Enum.HumanoidStateType.Ragdoll, false)
    SetHumanoidState(hum, Enum.HumanoidStateType.Running, false)
    SetHumanoidState(hum, Enum.HumanoidStateType.Swimming, false)
    hum:ChangeState(Enum.HumanoidStateType.RunningNoPhysics)
    hum.PlatformStand = true

    local animateScript = char:FindFirstChild("Animate")
    if animateScript then
        animateScript.Disabled = true
    end
    
    local HumAnim = char:FindFirstChildOfClass("Humanoid") or char:FindFirstChildOfClass("AnimationController")
    if HumAnim then
        for _, v in next, HumAnim:GetPlayingAnimationTracks() do
            v:AdjustSpeed(0)
        end
    end

    BodyGyro = Instance.new("BodyGyro")
    BodyGyro.P = 50000
    BodyGyro.maxTorque = Vector3.new(9e9, 9e9, 9e9)
    BodyGyro.cframe = rootPart.CFrame
    BodyGyro.Parent = rootPart

    BodyVelocity = Instance.new("BodyVelocity")
    BodyVelocity.maxForce = Vector3.new(9e9, 9e9, 9e9)
    BodyVelocity.velocity = Vector3.new(0, 0, 0)
    BodyVelocity.Parent = rootPart
end

local FlyToggle

local function StopFlying()
    local char = player.Character
    local hum = char and char:FindFirstChildWhichIsA("Humanoid")

    if not IsFlying and not hum then 
        local rootPart = GetRootPart()
        if rootPart then
            if rootPart:FindFirstChild("BodyGyro") then rootPart.BodyGyro:Destroy() end
            if rootPart:FindFirstChild("BodyVelocity") then rootPart.BodyVelocity:Destroy() end
        end
    end
    
    if not IsFlying then return end
    IsFlying = false
    
    if BodyGyro then BodyGyro:Destroy() BodyGyro = nil end
    if BodyVelocity then BodyVelocity:Destroy() BodyVelocity = nil end

    if FlyToggle then FlyToggle:Set(false) end

    if hum then
        local animateScript = char:FindFirstChild("Animate")
        if animateScript then
            animateScript.Disabled = false
        end

        SetHumanoidState(hum, Enum.HumanoidStateType.Climbing, true)
        SetHumanoidState(hum, Enum.HumanoidStateType.FallingDown, true)
        SetHumanoidState(hum, Enum.HumanoidStateType.Flying, true)
        SetHumanoidState(hum, Enum.HumanoidStateType.Freefall, true)
        SetHumanoidState(hum, Enum.HumanoidStateType.GettingUp, true)
        SetHumanoidState(hum, Enum.HumanoidStateType.Jumping, true)
        SetHumanoidState(hum, Enum.HumanoidStateType.Landed, true)
        SetHumanoidState(hum, Enum.HumanoidStateType.Physics, true)
        SetHumanoidState(hum, Enum.HumanoidStateType.Ragdoll, true)
        SetHumanoidState(hum, Enum.HumanoidStateType.Running, true)
        SetHumanoidState(hum, Enum.HumanoidStateType.Swimming, true)
        hum:ChangeState(Enum.HumanoidStateType.Running)
        hum.PlatformStand = false
    end
end

PlayersTab:Section("Fly")

local FlyToggle = PlayersTab:Toggle({
    Title = "Fly Toggle",
    Default = false,
    Flag = "IsFlying",
    Callback = function(value)
        if value then
            StartFlying()
        else
            StopFlying()
        end
    end
})

local FlySpeedSlider = PlayersTab:Slider({
    Title = "Fly Speed",
    Min = 1,
    Max = 1000,
    Default = CurrentSpeed,
    Flag = "FlySpeed",
    Callback = function(value)
        CurrentSpeed = math.floor(value)
    end
})

RunService.RenderStepped:Connect(function()
    local char = player.Character
    local hum = char and char:FindFirstChildWhichIsA("Humanoid")

    if not IsFlying or not BodyGyro or not BodyVelocity or not hum then 
        return 
    end

    local cam = workspace.CurrentCamera
    if not cam then return end

    BodyGyro.CFrame = cam.CFrame

    local moveVector = Vector3.new(0, 0, 0)
    local worldMove = hum.MoveDirection
    local relativeMove = cam.CFrame:VectorToObjectSpace(worldMove)
    
    moveVector = moveVector + (cam.CFrame.LookVector * (relativeMove.Z * -1))
    moveVector = moveVector + (cam.CFrame.RightVector * relativeMove.X)
    
    if moveVector.Magnitude > 0 then
        BodyVelocity.Velocity = moveVector.Unit * CurrentSpeed
    else
        BodyVelocity.Velocity = Vector3.new(0, 0, 0)
    end
end)

player.CharacterAdded:Connect(function(char)
    char:WaitForChild("Humanoid")
    StopFlying()
end)

PlayersTab:Section("Player Settings")

_G.SpeedEnabled = false
local originalSpeed = 16
local hasSavedWalkSpeed = false

local SpeedSlider = PlayersTab:Slider({
    Title = "WalkSpeed",
    Min = 1,
    Max = 1000,
    Default = 16,
    Flag = "PlayerSpeed",
    Callback = function(value)
        if _G.SpeedEnabled == true then
            pcall(function()
                game.Players.LocalPlayer.Character.Humanoid.WalkSpeed = value
            end)
        end
    end
})

local SpeedToggle = PlayersTab:Toggle({
    Title = "Speed Toggle",
    Default = false,
    Flag = "SpeedEnabled",
    Callback = function(value)
        _G.SpeedEnabled = value
        
        local Humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
        if not Humanoid then return end

        if value == true then
            if not hasSavedWalkSpeed then
                originalSpeed = Humanoid.WalkSpeed
                hasSavedWalkSpeed = true
            end
            
            Humanoid.WalkSpeed = SpeedSlider:Get()
            
        else
            Humanoid.WalkSpeed = originalSpeed
        end
    end
})

PlayersTab:Divider()

_G.JumpEnabled = false
local originalJumpPower = 50
local hasSavedJumpPower = false

local JumpSlider = PlayersTab:Slider({
    Title = "JumpPower",
    Min = 50,
    Max = 150,
    Default = 75,
    Flag = "PlayerJump",
    Callback = function(value)
        if _G.JumpEnabled == true then
            pcall(function()
                game.Players.LocalPlayer.Character.Humanoid.JumpPower = value
            end)
        end
    end
})

local JumpToggle = PlayersTab:Toggle({
    Title = "Jump Toggle",
    Default = false,
    Flag = "JumpEnabled",
    Callback = function(value)
        _G.JumpEnabled = value
        
        local Humanoid = game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChildWhichIsA("Humanoid")
        if not Humanoid then return end

        if value == true then
            if not hasSavedJumpPower then
                originalJumpPower = Humanoid.JumpPower
                hasSavedJumpPower = true
            end
            
            Humanoid.JumpPower = JumpSlider:Get()
            
        else
            Humanoid.JumpPower = originalJumpPower
        end
    end
})

local AutoTab = Window:Tab("Auto", "rbxassetid://86084882582277")

AutoTab:Section("Auto Fram Brainrots")

AutoTab:Section("[Use Auto Fram Brainrots on PRIVATE SERVERS Only]")

local Players = game:GetService("Players")
local workspace = game:GetService("Workspace")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local player = Players.LocalPlayer

getgenv().TeleportToBrainrot = false
local farmPart = nil
getgenv().currentTargetInfo = nil

local function isPlayerInFarmZone(character, zone)
    if not character or not zone then return false end
    local hrp = character:FindFirstChild("HumanoidRootPart")
    if not hrp then return false end
    local playerPos = hrp.Position; local zonePos = zone.Position; local zoneSize = zone.Size
    local minX = zonePos.X - zoneSize.X / 2; local maxX = zonePos.X + zoneSize.X / 2
    local minY = zonePos.Y - zoneSize.Y / 2; local maxY = zonePos.Y + zoneSize.Y / 2
    local minZ = zonePos.Z - zoneSize.Z / 2; local maxZ = zonePos.Z + zoneSize.Z / 2
    return (playerPos.X >= minX and playerPos.X <= maxX and
            playerPos.Y >= minY and playerPos.Y <= maxY and
            playerPos.Z >= minZ and playerPos.Z <= maxZ)
end

local function isPartInZone(partToCheck, zone)
    if not partToCheck or not zone then return false end
    local partPos = partToCheck:GetPivot().Position
    local zonePos = zone.Position
    local zoneSize = zone.Size
    local minX = zonePos.X - zoneSize.X / 2; local maxX = zonePos.X + zoneSize.X / 2
    local minY = zonePos.Y - zoneSize.Y / 2; local maxY = zonePos.Y + zoneSize.Y / 2
    local minZ = zonePos.Z - zoneSize.Z / 2; local maxZ = zonePos.Z + zoneSize.Z / 2
    return (partPos.X >= minX and partPos.X <= maxX and
            partPos.Y >= minY and partPos.Y <= maxY and
            partPos.Z >= minZ and partPos.Z <= maxZ)
end

local function getAllGrassCFrames(plot)
    local cframes = {}; if not plot then return cframes end
    local rowsFolder = plot:FindFirstChild("Rows"); if not rowsFolder then return cframes end
    for _, row in pairs(rowsFolder:GetChildren()) do
        local grassFolder = row:FindFirstChild("Grass")
        if grassFolder then for _, part in pairs(grassFolder:GetChildren()) do if part:IsA("BasePart") then table.insert(cframes, part.CFrame) end end end
    end
    return cframes
end

local AutoTeleportToggle = AutoTab:Toggle({
    Title = "Auto Farm Brainrot",
    Default = false,
    Flag = "TeleportToBrainrot",
    Callback = function(value)
        getgenv().TeleportToBrainrot = value
        if value then
            local myPlot; for i = 1, 6 do local plot = workspace.Plots:FindFirstChild(tostring(i)); if plot and plot:GetAttribute("Owner") == player.Name then myPlot = plot; break end end
            if not myPlot then MacUI:Notify({Title="Error", Content="Could not find your plot!", Duration=4}); getgenv().TeleportToBrainrot=false; AutoTeleportToggle:Set(false); return end
            local grassCFrames = getAllGrassCFrames(myPlot)
            if #grassCFrames == 0 then MacUI:Notify({Title="Error", Content="Could not find grass positions!", Duration=4}); getgenv().TeleportToBrainrot=false; AutoTeleportToggle:Set(false); return end
            farmPart = Instance.new("Part"); farmPart.Name = "FarmZonePart"; farmPart.Size = Vector3.new(98, 80, 263); farmPart.Anchored = true; farmPart.CanCollide = false; farmPart.Transparency = 1; farmPart.CastShadow = false; farmPart.Parent = workspace
            if grassCFrames[6] then farmPart.CFrame = CFrame.new(grassCFrames[6].Position) else warn("Warning: Could not find grass part #6."); farmPart.CFrame = CFrame.new(grassCFrames[1].Position) end

            local performanceButton = player:WaitForChild("PlayerGui"):WaitForChild("Main"):WaitForChild("Settings"):WaitForChild("Frame"):WaitForChild("ScrollingFrame"):WaitForChild("Performance"):WaitForChild("Button"):WaitForChild("DisplayName")
            if performanceButton.Text == "Off" then
                local args = {[1] = {["Value"] = true, ["Setting"] = "Performance"}}; local changeSettingRemote = ReplicatedStorage.Remotes.ChangeSetting
                for i = 1, 5 do changeSettingRemote:FireServer(unpack(args)); task.wait(0.1) end; task.wait(5)
            end

            task.spawn(function()
                local spawnerPosition = nil
                local spawner = myPlot:FindFirstChild("SpawnerUI", true); if spawner and spawner:IsA("BasePart") then spawnerPosition = spawner.Position; if player.Character then player.Character:MoveTo(spawnerPosition) end end
                if spawnerPosition then task.wait(1.5) end

                local chosen = nil
                local currentTargetSource = "Brainrots"

                while getgenv().TeleportToBrainrot do
                    if not player.Character then task.wait(1); continue end
                    if farmPart and not isPlayerInFarmZone(player.Character, farmPart) then
                        if spawnerPosition and player.Character then player.Character:MoveTo(spawnerPosition) end
                        task.wait(5); continue
                    end

                    local targetFolder = workspace:FindFirstChild("ScriptedMap", true)
                    local list = {}
                    currentTargetSource = "Brainrots"

                    if targetFolder then
                        local brainrotsFolder = targetFolder:FindFirstChild("Brainrots")
                        if brainrotsFolder then list = brainrotsFolder:GetChildren() end
                        if #list == 0 then
                            local missionBrainrotsFolder = targetFolder:FindFirstChild("MissionBrainrots")
                            if missionBrainrotsFolder then list = missionBrainrotsFolder:GetChildren(); currentTargetSource = "MissionBrainrots" end
                        end
                    end

                    if not chosen or not chosen.Parent then
                        if #list > 0 then
                             local potentialTargets = {}
                             for _, item in ipairs(list) do
                                 if farmPart and isPartInZone(item, farmPart) then
                                     table.insert(potentialTargets, item)
                                 end
                             end
                             if #potentialTargets > 0 then
                                chosen = potentialTargets[math.random(1, #potentialTargets)]
                             else
                                chosen = nil
                             end
                        else
                             chosen = nil
                        end

                        if chosen then
                            local targetID = chosen:GetAttribute("ID")
                            if targetID then
                                getgenv().currentTargetInfo = { id = targetID, source = currentTargetSource }
                            else
                                getgenv().currentTargetInfo = nil
                            end
                        else
                            getgenv().currentTargetInfo = nil
                        end
                    end

                    if chosen and chosen.Parent then
                        player.Character:MoveTo(chosen:GetPivot().Position)
                    end
                    task.wait(0.1)
                end
            end)
        else
            if farmPart then farmPart:Destroy(); farmPart = nil end
        end
    end
})

AutoTab:Section("Auto Hit")

local Players = game:GetService("Players")
local player = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

getgenv().AttackSpeed = 0.25

local SpeedSlider = AutoTab:Slider({
    Title = "Hit Speed",
    Description = "Set Speed to Auto Hit",
    Min = 0,
    Max = 1,
    Default = 0.25,
    Suffix = "s",
    Rounding = 2,
    Flag = "AttackSpeedSlider",
    Callback = function(value)
        getgenv().AttackSpeed = value
    end
})

getgenv().AutoHitMode = "Normal"

local ModeDropdown = AutoTab:Dropdown({
    Title = "Select Hit Mode",
    Options = {"Normal", "Remote", "Normal + Remote"},
    Default = "Normal",
    Flag = "AutoHitModeFlag",
    Callback = function(mode)
        getgenv().AutoHitMode = mode
    end
})

getgenv().AutoFarm = false

local AutoFarmToggle = AutoTab:Toggle({
    Title = "Auto Hit",
    Default = false,
    Flag = "AutoFarm",
    Callback = function(value)
        getgenv().AutoFarm = value
        
        if value then
            task.spawn(function()
                local player = game:GetService("Players").LocalPlayer

                local batPriority = {
                    "Rifling Bat", "Spiked Bat", "Fluted Bat",
                    "Skeletonized Bat", "Hammer Bat", "Aluminum Bat", "Iron Core Bat", "Iron Plate Bat", "Leather Grip Bat", "Basic Bat"
                }

                local function isPlayerInZone(character, zone)
                    if not character or not zone then return false end
                    local hrp = character:FindFirstChild("HumanoidRootPart")
                    if not hrp then return false end
                    local playerPos = hrp.Position; local zonePos = zone.Position; local zoneSize = zone.Size
                    local minX = zonePos.X - zoneSize.X / 2; local maxX = zonePos.X + zoneSize.X / 2
                    local minY = zonePos.Y - zoneSize.Y / 2; local maxY = zonePos.Y + zoneSize.Y / 2
                    local minZ = zonePos.Z - zoneSize.Z / 2; local maxZ = zonePos.Z + zoneSize.Z / 2
                    return (playerPos.X >= minX and playerPos.X <= maxX and playerPos.Y >= minY and playerPos.Y <= maxY and playerPos.Z >= minZ and playerPos.Z <= maxZ)
                end

                while getgenv().AutoFarm do
                    local character = player.Character
                    local humanoid = character and character:FindFirstChild("Humanoid")
                    
                    if humanoid then
                        local eventZone = workspace:FindFirstChild("EventZone")

                        if eventZone and isPlayerInZone(character, eventZone) then
                            humanoid:UnequipTools()
                        else
                            local bestBatFound = nil
                            for _, batName in ipairs(batPriority) do
                                local foundBat = player.Backpack:FindFirstChild(batName) or (character and character:FindFirstChild(batName))
                                if foundBat then bestBatFound = foundBat; break end
                            end
                            
                            if bestBatFound then
                                if not character:FindFirstChild(bestBatFound.Name) then
                                    humanoid:EquipTool(bestBatFound)
                                    task.wait(0.1)
                                end
                                
                                local currentMode = getgenv().AutoHitMode

                                if currentMode == "Normal" or currentMode == "Normal + Remote" then
                                    if character:FindFirstChild(bestBatFound.Name) then
                                        bestBatFound:Activate()
                                    end
                                end
    
                                if currentMode == "Remote" or currentMode == "Normal + Remote" then
                                    local targetInfo = getgenv().currentTargetInfo 
                                    if targetInfo and targetInfo.id and targetInfo.source then
                                        local args
                                        if targetInfo.source == "Brainrots" then
                                            args = {[1] = {["NormalBrainrots"] = {[1] = targetInfo.id}, ["MissionBrainrots"] = {}}}
                                        elseif targetInfo.source == "MissionBrainrots" then
                                            args = {[1] = {["NormalBrainrots"] = {}, ["MissionBrainrots"] = {[1] = targetInfo.id}}}
                                        end

                                        if args then
                                            pcall(function() ReplicatedStorage.Remotes.AttacksServer.WeaponAttack:FireServer(unpack(args)) end)
                                        end
                                    end
                                 end
                            end
                        end
                    end
                    
                    task.wait(getgenv().AttackSpeed) 
                end
            end)
        end
    end
})

AutoTab:Section("Auto Equip And Collect Money")

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local BestBrainrotsLabel = AutoTab:Label({
    Text = "1 = 1 sec / 600 = 10 min"
})

getgenv().EquipDelay = 60

local DelaySlider = AutoTab:Slider({
    Title = "Equip Best Brainrots Delay",
    Description = "Set Speed to Equip Best Brainrots",
    Min = 1,
    Max = 600,
    Default = 60,
    Suffix = "s",
    Rounding = 0,
    Flag = "EquipDelaySlider",
    Callback = function(value)
        getgenv().EquipDelay = value
    end
})

getgenv().AutoEquipBest = false

local AutoEquipToggle = AutoTab:Toggle({
    Title = "Auto Equip Best Brainrots",
    Default = false,
    Flag = "AutoEquipBest",
    Callback = function(value)
        getgenv().AutoEquipBest = value

        if value then
            task.spawn(function()
                while getgenv().AutoEquipBest do
                    game:GetService("ReplicatedStorage").Remotes.EquipBestBrainrots:FireServer()
                    
                    task.wait(getgenv().EquipDelay) 
                end
            end)
        end
    end
})

AutoTab:Section("Auto Open Eggs")

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local LocalPlayer = Players.LocalPlayer
local Backpack = LocalPlayer:WaitForChild("Backpack")

getgenv().SelectedEggs = { "Godly Lucky Egg" }
getgenv().AutoOpenEgg = false

local EggDropdown = AutoTab:Dropdown({
    Title = "Select Eggs to Open",
    Options = { "Godly Lucky Egg", "Secret Lucky Egg", "Meme Lucky Egg" },
    Default = getgenv().SelectedEggs,
    Multi = true,
    Callback = function(option)
        getgenv().SelectedEggs = option
    end
})

local AutoOpenEggToggle = AutoTab:Toggle({
    Title = "Auto Open Egg",
    Desc = "Equips and opens selected eggs in a loop.",
    Default = false,
    Flag = "AutoOpenEgg",
    Callback = function(value)
        getgenv().AutoOpenEgg = value
        if value then
            task.spawn(function()
                while getgenv().AutoOpenEgg do
                    for _, eggName in pairs(getgenv().SelectedEggs) do
                        if not getgenv().AutoOpenEgg then break end
                        local foundEgg = nil
                        for _, tool in pairs(Backpack:GetChildren()) do
                            if string.find(string.lower(tool.Name), string.lower(eggName)) then
                                foundEgg = tool
                                break
                            end
                        end

                        if foundEgg then
                            local humanoid = LocalPlayer.Character and LocalPlayer.Character:FindFirstChildOfClass("Humanoid")
                            if humanoid then
                                humanoid:EquipTool(foundEgg)
                                task.wait(0.2)
                                ReplicatedStorage.Remotes.OpenEgg:FireServer()
                            end
                        end

                        task.wait(0.5)
                    end
                    task.wait(0.2)
                end
            end)
        end
    end
})

AutoTab:Section("Auto Favorite Brainrots")

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local selectedBrainrotRarities = {}
local isFavoriteBrainrotLoopRunning = false

local BrainrotRarityOptions = {"Rare", "Epic", "Legendary", "Mythic", "Godly", "Secret", "Limited"}

local BrainrotRarityDropdown = AutoTab:Dropdown({
    Title = "Select Rarity",
    Options = BrainrotRarityOptions,
    Multi = true,
    Default = {},
    Flag = "BrainrotRaritySelection",
    Callback = function(selected_options)
        selectedBrainrotRarities = selected_options
    end
})

local FavoriteBrainrotToggle = AutoTab:Toggle({
    Title = "Auto Favorite Brainrot By Rarity",
    Default = false,
    Flag = "AutoFavoriteBrainrotToggle",
    Callback = function(value)
        if value then
            if isFavoriteBrainrotLoopRunning then return end
            isFavoriteBrainrotLoopRunning = true
            MacUI:Notify({ Title = "Started", Content = "Start Auto Favorite Brainrots", Duration = 3 })

            task.spawn(function()
                while isFavoriteBrainrotLoopRunning do
                    local localPlayer = Players.LocalPlayer
                    if not localPlayer or not localPlayer.Character then break end

                    local backpack = localPlayer.Backpack
                    local playerGui = localPlayer.PlayerGui
                    local hotbarSlots = UserInputService.TouchEnabled and 6 or 10

                    local function table_contains(tbl, val)
                        for _, v in ipairs(tbl) do
                            if v == val then return true end
                        end
                        return false
                    end

                    for _, tool in ipairs(backpack:GetChildren()) do
                        local success, err = pcall(function()
                            if tool and tool:IsA("Tool") then
                                local brainrotValue = tool:GetAttribute("Brainrot")
                                if not brainrotValue then return end

                                local isToolFavorited = false
                                
                                for i = 1, hotbarSlots do
                                    local slot = playerGui.BackpackGui.Backpack.Hotbar:FindFirstChild(tostring(i))
                                    local toolNameLabel = slot and slot:FindFirstChild("ToolName")
                                    if toolNameLabel and toolNameLabel.Text ~= "" and toolNameLabel.Text == tool.Name then
                                        if slot:FindFirstChild("HeartIcon") then isToolFavorited = true; break end
                                    end
                                end

                                if not isToolFavorited then
                                    local inventoryFrame = playerGui.BackpackGui.Backpack.Inventory.ScrollingFrame:FindFirstChild("UIGridFrame")
                                    if inventoryFrame then
                                        for _, itemSlot in ipairs(inventoryFrame:GetChildren()) do
                                            if itemSlot:IsA("TextButton") then
                                                local toolNameLabel = itemSlot:FindFirstChild("ToolName")
                                                if toolNameLabel and toolNameLabel.Text ~= "" and toolNameLabel.Text == tool.Name then
                                                    if itemSlot:FindFirstChild("HeartIcon") then isToolFavorited = true; break end
                                                end
                                            end
                                        end
                                    end
                                end
                                
                                if isToolFavorited then
                                    return 
                                end
                                
                                local uuidValue = tool:GetAttribute("ID")
                                if uuidValue and #selectedBrainrotRarities > 0 then
                                    local nestedModel = tool:FindFirstChild(brainrotValue)
                                    if nestedModel then
                                        local rarityValue = nestedModel:GetAttribute("Rarity")
                                        
                                        if rarityValue and table_contains(selectedBrainrotRarities, rarityValue) then
                                            local args = { [1] = uuidValue }
                                            ReplicatedStorage.Remotes.FavoriteItem:FireServer(unpack(args))
                                            MacUI:Notify({ Title = "Auto Favorite", Content = "Favorite: " .. tool.Name, Duration = 3 })
                                        end
                                    end
                                end
                            end
                        end)
                        if not success then
                            print("เกิด Error ขณะตรวจสอบไอเท็ม แต่ทำงานต่อได้:", err)
                        end
                    end
                    task.wait(1)
                end
            end)
        else
            if isFavoriteBrainrotLoopRunning then
                isFavoriteBrainrotLoopRunning = false
                MacUI:Notify({ Title = "Stopped", Content = "Stop Auto Favorite Brainrots", Duration = 4 })
            end
        end
    end
})

AutoTab:Section("Auto Favorite Plants")

local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local selectedPlantRarities = {}
local isFavoritePlantLoopRunning = false

local PlantsRarityOptions = {"Rare", "Epic", "Legendary", "Mythic", "Godly", "Secret", "Limited"}

local PlantRarityDropdown = AutoTab:Dropdown({
    Title = "Select Rarity",
    Options = PlantsRarityOptions,
    Multi = true,
    Default = {},
    Flag = "PlantRaritySelection",
    Callback = function(selected_options)
        selectedPlantRarities = selected_options
    end
})

local FavoritePlantToggle = AutoTab:Toggle({
    Title = "Auto Favorite Plants By Rarity",
    Default = false,
    Flag = "AutoFavoritePlantToggle",
    Callback = function(value)
        if value then
            if isFavoritePlantLoopRunning then return end
            isFavoritePlantLoopRunning = true
            MacUI:Notify({ Title = "Started", Content = "Start Auto Favorite Plants", Duration = 3 })

            task.spawn(function()
                while isFavoritePlantLoopRunning do
                    local localPlayer = Players.LocalPlayer
                    if not localPlayer or not localPlayer.Character then break end

                    local backpack = localPlayer.Backpack
                    local character = localPlayer.Character
                    local playerGui = localPlayer.PlayerGui
                    local hotbarSlots = UserInputService.TouchEnabled and 6 or 10

                    local function table_contains(tbl, val)
                        for _, v in ipairs(tbl) do
                            if v == val then return true end
                        end
                        return false
                    end

                    for _, tool in ipairs(backpack:GetChildren()) do
                        pcall(function()
                            if tool and tool:IsA("Tool") then
                                local plantValue = tool:GetAttribute("Plant")
                                if not plantValue then return end

                                local isToolFavorited = false
                                
                                for i = 1, hotbarSlots do
                                    local slot = playerGui.BackpackGui.Backpack.Hotbar:FindFirstChild(tostring(i))
                                    local toolNameLabel = slot and slot:FindFirstChild("ToolName")
                                    if toolNameLabel and toolNameLabel.Text ~= "" and toolNameLabel.Text == tool.Name then
                                        if slot:FindFirstChild("HeartIcon") then isToolFavorited = true; break end
                                    end
                                end

                                if not isToolFavorited then
                                    local inventoryFrame = playerGui.BackpackGui.Backpack.Inventory.ScrollingFrame:FindFirstChild("UIGridFrame")
                                    if inventoryFrame then
                                        for _, itemSlot in ipairs(inventoryFrame:GetChildren()) do
                                            if itemSlot:IsA("TextButton") then
                                                local toolNameLabel = itemSlot:FindFirstChild("ToolName")
                                                if toolNameLabel and toolNameLabel.Text ~= "" and toolNameLabel.Text == tool.Name then
                                                    if itemSlot:FindFirstChild("HeartIcon") then isToolFavorited = true; break end
                                                end
                                            end
                                        end
                                    end
                                end
                                
                                if isToolFavorited then
                                    return 
                                end
                                
                                local uuidValue = tool:GetAttribute("ID")
                                if uuidValue and #selectedPlantRarities > 0 then
                                    local nestedModel = tool:FindFirstChild(plantValue)
                                    if nestedModel then
                                        local rarityValue = nestedModel:GetAttribute("Rarity")
                                        
                                        if rarityValue and table_contains(selectedPlantRarities, rarityValue) then
                                            local args = { [1] = uuidValue }
                                            ReplicatedStorage.Remotes.FavoriteItem:FireServer(unpack(args))
                                            MacUI:Notify({ Title = "Auto Favorite", Content = "Favorite: " .. tool.Name, Duration = 3 })
                                        end
                                    end
                                end
                            end
                        end)
                        task.wait()
                    end

                    if character then
                        for _, tool in ipairs(character:GetChildren()) do
                            pcall(function()
                                if tool and tool:IsA("Tool") then
                                    local plantValue = tool:GetAttribute("Plant")
                                    if not plantValue then return end
                                    
                                    if isToolFavorited then
                                        return 
                                    end
                                    
                                    local uuidValue = tool:GetAttribute("ID")
                                    if uuidValue and #selectedPlantRarities > 0 then
                                        local nestedModel = tool:FindFirstChild(plantValue)
                                        if nestedModel then
                                            local rarityValue = nestedModel:GetAttribute("Rarity")
                                            
                                            if rarityValue and table_contains(selectedPlantRarities, rarityValue) then
                                                local args = { [1] = uuidValue }
                                                ReplicatedStorage.Remotes.FavoriteItem:FireServer(unpack(args))
                                                MacUI:Notify({ Title = "Auto Favorite", Content = "Favorite: " .. tool.Name, Duration = 3 })
                                            end
                                        end
                                    end
                                end
                            end)
                        end
                    end

                    task.wait(1)
                end
            end)
        else
            if isFavoritePlantLoopRunning then
                isFavoritePlantLoopRunning = false
                MacUI:Notify({ Title = "Stopped", Content = "Stop Auto Favorite Plants", Duration = 4 })
            end
        end
    end
})

AutoTab:Section("Auto Favorite by Mutation")

local AllMutationOptions = {"Gold", "Diamond", "Neon", "Frozen", "UpsideDown", "Rainbow", "Galactic", "Magma", "Underworld"}
local selectedSharedMutations = {}

local SharedMutationDropdown = AutoTab:Dropdown({
    Title = "Select Mutation",
    Options = AllMutationOptions,
    Multi = true,
    Default = {},
    Flag = "SharedMutationSelection",
    Callback = function(selected_options)
        selectedSharedMutations = selected_options
    end
})

local isFavoriteBrainrotMutationLoopRunning = false
local FavoriteBrainrotToggle = AutoTab:Toggle({
    Title = "Auto Favorite Brainrot By Mutation",
    Default = false,
    Flag = "AutoFavoriteBrainrotToggle",
    Callback = function(value)
        if value then
            if isFavoriteBrainrotMutationLoopRunning then return end
            isFavoriteBrainrotMutationLoopRunning = true
            MacUI:Notify({ Title = "Started", Content = "Start Auto Favorite Brainrots", Duration = 3 })

            task.spawn(function()
                while isFavoriteBrainrotMutationLoopRunning do
                    local localPlayer = Players.LocalPlayer
                    if not localPlayer or not localPlayer.Character then break end
                    local backpack = localPlayer.Backpack
                    local character = localPlayer.Character
                    local playerGui = localPlayer.PlayerGui
                    local hotbarSlots = UserInputService.TouchEnabled and 6 or 10

                    local function table_contains(tbl, val)
                        for _, v in ipairs(tbl) do
                            if v == val then return true end
                        end
                        return false
                    end

                    local function processTool(tool)
                        if tool and tool:IsA("Tool") then
                            local brainrotValue = tool:GetAttribute("Brainrot")
                            if not brainrotValue then return end
                            
                            local isToolFavorited = false
                            for i = 1, hotbarSlots do
                                local slot = playerGui.BackpackGui.Backpack.Hotbar:FindFirstChild(tostring(i))
                                local toolNameLabel = slot and slot:FindFirstChild("ToolName")
                                if toolNameLabel and toolNameLabel.Text ~= "" and toolNameLabel.Text == tool.Name then
                                    if slot:FindFirstChild("HeartIcon") then isToolFavorited = true; break end
                                end
                            end
                            if not isToolFavorited then
                                local inventoryFrame = playerGui.BackpackGui.Backpack.Inventory.ScrollingFrame:FindFirstChild("UIGridFrame")
                                if inventoryFrame then
                                    for _, itemSlot in ipairs(inventoryFrame:GetChildren()) do
                                        if itemSlot:IsA("TextButton") then
                                            local toolNameLabel = itemSlot:FindFirstChild("ToolName")
                                            if toolNameLabel and toolNameLabel.Text ~= "" and toolNameLabel.Text == tool.Name then
                                                if itemSlot:FindFirstChild("HeartIcon") then isToolFavorited = true; break end
                                            end
                                        end
                                    end
                                end
                            end

                            if isToolFavorited then
                                return 
                            end
                            
                            local uuidValue = tool:GetAttribute("ID")
                            if uuidValue and #selectedSharedMutations > 0 then
                                local nestedModel = tool:FindFirstChild(brainrotValue)
                                if nestedModel then
                                    local mutationValue = nestedModel:GetAttribute("Mutation")
                                    if mutationValue and table_contains(selectedSharedMutations, mutationValue) then
                                        local args = { [1] = uuidValue }
                                        ReplicatedStorage.Remotes.FavoriteItem:FireServer(unpack(args))
                                        MacUI:Notify({ Title = "Auto Favorite", Content = "Favorite: " .. tool.Name, Duration = 3 })
                                    end
                                end
                            end
                        end
                    end

                    for _, tool in ipairs(backpack:GetChildren()) do
                        pcall(processTool, tool)
                    end

                    if character then
                        for _, tool in ipairs(character:GetChildren()) do
                            pcall(processTool, tool)
                        end
                    end
                    
                    task.wait(1)
                end
            end)
        else
            if isFavoriteBrainrotMutationLoopRunning then
                isFavoriteBrainrotMutationLoopRunning = false
                MacUI:Notify({ Title = "Stopped", Content = "Stop Auto Favorite Brainrots", Duration = 4 })
            end
        end
    end
})

local isFavoritePlantMutationLoopRunning = false
local FavoritePlantToggle = AutoTab:Toggle({
    Title = "Auto Favorite Plants By Mutation",
    Default = false,
    Flag = "AutoFavoritePlantToggle",
    Callback = function(value)
        if value then
            if isFavoritePlantMutationLoopRunning then return end
            isFavoritePlantMutationLoopRunning = true
            MacUI:Notify({ Title = "Started", Content = "Start Auto Favorite Plants", Duration = 3 })

            task.spawn(function()
                while isFavoritePlantMutationLoopRunning do
                    local localPlayer = Players.LocalPlayer
                    if not localPlayer or not localPlayer.Character then break end
                    local backpack = localPlayer.Backpack
                    local character = localPlayer.Character
                    local playerGui = localPlayer.PlayerGui
                    local hotbarSlots = UserInputService.TouchEnabled and 6 or 10

                    local function table_contains(tbl, val)
                        for _, v in ipairs(tbl) do
                            if v == val then return true end
                        end
                        return false
                    end
                    
                    local function processTool(tool)
                        if tool and tool:IsA("Tool") then
                            local plantValue = tool:GetAttribute("Plant")
                            if not plantValue then return end

                            local isToolFavorited = false
                            for i = 1, hotbarSlots do
                                local slot = playerGui.BackpackGui.Backpack.Hotbar:FindFirstChild(tostring(i))
                                local toolNameLabel = slot and slot:FindFirstChild("ToolName")
                                if toolNameLabel and toolNameLabel.Text ~= "" and toolNameLabel.Text == tool.Name then
                                    if slot:FindFirstChild("HeartIcon") then isToolFavorited = true; break end
                                end
                            end

                            if not isToolFavorited then
                                local inventoryFrame = playerGui.BackpackGui.Backpack.Inventory.ScrollingFrame:FindFirstChild("UIGridFrame")
                                if inventoryFrame then
                                    for _, itemSlot in ipairs(inventoryFrame:GetChildren()) do
                                        if itemSlot:IsA("TextButton") then
                                            local toolNameLabel = itemSlot:FindFirstChild("ToolName")
                                            if toolNameLabel and toolNameLabel.Text ~= "" and toolNameLabel.Text == tool.Name then
                                                if itemSlot:FindFirstChild("HeartIcon") then isToolFavorited = true; break end
                                            end
                                        end
                                    end
                                end
                            end
                            
                            if isToolFavorited then
                                return 
                            end
                            
                            local uuidValue = tool:GetAttribute("ID")
                            if uuidValue and #selectedSharedMutations > 0 then
                                local nestedModel = tool:FindFirstChild(plantValue)
                                if nestedModel then
                                    local mutationValue = nestedModel:GetAttribute("Mutation")
                                    if mutationValue and table_contains(selectedSharedMutations, mutationValue) then
                                        local args = { [1] = uuidValue }
                                        ReplicatedStorage.Remotes.FavoriteItem:FireServer(unpack(args))
                                        MacUI:Notify({ Title = "Auto Favorite", Content = "Favorite: " .. tool.Name, Duration = 3 })
                                    end
                                end
                            end
                        end
                    end

                    for _, tool in ipairs(backpack:GetChildren()) do
                        pcall(processTool, tool)
                    end

                    if character then
                        for _, tool in ipairs(character:GetChildren()) do
                            pcall(processTool, tool)
                        end
                    end

                    task.wait(1)
                end
            end)
        else
            if isFavoritePlantMutationLoopRunning then
                isFavoritePlantMutationLoopRunning = false
                MacUI:Notify({ Title = "Stopped", Content = "Stop Auto Favorite Plants", Duration = 4 })
            end
        end
    end
})

local ShopTab = Window:Tab("Shop", "rbxassetid://11385419674")

ShopTab:Section("Auto Buy Seed")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local buySeedRemote = ReplicatedStorage.Remotes.BuyItem

local AllSeeds = { "Cactus Seed", "Strawberry Seed", "Pumpkin Seed", "Sunflower Seed", "Dragon Fruit Seed", "Eggplant Seed", "Watermelon Seed", "Grape Seed", "Cocotank Seed", "Carnivorous Plant Seed", "Mr Carrot Seed", "Tomatrio Seed", "Shroombino Seed", "Mango Seed", "King Limone Seed", "Starfruit Seed" }

getgenv().SelectedBuySeeds = {}
getgenv().AutoBuySeedSelected = false
getgenv().AutoBuySeedAll = false

local SeedDropdown = ShopTab:Dropdown({
    Title = "Select Seeds",
    Options = AllSeeds,
    Multi = true,
    Default = {},
    Callback = function(selected)
        getgenv().SelectedBuySeeds = selected
    end
})

local AutoBuySeedSelectedToggle = ShopTab:Toggle({
    Title = "Auto Buy Seed [Selected]",
    Default = false,
    Flag = "AutoBuySeedSelected",
    Callback = function(value)
        getgenv().AutoBuySeedSelected = value
        if value then
            task.spawn(function()
                while getgenv().AutoBuySeedSelected do
                    if #getgenv().SelectedBuySeeds > 0 then
                        for _, seed in ipairs(getgenv().SelectedBuySeeds) do
                            if not getgenv().AutoBuySeedSelected then break end
                            buySeedRemote:FireServer(seed, true)
                            task.wait(0.5)
                        end
                    else
                        task.wait(1)
                    end
                end
            end)
        end
    end
})

local AutoBuyAllToggle = ShopTab:Toggle({
    Title = "Auto Buy Seed [All]",
    Default = false,
    Flag = "AutoBuySeedAll",
    Callback = function(value)
        getgenv().AutoBuySeedAll = value
        if value then
            task.spawn(function()
                while getgenv().AutoBuySeedAll do
                    for _, seed in ipairs(AllSeeds) do
                        if not getgenv().AutoBuySeedAll then break end
                        buySeedRemote:FireServer(seed, true)
                        task.wait(0.5)
                    end
                end
            end)
        end
    end
})

ShopTab:Section("Auto Buy Gear")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local buyRemote = ReplicatedStorage.Remotes.BuyGear

local AllItems = { "Water Bucket", "Frost Grenade", "Banana Gun", "Frost Blower", "Carrot Launcher" }

getgenv().SelectedBuyItems = {}
getgenv().AutoBuySelected = false
getgenv().AutoBuyAll = false

local ItemDropdown = ShopTab:Dropdown({
    Title = "Select Gear",
    Options = AllItems,
    Multi = true,
    Default = {},
    Callback = function(selected)
        getgenv().SelectedBuyItems = selected
    end
})

local AutoBuySelectedToggle = ShopTab:Toggle({
    Title = "Auto Buy Gear [Selected]",
    Default = false,
    Flag = "AutoBuySelected",
    Callback = function(value)
        getgenv().AutoBuySelected = value

        if value then
            task.spawn(function()
                while getgenv().AutoBuySelected do
                    if #getgenv().SelectedBuyItems > 0 then
                        for _, item in ipairs(getgenv().SelectedBuyItems) do
                            if not getgenv().AutoBuySelected then break end
                            buyRemote:FireServer(item, true)
                            task.wait(0.5)
                        end
                    else
                        task.wait(1)
                    end
                end
            end)
        end
    end
})

local AutoBuyGearAllToggle = ShopTab:Toggle({
    Title = "Auto Buy Gear [All]",
    Default = false,
    Flag = "AutoBuyAll",
    Callback = function(value)
        getgenv().AutoBuyAll = value

        if value then
            task.spawn(function()
                while getgenv().AutoBuyAll do
                    for _, item in ipairs(AllItems) do
                        if not getgenv().AutoBuyAll then break end
                        buyRemote:FireServer(item, true)
                        task.wait(0.5)
                    end
                end
            end)
        end
    end
})

local SellTab = Window:Tab("Sell", "rbxassetid://10698878025")

SellTab:Section("Auto Sell Brainrots")

local SellBrainrotLabel = SellTab:Label({
    Text = "1 = 1 sec / 600 = 10 min"
})

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local itemSellRemote = ReplicatedStorage.Remotes.ItemSell

getgenv().SellDelay = 1
getgenv().AutoSell = false
getgenv().AutoSellFull = false

local SellDelaySlider = SellTab:Slider({
    Title = "Sell Brainrots All Delay",
    Min = 1,
    Max = 600,
    Default = 1,
    Rounding = 0,
    Suffix = "s",
    Flag = "SellDelaySlider",
    Callback = function(value)
        getgenv().SellDelay = value
    end
})

local AutoSellToggle = SellTab:Toggle({
    Title = "Auto Sell Brainrots All",
    Default = false,
    Flag = "AutoSell",
    Callback = function(value)
        getgenv().AutoSell = value
        if value then
            task.spawn(function()
                while getgenv().AutoSell do
                    itemSellRemote:FireServer()
                    task.wait(getgenv().SellDelay)
                end
            end)
        end
    end
})

local AutoSellFullToggle = SellTab:Toggle({
    Title = "Auto Sell Brainrots All When Inventory Full",
    Default = false,
    Flag = "AutoSellFull",
    Callback = function(value)
        getgenv().AutoSellFull = value
        if value then
            task.spawn(function()
                while getgenv().AutoSellFull do
                    local player = Players.LocalPlayer
                    if player then
                        local backpack = player:WaitForChild("Backpack")
                        if #backpack:GetChildren() >= 250 then
                            itemSellRemote:FireServer()
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})

SellTab:Section("Auto Sell Plants")

local SellPlantLabel = SellTab:Label({
    Text = "1 = 1 sec / 600 = 10 min"
})

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local plantSellRemote = ReplicatedStorage.Remotes.ItemSell

getgenv().PlantSellDelay = 1
getgenv().AutoSellPlants = false
getgenv().AutoSellPlantsFull = false

local PlantSellDelaySlider = SellTab:Slider({
    Title = "Sell Plants All Delay",
    Min = 1,
    Max = 600,
    Default = 1,
    Rounding = 0,
    Suffix = "s",
    Flag = "PlantSellDelaySlider",
    Callback = function(value)
        getgenv().PlantSellDelay = value
    end
})

local AutoSellPlantsToggle = SellTab:Toggle({
    Title = "Auto Sell Plants All",
    Default = false,
    Flag = "AutoSellPlants",
    Callback = function(value)
        getgenv().AutoSellPlants = value
        if value then
            task.spawn(function()
                while getgenv().AutoSellPlants do
                    local args = { [2] = true }
                    plantSellRemote:FireServer(unpack(args))
                    task.wait(getgenv().PlantSellDelay)
                end
            end)
        end
    end
})

local AutoSellPlantsFullToggle = SellTab:Toggle({
    Title = "Auto Sell Plants All When Inventory Full",
    Default = false,
    Flag = "AutoSellPlantsFull",
    Callback = function(value)
        getgenv().AutoSellPlantsFull = value
        if value then
            task.spawn(function()
                while getgenv().AutoSellPlantsFull do
                    local player = Players.LocalPlayer
                    if player then
                        local backpack = player:WaitForChild("Backpack")
                        if #backpack:GetChildren() >= 250 then
                            local args = { [2] = true }
                            plantSellRemote:FireServer(unpack(args))
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})

SellTab:Section("Auto Sell Brainrots + Plants")

local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")
local itemSellRemote = ReplicatedStorage.Remotes.ItemSell
local plantSellRemote = ReplicatedStorage.Remotes.ItemSell

getgenv().AutoSellAllFull = false

local AutoSellAllFullToggle = SellTab:Toggle({
    Title = "Auto Sell All When Inventory Full",
    Default = false,
    Flag = "AutoSellAllFull",
    Callback = function(value)
        getgenv().AutoSellAllFull = value
        if value then
            task.spawn(function()
                while getgenv().AutoSellAllFull do
                    local player = Players.LocalPlayer
                    if player then
                        local backpack = player:WaitForChild("Backpack")
                        if #backpack:GetChildren() >= 250 then
                            local args = { [2] = true }
                            itemSellRemote:FireServer(unpack(args))
                            plantSellRemote:FireServer(unpack(args))
                        end
                    end
                    task.wait(1)
                end
            end)
        end
    end
})


SellTab:Section("Auto Confirm")

local VirtualInputManager = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local AutoConfirmEnabled = false

local AutoConfirmSellToggle = SellTab:Toggle({
    Title = "Auto Confirm Brainrot or Plants Sell",
    Desc = "Auto Confirm",
    Default = false,
    Flag = "AutoConfirmPopUp",
    Callback = function(state)
        AutoConfirmEnabled = state

        if state then
            task.spawn(function()
                while AutoConfirmEnabled do
                    task.wait(0.5)

                    local touchGui = PlayerGui:FindFirstChild("TouchGui")
                    if touchGui and touchGui.Enabled == false then
                        touchGui.Enabled = true
                    end

                    local hud = PlayerGui:FindFirstChild("HUD")
                    local popup = hud and hud:FindFirstChild("PopUp")
                    local content = popup and popup:FindFirstChild("Content")
                    local textLabel = content and content:FindFirstChild("TextLabel")
                    local buttons = content and content:FindFirstChild("Buttons")
                    local yesButton = buttons and buttons:FindFirstChild("Yes")

                    if textLabel and textLabel.Text and yesButton and yesButton.Visible then
                        local text = textLabel.Text:lower()
                        if string.find(text, "are you sure you want to sell your brainrots") then
                            pcall(function()
                                local absPos = yesButton.AbsolutePosition
                                local absSize = yesButton.AbsoluteSize
                                local clickX = absPos.X + absSize.X * 1
                                local clickY = absPos.Y + absSize.Y * 1.75
                                VirtualInputManager:SendMouseButtonEvent(clickX, clickY, 0, true, nil, 0)
                                VirtualInputManager:SendMouseButtonEvent(clickX, clickY, 0, false, nil, 0)
                            end)
                            task.wait(1)
                        end
                    end
                end
            end)
        end
    end
})

local TeleportTab = Window:Tab("Teleport", "rbxassetid://6723742952")

TeleportTab:Section("Home")

local TeleportGrassButton = TeleportTab:Button({
    Title = "Teleport to Plots",
    Desc = "Goto Your Plots",
    Callback = function()
        local player = game:GetService("Players").LocalPlayer
        local plots = workspace:WaitForChild("Plots")

        for i = 1, 6 do
            local plot = plots:FindFirstChild(tostring(i))
            if plot and plot:GetAttribute("Owner") == player.Name then
                pcall(function()
                    local target = plot:WaitForChild("Rows"):WaitForChild("1"):WaitForChild("Grass"):GetChildren()[9]
                    if target and target:IsA("BasePart") then
                        player.Character:WaitForChild("HumanoidRootPart").CFrame = target.CFrame + Vector3.new(0, 5, 0)
                    end
                end)
                break
            end
        end
    end
})

TeleportTab:Section("Event")

local TeleportFixedButton = TeleportTab:Button({
    Title = "Teleport to Event",
    Desc = "Goto Event Area",
    Callback = function()
        local player = game:GetService("Players").LocalPlayer
        local hrp = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            hrp.CFrame = CFrame.new(-173.82, 12.49, 999.30)
        end
    end
})

local EventTab = Window:Tab("Event", "rbxassetid://128706247346129")

EventTab:Section("Card Event")

getgenv().ActionLock = false

getgenv().AutoDailyEvent = false
local isDailyLoopRunning = false
local dailyEventZonePart = nil

local AutoDailyEventToggle = EventTab:Toggle({
    Title = "Auto Daily Event",
    Desc = "Auto Card event",
    Default = false,
    Flag = "AutoDailyEvent",
    Callback = function(value)
        getgenv().AutoDailyEvent = value
        if value then
            if isDailyLoopRunning then return end
            isDailyLoopRunning = true
            dailyEventZonePart = Instance.new("Part"); dailyEventZonePart.Name = "EventZone"; dailyEventZonePart.Size = Vector3.new(172, 66, 169); dailyEventZonePart.Position = Vector3.new(-176.95, 11.56, 976.97); dailyEventZonePart.Anchored = true; dailyEventZonePart.Transparency = 1; dailyEventZonePart.CanCollide = false; dailyEventZonePart.CastShadow = false; dailyEventZonePart.Parent = workspace
            MacUI:Notify({ Title = "Started", Content = "Start Auto Event", Duration = 3 })
            task.spawn(function()
                while isDailyLoopRunning do
                    if not getgenv().ActionLock then
                        local player = game:GetService("Players").LocalPlayer
                        if not player or not player.Character then break end
                        local UserInputService = game:GetService("UserInputService")
                        local teleportPositions = {
                            ["-1"] = CFrame.new(-218.65, 13.68, 963.75),
                            ["-2"] = CFrame.new(-218.81, 13.68, 973.73),
                            ["-3"] = CFrame.new(-218.61, 13.68, 983.85),
                            ["-4"] = CFrame.new(-218.10, 13.56, 993.87)
                        }
                        local function isToolFavorited(tool)
                            local playerGui = player.PlayerGui
                            if not playerGui then return false end
                            local hotbarSlots = UserInputService.TouchEnabled and 6 or 10
                            local hotbar = playerGui:FindFirstChild("BackpackGui", true) and playerGui.BackpackGui.Backpack:FindFirstChild("Hotbar")
                            if hotbar then
                                for i = 1, hotbarSlots do
                                    local slot = hotbar:FindFirstChild(tostring(i))
                                    local toolNameLabel = slot and slot:FindFirstChild("ToolName")
                                    if toolNameLabel and toolNameLabel.Text ~= "" and toolNameLabel.Text == tool.Name then
                                        if slot:FindFirstChild("HeartIcon") then return true end
                                    end
                                end
                            end
                            local inventoryFrame = playerGui:FindFirstChild("BackpackGui", true) and playerGui.BackpackGui.Backpack.Inventory.ScrollingFrame:FindFirstChild("UIGridFrame")
                            if inventoryFrame then
                                for _, itemSlot in ipairs(inventoryFrame:GetChildren()) do
                                    if itemSlot:IsA("TextButton") then
                                        local toolNameLabel = itemSlot:FindFirstChild("ToolName")
                                        if toolNameLabel and toolNameLabel.Text ~= "" and toolNameLabel.Text == tool.Name then
                                            if itemSlot:FindFirstChild("HeartIcon") then return true end
                                        end
                                    end
                                end
                            end
                            return false
                        end
                        local function isPlayerInZone(character, zone)
                            if not character or not zone then return false end
                            local hrp = character:FindFirstChild("HumanoidRootPart")
                            if not hrp then return false end
                            local playerPos = hrp.Position; local zonePos = zone.Position; local zoneSize = zone.Size
                            local minX = zonePos.X - zoneSize.X / 2; local maxX = zonePos.X + zoneSize.X / 2
                            local minY = zonePos.Y - zoneSize.Y / 2; local maxY = zonePos.Y + zoneSize.Y / 2
                            local minZ = zonePos.Z - zoneSize.Z / 2; local maxZ = zonePos.Z + zoneSize.Z / 2
                            return (playerPos.X >= minX and playerPos.X <= maxX and playerPos.Y >= minY and playerPos.Y <= maxY and playerPos.Z >= minZ and playerPos.Z <= maxZ)
                        end
                        local myPlot
                        for i = 1, 6 do
                            local plot = workspace.Plots:FindFirstChild(tostring(i))
                            if plot and plot:GetAttribute("Owner") == player.Name then
                                myPlot = plot
                                break
                            end
                        end
                        if myPlot then
                            for i = -1, -4, -1 do
                                local platform = myPlot.EventPlatforms:FindFirstChild(tostring(i))
                                if platform then
                                    local ui = platform:FindFirstChild("PlatformEventUI", true)
                                    if ui and ui.Enabled then
                                        local titleLabel = ui:FindFirstChild("Title")
                                        if titleLabel then
                                            local targetBrainrotName = titleLabel.Text
                                            if targetBrainrotName and targetBrainrotName ~= "" and targetBrainrotName ~= "None" then
                                                local backpack = player:WaitForChild("Backpack")
                                                local character = player.Character
                                                local matches = {}
                                                for _, tool in ipairs(backpack:GetChildren()) do
                                                    if tool:IsA("Tool") and string.find(tool.Name, targetBrainrotName) and not isToolFavorited(tool) then
                                                        table.insert(matches, tool)
                                                    end
                                                end
                                                if character then
                                                    for _, tool in ipairs(character:GetChildren()) do
                                                        if tool:IsA("Tool") and string.find(tool.Name, targetBrainrotName) and not isToolFavorited(tool) then
                                                            table.insert(matches, tool)
                                                        end
                                                    end
                                                end
                                                if #matches > 0 then
                                                    getgenv().ActionLock = true
                                                    local toolToEquip = matches[math.random(1, #matches)]
                                                    local humanoidRootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                                                    local targetPosition = teleportPositions[tostring(i)]
                                                    if humanoidRootPart and targetPosition then
                                                        humanoidRootPart.CFrame = targetPosition
                                                        task.wait(0.5)
                                                    end
                                                    if player.Character and player.Character:FindFirstChild("Humanoid") then
                                                       player.Character.Humanoid:EquipTool(toolToEquip)
                                                       MacUI:Notify({ Title = "Platform Event", Content = "Equipped: " .. toolToEquip.Name, Duration = 2 })
                                                       task.wait(0.5)
                                                       if isPlayerInZone(player.Character, dailyEventZonePart) then
                                                           local rootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
                                                            if rootPart then
                                                                for _, instance in ipairs(workspace:GetDescendants()) do
                                                                    if instance:IsA("ProximityPrompt") then
                                                                        local prompt = instance
                                                                        local targetPart = prompt.Parent
                                                                        if targetPart and targetPart:IsA("BasePart") then
                                                                            local distance = (targetPart.Position - rootPart.Position).Magnitude
                                                                            if distance <= prompt.MaxActivationDistance then
                                                                                prompt:InputHoldBegin(); task.wait(prompt.HoldDuration); prompt:InputHoldEnd()
                                                                                MacUI:Notify({ Title = "Event", Content = "Placed Brainrot!", Duration = 2 }); break 
                                                                            end
                                                                        end
                                                                    end
                                                                end
                                                            end
                                                       end
                                                    end
                                                    getgenv().ActionLock = false
                                                    break 
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                        end
                    end
                    task.wait(1.5)
                end
            end)
        else
            if isDailyLoopRunning then
                isDailyLoopRunning = false
                if dailyEventZonePart then dailyEventZonePart:Destroy(); dailyEventZonePart = nil end
                MacUI:Notify({ Title = "Stopped", Content = "Stop Auto Event", Duration = 4 })
            end
        end
    end
})

EventTab:Section("Invasion Event")

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService") 

local isMissionBrainrotAutoRunning = false
local isMissionBrainrotTeleporting = false 
local missionBrainrotRemoteFireLoopActive = false 

local AutoMissionBrainrotToggle = EventTab:Toggle({
    Title = "Auto Farm Mission Brainrot",
    Desc = "Auto Event",
    Default = false,
    Flag = "AutoStartInvasion", 
    Callback = function(value)
        if value then
            if isMissionBrainrotAutoRunning then return end
            isMissionBrainrotAutoRunning = true
            isMissionBrainrotTeleporting = false 
            missionBrainrotRemoteFireLoopActive = false
            MacUI:Notify({ Title = "Auto Invasion", Content = "เริ่มตรวจสอบ Timer...", Duration = 3 })

            task.spawn(function()
                local chosenMissionBrainrot = nil 
                local spawnerPosition = nil 

                local function isPlayerInFarmZone(character, zone)
                    if not character or not zone then return false end
                    local hrp = character:FindFirstChild("HumanoidRootPart")
                    if not hrp then return false end
                    local playerPos = hrp.Position; local zonePos = zone.Position; local zoneSize = zone.Size
                    local minX = zonePos.X - zoneSize.X / 2; local maxX = zonePos.X + zoneSize.X / 2
                    local minY = zonePos.Y - zoneSize.Y / 2; local maxY = zonePos.Y + zoneSize.Y / 2
                    local minZ = zonePos.Z - zoneSize.Z / 2; local maxZ = zonePos.Z + zoneSize.Z / 2
                    return (playerPos.X >= minX and playerPos.X <= maxX and playerPos.Y >= minY and playerPos.Y <= maxY and playerPos.Z >= minZ and playerPos.Z <= maxZ)
                end
                
                local batPriority = {
                    "Rifling Bat", "Spiked Bat", "Fluted Bat",
                    "Skeletonized Bat", "Hammer Bat", "Aluminum Bat", "Iron Core Bat", "Iron Plate Bat", "Leather Grip Bat", "Basic Bat"
                }

                while isMissionBrainrotAutoRunning do
                    local player = Players.LocalPlayer
                    if not player or not player.Character then 
                        isMissionBrainrotAutoRunning = false 
                        break 
                    end
                    
                    if not isMissionBrainrotTeleporting then 
                        local timerFrame = player.PlayerGui:FindFirstChild("Main", true) and player.PlayerGui.Main:FindFirstChild("Right") and player.PlayerGui.Main.Right:FindFirstChild("ImminentAttackTimer")
                        if timerFrame and timerFrame.Visible then
                            local timeLabel = timerFrame:FindFirstChild("Main", true) and timerFrame.Main:FindFirstChild("Time")
                            if timeLabel and timeLabel.Text == "READY!" then
                                MacUI:Notify({ Title = "Auto Invasion", Content = "Invasion is Ready! Starting...", Duration = 3 })
                                pcall(function() ReplicatedStorage.Remotes.MissionServicesRemotes.RequestStartInvasion:FireServer() end)
                                task.wait(1) 
                                isMissionBrainrotTeleporting = true 
                                
                                if not missionBrainrotRemoteFireLoopActive then
                                    missionBrainrotRemoteFireLoopActive = true
                                    task.spawn(function()
                                        while isMissionBrainrotAutoRunning and isMissionBrainrotTeleporting do
                                            local missionBrainrotsFolder = workspace:FindFirstChild("ScriptedMap", true) and workspace.ScriptedMap:FindFirstChild("MissionBrainrots")
                                            if missionBrainrotsFolder then
                                                local brainrotList = missionBrainrotsFolder:GetChildren()
                                                if #brainrotList > 0 then
                                                    for _, brainrotModel in ipairs(brainrotList) do
                                                        if not isMissionBrainrotAutoRunning or not isMissionBrainrotTeleporting then break end 
                                                        if brainrotModel and brainrotModel.Parent then 
                                                            local id = brainrotModel:GetAttribute("ID")
                                                            if id then
                                                                local args = {[1] = {["NormalBrainrots"] = {}, ["MissionBrainrots"] = { id }}}
                                                                ReplicatedStorage.Remotes.AttacksServer.WeaponAttack:FireServer(unpack(args))
                                                                task.wait(0.1) 
                                                            end
                                                        end
                                                    end
                                                else
                                                    task.wait(0.5) 
                                                end
                                            else
                                                task.wait(0.5) 
                                            end
                                        end
                                        missionBrainrotRemoteFireLoopActive = false 
                                    end)
                                end
                            end
                        end
                        task.wait(0.5) 
                    else 
                        local victoryScreen = player.PlayerGui:FindFirstChild("Main", true) and player.PlayerGui.Main:FindFirstChild("Victory_Screen")
                        if victoryScreen and victoryScreen.Visible then
                            MacUI:Notify({ Title = "Auto Invasion", Content = "Invasion Complete! Clicking screen...", Duration = 4 })
                            isMissionBrainrotTeleporting = false 
                            chosenMissionBrainrot = nil 
                            
                            for _ = 1, 3 do
                                if not isMissionBrainrotAutoRunning then break end 
                                local clickPosition = Vector2.new(
                                    workspace.CurrentCamera.ViewportSize.X * 0.5, 
                                    workspace.CurrentCamera.ViewportSize.Y * 0.8 
                                )
                                UserInputService:InvokeMouseButton1Click(clickPosition)
                                task.wait(0.2) 
                            end
                            
                            task.wait(0.5) 
                        else
                            local myPlot
                            for i = 1, 6 do
                                local plot = workspace.Plots:FindFirstChild(tostring(i))
                                if plot and plot:GetAttribute("Owner") == player.Name then myPlot = plot; break end
                            end

                            if myPlot and player.Character then
                                if not spawnerPosition then
                                    local spawner = myPlot:FindFirstChild("SpawnerUI", true); if spawner and spawner:IsA("BasePart") then spawnerPosition = spawner.Position end
                                end

                                local farmZone = workspace:FindFirstChild("FarmZonePart") 
                                if farmZone and not isPlayerInFarmZone(player.Character, farmZone) then
                                    if spawnerPosition then player.Character:MoveTo(spawnerPosition); task.wait(1) end
                                else
                                    local missionBrainrotsFolder = workspace:FindFirstChild("ScriptedMap", true) and workspace.ScriptedMap:FindFirstChild("MissionBrainrots")
                                    if missionBrainrotsFolder then
                                        local list = missionBrainrotsFolder:GetChildren()
                                        if not chosenMissionBrainrot or not chosenMissionBrainrot.Parent then
                                            if #list > 0 then chosenMissionBrainrot = list[math.random(1, #list)] else chosenMissionBrainrot = nil end
                                        end
                                        
                                        if chosenMissionBrainrot and chosenMissionBrainrot.Parent then
                                            player.Character:MoveTo(chosenMissionBrainrot:GetPivot().Position)
                                            
                                            local character = player.Character; local humanoid = character and character:FindFirstChild("Humanoid")
                                            if humanoid then
                                                local bestBatFound = nil
                                                for _, batName in ipairs(batPriority) do local foundBat = player.Backpack:FindFirstChild(batName) or (character and character:FindFirstChild(batName)); if foundBat then bestBatFound = foundBat; break end end
                                                if bestBatFound then
                                                    if not character:FindFirstChild(bestBatFound.Name) then humanoid:EquipTool(bestBatFound); task.wait(0.1) end
                                                    if character:FindFirstChild(bestBatFound.Name) then bestBatFound:Activate() end
                                                end
                                            end
                                        end
                                    end
                                end
                            end
                            task.wait(0.1) 
                        end
                    end
                end
                
                if not isMissionBrainrotAutoRunning then
                     isMissionBrainrotTeleporting = false 
                     MacUI:Notify({ Title = "Auto Invasion", Content = "หยุดตรวจสอบ Timer/Teleport/Hit", Duration = 3 })
                end
            end)
        else
            isMissionBrainrotAutoRunning = false 
        end
    end
})

local VirtualInputManager = game:GetService("VirtualInputManager")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

local AutoClickEnabled = false

local AutoContinueToggle = EventTab:Toggle({
    Title = "Auto Continue Victory ",
    Desc = "Auto Continue",
    Default = false,
    Flag = "AutoVictoryClick",
    Callback = function(state)
        AutoClickEnabled = state
        if state then
            task.spawn(function()
                while AutoClickEnabled do
                    task.wait(0.5)
                    local touchGui = PlayerGui:FindFirstChild("TouchGui")
                    if touchGui and touchGui.Enabled == false then
                        touchGui.Enabled = true
                    end

                    local mainGui = PlayerGui:FindFirstChild("Main")
                    local victory = mainGui and mainGui:FindFirstChild("Victory_Screen")
                    local main = victory and victory:FindFirstChild("Main")
                    local buttonList = main and main:FindFirstChild("Button_List")
                    local closeButton = buttonList and buttonList:FindFirstChild("Close_Button")

                    if victory and victory.Visible and closeButton then
                        task.wait(5)
                        while AutoClickEnabled and victory.Visible do
                            pcall(function()
                                local cam = workspace.CurrentCamera
                                local absPos = closeButton.AbsolutePosition
                                local absSize = closeButton.AbsoluteSize
                                local clickX = absPos.X + (absSize.X / 2) + (absSize.X * 0.4)
                                local clickY = absPos.Y + (absSize.Y / 2) + (absSize.Y * 2)
                                VirtualInputManager:SendMouseButtonEvent(clickX, clickY, 0, true, nil, 0)
                                VirtualInputManager:SendMouseButtonEvent(clickX, clickY, 0, false, nil, 0)
                            end)
                            task.wait(0.1)
                        end
                    end
                end
            end)
        end
    end
})

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local workspace = game:GetService("Workspace")

_G.AutoStartInvasion = false

local AutoStartInvasionToggle = EventTab:Toggle({
    Title = "Auto Start Invasion",
    Desc = "Auo Start Event",
    Default = false,
    Flag = "AutoStartInvasion",
    Callback = function(value)
        _G.AutoStartInvasion = value
        
        if value then
            task.spawn(function()
                while _G.AutoStartInvasion do
                    local player = Players.LocalPlayer
                    if not player or not player.Character then 
                        _G.AutoStartInvasion = false
                        break 
                    end
                    
                    local timerFrame = player.PlayerGui:FindFirstChild("Main", true) and player.PlayerGui.Main:FindFirstChild("Right") and player.PlayerGui.Main.Right:FindFirstChild("ImminentAttackTimer")
                    if timerFrame and timerFrame.Visible then
                        local timeLabel = timerFrame:FindFirstChild("Main", true) and timerFrame.Main:FindFirstChild("Time")
                        if timeLabel and timeLabel.Text == "READY!" then
                            
                            pcall(function() ReplicatedStorage.Remotes.MissionServicesRemotes.RequestStartInvasion:FireServer() end)
                            
                            task.wait(5) 
                        end
                    end
                    task.wait(0.5)
                end
            end)
        else
            _G.AutoStartInvasion = false
        end
    end
})

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local workspace = game:GetService("Workspace")

local isKillAuraRunning = false

local MissionBrainrotKillAuraToggle = EventTab:Toggle({
    Title = "Mission Brainrot kill Aura",
    Desc = "Continuously fires attack remote for all mission brainrots",
    Default = false,
    Flag = "AutoRemoteAttack",
    Callback = function(value)
        if value then
            if isKillAuraRunning then return end
            isKillAuraRunning = true
            MacUI:Notify({ Title = "Mission Brainrot kill Aura", Content = "Started", Duration = 3 })

            task.spawn(function()
                local batPriority = {
                    "Rifling Bat", "Spiked Bat", "Fluted Bat",
                    "Skeletonized Bat", "Hammer Bat", "Aluminum Bat", "Iron Core Bat", "Iron Plate Bat", "Leather Grip Bat", "Basic Bat"
                }

                while isKillAuraRunning do
                    local player = Players.LocalPlayer
                    local character = player.Character
                    local humanoid = character and character:FindFirstChild("Humanoid")

                    if not player or not character or not humanoid then
                        isKillAuraRunning = false
                        break
                    end

                    local missionBrainrotsFolder = workspace:FindFirstChild("ScriptedMap", true) and workspace.ScriptedMap:FindFirstChild("MissionBrainrots")
                    if missionBrainrotsFolder then
                        local brainrotList = missionBrainrotsFolder:GetChildren()

                        if #brainrotList > 0 then
                            local bestBatFound = nil
                            for _, batName in ipairs(batPriority) do
                                local foundBat = player.Backpack:FindFirstChild(batName) or (character and character:FindFirstChild(batName))
                                if foundBat then
                                    bestBatFound = foundBat
                                    break
                                end
                            end

                            if bestBatFound then
                                if not character:FindFirstChild(bestBatFound.Name) then
                                    humanoid:EquipTool(bestBatFound)
                                    task.wait(0.1)
                                end
                            end

                            for _, brainrotModel in ipairs(brainrotList) do
                                if not isKillAuraRunning then break end

                                if brainrotModel and brainrotModel.Parent then
                                    local id = brainrotModel:GetAttribute("ID")
                                    if id then
                                        local args = {
                                            [1] = {
                                                ["NormalBrainrots"] = {},
                                                ["MissionBrainrots"] = {
                                                    [1] = id
                                                }
                                            }
                                        }
                                        pcall(function()
                                            ReplicatedStorage.Remotes.AttacksServer.WeaponAttack:FireServer(unpack(args))
                                        end)
                                    end
                                end
                            end
                            task.wait(0.1)
                        else
                            humanoid:UnequipTools()
                            task.wait(0.5)
                        end
                    else
                        humanoid:UnequipTools()
                        task.wait(0.5)
                    end
                end

                if not isKillAuraRunning then
                    if humanoid then humanoid:UnequipTools() end
                    MacUI:Notify({ Title = "Mission Brainrot kill Aura", Content = "Stopped", Duration = 3 })
                end
            end)
        else
            isKillAuraRunning = false
            local player = Players.LocalPlayer
            local character = player.Character
            local humanoid = character and character:FindFirstChild("Humanoid")
            if humanoid then humanoid:UnequipTools() end
        end
    end
})

EventTab:Section("Merge Madness Event")

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local UserInputService = game:GetService("UserInputService") 

local CFrame_Pos1 = CFrame.new(-184.19, 11.76, 1026.13)
local CFrame_Pos2 = CFrame.new(-173.69, 11.76, 1026.09)
local CFrame_Mix = CFrame.new(-194.42, 11.76, 1027.23) 

_G.CycleStep = "FindPair" 
_G.CyclePair_B = nil 
_G.ToolA_ModelName = nil
_G.ToolB_ModelName = nil
_G.FavoriteOnly = false 
local usedMutations = {} 

local function isToolFavorited(tool)
    local playerGui = LocalPlayer.PlayerGui 
    if not playerGui then return false end
    local hotbarSlots = UserInputService.TouchEnabled and 6 or 10
    local hotbar = playerGui:FindFirstChild("BackpackGui", true) and playerGui.BackpackGui.Backpack:FindFirstChild("Hotbar")
    if hotbar then
        for i = 1, hotbarSlots do
            local slot = hotbar:FindFirstChild(tostring(i))
            local toolNameLabel = slot and slot:FindFirstChild("ToolName")
            if toolNameLabel and toolNameLabel.Text ~= "" and toolNameLabel.Text == tool.Name then
                if slot:FindFirstChild("HeartIcon") then return true end
            end
        end
    end
    local inventoryFrame = playerGui:FindFirstChild("BackpackGui", true) and playerGui.BackpackGui.Backpack.Inventory.ScrollingFrame:FindFirstChild("UIGridFrame")
    if inventoryFrame then
        for _, itemSlot in ipairs(inventoryFrame:GetChildren()) do
            if itemSlot:IsA("TextButton") then
                local toolNameLabel = itemSlot:FindFirstChild("ToolName")
                if toolNameLabel and toolNameLabel.Text ~= "" and toolNameLabel.Text == tool.Name then
                    if itemSlot:FindFirstChild("HeartIcon") then return true end
                end
            end
        end
    end
    return false
end

local function GetToolInfo(tool, blacklist)
    if not tool:IsA("Tool") then return nil end
    
    local isFavorite = isToolFavorited(tool)
    if _G.FavoriteOnly then
        if not isFavorite then return nil end
    else
        if isFavorite then return nil end
    end

    if string.find(tool.Name, "-") then
        return nil
    end

    local modelName = tool:GetAttribute("Brainrot") or tool:GetAttribute("Plant")
    if not (modelName and modelName ~= "") then
        return nil
    end
    
    local Model = tool:FindFirstChild(modelName)
    if not (Model and Model:IsA("Model")) then 
        return nil 
    end
    
    local MutationAtt = Model:GetAttribute("Mutation")
    
    if not (MutationAtt ~= nil and MutationAtt ~= "") then 
        return nil 
    end
    
    if blacklist[MutationAtt] then
        return nil
    end
    
    return { Tool = tool, ModelName = Model.Name, Mutation = MutationAtt }
end

local function CheckAndFirePrompt(humanoid, rootPart, expectedText, toolInfo)
    if not rootPart then return false end
    
    local ActionTextLabel = LocalPlayer.PlayerGui:FindFirstChild("ProximityPrompts")
        and LocalPlayer.PlayerGui.ProximityPrompts:FindFirstChild("Default")
        and LocalPlayer.PlayerGui.ProximityPrompts.Default:FindFirstChild("PromptFrame")
        and LocalPlayer.PlayerGui.ProximityPrompts.Default.PromptFrame:FindFirstChild("ActionText")

    if not (ActionTextLabel and ActionTextLabel:IsA("TextLabel")) then
        return false
    end
    
    if ActionTextLabel.Text == expectedText then
        local prompt = nil
        
        for attempt = 1, 10 do
            for _, instance in ipairs(Workspace:GetDescendants()) do
                if instance:IsA("ProximityPrompt") and instance.Enabled then
                    local targetPart = instance.Parent
                    if targetPart and targetPart:IsA("BasePart") then
                        if (targetPart.Position - rootPart.Position).Magnitude <= instance.MaxActivationDistance then
                            prompt = instance
                            break
                        end
                    end
                end
            end
            if prompt then break else task.wait(0.1) end
        end

        if not prompt then
            return false
        end

        prompt:InputHoldBegin()
        task.wait(prompt.HoldDuration)
        prompt:InputHoldEnd()
        
        local success = false
        local startTime = tick()
        while tick() - startTime < 3 do
            if not _G.AutoMutateActive then return false end

            if toolInfo then
                if not humanoid.Parent:FindFirstChild(toolInfo.Tool.Name) then
                    success = true
                    break
                end
            else
                if not prompt.Enabled then
                    success = true
                    break
                end
            end
            task.wait(0.1)
        end

        return success
        
    else
        return false
    end
end

local function CheckMachineModels(modelNameA, modelNameB)
    local MutationMachine = Workspace:FindFirstChild("ScriptedMap")
        and Workspace.ScriptedMap:FindFirstChild("MutationMachine")
    
    if MutationMachine and modelNameA and modelNameB then
        local foundA = MutationMachine:FindFirstChild(modelNameA)
        local foundB = MutationMachine:FindFirstChild(modelNameB)
        
        if (foundA and foundA:IsA("Model")) and (foundB and foundB:IsA("Model")) then
            return true
        end
    end
    return false
end

local function GetTimerText()
    local TimerLabel = nil 
    local ScriptedMap = Workspace:FindFirstChild("ScriptedMap")
    local MutationMachine = ScriptedMap and ScriptedMap:FindFirstChild("MutationMachine")
    local UI_Attachment = MutationMachine and MutationMachine:FindFirstChild("UI")
    local GUI_Billboard = UI_Attachment and UI_Attachment:FindFirstChild("GUI")
    if GUI_Billboard then TimerLabel = GUI_Billboard:FindFirstChild("Timer") end

    if TimerLabel and TimerLabel:IsA("TextLabel") then
        return TimerLabel.Text
    end
    return "" 
end

local function Perform_Action_A(infoA, humanoid, rootPart)
    humanoid:EquipTool(infoA.Tool)
    task.wait(0.2)
    
    while _G.AutoMutateActive do
        rootPart.CFrame = CFrame_Pos1
        task.wait(1.0) 
        local success = CheckAndFirePrompt(humanoid, rootPart, "Place Plant or Brainrot", infoA) 
        
        if success then 
            break 
        else
            task.wait(0.5)
        end
    end
    
    task.wait(0.5) 
end

local function Perform_Action_B(infoB, humanoid, rootPart)
    humanoid:EquipTool(infoB.Tool)
    task.wait(0.2)

    while _G.AutoMutateActive do
        rootPart.CFrame = CFrame_Pos2
        task.wait(1.0) 
        local success = CheckAndFirePrompt(humanoid, rootPart, "Place Plant or Brainrot", infoB) 
        
        if success then 
            break 
        else
            task.wait(0.5)
        end
    end
    
    task.wait(0.5) 
end

local function Perform_Action_Mix(humanoid, rootPart)
    humanoid:UnequipTools() 
    task.wait(0.2)
    
    while _G.AutoMutateActive do
        rootPart.CFrame = CFrame_Mix 
        task.wait(1.0) 
        
        local success = CheckAndFirePrompt(humanoid, rootPart, "Mix", nil) 
        
        if success then 
            break 
        end
    end

    task.wait(0.5) 
end

_G.AutoMutateActive = false

local AutoPairToggle = EventTab:Toggle({
    Title = "Auto Merge Madness Event",
    Desc = "หาคู่, วาง 2 จุด, และผสม",
    Default = false,
    Flag = "AutoMutateToggle", 
    
    Callback = function(value)
        _G.AutoMutateActive = value
        if not _G.AutoMutateActive then 
            _G.CycleStep = "FindPair"
            _G.CyclePair_B = nil
            _G.ToolA_ModelName = nil
            _G.ToolB_ModelName = nil
            usedMutations = {}
            return 
        end
        
        _G.CycleStep = "FindPair"
        _G.CyclePair_B = nil
        _G.ToolA_ModelName = nil
        _G.ToolB_ModelName = nil
        usedMutations = {}

        task.spawn(function()
            while _G.AutoMutateActive do
                local WaitTime = 1 
                local Character = LocalPlayer.Character
                local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
                local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

                if not (Character and Humanoid and HumanoidRootPart and Humanoid.Health > 0) then
                    task.wait(WaitTime)
                    continue 
                end
                
                local isMachineReady = false
                if GetTimerText() == "~ Mutate plants or brainrots! ~" then
                    isMachineReady = true
                end

                if isMachineReady then
                    WaitTime = 0.2 
                    
                    if _G.CycleStep == "FindPair" then
                        
                        local validTools = {}
                        local backpackTools = LocalPlayer.Backpack:GetChildren()
                        
                        for i = 1, #backpackTools do
                            local info = GetToolInfo(backpackTools[i], usedMutations)
                            if info then
                                table.insert(validTools, info)
                            end
                        end
                        
                        local pairFound = false
                        for i = 1, #validTools do
                            local infoA = validTools[i]
                            
                            for j = i + 1, #validTools do
                                local infoB = validTools[j]
                                
                                if infoA.ModelName == infoB.ModelName and infoA.Mutation ~= infoB.Mutation then
                                    Perform_Action_A(infoA, Humanoid, HumanoidRootPart)
                                    usedMutations[infoA.Mutation] = true
                                    _G.CyclePair_B = infoB
                                    _G.ToolA_ModelName = infoA.ModelName 
                                    _G.ToolB_ModelName = infoB.ModelName 
                                    _G.CycleStep = "PlaceB" 
                                    pairFound = true
                                    break 
                                end
                            end
                            if pairFound then break end
                        end
                        
                    elseif _G.CycleStep == "PlaceB" then
                        if _G.CyclePair_B then
                            Perform_Action_B(_G.CyclePair_B, Humanoid, HumanoidRootPart)
                            usedMutations[_G.CyclePair_B.Mutation] = true
                            _G.CyclePair_B = nil
                            _G.CycleStep = "Mix" 
                        else
                            _G.CycleStep = "FindPair"
                        end
                        
                    elseif _G.CycleStep == "Mix" then
                        if CheckMachineModels(_G.ToolA_ModelName, _G.ToolB_ModelName) then
                            Perform_Action_Mix(Humanoid, HumanoidRootPart)
                            _G.CycleStep = "WaitingForReset"
                        else
                        end
                        
                    elseif _G.CycleStep == "WaitingForReset" then
                    end
                    
                else
                    if _G.CycleStep ~= "FindPair" then
                        _G.CycleStep = "FindPair"
                        _G.CyclePair_B = nil
                        _G.ToolA_ModelName = nil 
                        _G.ToolB_ModelName = nil 
                        usedMutations = {}
                    end
                end
                
                task.wait(WaitTime)
                
            end 
        end)
    end
})

local FavoriteOnlyToggle = EventTab:Toggle({
    Title = "Favorite Only",
    Desc = "ON: ใช้เฉพาะตัวที่ติดดาว | OFF: ใช้เฉพาะตัวที่ไม่ติดดาว",
    Default = false,
    Flag = "FavoriteOnlyToggle",
    Callback = function(value)
        _G.FavoriteOnly = value
    end
})

EventTab:Divider()

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local CFrame_XP = CFrame.new(-151.39, 11.76, 1028.88)

_G.AutoXPActive = false

local function GetProgress()
    local ScriptedMap = Workspace:FindFirstChild("ScriptedMap")
    local MutationMachine = ScriptedMap and ScriptedMap:FindFirstChild("MutationMachine")
    local UIBAR = MutationMachine and MutationMachine:FindFirstChild("UIBAR")
    local GUI = UIBAR and UIBAR:FindFirstChild("GUI")
    local Progress = GUI and GUI:FindFirstChild("Progress")
    local ProgressLabel = Progress and Progress:FindFirstChild("Progress_Amount")
    
    if ProgressLabel and ProgressLabel:IsA("TextLabel") and ProgressLabel.Text then
        local cur, max = string.match(ProgressLabel.Text, "(%d+)/(%d+)")
        if cur and max then
            return tonumber(cur), tonumber(max)
        end
    end
    return nil, nil 
end

local function PressAndVerifyXP(rootPart)
    if not rootPart then return false end
    local expectedText = "Add XP"
    
    local ActionTextLabel = LocalPlayer.PlayerGui:FindFirstChild("ProximityPrompts")
        and LocalPlayer.PlayerGui.ProximityPrompts:FindFirstChild("Default")
        and LocalPlayer.PlayerGui.ProximityPrompts.Default:FindFirstChild("PromptFrame")
        and LocalPlayer.PlayerGui.ProximityPrompts.Default.PromptFrame:FindFirstChild("ActionText")

    if not (ActionTextLabel and ActionTextLabel:IsA("TextLabel") and ActionTextLabel.Text == expectedText) then
        return false 
    end

    local ScriptedMap = Workspace:FindFirstChild("ScriptedMap")
    local MutationMachine = ScriptedMap and ScriptedMap:FindFirstChild("MutationMachine")
    local UIBAR = MutationMachine and MutationMachine:FindFirstChild("UIBAR")
    local prompt = UIBAR and UIBAR:FindFirstChild("XPPrompt")

    if not (prompt and prompt:IsA("ProximityPrompt")) then
        return false 
    end
    
    if not prompt.Enabled then
         return false
    end

    while _G.AutoXPActive do 
        prompt:InputHoldBegin() 
        task.wait(prompt.HoldDuration)
        prompt:InputHoldEnd()
        
        local success = false
        local startTime = tick()
        while tick() - startTime < 3 do
            if not _G.AutoXPActive then return false end

            if not prompt.Enabled then
                success = true
                break
            end
            task.wait(0.1)
        end

        if success then
            return true
        else
        end
    end
    return false
end

local AutoAddXPToggle = EventTab:Toggle({
    Title = "Auto Add XP",
    Desc = "วาปและกด 'Add XP' จนกว่าจะเต็ม",
    Default = false,
    Flag = "AutoAddXP", 
    
    Callback = function(value)
        _G.AutoXPActive = value
        if not _G.AutoXPActive then 
            return 
        end

        task.spawn(function()
            while _G.AutoXPActive do
                local WaitTime = 1 
                
                local Character = LocalPlayer.Character
                local Humanoid = Character and Character:FindFirstChildOfClass("Humanoid")
                local HumanoidRootPart = Character and Character:FindFirstChild("HumanoidRootPart")

                if not (Character and Humanoid and HumanoidRootPart and Humanoid.Health > 0) then
                    task.wait(WaitTime)
                    continue 
                end
                
                local current, max = GetProgress()
                
                if current and max and current < max then
                    WaitTime = 0.2 
                    
                    HumanoidRootPart.CFrame = CFrame_XP
                    
                    local expTools = {}
                    for _, tool in ipairs(LocalPlayer.Backpack:GetChildren()) do
                        if tool:IsA("Tool") and string.find(tool.Name, "EXP") then
                            table.insert(expTools, tool)
                        end
                    end

                    if #expTools > 0 then
                        local toolToEquip = expTools[math.random(1, #expTools)]
                        Humanoid:EquipTool(toolToEquip)
                        task.wait(0.5) 

                        task.wait(1.0) 

                        while _G.AutoXPActive and current and max and current < max do
                            local pressSuccess = PressAndVerifyXP(HumanoidRootPart)
                            
                            if not pressSuccess then
                                break
                            end
                            
                            task.wait(0.5) 
                            
                            current, max = GetProgress()
                        end
                    else
                    end
                else
                end
                
                task.wait(WaitTime)
            end
        end)
    end
})

_G.AutoResetActive = false

local AutoResetToggle = EventTab:Toggle({
    Title = "Auto Reset Merge Madness Event",
    Desc = "เมื่อ 'Main_Complete' ปรากฏ จะรีเซ็ตอัตโนมัติ",
    Default = false,
    Flag = "AutoResetToggle",
    
    Callback = function(value)
        _G.AutoResetActive = value
        if not _G.AutoResetActive then return end

        task.spawn(function()
            while _G.AutoResetActive do
                local WaitTime = 0.5 
                
                local playerGui = LocalPlayer:FindFirstChild("PlayerGui")
                local Main = playerGui and playerGui:FindFirstChild("Main")
                local Billboard = Main and Main:FindFirstChild("Billboard")
                local Main_Complete = Billboard and Billboard:FindFirstChild("Main_Complete")

                if Main_Complete and Main_Complete.Visible == true then
                    
                    task.wait(1)
                    
                    local InteractRemote = ReplicatedStorage:FindFirstChild("Remotes")
                        and ReplicatedStorage.Remotes:FindFirstChild("Events")
                        and ReplicatedStorage.Remotes.Events:FindFirstChild("MutationMania")
                        and ReplicatedStorage.Remotes.Events.MutationMania:FindFirstChild("Interact")

                    if InteractRemote and _G.AutoResetActive then
                        local args = {
                            [1] = "ResetRequest"
                        }
                        InteractRemote:FireServer(unpack(args))
                        
                        WaitTime = 5 
                    end
                end
                
                task.wait(WaitTime)
            end
        end)
    end
})

local SettingTab = Window:Tab("Settings", "rbxassetid://128706247346129")

SettingTab:Section("Performance")

getgenv().HideNotifications = false

local HideNotificationsToggle = SettingTab:Toggle({
    Title = "Hide Notifications",
    Desc = "Hide Notify",
    Default = false,
    Flag = "HideNotifications",
    Callback = function(value)
        getgenv().HideNotifications = value
        local player = game:GetService("Players").LocalPlayer
        local notifications = player:WaitForChild("PlayerGui"):WaitForChild("Notifications")
        notifications.Enabled = not value
    end
})

local LowGraphicsToggle = SettingTab:Toggle({
    Title = "Low Graphics",
    Desc = "Reduce graphics to increase FPS",
    Default = false,
    Flag = "LowGraphics",
    Callback = function(value)
        local lighting = game:GetService("Lighting")
        local terrain = workspace:FindFirstChildOfClass("Terrain")
        local settings = settings()
        local Players = game:GetService("Players")

        local function safeGetWorkspaceRadius()
            local ok, result = pcall(function()
                return workspace.StreamingTargetRadius
            end)
            return ok and result or 1000
        end

        local function safeSetWorkspaceRadius(radius)
            pcall(function()
                if workspace.StreamingEnabled then
                    workspace.StreamingTargetRadius = radius
                end
            end)
        end

        getgenv().LowGfxDefaultValues = getgenv().LowGfxDefaultValues or {
            QualityLevel = settings.Rendering.QualityLevel,
            GlobalShadows = lighting.GlobalShadows,
            FogEnd = lighting.FogEnd,
            Brightness = lighting.Brightness,
            Ambient = lighting.Ambient,
            OutdoorAmbient = lighting.OutdoorAmbient,
            WaterWaveSize = terrain and terrain.WaterWaveSize or nil,
            WaterWaveSpeed = terrain and terrain.WaterWaveSpeed or nil,
            WaterReflectance = terrain and terrain.WaterReflectance or nil,
            WaterTransparency = terrain and terrain.WaterTransparency or nil,
            MaxRenderDistance = safeGetWorkspaceRadius()
        }
        getgenv().LowGfxChangedObjects = getgenv().LowGfxChangedObjects or {}
        getgenv().LowGfxDecalData = getgenv().LowGfxDecalData or {}

        local DefaultValues = getgenv().LowGfxDefaultValues
        local ChangedObjects = getgenv().LowGfxChangedObjects
        local DecalData = getgenv().LowGfxDecalData

        if value then
            settings.Rendering.QualityLevel = Enum.QualityLevel.Level01
            safeSetWorkspaceRadius(200)

            lighting.GlobalShadows = false
            lighting.FogEnd = 500
            lighting.Brightness = 1
            lighting.Ambient = Color3.new(1, 1, 1)
            lighting.OutdoorAmbient = Color3.new(1, 1, 1)

            if terrain then
                terrain.WaterWaveSize = 0
                terrain.WaterWaveSpeed = 0
                terrain.WaterReflectance = 0
                terrain.WaterTransparency = 1
            end

            for _, v in pairs(workspace:GetDescendants()) do
                if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Beam") then
                    if v.Enabled then
                        ChangedObjects[v] = true
                        v.Enabled = false
                    end
                elseif v:IsA("Decal") or v:IsA("Texture") then
                    if v:IsA("Decal") and v.Texture ~= "" then
                        DecalData[v] = v.Texture
                        v.Texture = ""
                    elseif v:IsA("Texture") and v.Transparency < 1 then
                        ChangedObjects[v] = v.Transparency
                        v.Transparency = 1
                    end
                elseif v:IsA("PointLight") or v:IsA("SpotLight") or v:IsA("SurfaceLight") then
                    if v.Enabled then
                        ChangedObjects[v] = true
                        v.Enabled = false
                    end
                end
            end

            for _, plr in pairs(Players:GetPlayers()) do
                if plr.Character then
                    for _, part in pairs(plr.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CastShadow = false
                        end
                    end
                end
            end

        else
            settings.Rendering.QualityLevel = DefaultValues.QualityLevel
            safeSetWorkspaceRadius(DefaultValues.MaxRenderDistance)
            lighting.GlobalShadows = DefaultValues.GlobalShadows
            lighting.FogEnd = DefaultValues.FogEnd
            lighting.Brightness = DefaultValues.Brightness
            lighting.Ambient = DefaultValues.Ambient
            lighting.OutdoorAmbient = DefaultValues.OutdoorAmbient

            if terrain and DefaultValues.WaterWaveSize then
                terrain.WaterWaveSize = DefaultValues.WaterWaveSize
                terrain.WaterWaveSpeed = DefaultValues.WaterWaveSpeed
                terrain.WaterReflectance = DefaultValues.WaterReflectance
                terrain.WaterTransparency = DefaultValues.WaterTransparency
            end

            for v, old in pairs(ChangedObjects) do
                if v and v.Parent then
                    if typeof(old) == "boolean" then
                        v.Enabled = old
                    elseif typeof(old) == "number" then
                        v.Transparency = old
                    end
                end
            end
            getgenv().LowGfxChangedObjects = {}

            for v, tex in pairs(DecalData) do
                if v and v.Parent then
                    v.Texture = tex
                end
            end
            getgenv().LowGfxDecalData = {}

            for _, plr in pairs(Players:GetPlayers()) do
                if plr.Character then
                    for _, part in pairs(plr.Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CastShadow = true
                        end
                    end
                end
            end
        end
    end
})

local selectedLanguage = "English"

SettingTab:Section("Language Settings")

local LanguageDropdown = SettingTab:Dropdown({
    Title = "Select Language",
    Options = {"English", "ภาษาไทย"},
    Default = selectedLanguage,
    Callback = function(chosenLanguage)
        selectedLanguage = chosenLanguage
    end
})
local ApplyButton = SettingTab:Button({
    Title = "Apply",
    Desc = "Apply the selected language"
})

local languageScripts = {
    ["English"] = function()
        UpdateCode:SetTitle("Script Update")
        UpdateCode:SetCode([[# PvB Script Update! (v1.8.7)

## What’s new:

- [+] Added Auto Merge Madness Event (Toggle)
- [+] Added Favorite Only (Toggle) For Auto Merge Madness Event
- [+] Added  Auto Add XP (Toggle)
- [+] Added Auto Reset Merge Madness Event (Toggle) ]])
        DiscordLabel:SetText("If you found errors or want to me create another map script, please let us know on Discord. We listen to all your problems.")
        CopyDiscordButton:SetTitle("Copy Discord Link")
        CopyDiscordButton:SetDesc("Click to copy the Discord invite link.")
        FeedBackLabel:SetText("Feedback / Report a bug (Don't Spam)")
        FeedBackInput:SetPlaceholder("Enter your feedback...")
        FeedBackButton:SetTitle("Send Feedback")
        FeedBackButton:SetDesc("Send your feedback to the Dev")
        AntiAFKToggle:SetTitle("Anti AFK")
        ReconnectToggle:SetTitle("Auto Reconnect")
        PlayerDropdown:SetTitle("Select Players")
        TeleportButton:SetTitle("Teleport to the [selected] player.")
        TeleportButton:SetDesc("Go to the selected player")
        FlyToggle:SetTitle("Fly Toggle")
        FlySpeedSlider:SetTitle("Fly Speed")
        SpeedSlider:SetTitle("WalkSpeed Slider")
        SpeedToggle:SetTitle("WalkSpeed Toggle")
        JumpSlider:SetTitle("Jump Slider")
        JumpToggle:SetTitle("Jump Toggle")
        AutoTeleportToggle:SetTitle("Auto Farm Brainrot")
        SpeedSlider:SetTitle("Hit Speed")
        AutoFarmToggle:SetTitle("Auto Hit")
        BestBrainrotsLabel:SetText("1 = 1 sec / 600 = 10 min")
        DelaySlider:SetTitle("Equip Best Brainrots Delay")
        AutoEquipToggle:SetTitle("Auto Equip Best Brainrots")
        EggDropdown:SetTitle("Select Eggs to Open")
        AutoOpenEggToggle:SetTitle("Auto Open Egg")
        BrainrotRarityDropdown:SetTitle("Select Rarity")
        FavoriteBrainrotToggle:SetTitle("Auto Favorite Brainrot By Rarity")
        PlantRarityDropdown:SetTitle("Select Rarity")
        FavoritePlantToggle:SetTitle("Auto Favorite Plants By Rarity")
        SharedMutationDropdown:SetTitle("Select Mutation")
        FavoriteBrainrotToggle:SetTitle("Auto Favorite Brainrot By Mutation")
        FavoritePlantToggle:SetTitle("Auto Favorite Plants By Mutation")
        SeedDropdown:SetTitle("Select Seeds")
        AutoBuySeedSelectedToggle:SetTitle("Auto Buy Seed [Selected]")
        AutoBuyAllToggle:SetTitle("Auto Buy Seed [All]")
        ItemDropdown:SetTitle("Select Gear")
        AutoBuySelectedToggle:SetTitle("Auto Buy Gear [Selected]")
        AutoBuyGearAllToggle:SetTitle("Auto Buy Gear [All]")
        SellBrainrotLabel:SetText("1 = 1 sec / 600 = 10 min")
        SellDelaySlider:SetTitle("Sell Brainrots Delay")
        AutoSellToggle:SetTitle("Auto Sell Brainrots All")
        AutoSellFullToggle:SetTitle("Auto Sell Brainrots All When Inventory Full")
        SellPlantLabel:SetText("1 = 1 sec / 600 = 10 min")
        PlantSellDelaySlider:SetTitle("Sell Plants Delay")
        AutoSellPlantsToggle:SetTitle("Auto Sell Plants All")
        AutoSellPlantsFullToggle:SetTitle("Auto Sell Plants All When Inventory Full")
        AutoSellAllFullToggle:SetTitle("Auto Sell All When Inventory Full")
        AutoConfirmSellToggle:SetTitle("Auto Confirm Sell")
        TeleportGrassButton:SetTitle("Teleport to Plots")
        TeleportGrassButton:SetDesc("Goto Your Plots")
        TeleportFixedButton:SetTitle("Teleport to Prison Event")
        TeleportFixedButton:SetDesc("Goto Event Area")
        AutoDailyEventToggle:SetTitle("Auto Daily Event")
        AutoMissionBrainrotToggle:SetTitle("Auto Farm Mission Brainrots + Everything")
        AutoContinueToggle:SetTitle("Auto Continue Victory")
        AutoStartInvasionToggle:SetTitle("Auto Start Invasion Event")
        MissionBrainrotKillAuraToggle:SetTitle("Mission Brainrot kill Aura")
        HideNotificationsToggle:SetTitle("Hide Notifications")
        LowGraphicsToggle:SetTitle("Low Graphics")
        LanguageDropdown:SetTitle("Select Language")
        ApplyButton:SetTitle("Apply")
        ApplyButton:SetDesc("Apply the selected language")
    end,
    
    ["ภาษาไทย"] = function()
        UpdateCode:SetTitle("อัพเดทสคริป")
        UpdateCode:SetCode([[# แมพ พืชปะทะเบรนล็อต สคริปอัพเดท (v1.8.7)

## มีอะไรใหม่บ้าง:

- [+] เพิ่มออโต้ทำอีเว้นใหม่ (อีเว้นการผสาน) (Toggle)
- [+] เพิ่ม เฉพาะรายการโปรด (เอาแค่ตัวที่ล็อคไว้) (Toggle) สำหรับ ออโต้ทำอีเว้นใหม่ (อีเว้นการผสาน) เท่านั้น
- [+] เพิ่ม ออโต้ใส่ Xp (Toggle)
- [+] เพิ่ม ออโต้รีเซ็ตอีเว้นใหม่เมื่อทำเสร็จ (Toggle) ]])
        DiscordLabel:SetText("เจอบัค, หรือต่าง, อยากให้สร้างสคริปแมพอื่น, แจ้งมาได้ที่ ดิสคอร์ด รับฟังทุกปัญหา")
        CopyDiscordButton:SetTitle("คักลอกลิ้งดิสคอร์ด")
        CopyDiscordButton:SetDesc("กดเพื่อคัดลอกลิงก์เชิญ Discord")
        FeedBackLabel:SetText("ส่งความคิดเห็น / แจ้งบัค (ห้ามส่งรัวๆ)")
        FeedBackInput:SetPlaceholder("ใส่ความคิดเห็น")
        FeedBackButton:SetTitle("ส่งความคิดเห็น")
        FeedBackButton:SetDesc("ส่งความคิดเห็นไปที่นักพัฒนา")
        AntiAFKToggle:SetTitle("ป้องกัน AFK [กันหลุดเมื่อยืนนิ่งเกิน20นาที]")
        ReconnectToggle:SetTitle("เข้าแมพใหม่เมื่อหลุด (กลับเข้าเกมและรันสคริปต์ให้อัตโนมัติ)")
        PlayerDropdown:SetTitle("เลือกผู้เล่น")
        TeleportButton:SetTitle("เทเลพอร์ตไปยังผู้เล่น [ที่เลือก]")
        TeleportButton:SetDesc("ไปหาผู้เล่นที่เลือก")
        FlyToggle:SetTitle("บิน")
        FlySpeedSlider:SetTitle("ปรับความเร็วการบิน")
        SpeedSlider:SetTitle("ปรับความเร็วการเดิน")
        SpeedToggle:SetTitle("เปิดความเร็วการเดิน")
        JumpSlider:SetTitle("ปรับการกระโดด")
        JumpToggle:SetTitle("เปิดการกระโดด")
        AutoTeleportToggle:SetTitle("ฟาร์ม Brainrots อัตโนมัติ")
        SpeedSlider:SetTitle("ความเร็วการตี")
        AutoFarmToggle:SetTitle("ตีอัตโนมัติ")
        BestBrainrotsLabel:SetText("1 = 1วิ / 600วิ = 10นาที")
        DelaySlider:SetTitle("ดีเลย์การสวม Brainrots ที่ดีที่สุด")
        AutoEquipToggle:SetTitle("ใส่ Brainrots ที่ดีที่สุดอัตโนมัติ")
        EggDropdown:SetTitle("เลือกไข่ที่จะเปิด")
        AutoOpenEggToggle:SetTitle("เปิดไข่อัตโนมัติ")
        BrainrotRarityDropdown:SetTitle("เลือกความหายาก")
        FavoriteBrainrotToggle:SetTitle("ล็อคหัวใจ Brainrots อัตโนมัติ [ตามความหายากที่เลือก]")
        PlantRarityDropdown:SetTitle("เลือกความหายาก")
        FavoritePlantToggle:SetTitle("ล็อคหัวใจ Plants อัตโนมัติ [ตามความหายากที่เลือก]")
        SharedMutationDropdown:SetTitle("เลือกสถานะ")
        FavoriteBrainrotToggle:SetTitle("ล็อคหัวใจ Brainrot อัตโนมัติ [ตามสถานะที่เลือก]")
        FavoritePlantToggle:SetTitle("ล็อคหัวใจ Plants อัตโนมัติ [ตามสถานะที่เลือก]")
        SeedDropdown:SetTitle("เลือกเมล็ดพันธุ์")
        AutoBuySeedSelectedToggle:SetTitle("ซื้อเมล็ดพันธุ์อัตโนมัติ [ที่เลือก]")
        AutoBuyAllToggle:SetTitle("ซื้อเมล็ดพันธุ์อัตโนมัติ [ทั้งหมด]")
        ItemDropdown:SetTitle("เลือกอุปกรณ์")
        AutoBuySelectedToggle:SetTitle("ซื้ออุปกรณ์อัตโนมัติ [ที่เลือก]")
        AutoBuyGearAllToggle:SetTitle("ซื้ออุปกรณ์อัตโนมัติ [ทั้งหมด]")
        SellBrainrotLabel:SetText("1 = 1วิ / 600วิ = 10นาที")
        SellDelaySlider:SetTitle("ดีเลย์การขาย Brainrot ทั้งหมด")
        AutoSellToggle:SetTitle("ขาย Brainrot ทั้งหมดอัตโนมัติ")
        AutoSellFullToggle:SetTitle("ขาย Brainrot ทั้งหมดอัตโนมัติ [เมื่อกระเป๋าเต็ม]")
        SellPlantLabel:SetText("1 = 1วิ / 600วิ = 10นาที")
        PlantSellDelaySlider:SetTitle("ดีเลย์การขาย Plant ทั้งหมด")
        AutoSellPlantsToggle:SetTitle("ขาย Plant ทั้งหมดอัตโนมัติ")
        AutoSellPlantsFullToggle:SetTitle("ขาย Plant ทั้งหมดอัตโนมัติ [เมื่อกระเป๋าเต็ม]")
        AutoSellAllFullToggle:SetTitle("ขายทั้งสองอัตโนมัติ [เมื่อกระเป๋าเต็ม]")
        AutoConfirmSellToggle:SetTitle("ออโต้ยืนยันการขายอัตโนมัติ (เมื่อมีuiให้กดยืนยัน)")
        TeleportGrassButton:SetTitle("วาปไปสวนของตัวเอง")
        TeleportGrassButton:SetDesc("วาปไปที่พล็อต")
        TeleportFixedButton:SetTitle("วาปไปอีเว้น")
        TeleportFixedButton:SetDesc("วาปไปสถานที่อีเว้น")
        AutoDailyEventToggle:SetTitle("ออโต้ทำอีเว้นรายวันอัตโนมัติ")
        AutoMissionBrainrotToggle:SetTitle("ออโต้ฟาร์มภารกิจ เบรนร็อต + ทำทุกอย่างในอีเว้น")
        AutoContinueToggle:SetTitle("ออโต้กดดำเนินการต่อเมื่อชนะอัตโนมัติ")
        AutoStartInvasionToggle:SetTitle("เริ่มการบุกอัตโนมัติ")
        MissionBrainrotKillAuraToggle:SetTitle("ออโต้ โจมตีอัตโนมัติ (Kill Aura) สำหรับภารกิจ เบรนร็อต")
        HideNotificationsToggle:SetTitle("ซ่อนการแจ้งเตือน")
        LowGraphicsToggle:SetTitle("ปรับกราฟิกให้ต่ำลงเพื่อเพิ่ม FPS")
        LanguageDropdown:SetTitle("เลือกภาษา")
        ApplyButton:SetTitle("ยืนยันการเปลี่ยนภาษา")
    end
}

ApplyButton:SetCallback(function()
    if languageScripts[selectedLanguage] then
        languageScripts[selectedLanguage]()
        
        MacUI:Notify({
            Title = "Success",
            Content = "Language has been set to: " .. selectedLanguage,
            Duration = 4
        })
    else
        MacUI:Notify({
            Title = "Error",
            Content = "No script found for language: " .. selectedLanguage,
            Duration = 4
        })
    end
end)

MacUI:Notify({
    Title = "Script Loaded",
    Content = "Tad Hub PvB | 1.9.7",
    Duration = 10
})


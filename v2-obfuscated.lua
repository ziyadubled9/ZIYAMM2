-- [ VARIABLES ] --
local ziya =  loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
getgenv().DebugMode = true

local function getTime()
    local t = os.date("*t")
    return string.format("[%02d:%02d:%02d]", t.hour, t.min, t.sec)
end

function debugPrint(...)
    if getgenv().DebugMode == true then
        print(getTime(), "[DEBUG]", ...)
    end
end

function debugWarn(...)
    if getgenv().DebugMode == true  then
        warn(getTime(), "[WARNING]", ...)
    end
end

function debugError(...)
    if getgenv().DebugMode == true  then
        error(getTime() .. " [ERROR] " .. table.concat({...}, " "))
    end
end


local function blankfunction(...)
    return ...
end

local cloneref = cloneref or blankfunction
local GetService, cloneref = game.GetService, cloneref or function(r) return r end or blankfunction

local function SafeGetService(service)
    return cloneref(game:GetService(service))
end

local services = setmetatable({}, {
    __index = function(self, service)
        local r = cloneref(GetService(game, service))
        self[service] = r
        return r
    end
})


local Players = SafeGetService("Players")
local StarterGui = SafeGetService("StarterGui")
local CoreGui = SafeGetService("CoreGui")
local ReplicatedStorage = SafeGetService("ReplicatedStorage")

local function sendValidnotif(text)
    pcall(function()
        StarterGui:SetCore("SendNotification", {
            Title = "System",
            Text = text,
            Duration = 5,
            Icon = "rbxassetid://6023426923",
        })
    end)


    pcall(function()
        local soundParent = Instance.new("Folder")
        soundParent.Name = tostring(math.random(100000, 999999))
        soundParent.Archivable = false
        soundParent.Parent = SafeGetService("Lighting")


        local sound = Instance.new("Sound")
        sound.Name = tostring(math.random(100, 99999))
        sound.SoundId = "rbxassetid://1559445112"
        sound.Volume = 1
        sound.Archivable = false
        sound.Parent = soundParent


        sound:Play()


        sound.Ended:Connect(function()
            if sound then
                sound:Destroy()
            end
            if soundParent and #soundParent:GetChildren() == 0 then
                soundParent:Destroy()
            end
        end)


        task.delay(10, function()
            if soundParent then
                soundParent:Destroy()
            end
        end)
    end)
end



function sendnotif(title, content, duration, image)
    ziya:Notify({
        Title = title,
        Content = content,
        Duration = duration,
        Image = image,
    })
end

local function detectSimpleSpyV3()
    for _, v in pairs(getloadedmodules()) do
        if tostring(v):find("SimpleSpy") then
            Players.LocalPlayer:Kick("⚠️ Spy ?!")
            wait(1)
            while true do end
            return true
        end
    end


    if getgenv and getgenv().SimpleSpy then
        Players.LocalPlayer:Kick("⚠️ Spy ?!")
        wait(1)
        while true do end
        return true
    end

    return false
end

local genv = getgenv and getgenv() or shared or _G or {}


local ChatService = SafeGetService("Chat")
local TeleportService = SafeGetService("TeleportService")
local TextChatService = SafeGetService("TextChatService")
local VirtualUser = SafeGetService("VirtualUser")
local Lighting = SafeGetService("Lighting")
local UserInputService = SafeGetService("UserInputService")
local RunService = SafeGetService("RunService")
local HttpService = SafeGetService("HttpService")
local Workspace = SafeGetService("Workspace")
local VirtualInputManager = SafeGetService("VirtualInputManager")
local GuiService = SafeGetService("GuiService")
local MarketplaceService = SafeGetService("MarketplaceService")
local CollectionService = SafeGetService("CollectionService")
local TweenService = SafeGetService("TweenService")
local Mouse = Players.LocalPlayer:GetMouse()



local LocalPlayer = Players.LocalPlayer
local Player = Players.LocalPlayer
local player = Players.LocalPlayer
local character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local backpack = player:FindFirstChild("Backpack")

local espHighlights = {}

local walkSpeedEnabled = false
local espEnabled = false
local flying = false

local walkSpeedValue = 16
local jumpPowerValue = 50
local flySpeedValue = 50



local Window = ziya:CreateWindow({
   Name = "MM2",
   Icon = 0, -- Icon in Topbar. Can use Lucide Icons (string) or Roblox Image (number). 0 to use no icon (default).
   LoadingTitle = "MM2",
   LoadingSubtitle = "by ziya",
   ShowText = "Rayfield", -- for mobile users to unhide rayfield, change if you'd like
   Theme = "Default", -- Check https://docs.sirius.menu/rayfield/configuration/themes

   ToggleUIKeybind = "K", -- The keybind to toggle the UI visibility (string like "K" or Enum.KeyCode)

   DisableRayfieldPrompts = false,
   DisableBuildWarnings = false, -- Prevents Rayfield from warning when the script has a version mismatch with the interface

   ConfigurationSaving = {
      Enabled = true,
      FolderName = nil, -- Create a custom folder for your hub/game
      FileName = "ZiyaMM2"
   },

   Discord = {
      Enabled = false, -- Prompt the user to join your Discord server if their executor supports it
      Invite = "noinvitelink", -- The Discord invite code, do not include discord.gg/. E.g. discord.gg/ ABCD would be ABCD
      RememberJoins = true -- Set this to false to make them join the discord every time they load it up
   },

   KeySystem = false, -- Set this to true to use our key system
   KeySettings = {
      Title = "Untitled",
      Subtitle = "Key System",
      Note = "No method of obtaining the key is provided", -- Use this to tell the user how to get a key
      FileName = "Key", -- It is recommended to use something unique as other scripts using Rayfield may overwrite your key file
      SaveKey = true, -- The user's key will be saved, but if you change the key, they will be unable to use your script
      GrabKeyFromSite = false, -- If this is true, set Key below to the RAW site you would like Rayfield to get the key from
      Key = {"Hello"} -- List of keys that will be accepted by the system, can be RAW file links (pastebin, github etc) or simple strings ("hello","key22")
   }
})

-- [ TABS ] --
local MurderTab = Window:CreateTab("MM2", "pocket-knife")

    -- [Murderer Mystery  Section] --
    MurderTab:CreateSection("Information")
    MurderTab:CreateLabel("Welcome " .. LocalPlayer.DisplayName .. " !", "github")

    MurderTab:CreateDivider()
    MurderTab:CreateSection("Players Section")



    local isESPEnabled = false
    local playerData = {}


    local function updatePlayerData()
        playerData = ReplicatedStorage:WaitForChild("Remotes"):WaitForChild("Extras"):WaitForChild("GetPlayerData")
        :InvokeServer()
    end


    local function getRoleColor(plr)
        if playerData and playerData[plr.Name] then
            local data = playerData[plr.Name]


            if data.Dead then
                return Color3.new(0.372549, 0.364706, 0.364706)
            end

            if data.Role == "Murderer" then
                return Color3.fromRGB(200, 0, 0)
            elseif data.Role == "Sheriff" then
                return Color3.fromRGB(0, 0, 200)
            elseif data.Role == "Hero" then
                return Color3.new(0.980392, 0.913725, 0.000000)
            elseif data.Role == "Innocent" then
                return Color3.fromRGB(0, 200, 0)
            end
        end
        return Color3.new(0.372549, 0.364706, 0.364706)
    end


    local function updateESP()
        for _, player in pairs(Players:GetPlayers()) do
            if player ~= Players.LocalPlayer and player.Character then
                local highlight = player.Character:FindFirstChild("Highlight")
                if isESPEnabled then
                    if not highlight then
                        highlight = Instance.new("Highlight")
                        highlight.Parent = player.Character
                    end
                    highlight.FillTransparency = 0.7
                    highlight.OutlineTransparency = 0.8
                    highlight.FillColor = getRoleColor(player)
                elseif highlight then
                    highlight:Destroy()
                end
            end
        end
    end


    spawn(function()
        while true do
            if isESPEnabled then
                updatePlayerData()
                updateESP()
            else
                for _, player in pairs(Players:GetPlayers()) do
                    if player.Character then
                        local highlight = player.Character:FindFirstChild("Highlight")
                        if highlight then
                            highlight:Destroy()
                        end
                    end
                end
            end
            wait(1)
        end
    end)


    local MurderESPToggle = MurderTab:CreateToggle({
        Name = "Players Roles ESP",
        CurrentValue = false,
        Flag = "PlayerRolesEsp",
        Callback = function(Value)
            isESPEnabled = Value
        end,
    })


    local maps = {
        "Normal", "MilBase", "Bank2", "Mineshaft", "BioLab", "Barn", "Office3", "Manor", "Hotel",
        "Hospital3", "Mansion2", "House2", "PoliceStation", "Workplace", "VampireCastle", "Farmhouse", 
        "Station","LogCabin", "ChristmasItaly", "Factory","ResearchFacility","SkiLodge", "IceCastle",
    }


    local function getGunDropColor()
        return Color3.new(0.600000, 0.000000, 1.000000) -- purple
    end
    local isESPGUNEnabled = false


    spawn(function()
        while true do
            if isESPGUNEnabled then
                for _, mapName in ipairs(maps) do
                    local mapContainer = Workspace:FindFirstChild(mapName)
                    if mapContainer then
                        local gunDrop = mapContainer:FindFirstChild("GunDrop")


                        if gunDrop and gunDrop:IsA("BasePart") then
                            if not gunDrop:FindFirstChild("GunDropHighlight") then
                                local gunHighlight = Instance.new("Highlight")
                                gunHighlight.Name = "GunDropHighlight"
                                gunHighlight.Parent = gunDrop
                                gunHighlight.FillTransparency = 0.2
                                gunHighlight.OutlineTransparency = 0.8
                                gunHighlight.FillColor = getGunDropColor()
                            end
                        end
                    end
                end
            else
                for _, mapName in ipairs(maps) do
                    local mapContainer = Workspace:FindFirstChild(mapName)
                    if mapContainer then
                        local gunDrop = mapContainer:FindFirstChild("GunDrop")
                        if gunDrop and gunDrop:FindFirstChild("GunDropHighlight") then
                            gunDrop.GunDropHighlight:Destroy()
                        end
                    end
                end
            end
            wait(1)
        end
    end)


    local GunDropESPToggle = MurderTab:CreateToggle({
        Name = "Gun ESP",
        CurrentValue = false,
        Flag = "GunDropToggle",
        Callback = function(Value)
            isESPGUNEnabled = Value
        end,
    })


    local trapDetection = false


    local function handleTrapDetection()
        if trapDetection then
            trapDetection = false

            for _, v in ipairs(workspace:GetChildren()) do
                if v.Name == "TrapESP" then
                    v:Destroy()
                end
            end
        else
            trapDetection = true

            for _, v in ipairs(workspace:GetDescendants()) do
                if v.Name == "Trap" and v.Parent:IsDescendantOf(workspace) then
                    v.Transparency = 0


                    local trapHighlight = Instance.new("Highlight")
                    trapHighlight.Name = "TrapESP"
                    trapHighlight.Parent = v
                    trapHighlight.FillTransparency = 0.2
                    trapHighlight.OutlineTransparency = 0.8
                    trapHighlight.FillColor = Color3.new(0.286275, 0.011765, 0.250980)
                end
            end
        end
    end


    local TrapToggle = MurderTab:CreateToggle({
        Name = "Trap ESP",
        CurrentValue = false,
        Flag = "TrapDetectionToggle",
        Callback = function(Value)
            handleTrapDetection()
        end,
    })






    local function findSheriff()
        updatePlayerData()
    
        if playerData then
            for playerName, data in pairs(playerData) do
                if data.Role == "Sheriff" then
                    local player = Players:FindFirstChild(playerName)
                    if player and player.Character then
                        return player
                    end
                end
            end
        end
    
        for _, player in ipairs(Players:GetPlayers()) do
            local backpack = player:FindFirstChild("Backpack")
            if backpack and backpack:FindFirstChild("Gun") and player.Character then
                return player
            end
            if player.Character and player.Character:FindFirstChild("Gun") then
                return player
            end
        end
    
        return nil
    end
    

    local function findMurderer()
        updatePlayerData()
        if playerData then
            for playerName, data in pairs(playerData) do
                if data.Role == "Murderer" then
                    local player = Players:FindFirstChild(playerName)
                    if player and player.Character then
                        return player
                    end
                end
            end
        end


        for _, player in ipairs(Players:GetPlayers()) do
            local backpack = player:FindFirstChild("Backpack")
            if backpack and backpack:FindFirstChild("Knife") then
                return player
            end
            if player.Character and player.Character:FindFirstChild("Knife") then
                return player
            end
        end

        return nil
    end



    -- [Misc Section] --
    MurderTab:CreateDivider()
    MurderTab:CreateSection("Misc Section")


    local dodgeConnection


    MurderTab:CreateToggle({
        Name = "Auto Dodge Knife",
        CurrentValue = false,
        Flag = "AutoDodgeMM2Knife",
        Callback = function(Value)
            if Value then
                dodgeConnection = workspace.ChildAdded:Connect(function(object)
                    if object.Name == "ThrowingKnife" and object:IsA("Model") then
                        local dodged = false
                        while not dodged and object do
                            task.wait()
                            -- Remplacez par la méthode correcte pour obtenir la position du joueur
                            local playerCharacter = LocalPlayer.Character
                            if playerCharacter and playerCharacter.PrimaryPart then
                                local playerPosition = playerCharacter:GetPivot()
                                local knifePosition = object:GetPivot().Position
                                local distance = (playerPosition.Position - knifePosition).Magnitude

                                if distance < 15 then
                                    local deltaX = playerPosition.Position.X - knifePosition.X
                                    local deltaY = playerPosition.Position.Y - knifePosition.Y

                                    if deltaY < 4.35 then
                                        playerCharacter:SetPrimaryPartCFrame(
                                            playerPosition * CFrame.new(-deltaX * 3, 0, 0)
                                        )
                                        dodged = true
                                    end
                                end
                            end
                        end
                    end
                end)
            else
                if dodgeConnection then
                    dodgeConnection:Disconnect()
                    dodgeConnection = nil
                end
            end
        end
    })

    MurderTab:CreateButton({
        Name = "Remove Barriers",
        Callback = function()
            for _, descendant in pairs(workspace:GetDescendants()) do
                if descendant.Name == "GlitchProof" then
                    descendant:Destroy()
                end
            end
        end,
    })


    MurderTab:CreateToggle({
        Name = "Disable Trap",
        CurrentValue = false,
        Flag = "DisableTrapMM2Toggle",
        Callback = function(Value)
            if Value then
                task.spawn(function()
                    while Value do
                        task.wait(0.25)
                        pcall(function()
                            for _, player in pairs(Players:GetPlayers()) do
                                if player.Name ~= Players.LocalPlayer.Name then
                                    local character = workspace:FindFirstChild(player.Name)
                                    if character then
                                        for _, obj in pairs(character:GetChildren()) do
                                            if obj.Name == "Trap" and obj:IsA("Model") then
                                                obj:Destroy()
                                            end
                                        end
                                    end
                                end
                            end
                        end)
                    end
                end)
            else
                --  debugPrint("ziya Hub | Disable Trap  : off.")
            end
        end,
    })



    local function secondsToMinutes(seconds)
        if seconds == -1 then return "" end
        local minutes = math.floor(seconds / 60)
        local remainingSeconds = seconds % 60
        return string.format("%dm %ds", minutes, remainingSeconds)
    end

    local timertask = nil
    local timertext = nil


    MurderTab:CreateToggle({
        Name = "Round Timer",
        CurrentValue = false,
        Flag = "RoundTimerToggle",
        Callback = function(state)
            if state then
                timertext = Instance.new("TextLabel")
                timertext.Parent = script.Parent
                timertext.BackgroundTransparency = 1
                timertext.TextColor3 = Color3.fromRGB(255, 255, 255)
                timertext.TextScaled = true
                timertext.AnchorPoint = Vector2.new(0.5, 0.5)
                timertext.Position = UDim2.fromScale(0.5, 0.15)
                timertext.Size = UDim2.fromOffset(200, 50)
                timertext.Font = Enum.Font.Fantasy


                timertask = task.spawn(function()
                    while task.wait(0.5) do
                        local success, timeLeft = pcall(function()
                            return ReplicatedStorage.Remotes.Extras.GetTimer:InvokeServer()
                        end)
                        if success and timertext then
                            timertext.Text = secondsToMinutes(timeLeft)
                        elseif not success then
                            timertext.Text = "Timer Error"
                        end
                    end
                end)
            else
                if timertext then
                    timertext:Destroy()
                    timertext = nil
                end
                if timertask then
                    task.cancel(timertask)
                    timertask = nil
                end
            end
        end,
    })





    -- [Teleports Section] --
    MurderTab:CreateDivider()
    MurderTab:CreateSection("Teleports Section")


    local function teleportToLobby()
        LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(Vector3.new(-5081, 285, 90)))
    end


    local function teleportToMap()
        local spawnsFolder = nil


        for _, mapName in ipairs(maps) do
            local map = Workspace:FindFirstChild(mapName)
            if map then
                spawnsFolder = map:FindFirstChild("Spawns")
                if spawnsFolder then
                    break
                end
            end
        end


        if spawnsFolder then
            local spawns = spawnsFolder:GetChildren()
            if #spawns > 0 then
                local randomSpawn = spawns[math.random(1, #spawns)]
                if LocalPlayer and LocalPlayer.Character then
                    LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(randomSpawn.Position))
                else
                    debugWarn("ziya Hub | Player or character not found")
                end
            else
                debugWarn("ziya Hub | No spawns found in 'Spawns' folder")
            end
        else
            debugWarn("ziya Hub | No valid spawns folder found in any map")
        end
    end



    local function teleportAboveMap()
        local spawnsFolder = nil


        for _, mapName in ipairs(maps) do
            local map = Workspace:FindFirstChild(mapName)
            if map then
                spawnsFolder = map:FindFirstChild("Spawns")
                if spawnsFolder then
                    break
                end
            end
        end

        if spawnsFolder then
            local spawns = spawnsFolder:GetChildren()
            if #spawns > 0 then
                local randomSpawn = spawns[math.random(1, #spawns)]
                if randomSpawn:IsA("BasePart") then
                    local abovePosition = randomSpawn.Position + Vector3.new(0, 50, 0)


                    if LocalPlayer and LocalPlayer.Character and LocalPlayer.Character.PrimaryPart then
                        LocalPlayer.Character:SetPrimaryPartCFrame(CFrame.new(abovePosition))
                    else
                        debugWarn("ziya Hub | Player or character not found")
                    end
                else
                    debugWarn("ziya Hub | Invalid spawn object found in 'Spawns' folder")
                end
            else
                debugWarn("ziya Hub | No spawns found in 'Spawns' folder")
            end
        else
            debugWarn("ziya Hub | No valid spawns folder found in any map")
        end
    end




    local function teleportToSheriff()
        local sheriff = findSheriff()
        if sheriff and sheriff.Character and sheriff.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = sheriff.Character:FindFirstChild("HumanoidRootPart")
            LocalPlayer.Character:SetPrimaryPartCFrame(hrp.CFrame)
        else
            debugWarn("ziya Hub | Sheriff not found!")
        end
    end


    local function teleportToMurderer()
        local murderer = findMurderer()
        if murderer and murderer.Character and murderer.Character:FindFirstChild("HumanoidRootPart") then
            local hrp = murderer.Character:FindFirstChild("HumanoidRootPart")
            LocalPlayer.Character:SetPrimaryPartCFrame(hrp.CFrame)
        else
            sendnotif("Notification", "Murderer not found!", 2, "triangle-alert")
        end
    end


    local LobbyButton = MurderTab:CreateButton({
        Name = "Lobby",
        Callback = function()
            teleportToLobby()
        end,
    })

    local MapButton = MurderTab:CreateButton({
        Name = "Map",
        Callback = function()
            teleportToMap()
        end,
    })

    local MapButton = MurderTab:CreateButton({
        Name = "Above Map",
        Callback = function()
            teleportAboveMap()
        end,
    })

    local TPTOSheriffButton = MurderTab:CreateButton({
        Name = "Teleport to Sheriff",
        Callback = function()
            teleportToSheriff()
        end,
    })

    local TPTOMurdererButton = MurderTab:CreateButton({
        Name = "Teleport to Murderer",
        Callback = function()
            teleportToMurderer()
        end,
    })



    --  [AutoFarm Section] --
    MurderTab:CreateDivider()
    MurderTab:CreateSection("Farm Section")

    local autofarmRunning = false
    local safeModeFarm = false
    local visitedPositions = {}






    local function isSafeToTeleport(coinPosition)
        local murderer = findMurderer()
        if murderer and murderer.Character and murderer.Character:FindFirstChild("HumanoidRootPart") then
            local murdererPosition = murderer.Character.HumanoidRootPart.Position
            local distance = (coinPosition - murdererPosition).magnitude
            return distance > 10
        end
        return true
    end

    local function hasVisited(position)
        for _, visited in ipairs(visitedPositions) do
            if (visited - position).magnitude < 1 then
                return true
            end
        end
        return false
    end



    local function findMap()
        local map = nil
        local function lookForMapIn(part)
            for _, v in pairs(part:GetChildren()) do
                if v:IsA("Model") and (v.Name == "PoliceStation" or v.Name == "IceCastle" or v.Name == "SkiLodge" or v.Name == "Station" or v.Name == "LogCabin" or v.Name == "ChristmasItaly" or v.Name == "ResearchFacility" or v.Name == "BioLab" or v.Name == "Mineshaft" or v.Name == "Office3" or v.Name == "Hotel" or v.Name == "Factory" or v.Name == "Manor" or v.Name == "Hospital3" or v.Name == "Bank2" or v.Name == "Farmhouse" or v.Name == "Workplace" or v.Name == "MilBase" or v.Name == "Barn" or v.Name == "House2" or v.Name == "Farmhouse" or v.Name == "Mansion2" or v.Name == "Normal" or v.Name == "VampireCastle") then
                    map = v
                    return
                end
            end
        end

        while autofarmRunning do
            lookForMapIn(Workspace)
            if map then
                debugPrint("ziya Hub | Found map: ", map.Name)
                return map
            else
                debugPrint("ziya Hub | Map not found, retrying...")
                wait(2)
            end
        end
    end


    local noclipConnection = nil
    local function setNoclip(enable)

        if enable then
            noclipConnection = RunService.Stepped:Connect(function()
                if LocalPlayer.Character then
                    for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                        if part:IsA("BasePart") and part.CanCollide then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            if noclipConnection then
                noclipConnection:Disconnect()
                noclipConnection = nil
            end


            if LocalPlayer.Character then
                for _, part in pairs(LocalPlayer.Character:GetDescendants()) do
                    if part:IsA("BasePart") and not part.CanCollide then
                        part.CanCollide = true
                    end
                end
            end
        end
    end


    local function tweenToPosition(targetPosition)
        local player = Players.LocalPlayer
        local character = player.Character or player.CharacterAdded:Wait()
        local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
        local humanoid = character:FindFirstChild("Humanoid")


        if not humanoidRootPart or not humanoid then
            debugWarn("ziya Hub | [TweenToPosition] Missing Humanoid or HumanoidRootPart.")
            return
        end


        local distance = (humanoidRootPart.Position - targetPosition).Magnitude
        local walkSpeed = humanoid.WalkSpeed > 0 and humanoid.WalkSpeed or 16
        local travelTime = distance / walkSpeed


        local tweenInfo = TweenInfo.new(
            travelTime,
            Enum.EasingStyle.Sine,
            Enum.EasingDirection.InOut
        )


        local goal = {
            CFrame = CFrame.new(targetPosition)
        }


        local tween = TweenService:Create(humanoidRootPart, tweenInfo, goal)


        local function cleanupTween()
            if tween then
                tween:Cancel()
            end
        end


        local characterRemovedConn = character.AncestryChanged:Connect(function(_, parent)
            if not parent then
                cleanupTween()
            end
        end)

        tween:Play()
        tween.Completed:Wait()


        characterRemovedConn:Disconnect()
    end



    local originalWalkSpeed = LocalPlayer.Character.Humanoid.WalkSpeed
    local function autofarm()
        local autoresetrunning = false
        local map = nil
        local coinsModel = nil



        LocalPlayer.Character.Humanoid.WalkSpeed = 22.5
        setNoclip(true)

        while autofarmRunning do
            map = findMap()

            if map then
                local glitchProof = map:FindFirstChild("GlitchProof")
                if glitchProof then
                    debugPrint("ziya Hub | Found GlitchProof, destroying it")
                    glitchProof:Destroy()
                end


                while autofarmRunning do
                    coinsModel = map:FindFirstChild("CoinContainer")
                    if coinsModel then
                        debugPrint("ziya Hub | CoinContainer found, starting autofarm")
                        LocalPlayer.Character.Humanoid.WalkSpeed = 22.5
                        break
                    else
                        debugWarn("ziya Hub | CoinContainer not found, retrying...")
                        wait(2)
                    end
                end

                if coinsModel then
                    while autofarmRunning do
                        if not workspace:FindFirstChild(map.Name) then
                            debugWarn("ziya Hub | Map no longer in workspace, retrying...")
                            break
                        end

                        local closestCoin = nil
                        local minDistance = math.huge
                        local restrictedPosition = Vector3.new(-98, 139, 49)
                        local restrictedDistanceThreshold = 155
                


                        local hasTeleported = false

                        local function teleportToMap2()
                            local spawnsFolder2 = nil
                            for _, mapName in ipairs(maps) do
                                local map = Workspace:FindFirstChild(mapName)
                                if map then
                                    spawnsFolder2 = map:FindFirstChild("Spawns")
                                    if spawnsFolder2 then
                                        break
                                    end
                                end
                            end


                            if spawnsFolder2 and not hasTeleported then
                                local spawns2 = spawnsFolder2:GetChildren()
                                if #spawns2 > 0 then
                                    local randomSpawn2 = spawns2[math.random(1, #spawns2)]
                                    if randomSpawn2:IsA("BasePart") then
                                        if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                                            LocalPlayer.Character.HumanoidRootPart.CFrame = CFrame.new(randomSpawn2
                                                .Position)
                                            hasTeleported = true
                                            LocalPlayer.Character.Humanoid.WalkSpeed = 22.5
                                            debugPrint('ziya Hub | It worked! Teleportation successful!')
                                        else
                                            debugWarn("ziya Hub | HumanoidRootPart not found for teleportation.")
                                        end
                                    else
                                        debugWarn("ziya Hub | Selected spawn is not a BasePart.")
                                    end
                                else
                                    debugWarn("ziya Hub | No spawns found in 'Spawns' folder")
                                end
                            else
                                debugWarn("ziya Hub | Already teleported or no valid spawns folder found in any map")
                            end
                        end


                        local function onPlayerDied()
                            local fullVisible = LocalPlayer.PlayerGui.MainGUI.Game.CoinBags.Container.Coin.Full
                                .Visible
                            local fullBagIconVisible = LocalPlayer.PlayerGui.MainGUI.Game.CoinBags.Container.Coin
                                .FullBagIcon.Visible
                            local coinsText = tonumber(LocalPlayer.PlayerGui.MainGUI.Game.CoinBags.Container.Coin
                                .CurrencyFrame.Icon.Coins.Text)

                            if LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
                                local humanoid = LocalPlayer.Character.Humanoid
                                if humanoid.Health <= 0 and not fullVisible and autofarmRunning then
                                    wait(5)
                                    teleportToMap2()
                                    hasTeleported = true
                                    debugPrint('ziya Hub | It worked! Teleportation successful!')
                                else
                                    debugPrint("ziya Hub | Conditions not met for teleportation.")
                                end
                            else
                                debugWarn("ziya Hub | Humanoid not found.")
                            end
                        end

                        if LocalPlayer.Character then
                            LocalPlayer.Character:WaitForChild("Humanoid").Died:Connect(onPlayerDied)
                        end


                        LocalPlayer.CharacterAdded:Connect(function(character)
                            wait(5)
                            hasTeleported = false
                        end)




                        local character = LocalPlayer.Character

                        if character and character.PrimaryPart then
                            local playerPosition = character.PrimaryPart.Position


                            local function ownsGamePass(player, gamePassId)
                                local success, hasGamePass = pcall(function()
                                    return player.UserId and Players:UserOwnsGamePassAsync(player.UserId, gamePassId)
                                end)
                                return success and hasGamePass
                            end

                            local fullVisible = LocalPlayer.PlayerGui.MainGUI.Game.CoinBags.Container.Coin.Full
                                .Visible
                            local fullBagIconVisible = LocalPlayer.PlayerGui.MainGUI.Game.CoinBags.Container.Coin
                                .FullBagIcon.Visible
                            local coinsText = tonumber(LocalPlayer.PlayerGui.MainGUI.Game.CoinBags.Container.Coin
                                .CurrencyFrame.Icon.Coins.Text)
                            local gamePassId = 429957
                            local pingDisplayed = false


                            local coinLimit = ownsGamePass(LocalPlayer, gamePassId) and 50 or 40


                            if fullVisible and fullBagIconVisible and coinsText >= coinLimit then
                                debugPrint("ziya Hub | Movement to coins is restricted because your bag is Full.")
                                pingDisplayed = true
                            else
                                pingDisplayed = false
                                local closestCoin
                                local minDistance = math.huge

                                for _, v in pairs(coinsModel:GetChildren()) do
                                    if v.Name == "Coin_Server" and v:FindFirstChild("TouchInterest") then
                                        local coinPosition = v.Position
                                        local distance = (coinPosition - playerPosition).magnitude


                                        if distance < minDistance and not hasVisited(coinPosition) and (not safeModeFarm or isSafeToTeleport(coinPosition)) then
                                            minDistance = distance
                                            closestCoin = v
                                        end
                                    end
                                end


                                if closestCoin then
                                    if closestCoin.Parent and closestCoin:FindFirstChild("TouchInterest") then
                                        local playerPosition = LocalPlayer.Character.PrimaryPart.Position
                                        local distanceToRestrictedPosition = (playerPosition - restrictedPosition)
                                            .magnitude

                                        if distanceToRestrictedPosition > restrictedDistanceThreshold then
                                            local targetPosition = closestCoin.Position

                                            tweenToPosition(targetPosition)

                                            table.insert(visitedPositions, targetPosition)
                                        else
                                            debugWarn(
                                            "ziya Hub | Player is too close to the restricted position, not moving towards the coin...")
                                        end
                                    else
                                        debugWarn(
                                        "ziya Hub | Coin is no longer available, finding next closest coin...")
                                    end
                                else
                                    debugWarn("ziya Hub | No coins found or too close to the murderer, waiting...")
                                end
                            end
                        else
                            debugWarn("ziya Hub | Character or PrimaryPart is not valid.")
                        end

                        wait(0.05)
                    end
                end
            else
                debugPrint("ziya Hub | CoinContainer not found in map")
            end
        end
    end


    if autofarmRunning == false then
        LocalPlayer.Character.Humanoid.WalkSpeed = 16



        setNoclip(false)
    end

    -- AUTO FARM TOGGLE
    local AutoFarmToggle = MurderTab:CreateToggle({
        Name = "Auto Farm",
        CurrentValue = false,
        Flag = "ToggleAutoFarmMM2",
        Callback = function(Value)
            if Value then
                autofarmRunning = true
                coroutine.wrap(function()
                    while autofarmRunning do
                        pcall(autofarm)
                        wait(0.1)
                    end
                end)()
            else
                autofarmRunning = false
            end
        end,
    })





    local autoResetRunning = false
    local autoResetConnection

    -- AUTO RESET EZ
    local AutoFarmToggle = MurderTab:CreateToggle({
        Name = "Auto Reset",
        CurrentValue = false,
        Flag = "ToogleAutoReset",
        Callback = function(Value)
            autoResetRunning = Value


            if not autoResetRunning and autoResetConnection then
                autoResetConnection:Disconnect()
                autoResetConnection = nil
                debugPrint("ziya Hub | Auto reset deactivated.")
                return
            end


            if autoResetRunning then
                debugPrint("ziya Hub | Auto reset activated.")
                autoResetConnection = RunService.Heartbeat:Connect(function()
                    local character = LocalPlayer.Character


                    if character and character:FindFirstChild("Humanoid") then
                        local fullVisible = LocalPlayer.PlayerGui.MainGUI.Game.CoinBags.Container.Coin.Full.Visible
                        local fullBagIconVisible = LocalPlayer.PlayerGui.MainGUI.Game.CoinBags.Container.Coin
                            .FullBagIcon.Visible
                        local coinsText = tonumber(LocalPlayer.PlayerGui.MainGUI.Game.CoinBags.Container.Coin
                            .CurrencyFrame.Icon.Coins.Text)


                        if fullVisible and fullBagIconVisible and (coinsText == 40 or coinsText == 50) then
                            wait(2)
                            character.Humanoid.Health = 0
                            debugPrint("ziya Hub | Player reset due to auto reset + full bag.")
                        end
                    else
                        debugWarn("ziya Hub | Character or Humanoid not valid.")
                    end
                end)
            end
        end
    })



    -- XP FARM
    local xpfarmenabled = false

    MurderTab:CreateToggle({
        Name = "XP Farm (BETA)",
        CurrentValue = false,
        Flag = "ToggleXpFarm",
        Callback = function(Value)
            xpfarmenabled = Value

            local function isPlayerFull()
                local gui = LocalPlayer.PlayerGui.MainGUI.Game.CoinBags.Container.Coin
                local fullVisible = gui.Full.Visible
                local fullBagIconVisible = gui.FullBagIcon.Visible
                local coinsText = tonumber(gui.CurrencyFrame.Icon.Coins.Text)

                return fullVisible and fullBagIconVisible and (coinsText == 40 or coinsText == 50)
            end

            local function hasKnife(plr)
                return plr.Backpack:FindFirstChild("Knife") or (plr.Character and plr.Character:FindFirstChild("Knife"))
            end

            local function hasGun(plr)
                return plr.Backpack:FindFirstChild("Gun") or (plr.Character and plr.Character:FindFirstChild("Gun"))
            end

            local function findMurderer()
                updatePlayerData()
                if playerData then
                    for playerName, data in pairs(playerData) do
                        if data.Role == "Murderer" then
                            local player = Players:FindFirstChild(playerName)
                            if player then
                                return player
                            end
                        end
                    end
                end

                for _, player in ipairs(Players:GetPlayers()) do
                    if hasKnife(player) then
                        return player
                    end
                end

                return nil
            end


            local function performActions()
           

                if isPlayerFull() then
                    if findMurderer() == LocalPlayer then
                        keypress(0x54)
                        task.wait(0.2)
                        keyrelease(0x54)
                    end

                    if hasGun(LocalPlayer) then
                        keypress(0x43)
                        task.wait(0.2)
                        keyrelease(0x43)
                    elseif not hasGun(LocalPlayer) and not hasKnife(LocalPlayer) then
                        local murderer = findMurderer()

                        if murderer then
                            local thrust = Instance.new('BodyThrust', LocalPlayer.Character.HumanoidRootPart)
                            thrust.Force = Vector3.new(9999, 9999, 9999)
                            thrust.Name = "YeetForce"
                            repeat
                                LocalPlayer.Character.HumanoidRootPart.CFrame = murderer.Character.HumanoidRootPart
                                    .CFrame
                                thrust.Location = murderer.Character.HumanoidRootPart.Position
                                RunService.Heartbeat:Wait()
                            until not murderer.Character or not murderer.Character:FindFirstChild("Head")
                        else
                            sendnotif("Notification", "Murderer not found!", 1, "triangle-alert")
                        end
                    end
                end
                --  toggleAntiAFK(Value)
            end

            if Value then
                task.spawn(function()
                    while xpfarmenabled do
                        local success, err = pcall(performActions)
                        if not success then
                            debugWarn("ziya Hub | Error during XP Farm loop:", err)
                        end
                        wait(1)
                    end
                end)
            else
                xpfarmenabled = false
                debugPrint("ziya Hub | XP Farm disabled")
            end
        end,
    })


    -- [Sheriff Section] --
    MurderTab:CreateDivider()
    MurderTab:CreateSection("Sheriff Section")


    local function getRootPart()
        local character = player.Character or player.CharacterAdded:Wait()
        return character:WaitForChild("HumanoidRootPart")
    end


    local toggleActive = false

    local function teleportAndReturn()
        local murderer = findMurderer()
        if murderer == player then
            debugPrint("ziya Hub | You are the murderer, teleporting is disabled.")
            return
        end
    
        for _, mapName in ipairs(maps) do
            local map = Workspace:FindFirstChild(mapName)
    
            if map then
                local gunDrop = map:FindFirstChild("GunDrop")
    
                if gunDrop and gunDrop:IsA("BasePart") then
                    local character = player.Character
                    local knife = player.Backpack:FindFirstChild("Knife") or (character and character:FindFirstChild("Knife"))
                    if knife then return end
    
                    local rootPart = getRootPart()
                    if not rootPart then return end
    
                    local originalCFrame = rootPart.CFrame
    
                    rootPart.CFrame = CFrame.new(gunDrop.Position + Vector3.new(0, 3, 0))
    
                    local timeout = 0.5
                    local startTime = tick()
                    while map:FindFirstChild("GunDrop") and (tick() - startTime) < timeout do
                        task.wait(0.025)
                    end
    
             
                    rootPart.CFrame = originalCFrame
                    return
                end
            end
        end
    end
    
    


    spawn(function()
        while true do
            wait(0.5)
            if toggleActive then
                teleportAndReturn()
            end
        end
    end)


    MurderTab:CreateKeybind({
        Name = "Grab Gun",
        CurrentKeybind = "G",
        HoldToInteract = false,
        Flag = "KeybindGunGrabOnce",
        Callback = function()
            teleportAndReturn()
        end,
    })




                                        
    local AutoGrabGunToggle = MurderTab:CreateToggle({
        Name = "Auto Grab Gun",
        CurrentValue = false,
        Flag = "ToggleGunGrab",
        Callback = function(Value)
            toggleActive = Value
        end,
    })




    local autoShooting = false
    local shootOffset = 10





    local function findSheriffThatsNotMe()
        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local backpack = player:FindFirstChild("Backpack")
                if backpack then
                    for _, item in ipairs(backpack:GetChildren()) do
                        if item.Name == "Gun" then
                            return player
                        end
                    end
                end
            end
        end
        return nil
    end



    local function startAutoShooting()
        sendnotif("Notification", "Auto-shooting started.", 5, "circle-check-big")
        
        repeat
            task.wait(0.2)
    
            local murderer = findMurderer() or findSheriffThatsNotMe()
            if not murderer or not murderer.Character or not murderer.Character:FindFirstChild("HumanoidRootPart") then
                debugWarn("[ziya HUB] > MM2 Autoshoot - No murderer or HRP.")
                continue
            end
    
            local murdererHRP = murderer.Character.HumanoidRootPart
            local characterRootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not characterRootPart then continue end
    
            local rayDirection = (murdererHRP.Position - characterRootPart.Position).Unit * 50
    
            local raycastParams = RaycastParams.new()
            raycastParams.FilterType = Enum.RaycastFilterType.Exclude
            raycastParams.FilterDescendantsInstances = { LocalPlayer.Character }
    
            local hit = workspace:Raycast(characterRootPart.Position, rayDirection, raycastParams)
            local clearLineOfSight = (not hit) or (hit.Instance and hit.Instance:IsDescendantOf(murderer.Character))
    
            if clearLineOfSight then
              
                if not LocalPlayer.Character:FindFirstChild("Gun") then
                    local gunInBackpack = LocalPlayer.Backpack:FindFirstChild("Gun")
                    if gunInBackpack then
                        pcall(function()
                            LocalPlayer.Character:FindFirstChildOfClass("Humanoid"):EquipTool(gunInBackpack)
                        end)
                        task.wait(0.2) 
                    else
                        sendnotif("Notification", "You don't have the gun..?", 3, "mail-warning")
                        break
                    end
                end
    
           
                local velocity = murdererHRP.AssemblyLinearVelocity
                local predictionTime = 0.2
                local predictedPosition = murdererHRP.Position + velocity * predictionTime
    
                local args = {
                    [1] = 1,
                    [2] = predictedPosition,
                    [3] = "AH2"
                }
    
                local gun = LocalPlayer.Character:FindFirstChild("Gun")
                if gun and gun:FindFirstChild("KnifeLocal") then
                    pcall(function()
                        gun.KnifeLocal.CreateBeam.RemoteFunction:InvokeServer(unpack(args))
                    end)
                    sendnotif("Notification", "Auto-Shooting!", 2, "target")
                else
                    sendnotif("Notification", "Gun not ready!", 2, "triangle-alert")
                end
            end
        until not autoShooting
    end
    

    local AutoShootToggle = MurderTab:CreateToggle({
        Name = "Auto-Shoot (BETA)",
        CurrentValue = false,
        Flag = "AutoShoot",
        Callback = function(Value)
            autoShooting = Value
            if autoShooting then
                coroutine.wrap(startAutoShooting)()
            end
        end,
    })



    MurderTab:CreateKeybind({
        Name = "Shoot Murder (BETA)",
        CurrentKeybind = "C",
        HoldToInteract = false,
        Flag = "ShootMurderKeybind",
        Callback = function()
            local murderer = findMurderer()
            if not murderer or not murderer.Character then
                sendnotif("Notification", "Murderer not found!", 1, "triangle-alert")
                return
            end
    
            local murdererHRP = murderer.Character:FindFirstChild("HumanoidRootPart")
            local rootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if not murdererHRP or not rootPart then
                debugPrint("ziya Hub | HumanoidRootPart not found!")
                return
            end
    
            local originalCFrame = rootPart.CFrame
    
            local gunTool = LocalPlayer.Backpack:FindFirstChild("Gun")
            if not gunTool then
                sendnotif("Notification", "Gun not found in backpack!", 1, "triangle-alert")
                return
            end
            gunTool.Parent = LocalPlayer.Character
            task.wait(0.05)
    
    
            local heartbeatConnection = RunService.Heartbeat:Connect(function()
                local behindMurderer = murdererHRP.Position - murdererHRP.CFrame.LookVector * 5
                rootPart.CFrame = CFrame.new(behindMurderer, murdererHRP.Position)
            end)
    
       
            local velocity = murdererHRP.AssemblyLinearVelocity
            local prediction = murdererHRP.Position + (velocity * Vector3.new(1.1, 0.5, 1.1)) * 0.2
    
            local args = {
                [1] = 1,
                [2] = prediction,
                [3] = "AH2"
            }
    
            local success = pcall(function()
                LocalPlayer.Character.Gun.KnifeLocal.CreateBeam.RemoteFunction:InvokeServer(unpack(args))
            end)
    
            if success then
                sendnotif("Notification", "Shot fired!", 1.5, "circle-check-big")
            else
                sendnotif("Notification", "Failed to shoot murderer.", 1.5, "triangle-alert")
            end
   

    
            if heartbeatConnection then
                heartbeatConnection:Disconnect()
            end
    
            rootPart.CFrame = originalCFrame
            gunTool.Parent = LocalPlayer.Backpack
        end,
    })
    
    
    

    -- [Murderer Section] --
    MurderTab:CreateDivider()
    MurderTab:CreateSection("Murder Section")



    local function onKeybindPressed()
 

        if findMurderer() ~= LocalPlayer then
            sendnotif("Notification", "You're not the murderer.", 1, "mail-warning")
            return
        end


        if not LocalPlayer.Character:FindFirstChild("Knife") then
            local hum = LocalPlayer.Character:FindFirstChild("Humanoid")
            local knife = LocalPlayer.Backpack:FindFirstChild("Knife")
            if knife then
                hum:EquipTool(knife)
            else
                sendnotif("Notification", "You don't have the knife..?", 1, "mail-warning")
                return
            end
        end


        for _, player in ipairs(Players:GetPlayers()) do
            if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player ~= LocalPlayer then
                local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                hrp.Anchored = true
                hrp.CFrame = LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame +
                    LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame.LookVector * 1
            end
        end

        local args = {
            [1] = "Slash"
        }
        LocalPlayer.Character.Knife.Stab:FireServer(unpack(args))
    end


    MurderTab:CreateKeybind({
        Name = "Kill All",
        CurrentKeybind = "T",
        HoldToInteract = false,
        Flag = "KillAllV2",
        Callback = function(Keybind)
            if not Keybind then
                onKeybindPressed()
            end
        end,
    })




    -- KILL ALL FUCKING AURA NIGGA

    local auraRange = 15
    local killAuraCon

    MurderTab:CreateSlider({
        Name = "Aura Range",
        Range = { 5, 50 },
        Increment = 1,
        Suffix = " studs",
        CurrentValue = auraRange,
        Flag = "AuraRange",
        Callback = function(value)
            auraRange = value
        end,
    })


    MurderTab:CreateToggle({
        Name = "Kill Aura",
        Callback = function(state)
            if state then
                if killAuraCon then killAuraCon:Disconnect() end
                killAuraCon = RunService.Heartbeat:Connect(function()
                    for _, player in ipairs(Players:GetPlayers()) do
                        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") and player ~= LocalPlayer then
                            local hrp = player.Character:FindFirstChild("HumanoidRootPart")
                            if (hrp.Position - LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Position).Magnitude < auraRange then
                                hrp.Anchored = true
                                hrp.CFrame = LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame +
                                    LocalPlayer.Character:FindFirstChild("HumanoidRootPart").CFrame.LookVector * 2

                                task.wait(0.1)

                                local args = {
                                    [1] = "Slash"
                                }

                                LocalPlayer.Character.Knife.Stab:FireServer(unpack(args))
                                return
                            end
                        end
                    end
                end)
            else
                if killAuraCon then killAuraCon:Disconnect() end
            end
        end,
    })










    -- [Fun Section] --
    MurderTab:CreateDivider()
    MurderTab:CreateSection("Fun Section")





    MurderTab:CreateButton({
        Name = "Get All Emotes",
        Callback = function()
            local player = Players.LocalPlayer


            local function ensureTabExists()
                local emotePages = player.PlayerGui.MainGUI.Game.Emotes.EmotePages


                if not emotePages:FindFirstChild("ziya Hub") then
                    local emote = require(ReplicatedStorage.Modules.EmoteModule).GeneratePage
                    local target = player.PlayerGui.MainGUI.Game.Emotes
                    local emotelist = { "headless", "zombie", "zen", "ninja", "floss", "dab" }


                    emote(emotelist, target, "ziya Hub")
                end
            end

            for _, v in pairs(player.PlayerGui.MainGUI.Game.Emotes.EmotePages:GetChildren()) do
                if v.Name == "ziya Hub" then
                    v:Destroy()
                end
            end

            ensureTabExists()

            player.PlayerGui.MainGUI.Game.Emotes.EmotePages.ChildRemoved:Connect(function(child)
                if child.Name == "ziya Hub" then
                    ensureTabExists()
                end
            end)
        end
    })




    -- BLURT ROLES
    local function sendStatusMessage()
        local textChannels = TextChatService:WaitForChild("TextChannels"):GetChildren()

        for _, textChannel in ipairs(textChannels) do
            if textChannel.Name ~= "RBXSystem" then
                local murd = findMurderer()
                local sher = findSheriff()

                local murdName = ""
                local sherName = ""

                if murd then murdName = murd.Name end
                if sher then sherName = sher.Name end

                if murd == LocalPlayer then murdName = "###" end
                if sher == LocalPlayer then sherName = "###" end


                if not murd then murdName = "Unknow" end
                if not sher then sherName = "Unknow" end

                local message = string.format([[Murderer is %s
Sheriff is %s ]], murdName, sherName)

                textChannel:SendAsync(message)
            end
        end
    end



    MurderTab:CreateButton({
        Name = "Blurt Roles",
        Callback = function()
            sendStatusMessage()
        end,
    })




    MurderTab:CreateButton({
        Name = "Destroy UI",
        Callback = function()
            ziya:Destroy()
        end,
    })

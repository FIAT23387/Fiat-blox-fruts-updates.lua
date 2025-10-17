-- Fiat Hub (Fluent-based) - Atualizado by_fiat
local Fluent = loadstring(game:HttpGet("https://github.com/dawid-scripts/Fluent/releases/latest/download/main.lua"))()
local SaveManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/SaveManager.lua"))()
local InterfaceManager = loadstring(game:HttpGet("https://raw.githubusercontent.com/dawid-scripts/Fluent/master/Addons/InterfaceManager.lua"))()

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Janela Principal (Dark)
local Window = Fluent:CreateWindow({
    Title = "Fiat Hub",
    SubTitle = "by_fiat",
    TabWidth = 160,
    Size = UDim2.fromOffset(580,460),
    Acrylic = true,
    Theme = "Dark",
    MinimizeKey = nil
})
Window.Parent = LocalPlayer:WaitForChild("PlayerGui")

pcall(function()
    if Window.MainContainer then
        Window.MainContainer.BackgroundColor3 = Color3.fromRGB(50,50,50)
        Window.MainContainer.BackgroundTransparency = 0.2
    end
end)

-- Abas
local Tabs = {
    Farm = Window:AddTab({Title="Farm", Icon=""}),
    Settings = Window:AddTab({Title="Settings", Icon="settings"})
}

-- Notificações
local function notify(title,content,duration)
    Fluent:Notify({Title=title or "Fiat Hub", Content=content or "", Duration=duration or 4})
end

-- Dropdown players
local SelectedPlayer = nil
local function buildPlayerValueList()
    local list = {}
    for _,p in ipairs(Players:GetPlayers()) do
        if p~=LocalPlayer then table.insert(list,p.Name) end
    end
    return list
end
local function setSelectedPlayerByName(name)
    if not name or name=="" then SelectedPlayer=nil; notify("Player","Nenhum player selecionado",3); return end
    local p = Players:FindFirstChild(name)
    if p then SelectedPlayer=p; notify("Player","Selecionado: "..p.Name,3)
    else SelectedPlayer=nil; notify("Player","Player não encontrado: "..tostring(name),3) end
end

-- ToggleTable
local ToggleTable = {}

-- ===============================
-- 🟢 DROPDOWN FAST ATTACK SPEED
-- ===============================
local FastAttackSpeed = 0.8 -- Default
local FastAttackDropdown = Tabs.Farm:AddDropdown("FastAttackSpeedDropdown",{
    Title="Fast Attack Speed",
    Values={"0.1⚠️","0.3⚠️","0.4⚠️","0.8⚠️","2✅ recomendo"},
    Multi=false,
    Default=4
})
FastAttackDropdown:OnChanged(function(value)
    local num = tonumber(value:match("%d+%.?%d*"))
    if num then FastAttackSpeed = num end
    notify("Fast Attack","Velocidade ajustada para "..FastAttackSpeed,3)
end)

-- ===============================
-- 🟢 AUTO FARM LOGIC
-- ===============================
local AutoFarmActive = false
local BringMobsActive = false

-- Config
local FarmStages = {
    {Level=0, Position=Vector3.new(-4934,313,-2788)},
    {Level=50, Position=Vector3.new(-4672,876,-1971)},
}
local CurrentStageIndex = 1

-- Função util para puxar mobs
local function PullMobs()
    if not BringMobsActive then return end
    local pos = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") and LocalPlayer.Character.HumanoidRootPart.Position
    if not pos then return end
    for _, mob in ipairs(workspace:GetDescendants()) do
        if mob:IsA("Model") and mob:FindFirstChild("Humanoid") and mob.Name=="Sky Bandit" then
            if mob:FindFirstChild("HumanoidRootPart") then
                mob:FindFirstChild("HumanoidRootPart").CFrame = CFrame.new(pos - Vector3.new(0,20,0))
                -- Aumentar hitbox
                if mob.HumanoidRootPart.Size.X < 200 then
                    mob.HumanoidRootPart.Size = Vector3.new(200,200,200)
                end
            end
        end
    end
end

-- Função levitar
local function LevitateAt(position)
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return end
    char.HumanoidRootPart.Anchored = true
    char.HumanoidRootPart.CFrame = CFrame.new(position)
end

-- Função apertar tecla 1
local function PressKey1Once()
    pcall(function()
        local vim = game:GetService("VirtualInputManager")
        if vim and vim.SendKeyEvent then
            vim:SendKeyEvent(true, Enum.KeyCode.One, false, game)
            task.wait(0.05)
            vim:SendKeyEvent(false, Enum.KeyCode.One, false, game)
        end
    end)
end

-- Auto Farm loop
task.spawn(function()
    while task.wait(1) do
        if AutoFarmActive then
            -- Determinar stage conforme level
            local plrLevel = LocalPlayer:FindFirstChild("leaderstats") and LocalPlayer.leaderstats:FindFirstChild("Level") and LocalPlayer.leaderstats.Level.Value or 0
            if CurrentStageIndex < #FarmStages and plrLevel >= FarmStages[CurrentStageIndex+1].Level then
                CurrentStageIndex = CurrentStageIndex + 1
            end
            local stagePos = FarmStages[CurrentStageIndex].Position
            LevitateAt(stagePos)
            PullMobs()
            PressKey1Once()
            -- Espera mobs morrerem (simplificado: espera 60s)
            task.wait(60)
        end
    end
end)

-- ===============================
-- 🟢 TOGGLES FARM
-- ===============================
-- Auto Farm
ToggleTable["AutoFarm"] = Tabs.Farm:AddToggle("AutoFarmToggle",{Title="Auto Farm Level Beta ⚠️",Default=false})
ToggleTable["AutoFarm"]:OnChanged(function(value)
    AutoFarmActive = value
    if value then
        notify("Auto Farm","Auto Farm ativado!",3)
    else
        notify("Auto Farm","Auto Farm desativado!",3)
    end
end)

-- Bring Mobs
ToggleTable["BringMobs"] = Tabs.Farm:AddToggle("BringMobsToggle",{Title="Bring Mob ⚠️",Default=false})
ToggleTable["BringMobs"]:OnChanged(function(value)
    if not AutoFarmActive and value then
        notify("Bring Mobs","Ative Auto Farm primeiro!",3)
        ToggleTable["BringMobs"]:SetValue(false)
        return
    end
    BringMobsActive = value
end)

-- Fast Attack
ToggleTable["FastAttack"] = Tabs.Farm:AddToggle("FastAttackToggle",{Title="Fast Attack ⚠️",Default=false})
ToggleTable["FastAttack"]:OnChanged(function(value)
    if value then
        notify("Fast Attack","Ativado!",3)
        task.spawn(function()
            local SuperFastMode = true
            local plr = LocalPlayer
            local CbFw = debug.getupvalues(require(plr.PlayerScripts.CombatFramework))
            local CbFw2 = CbFw[2]

            function GetCurrentBlade()
                local p13 = CbFw2.activeController
                local ret = p13.blades[1]
                if not ret then return end
                while ret.Parent ~= plr.Character do ret = ret.Parent end
                return ret
            end

            function AttackNoCD()
                local AC = CbFw2.activeController
                for i = 1, 1 do
                    local bladehit = require(game.ReplicatedStorage.CombatFramework.RigLib).getBladeHits(
                        plr.Character,
                        {plr.Character.HumanoidRootPart},
                        60
                    )
                    local cac = {}
                    local hash = {}
                    for k, v in pairs(bladehit) do
                        if v.Parent:FindFirstChild("HumanoidRootPart") and not hash[v.Parent] then
                            table.insert(cac, v.Parent.HumanoidRootPart)
                            hash[v.Parent] = true
                        end
                    end
                    bladehit = cac
                    if #bladehit > 0 then
                        local u8 = debug.getupvalue(AC.attack, 5)
                        local u9 = debug.getupvalue(AC.attack, 6)
                        local u7 = debug.getupvalue(AC.attack, 4)
                        local u10 = debug.getupvalue(AC.attack, 7)
                        local u12 = (u8 * 798405 + u7 * 727595) % u9
                        local u13 = u7 * 798405
                        (function()
                            u12 = (u12 * u9 + u13) % 1099511627776
                            u8 = math.floor(u12 / u9)
                            u7 = u12 - u8 * u9
                        end)()
                        u10 = u10 + 1
                        debug.setupvalue(AC.attack, 5, u8)
                        debug.setupvalue(AC.attack, 6, u9)
                        debug.setupvalue(AC.attack, 4, u7)
                        debug.setupvalue(AC.attack, 7, u10)
                        pcall(function()
                            for k, v in pairs(AC.animator.anims.basic) do
                                v:Play()
                            end
                        end)
                        if plr.Character:FindFirstChildOfClass("Tool") and AC.blades and AC.blades[1] then
                            game:GetService("ReplicatedStorage").RigControllerEvent:FireServer("weaponChange",tostring(GetCurrentBlade()))
                            game.ReplicatedStorage.Remotes.Validator:FireServer(math.floor(u12 / 1099511627776 * 16777215), u10)
                            game:GetService("ReplicatedStorage").RigControllerEvent:FireServer("hit", bladehit, i, "")
                        end
                    end
                end
            end

            local waitFunc = SuperFastMode and task.wait or wait
            while ToggleTable["FastAttack"]:GetValue() do
                AttackNoCD()
                waitFunc(FastAttackSpeed)
            end
        end)
    else
        notify("Fast Attack","Desativado!",3)
    end
end)

-- ===============================
-- Add-ons Fluent
-- ===============================
SaveManager:SetLibrary(Fluent)
InterfaceManager:SetLibrary(Fluent)
SaveManager:IgnoreThemeSettings()
SaveManager:SetIgnoreIndexes({})
InterfaceManager:SetFolder("FiatHub")
SaveManager:SetFolder("FiatHub/specific-game")
InterfaceManager:BuildInterfaceSection(Tabs.Settings)
SaveManager:BuildConfigSection(Tabs.Settings)

-- Aba inicial
Window:SelectTab(1)
Fluent:Notify({Title="Fiat Hub", Content="Script carregado com sucesso!", Duration=6})
pcall(function() SaveManager:LoadAutoloadConfig() end)

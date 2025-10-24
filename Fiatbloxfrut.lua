-- Ui Lib
local redzlib = loadstring(game:HttpGet("https://raw.githubusercontent.com/tbao143/Library-ui/refs/heads/main/Redzhubui"))()

-- Window
local Window = redzlib:MakeWindow({
    Title = "FIAT HUB: Blox Fruits BETA⚠️",
    SubTitle = "by FIAT",
    SaveFolder = "testando | redz lib v5.lua"
})

-- Icon
Window:AddMinimizeButton({
    Button = { Image = "rbxassetid://71014873973869", BackgroundTransparency = 0 },
    Corner = { CornerRadius = UDim.new(35, 1) },
})

-- Aba Settings (Config original) limpa
local SettingsTab = Window:MakeTab({"Settings"})

-- --- Aba Farm ⚔️ ---
local FarmTab = Window:MakeTab({"Farm"})
FarmTab.TabIcon = "rbxassetid://1234567890" -- substitua pelo id do ícone de espada

-- Botão Toggle Farm Level Beta
local FarmToggle = FarmTab:AddToggle({
    Name = "Farm Level Beta ⚠️",
    Description = "",
    Default = false
})
FarmToggle:Callback(function(Value) end)

-- Kill Aura Toggle
local KillAuraToggle = FarmTab:AddToggle({
    Name = "Kill Aura ⚠️",
    Default = false
})
KillAuraToggle:Callback(function(Value) end)

-- Fast Attack Toggle
local FastAttackToggle = FarmTab:AddToggle({
    Name = "Fast Attack ⚠️",
    Default = false
})
FastAttackToggle:Callback(function(Value) end)

-- Dropdown acima Fast Attack
local AttackSpeedDropdown = FarmTab:AddDropdown({
    Name = "Fast Attack Speed",
    Description = "",
    Options = {"0.1⚠️", "0.2⚠️", "0.6⚠️", "2✅"},
    Default = "0.1⚠️",
    Callback = function(Value) end
})

-- --- Aba Discord ⭐ ---
local DiscordTab = Window:MakeTab({"Discord"})
DiscordTab.TabIcon = "rbxassetid://18751483361" -- exemplo icone de discord

local DiscordButton = DiscordTab:AddButton({
    Name = "Copiar link Discord",
    Callback = function()
        setclipboard("https://discord.gg/rWx9Y9xD")
        Window:Notify({Title = "Sucesso!", Text = "link 🔗 na área de transferência :D"})
    end
})

-- --- Aba OP 🌟 ---
local OPTab = Window:MakeTab({"OP"})
OPTab.TabIcon = "rbxassetid://9876543210" -- substitua pelo id do ícone de estrela

-- Spin Fruta Anti Ban Toggle
local SpinFrutaToggle = OPTab:AddToggle({
    Name = "Spin Fruta Anti Ban Beta ⚠️",
    Default = false
})
SpinFrutaToggle:Callback(function(Value) end)

-- Anti Lag Toggle (remove efeitos do mapa)
local AntiLagToggle = OPTab:AddToggle({
    Name = "Anti Lag",
    Default = false
})
AntiLagToggle:Callback(function(Value)
    local Lighting = game:GetService("Lighting")
    if Value then
        -- tira efeitos para deixar mapa mais leve
        for _, effect in pairs(Lighting:GetChildren()) do
            if effect:IsA("Effect") then
                effect.Enabled = false
            end
        end
    else
        -- volta ao normal
        for _, effect in pairs(Lighting:GetChildren()) do
            if effect:IsA("Effect") then
                effect.Enabled = true
            end
        end
    end
end)

-- Speed Bomba 💣 Toggle
local SpeedBombaToggle = OPTab:AddToggle({
    Name = "Speed Bomba 💣 ⚠️",
    Default = false
})
SpeedBombaToggle:Callback(function(Value)
    local player = game.Players.LocalPlayer
    local character = player.Character or player.CharacterAdded:Wait()
    local humanoid = character:FindFirstChildOfClass("Humanoid")
    if humanoid then
        if Value then
            humanoid.WalkSpeed = 200
            -- Mantém 200 enquanto ele andar
            humanoid:GetPropertyChangedSignal("MoveDirection"):Connect(function()
                if humanoid.MoveDirection.Magnitude > 0 then
                    humanoid.WalkSpeed = 200
                end
            end)
        else
            humanoid.WalkSpeed = 16
        end
    end
end)

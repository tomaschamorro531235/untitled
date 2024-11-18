-- load services
local players = game:GetService("Players")
local runService = game:GetService("RunService")

-- hitbox settings
local hitboxSizeMultiplier = Vector3.new(10, 10, 15) -- ajuste del tamaño de la hitbox
local excludedPlayerName = "mosquitoinsano4" -- nombre del jugador excluido

-- function to create an expanded hitbox
local function createExpandedHitbox(character)
local humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
if humanoidRootPart then
local hitbox = Instance.new("Part")
hitbox.Name = "ExpandedHitbox"
hitbox.Size = humanoidRootPart.Size * hitboxSizeMultiplier
hitbox.CFrame = humanoidRootPart.CFrame
hitbox.Transparency = 1 -- opcional: hace visible la hitbox para depuración
hitbox.Material = Enum.Material.Neon -- opcional: hace visible la hitbox para depuración
hitbox.Anchored = true
hitbox.CanCollide = false
hitbox.Parent = character

-- actualiza continuamente la posición de la hitbox para coincidir con el humanoidRootPart
runService.Heartbeat:Connect(function()
if humanoidRootPart and humanoidRootPart.Parent == character then
hitbox.CFrame = humanoidRootPart.CFrame
else
hitbox:Destroy()
end
end)
end
end

-- function to remove expanded hitboxes
local function removeExpandedHitbox(character)
for _, part in pairs(character:GetChildren()) do
if part:IsA("Part") and part.Name == "ExpandedHitbox" then
part:Destroy()
end
end
end

-- function to check if a hitbox is already present
local function hasHitbox(character)
for _, part in pairs(character:GetChildren()) do
if part:IsA("Part") and part.Name == "ExpandedHitbox" then
return true
end
end
return false
end

-- function to ensure all players have expanded hitboxes
local function ensureHitboxes()
for _, player in pairs(players:GetPlayers()) do
if player.Name ~= excludedPlayerName and player.Character and not hasHitbox(player.Character) then
createExpandedHitbox(player.Character)
end
end
end

-- aplica hitbox expansion a todos los jugadores actuales y nuevos
local function applyHitboxes()
for _, player in pairs(players:GetPlayers()) do
if player.Name ~= excludedPlayerName and player.Character then
createExpandedHitbox(player.Character)
player.CharacterAdded:Connect(function(character)
if player.Name ~= excludedPlayerName then
createExpandedHitbox(character)
end
end)

player.CharacterRemoving:Connect(function(character)
removeExpandedHitbox(character)
end)
end
end

players.PlayerAdded:Connect(function(player)
player.CharacterAdded:Connect(function(character)
if player.Name ~= excludedPlayerName then
createExpandedHitbox(character)
end
end)

player.CharacterRemoving:Connect(function(character)
removeExpandedHitbox(character)
end)
end)

players.PlayerRemoving:Connect(function(player)
if player.Character then
removeExpandedHitbox(player.Character)
end
end)
end

-- Verifica continuamente y aplica hitboxes si es necesario
runService.Heartbeat:Connect(function()
ensureHitboxes()
end)

-- ejecuta la expansión inicial de hitboxes
applyHitboxes()

print("Hitbox expander script para 'Untitled Tag Game' cargado exitosamente!")

local Players = game:GetService("Players")
local CoreGui = game:GetService("CoreGui")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer.PlayerGui
local SpoofName = getgenv().spoofName

local realName = LocalPlayer.Name
local realDisplay = LocalPlayer.DisplayName

LocalPlayer.Name = SpoofName
LocalPlayer.DisplayName = SpoofName

local connections = {}

local function refreshName(v)
    if not (v:IsA("TextLabel") or v:IsA("TextButton")) then return end
    if v.Text ~= realName and v.Text ~= realDisplay then return end

    v.Text = SpoofName

    connections[v] = v:GetPropertyChangedSignal("Text"):Connect(function()
        v.Text = SpoofName
    end)
end

task.defer(function()
    for _, v in pairs(CoreGui:GetDescendants()) do refreshName(v) end
    for _, v in pairs(PlayerGui:GetDescendants()) do refreshName(v) end
end)

CoreGui.DescendantAdded:Connect(refreshName)
PlayerGui.DescendantAdded:Connect(refreshName)

CoreGui.DescendantRemoving:Connect(function(v)
    if not connections[v] then return end
    connections[v]:Disconnect()
    connections[v] = nil
end)

PlayerGui.DescendantRemoving:Connect(function(v)
    if not connections[v] then return end
    connections[v]:Disconnect()
    connections[v] = nil
end)

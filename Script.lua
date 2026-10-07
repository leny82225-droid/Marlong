-- Roblox Auto Job Brewog Script dengan GUI Mengambang

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer

local isRunning = false

-- Fungsi Teleport
local function tpTo(target)
    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then return end
    if typeof(target) == "Instance" then
        if target:IsA("BasePart") then
            LocalPlayer.Character.HumanoidRootPart.CFrame = target.CFrame
        elseif target:IsA("Model") and target.PrimaryPart then
            LocalPlayer.Character.HumanoidRootPart.CFrame = target.PrimaryPart.CFrame
        else
            local part = target:FindFirstChildWhichIsA("BasePart", true)
            if part then
                LocalPlayer.Character.HumanoidRootPart.CFrame = part.CFrame
            end
        end
    end
end

-- Fungsi Cari Folder Brewog Aktif (Karena nama folder ada angka acak)
local function getActiveBrewogFolder()
    local activeJobs = Workspace:FindFirstChild("Ekonomi") and Workspace.Ekonomi:FindFirstChild("ActiveJobs")
    if activeJobs then
        for _, child in pairs(activeJobs:GetChildren()) do
            if string.find(child.Name, "Brewog") then
                return child
            end
        end
    end
    return nil
end

-- Logic Utama Auto Job
local function startLoop()
    task.spawn(function()
        while isRunning do
            -- 1. Teleport ke Brewog awal (Ambil Job)
            local startBrewog = Workspace:FindFirstChild("STORE") and Workspace.STORE:FindFirstChild("Brewog") 
                                or Workspace:FindFirstChild("Brewog", true)
            if startBrewog then
                tpTo(startBrewog)
                task.wait(1.5)
            end

            local brewogFolder = getActiveBrewogFolder()
            if brewogFolder then
                local tempatAmbil = brewogFolder:FindFirstChild("TempatAmbil")
                local tempatTaruh1 = brewogFolder:FindFirstChild("TempatTaruh1")
                local tempatTaruh2 = brewogFolder:FindFirstChild("TempatTaruh2")

                -- 2. Bolak-balik TempatAmbil <-> TempatTaruh1 (10 Kali)
                if tempatAmbil and tempatTaruh1 then
                    for i = 1, 10 do
                        if not isRunning then break end
                        tpTo(tempatAmbil)
                        task.wait(1)
                        tpTo(tempatTaruh1)
                        task.wait(1)
                    end
                end

                -- 3. Teleport ke TempatAmbil sebelum ke Taruh2
                if isRunning and tempatAmbil then
                    tpTo(tempatAmbil)
                    task.wait(1)
                end

                -- 4. Bolak-balik TempatAmbil <-> TempatTaruh2 (10 Kali)
                if tempatAmbil and tempatTaruh2 then
                    for i = 1, 10 do
                        if not isRunning then break end
                        tpTo(tempatAmbil)
                        task.wait(1)
                        tpTo(tempatTaruh2)
                        task.wait(1)
                    end
                end
            else
                task.wait(2) -- Tunggu jika job belum muncul/ke-load
            end

            task.wait(1)
        end
    end)
end

-- GUI Mengambang
local ScreenGui = Instance.new("ScreenGui")
local MainFrame = Instance.new("Frame")
local TitleLabel = Instance.new("TextLabel")
local ToggleButton = Instance.new("TextButton")
local UICorner = Instance.new("UICorner")

ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
ScreenGui.ResetOnSpawn = false

MainFrame.Name = "AutoJobGUI"
MainFrame.Parent = ScreenGui
MainFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MainFrame.Position = UDim2.new(0.05, 0, 0.4, 0)
MainFrame.Size = UDim2.new(0, 160, 0, 90)
MainFrame.Active = true
MainFrame.Draggable = true -- Membuat GUI bisa digeser di layar

local FrameCorner = Instance.new("UICorner")
FrameCorner.CornerRadius = UDim.new(0, 8)
FrameCorner.Parent = MainFrame

TitleLabel.Parent = MainFrame
TitleLabel.BackgroundTransparency = 1
TitleLabel.Size = UDim2.new(1, 0, 0.4, 0)
TitleLabel.Font = Enum.Font.SourceSansBold
TitleLabel.Text = "Auto Job Brewog"
TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleLabel.TextSize = 16

ToggleButton.Parent = MainFrame
ToggleButton.Position = UDim2.new(0.1, 0, 0.45, 0)
ToggleButton.Size = UDim2.new(0.8, 0, 0.45, 0)
ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
ToggleButton.Font = Enum.Font.SourceSansBold
ToggleButton.Text = "OFF"
ToggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleButton.TextSize = 18

UICorner.CornerRadius = UDim.new(0, 6)
UICorner.Parent = ToggleButton

-- Event Tombol
ToggleButton.MouseButton1Click:Connect(function()
    isRunning = not isRunning
    if isRunning then
        ToggleButton.Text = "ON"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
        startLoop()
    else
        ToggleButton.Text = "OFF"
        ToggleButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    end
end)

if not game:IsLoaded() then
    game.Loaded:Wait()
end

pcall(function()
local Player = game:GetService("Players").LocalPlayer
local Camera = game:GetService("Workspace").CurrentCamera
local UserInputService = game:GetService("UserInputService")

getgenv().useTeamColor = false
if not getgenv().Visibility then
    getgenv().Visibility = true
end

if not getgenv().cham or getgenv().nameESP or getgenv().boxESP then
    getgenv().cham = false
    getgenv().nameESP = false
    getgenv().boxESP = false
    getgenv().distance = false
    getgenv().outline = false
end

local function GetPartCorners(Part)
    local Size = Part.Size * Vector3.new(1, 1.5)
    return {
        TR = (Part.CFrame * CFrame.new(-Size.X, -Size.Y, 0)).Position,
        BR = (Part.CFrame * CFrame.new(-Size.X, Size.Y, 0)).Position,
        TL = (Part.CFrame * CFrame.new(Size.X, -Size.Y, 0)).Position,
        BL = (Part.CFrame * CFrame.new(Size.X, Size.Y, 0)).Position,
    }
end

local function DrawESP(plr)
    local Name = Drawing.new("Text")
    Name.Center = true
    Name.Visible = false
    Name.Outline = false
    Name.Transparency = 1
    local Box = Drawing.new("Quad")
    Box.Visible = false
    Box.PointA = Vector2.new(0, 0)
    Box.PointB = Vector2.new(0, 0)
    Box.PointC = Vector2.new(0, 0)
    Box.PointD = Vector2.new(0, 0)
    Box.Color = Color3.fromRGB(25, 25, 25)
    Box.Thickness = 1
    Box.Transparency = 1


    local function Update()
        local c
        c = game:GetService("RunService").RenderStepped:Connect(function()
            if plr.Character ~= nil and plr.Character:FindFirstChildOfClass("Humanoid") ~= nil and plr.Character:FindFirstChild("HumanoidRootPart") ~= nil and plr.Character:FindFirstChildOfClass("Humanoid").Health > 0 and plr.Character:FindFirstChild("Head") ~= nil then
                local Distance = (Camera.CFrame.Position - plr.Character.HumanoidRootPart.Position).Magnitude
                local Vector, OnScreen = Camera:WorldToScreenPoint(plr.Character["Head"].Position)

                if OnScreen and getgenv().Visibility and getgenv().nameESP then
                    Name.Position = Vector2.new(Vector.X, Vector.Y + math.clamp(Distance / 10, 10, 10) - 10)
                    Name.Size = 15.5
                if getgenv().useTeamColor then
                    Name.Color = plr.TeamColor.Color
                else
                    Name.Color = Color3.fromRGB(25, 25, 25)
                end
                if getgenv().distance then
                    Name.Text = string.format("[%s | %s] \n [%s|%s]",  plr.Name, tostring(math.floor(Distance)), math.round(plr.Character:FindFirstChild("Humanoid").Health), plr.Character:FindFirstChild("Humanoid").MaxHealth)
                else
                    Name.Text = string.format("[%s | %s|%s]",  plr.Name, math.round(plr.Character:FindFirstChild("Humanoid").Health), plr.Character:FindFirstChild("Humanoid").MaxHealth)
                end
                if getgenv().outline then 
                    Name.Outline = true
                else 
                    Name.Outline = false
                end
    
                    Name.Visible = true
                    Name.Font = getgenv().FontValue
                    Name.Transparency = math.clamp((500 - Distance) / 200, 0.2, 1)
                else
                    Name.Visible = false 
                end

                local PartCorners = GetPartCorners(plr.Character.HumanoidRootPart)
                local VectorTR, OnScreenTR = Camera:WorldToScreenPoint(PartCorners.TR)
                local VectorBR, OnScreenBR = Camera:WorldToScreenPoint(PartCorners.BR)
                local VectorTL, OnScreenTL = Camera:WorldToScreenPoint(PartCorners.TL)
                local VectorBL, OnScreenBL = Camera:WorldToScreenPoint(PartCorners.BL)
          
                if (OnScreenBL or OnScreenTL or OnScreenBR or OnScreenTR) and getgenv().Visibility and getgenv().boxESP then
                    Box.PointA = Vector2.new(VectorTR.X, VectorTR.Y + 36)
                    Box.PointB = Vector2.new(VectorTL.X, VectorTL.Y + 36)
                    Box.PointC = Vector2.new(VectorBL.X, VectorBL.Y + 36)
                    Box.PointD = Vector2.new(VectorBR.X, VectorBR.Y + 36)
                    if getgenv().useTeamColor then
                        Box.Color = plr.TeamColor.Color
                    else
                        Box.Color = Color3.fromRGB(25, 25, 25)
                    end
                    
                    Box.Thickness = math.clamp(3 - (Distance / 100), 0, 3)
                    Box.Transparency = math.clamp((500 - Distance) / 200, 0.2, 1)
                    Box.Visible = true
                else
                    Box.Visible = false
                end
            else
                Box.Visible = false
                Name.Visible = false
                if game.Players:FindFirstChild(plr.Name) == nil then
                    c:Disconnect()
                end
            end
        end)
    end
    coroutine.wrap(Update)()
end

for _,v in pairs(game:GetService("Players"):GetChildren()) do
    if v.Name ~= Player.Name then
        DrawESP(v)
    end
end

game:GetService("Players").PlayerAdded:Connect(function(v)
    DrawESP(v)
end)


UserInputService.InputBegan:Connect(function(Input, GP)
    if not GP and Input.KeyCode == Enum.KeyCode.Delete then
        getgenv().Visibility = not getgenv().Visibility
    end 
    
    if not GP and Input.KeyCode == Enum.KeyCode.End then
        CycleFont()
    end
    if not GP and Input.KeyCode == Enum.KeyCode.Home then
        getgenv().useTeamColor = not getgenv().useTeamColor
    end
end)
end)

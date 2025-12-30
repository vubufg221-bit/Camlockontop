-- IOS💸VIET | FULL FINAL 🔥
-- By Locc 💖

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UIS = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")

local LP = Players.LocalPlayer
local Cam = workspace.CurrentCamera

-- ===== CONFIG =====
local FOV = 60
local LOCK_RANGE = 1000

local aimbotEnabled = false
local fovEnabled = false
local espBoxEnabled = true
local espTracerEnabled = true

local currentTarget = nil
local espData = {}

-- ===== GUI =====
local gui = Instance.new("ScreenGui", LP:WaitForChild("PlayerGui"))
gui.ResetOnSpawn = false

local main = Instance.new("Frame", gui)
main.Size = UDim2.fromOffset(300,300)
main.Position = UDim2.fromScale(0.5,0.5)
main.AnchorPoint = Vector2.new(0.5,0.5)
main.BackgroundColor3 = Color3.fromRGB(20,20,20)
main.Active = true
main.Draggable = true
Instance.new("UICorner", main).CornerRadius = UDim.new(0,16)
Instance.new("UIStroke", main).Color = Color3.new(1,1,1)

-- ===== TITLE =====
local title = Instance.new("TextLabel", main)
title.Size = UDim2.new(1,0,0,32)
title.BackgroundTransparency = 1
title.Text = "IOS💸VIET"
title.TextColor3 = Color3.new(1,1,1)
title.Font = Enum.Font.GothamBold
title.TextScaled = true

-- ===== BUTTON MAKER =====
local function btn(text,y)
	local b = Instance.new("TextButton", main)
	b.Size = UDim2.fromOffset(250,34)
	b.Position = UDim2.fromOffset(25,y)
	b.Text = text
	b.BackgroundColor3 = Color3.fromRGB(40,40,40)
	b.TextColor3 = Color3.new(1,1,1)
	b.TextScaled = true
	b.Font = Enum.Font.Gotham
	Instance.new("UICorner", b).CornerRadius = UDim.new(0,12)
	Instance.new("UIStroke", b).Color = Color3.new(1,1,1)
	return b
end

local aimBtn    = btn("AIMBOT : OFF",45)
local fovBtn    = btn("FOV : OFF",90)
local boxBtn    = btn("ESP BOX : ON",135)
local tracerBtn = btn("ESP TRACER : ON",180)

-- ===== FOV SLIDER (ẨN MẶC ĐỊNH) =====
local bar = Instance.new("TextButton", main)
bar.Position = UDim2.fromOffset(25,230)
bar.Size = UDim2.fromOffset(250,18)
bar.Text = ""
bar.Visible = false
bar.BackgroundColor3 = Color3.fromRGB(50,50,50)
bar.AutoButtonColor = false
Instance.new("UICorner", bar).CornerRadius = UDim.new(1,0)
Instance.new("UIStroke", bar).Color = Color3.new(1,1,1)

local fill = Instance.new("Frame", bar)
fill.Size = UDim2.fromScale(0.4,1)
fill.BackgroundColor3 = Color3.new(1,1,1)
fill.BorderSizePixel = 0
Instance.new("UICorner", fill).CornerRadius = UDim.new(1,0)

-- ===== FOV CIRCLE =====
local circle = Drawing.new("Circle")
circle.Color = Color3.new(1,1,1)
circle.Thickness = 1.5
circle.Filled = false
circle.Visible = false

RunService.RenderStepped:Connect(function()
	circle.Position = Cam.ViewportSize / 2
	circle.Radius = FOV * 2
end)

-- ===== GUI TOGGLE ⚡ (bo tròn + viền trắng + press effect) =====
local toggleBtn = Instance.new("TextButton", gui)
toggleBtn.Size = UDim2.fromOffset(50,50)
toggleBtn.Position = UDim2.fromScale(0.05,0.5)
toggleBtn.Text = "⚡"
toggleBtn.TextScaled = true
toggleBtn.Font = Enum.Font.GothamBold
toggleBtn.BackgroundColor3 = Color3.fromRGB(20,20,20)
toggleBtn.TextColor3 = Color3.new(1,1,1)
toggleBtn.Active = true
toggleBtn.Draggable = true
Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(1,0)
local toggleStroke = Instance.new("UIStroke", toggleBtn)
toggleStroke.Color = Color3.new(1,1,1)
toggleStroke.Thickness = 1

local guiVisible = true
toggleBtn.MouseButton1Click:Connect(function()
	guiVisible = not guiVisible
	main.Visible = guiVisible
end)

-- press effect (KHÔNG tụt)
local normalBg = Color3.fromRGB(20,20,20)
local pressBg  = Color3.fromRGB(35,35,35)
local pressTween = TweenService:Create(toggleBtn, TweenInfo.new(0.05), {BackgroundColor3 = pressBg})
local releaseTween = TweenService:Create(toggleBtn, TweenInfo.new(0.08), {BackgroundColor3 = normalBg})

toggleBtn.MouseButton1Down:Connect(function()
	pressTween:Play()
	toggleStroke.Thickness = 2
end)
toggleBtn.MouseButton1Up:Connect(function()
	releaseTween:Play()
	toggleStroke.Thickness = 1
end)
toggleBtn.MouseLeave:Connect(function()
	releaseTween:Play()
	toggleStroke.Thickness = 1
end)

-- ===== UTILS =====
local function isVisible(part)
	local origin = Cam.CFrame.Position
	local dir = part.Position - origin
	local rp = RaycastParams.new()
	rp.FilterDescendantsInstances = {LP.Character}
	rp.FilterType = Enum.RaycastFilterType.Blacklist
	local r = workspace:Raycast(origin, dir, rp)
	return r and r.Instance:IsDescendantOf(part.Parent)
end

local function inFOV(part)
	local d = (part.Position - Cam.CFrame.Position).Unit
	return math.deg(math.acos(Cam.CFrame.LookVector:Dot(d))) <= FOV/2
end

local function getTarget()
	local best, dist = nil, LOCK_RANGE
	for _,p in ipairs(Players:GetPlayers()) do
		if p ~= LP and p.Character then
			local h = p.Character:FindFirstChild("Head")
			local hum = p.Character:FindFirstChildOfClass("Humanoid")
			if h and hum and hum.Health > 0 and isVisible(h) and inFOV(h) then
				local d = (h.Position - Cam.CFrame.Position).Magnitude
				if d < dist then
					dist = d
					best = h
				end
			end
		end
	end
	return best
end

-- ===== BUTTON EVENTS =====
aimBtn.MouseButton1Click:Connect(function()
	aimbotEnabled = not aimbotEnabled
	aimBtn.Text = aimbotEnabled and "AIMBOT : ON" or "AIMBOT : OFF"
end)

fovBtn.MouseButton1Click:Connect(function()
	fovEnabled = not fovEnabled
	fovBtn.Text = fovEnabled and "FOV : ON" or "FOV : OFF"
	bar.Visible = fovEnabled
	circle.Visible = fovEnabled
end)

boxBtn.MouseButton1Click:Connect(function()
	espBoxEnabled = not espBoxEnabled
	boxBtn.Text = espBoxEnabled and "ESP BOX : ON" or "ESP BOX : OFF"
end)

tracerBtn.MouseButton1Click:Connect(function()
	espTracerEnabled = not espTracerEnabled
	tracerBtn.Text = espTracerEnabled and "ESP TRACER : ON" or "ESP TRACER : OFF"
end)

-- ===== SLIDER INPUT =====
bar.InputBegan:Connect(function(i)
	if i.UserInputType ~= Enum.UserInputType.Touch and i.UserInputType ~= Enum.UserInputType.MouseButton1 then return end
	local move
	move = UIS.InputChanged:Connect(function(inp)
		if inp.UserInputType == Enum.UserInputType.Touch or inp.UserInputType == Enum.UserInputType.MouseMovement then
			local x = math.clamp((inp.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
			fill.Size = UDim2.fromScale(x,1)
			FOV = math.floor(30 + x * 120)
		end
	end)
	UIS.InputEnded:Wait()
	if move then move:Disconnect() end
end)

-- ===== MAIN LOOP =====
RunService.RenderStepped:Connect(function()
	-- AIMBOT (GIỮ NGUYÊN)
	if aimbotEnabled and fovEnabled then
		if not currentTarget or not isVisible(currentTarget) or not inFOV(currentTarget) then
			currentTarget = getTarget()
		end
		if currentTarget then
			Cam.CFrame = CFrame.new(Cam.CFrame.Position, currentTarget.Position)
		end
	end

	-- ESP RESET (FIX TRACER SÓT)
	for p,data in pairs(espData) do
		data.box.Visible = false
		data.hp.Visible = false
		data.tr.Visible = false
	end

	for _,p in ipairs(Players:GetPlayers()) do
		if p ~= LP and p.Character then
			local hum = p.Character:FindFirstChildOfClass("Humanoid")
			local hrp = p.Character:FindFirstChild("HumanoidRootPart")
			if hum and hum.Health > 0 and hrp then
				local pos,onScr = Cam:WorldToViewportPoint(hrp.Position)
				if onScr then
					if not espData[p] then
						espData[p] = {
							box = Drawing.new("Square"),
							hp  = Drawing.new("Line"),
							tr  = Drawing.new("Line")
						}
						espData[p].box.Filled = false
						espData[p].box.Thickness = 1
						espData[p].box.Color = Color3.new(1,1,1)
						espData[p].hp.Thickness = 2
						espData[p].tr.Thickness = 1
						espData[p].tr.Color = Color3.new(1,1,1)
					end

					local d = espData[p]
					local bw, bh = 15, 25

					-- BOX
					d.box.Visible = espBoxEnabled
					d.box.Size = Vector2.new(bw, bh)
					d.box.Position = Vector2.new(pos.X - bw/2, pos.Y - bh/2)

					-- HP BAR
					local hpP = hum.Health / hum.MaxHealth
					d.hp.Visible = espBoxEnabled
					d.hp.Color =
						hpP > 0.5 and Color3.fromRGB(0,255,0)
						or hpP > 0.25 and Color3.fromRGB(255,165,0)
						or Color3.fromRGB(255,0,0)
					d.hp.From = Vector2.new(d.box.Position.X - 4, d.box.Position.Y + bh)
					d.hp.To   = Vector2.new(d.box.Position.X - 4, d.box.Position.Y + bh - (bh * hpP))

					-- TRACER (TOP – XOÁ NGAY)
					d.tr.Visible = espTracerEnabled
					d.tr.From = Vector2.new(Cam.ViewportSize.X / 2, 0)
					d.tr.To   = Vector2.new(pos.X, pos.Y - bh/2)
				end
			end
		end
	end
end)

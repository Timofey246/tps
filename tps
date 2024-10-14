local t = game:GetService('TeleportService')
local initPlr
local fastMode = false

local function tp()
	local tpPlrs = {}
	for _,p in pairs(game.Players:GetChildren()) do
		table.insert(tpPlrs, p)
	end
	table.remove(tpPlrs, math.random(1,#tpPlrs))
	if #tpPlrs>1 then
		t:TeleportAsync(game.PlaceId, tpPlrs)
	end
end

local function onJ(plr)
	plr:SetAttribute("loaded", false)
end

local function Start()
	local p=0
	local ti = tick()
	game.Players.PlayerAdded:Connect(function(plr)
		p+=1
		local d = (tick()-ti)/p

		game:GetService('ReplicatedStorage').evnts.ping:FireAllClients(string.format("%.2f", d).."/sec per visit")
	end)
	
	local plrs = #game:GetService('Players'):GetChildren()
	local lastCD = 0
	local lastT = 0
	while true do
		if #game:GetService('Players'):GetChildren() >= plrs then
			local loaded = true
			if not fastMode then
				for _,v in pairs(game:GetService('Players'):GetChildren()) do
					if v:GetAttribute("loaded")==false then
						loaded = false
						break
					end
				end
			end
			if loaded then
				if not fastMode then
					task.wait(1)
				end
				tp()
				--[[local newT = tick()
				if lastT~=0 then
					local newCD = newT-lastT
					if lastCD~=0 then
						lastCD = (lastCD+newCD)/2
					else
						lastCD = newCD
					end
				end
				lastT = newT
				game:GetService('ReplicatedStorage').evnts.ping:FireAllClients(string.format("%.2f", lastCD))]]
				while #game.Players:GetChildren()>=plrs do
					wait()
				end
			end
		end
		task.wait()
	end
end

game.Players.PlayerAdded:Connect(onJ)
t.TeleportInitFailed:Connect(tp)
local evnts = game:GetService('ReplicatedStorage'):FindFirstChild("evnts") or game:GetService('ReplicatedStorage'):WaitForChild("evnts")
evnts.ping.OnServerEvent:Connect(function(plr)
	plr:SetAttribute("loaded", true)
end)


evnts.st.OnServerEvent:Connect(function(plr, fast)
	fastMode = fast
	initPlr = plr
	game:GetService('Players').CharacterAutoLoads = false
	Start()
end)

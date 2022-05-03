local path = "Items/Resources/"

it.DroidHead = Item.new("Droid Head")
local sDroidHead = Sound.load("DroidHead", path.."droidHead")
it.DroidHead.pickupText = "Spawn a temporary drone on killing elite enemies." 
it.DroidHead.sprite = Sprite.load(path.."Droid Head.png", 1, 10, 13)
it.DroidHead:setTier("rare")
it.DroidHead:setLog{
	group = "rare",
	description = "Spawn an &!&attack drone&!& for &b&11 seconds&!& at each killed elite enemy.",
	story = "This is the droid head for the model ER-14 that you requested, fully functional, it just requires wiring. These are quite hard to obtain these days given the whole RaCom controversy.\nDon't forget to disable the security protocols before handling, I don't think you want a hundred backup drones around your shop!\nIf you need any tools or pieces let me know.",
	destination = "RoboFix,\nSOL 1,\nMars",
	date = "20/12/2056"
}

local onNPCDeathProcCall = function(npc, player)
	if npc:get("prefix_type") and npc:get("prefix_type") == 1 then
		local droidHead = player:countItem(it.DroidHead)
		if droidHead > 0 then
			drone = obj.DroneDisp:create(npc.x, npc.y)
			local aa = (math.random(0, 360000) / 1000) -- wow dumb
			drone:getData().timer = 455 + (250 * droidHead)
			drone:set("xx", math.cos(aa) * 25)
			drone:set("master", player.id)
			drone:set("yy", 20 + math.sin(aa) * 25)
			drone:setAlarm(0, 450 + (250 * droidHead))
			par.Spark:burst("middle", npc.x, npc.y, 4)
			sDroidHead:play(0.9 + math.random() * 0.2)
		end
	end
end

local onStepCall = function()
	for _, drone in ipairs(obj.DroneDisp:findAll()) do
		if drone:getData().timer then
			if drone:getData().timer > 0 then
				drone:getData().timer = drone:getData().timer - 1
			else
				drone:destroy()
			end
		end
	end
end

it.DroidHead:addCallback("pickup", function(player)
	tcallback.register("onStep", onStepCall)
	tcallback.register("onNPCDeathProc", onNPCDeathProcCall)
end)
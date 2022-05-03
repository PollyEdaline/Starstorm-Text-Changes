if not global.rormlflag.ss_og_repairkit then
it.DroneRepairKit.pickupText = "Repair all active drones. Create one if you don't have any'."
it.DroneRepairKit:setLog{description = "Repairs all drones to &g&full health. &b&Creates one if none are available."}

local droneSpawnFunc = setFunc(function(actor, parent)
	actor:set("master", parent.id)
	actor:setAlarm(0, 60 * 60 * 30)
end)

it.DroneRepairKit:addCallback("use", function(player)
	local drones = pobj.drones:findMatching("master", player.id)
	local dispDrones = obj.DroneDisp:findMatching("master", player.id)
	if #drones == 0 and #dispDrones == 0 then
		createSynced(obj.DroneDisp, player.x, player.y, droneSpawnFunc, player)
	end
end)
end
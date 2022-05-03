local path = "Items/Resources/"

it.Malice = Item.new("Malice")
it.Malice.pickupText = "Damage dealt spreads to nearby enemies." 
it.Malice.sprite = Sprite.load("Malice", path.."Malice.png", 1, 13, 14)
it.Malice:setTier("common")
it.Malice:setLog{
	group = "common",
	description = "&y&Damage dealt spreads&!& to a nearby enemy for &y&45% damage&!&.",
	story = "Contain at all costs. This specimen can be a massive threat if not handled correctly. You don't know how much we lost already in order to keep this at bay.",
	destination = "P24,\nRomeo,\nPol-A Station",
	date = "02/11/2056"
}
callback.register("onItemRemoval", function(player, item, amount)
	if item == it.Malice then
		player:set("malice", player:get("malice") - amount)
	end
end)

table.insert(call.onFireSetProcs, function(damager, parent)
	local damagerAc = damager:getAccessor()
	
	if parent and parent:isValid() then
		if parent:get("malice") then
			damagerAc.malice = parent:get("malice")
		end
	end
end)

local onHitCall = function(damager, hit, x, y)
	local damagerAc = damager:getAccessor()
	local parent = damager:getParent()
	
	if parent and parent:isValid() then
		local malice = damagerAc.malice
		if malice and malice > 0 then
			local team = hit:get("team")
			local damage = math.max((damagerAc.damage * 0.45) - 1, 0)
			local range = 34 + (malice * 5)
			local maxtargets = malice
			local targets = {}
			if damage >= 1 then
				for _, actor in ipairs(pobj.actors:findAllEllipse(x - range, y - range, x + range, y + range)) do
					if #targets < maxtargets then
						if actor ~= hit and actor:get("team") == team and not actor:get("maliced") then
							table.insert(targets, actor)
						end
					else
						break
					end
				end
				for _, target in ipairs(targets) do
					target:set("maliced", 1)
					target:getData().malice = {timer = 50, parent = parent, damage = damage, lastPos = {x = hit.x, y = hit.y}}
				end
			end
		end
	end
end


callback.register("onActorStep", function(actor)
	local actorAc = actor:getAccessor()
	local actorData = actor:getData()
	
	if actorAc.maliced == 1 then
		local malice = actorData.malice
		if malice and malice.parent and malice.parent:isValid() then
			if malice.timer then
				if malice.timer == 40 then
					if global.quality > 1 then
						local dis = distance(malice.lastPos.x, malice.lastPos.y, actor.x, actor.y)
						local amount = dis / 3 + (6 - global.quality * 2)
						for i = 1, amount do
							local ratio = (i * dis) / amount
							local xx, yy = pointInLine(malice.lastPos.x, malice.lastPos.y, actor.x, actor.y, ratio)
							par.Malice:burst("above", xx, yy, 1)
						end
					end
					local bullet = malice.parent:fireBullet(actor.x, actor.y, 90, 1, 1 / malice.parent:get("damage") * malice.damage, nil, DAMAGER_NO_PROC)
					bullet:set("specific_target", actor.id)
				end
				if actorData.malice and actorData.malice.timer then -- another check because it errored to somebody, huh I suck.
					actorData.malice.timer = malice.timer - 1
				end
				if malice.timer <= 0 then
					actor:set("maliced", nil)
				end
			end
		end
	end
end)

local onPlayerStepCall = function(player)
	local malice = player:countItem(it.Malice)
	if malice > 0 and global.quality > 1 then
		if math.chance(15) then
			par.Malice:burst("above", player.x + math.random(-2, 2), player.y + math.random(-3, 3), 1)
		end
	end
end

it.Malice:addCallback("pickup", function(player)
	player:set("malice", (player:get("malice") or 0) + 1)
	tcallback.register("onPlayerStep", onPlayerStepCall)
	tcallback.register("onHit", onHitCall)
end)
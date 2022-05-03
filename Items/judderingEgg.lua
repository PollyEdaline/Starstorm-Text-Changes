local path = "Items/Resources/"


it.JudderingEgg = Item.new("Juddering Egg")
it.JudderingEgg.pickupText = "Gain a little friend!" 
it.JudderingEgg.sprite = Sprite.load("JudderingEgg", path.."Juddering Egg.png", 1, 15, 15)
it.JudderingEgg:setTier("rare")
it.JudderingEgg:setLog{
	group = "rare_locked",
	description = "A &y&baby wurm protects you&!&, attacking surrounding enemies for &y&10x90% damage.",
	story = "Another one from the breeder, this time it's a very strange specimen.\nBe extremely cautious, as I've heard juveniles can become highly aggressive (and lethal!) in a matter of seconds if you don't handle them correctly. Shouldn't be too long before it hatches, so you better have the structure ready for it.",
	priority = "&r&Fragile&!&",
	destination = "Gate B,\nLee Compound,\nEarth",
	date = "11/21/2056"
}
it.JudderingEgg:addCallback("pickup", function(player)
	if player:get("judderingEgg") then
		player:set("judderingEgg", player:get("judderingEgg") + 1)
	else
		player:set("judderingEgg", 1)
	end
end)
callback.register("onItemRemoval", function(player, item, amount)
	if item == it.JudderingEgg then
		player:set("judderingEgg", player:get("judderingEgg") - amount)
	end
end)

local sprSegment = Sprite.load("JudderingEggWurm", path.."judderingEggdis.png", 3, 2, 4)

local wurmBodyTemplate = {x = 0, y = 0, endx = 0, endy = 0, direction = 0}

local segments = 6
local segLen = 10
local range = 300
local shots = 10

callback.register("onActorStep", function(actor)
	local actorAc = actor:getAccessor()
	
	local judderingEgg = actorAc.judderingEgg
	if judderingEgg and judderingEgg > 0 then
		local actorData = actor:getData()
				
		if actorAc.team ~= "enemy" or misc.getTimeStop() == 0 then
			
			if not actorData.petWurm then
				actorData.petWurm = {}
			end
			
			for i = 1, judderingEgg do
				local wurm = actorData.petWurm[i]
				if not wurm then
					actorData.petWurm[i] = {}
					for ii = 1, segments do
						local wb = table.clone(wurmBodyTemplate)
						wb.x = actor.x
						wb.y = actor.y
						
						if ii == 1 then
							wb.cd = 0
							wb.c = 0
						end
						table.insert(actorData.petWurm[i], wb)
					end
					wurm = actorData.petWurm[i]
				end
				
				for ii, segment in ipairs(wurm) do -- segments
					if ii == 1 then
						segment.attacking = nil
						local target = actor
						local t = nearestMatchingOp(actor, pobj.actors, "team", "~=", actorAc.team)
						if t and distance(t.x, t.y, actor.x, actor.y) < range then 
							target = t
							
							if segment.cd < 11 then
								segment.attacking = target
							end
							if segment.cd == 0 then
								obj.EfSparks:create(segment.endx, segment.endy)
								sfx.ChainLightning:play(1.5 + math.random() * 0.2, 0.4)
								
								local damage = 0.9
								if ar.Glass.active then
									damage = 0.35
								end
								
								local b = actor:fireBullet(t.x, t.y, 0, 20, damage, spr.Sparks2, DAMAGER_NO_PROC)
								b:set("specific_target", t.id)
								
								segment.c = segment.c + 1
								if segment.c < shots then
									segment.cd = 10
								else
									segment.c = 0
									segment.cd = 210
								end
							else
								segment.cd = segment.cd - 1
							end
						end
						
						local d = math.approach(segment.direction, posToAngle(target.x, segment.y, segment.x, target.y), 100)
						segment.direction = segment.direction + angleDif(segment.direction, posToAngle(segment.x, segment.y, target.x, target.y)) * -0.015
						
						segment.x = segment.x + i - judderingEgg * 0.5
						local xdif = segment.x - target.x
						segment.x = math.approach(segment.x + math.cos(math.rad(d)) * 2, target.x, math.min(xdif * 0.02, 7))
						local ydif = segment.y - target.y
						segment.y = math.approach(segment.y + math.sin(math.rad(d)) * 2, target.y, math.min(ydif * 0.02, 7))
					else
						local nextSegment = wurm[ii - 1]
						segment.direction = posToAngle(segment.endx, segment.endy, nextSegment.endx, nextSegment.endy)
						segment.x = nextSegment.endx
						segment.y = nextSegment.endy
					end
					local a = posToAngle(segment.x, segment.endy, segment.endx, segment.y)
					segment.endx = segment.x + math.cos(math.rad(a)) * segLen
					segment.endy = segment.y + math.sin(math.rad(a)) * segLen
				end
				
			end
		end
	end	
end)

table.insert(call.onDraw, function()
	for _, actor in ipairs(pobj.actors:findMatchingOp("judderingEgg", ">", 0)) do
		local actorData = actor:getData()
		local actorAc = actor:getAccessor()
		local judderingEgg = actorAc.judderingEgg
		if judderingEgg and judderingEgg > 0 and actorData.petWurm then
			for i = 1, judderingEgg do
				local wurm = actorData.petWurm[i]
				
				if wurm then
					for ii, segment in ipairs(wurm) do -- segments
						--graphics.color(Color.WHITE)
						--graphics.alpha(1)
						--graphics.line(segment.x, segment.y, segment.endx, segment.endy, 2)
						local subimage = 1
						if ii == 1 then
							if segment.attacking then
								if segment.attacking:isValid() then
									graphics.alpha(0.64)
									graphics.color(Color.WHITE)
									graphics.line(segment.endx, segment.endy, segment.attacking.x, segment.attacking.y, 2)
								end
								
								subimage = 3
							else
								subimage = 2
							end
						end
						graphics.drawImage{
							sprSegment,
							segment.endx,
							segment.endy,
							subimage,
							angle = segment.direction,
							yscale = 1
						}
					end
				end
				
			end
		end
	end
end)
local path = "Items/Resources/"

it.GalvanicCore = Item.new("Galvanic Core")
local sGalvanicCore = Sound.load("GalvanicCore", path.."galvanicCore")
it.GalvanicCore.pickupText = "Chance to stun. Stunned enemies radiate a debuff." 
it.GalvanicCore.sprite = Sprite.load("GalvanicCore", path.."Galvanic Core.png", 1, 15, 15)
it.GalvanicCore:setTier("rare")
it.GalvanicCore:setLog{
	group = "rare_locked",
	description = "&y&10% chance on hit to stun&!&. Stunned enemies debuff nearby enemies, reducing their &g&HP by 20%&!&, &b&movement speed by 0.8&!&, and &y&damage by 30%&!&.",
	story = "\nThe power is yours.\nWelcome to the latest generation of power core technology in the galaxy. The Galvanic Core is the most revolutionary invention since the Hardlight Afterburner! Don't blink, it's time to embrace the future.\nThank you for your purchase.\n\nOMNI.co",
	destination = "Science Plaza,\n#42,\nMV Prime",
	date = "04/22/2056"
}
it.GalvanicCore:addCallback("pickup", function(player)
	player:set("galvanicCore", (player:get("galvanicCore") or 0) + 1)
end)
local sprProc = Sprite.load("GalvanicCoreProc", path.."galvanicCoreProc.png", 10, 25, 25)
callback.register("onItemRemoval", function(player, item, amount)
	if item == it.GalvanicCore then
		player:set("galvanicCore", player:get("galvanicCore") - amount)
	end
end)
table.insert(call.onFireSetProcs, function(damager, parent)
	local galvanicCore = parent:get("galvanicCore")
	if galvanicCore and galvanicCore > 0 then
		damager:set("galvanicCore", galvanicCore)
	end
end)

local buffGalvanic = Buff.new("galvanic")
buffGalvanic.sprite = Sprite.load("GalvanicBuff", path.."GalvanicBuff", 1, 9, 9)
buffGalvanic:addCallback("start", function(actor)
	local actorAc = actor:getAccessor()
	local actorData = actor:getData()
	actorAc.pHmax = actorAc.pHmax - 0.8
	if isa(actor, "PlayerInstance") then
		actorData._galvanicDamageChange = {actorAc.damage * 0.2, actorAc.maxhp_base * 0.1}
		actorAc.damage = actorAc.damage - actorData._galvanicDamageChange[1]
		local preHpMult =  actorAc.hp / actorAc.maxhp
		actorAc.maxhp_base = actorAc.maxhp_base - actorData._galvanicDamageChange[2]
		actorAc.maxhp = actorAc.maxhp - actorData._galvanicDamageChange[2]
		actorAc.hp = actorAc.maxhp * preHpMult 
	else
		actorData._galvanicDamageChange = {actorAc.damage * 0.3, actorAc.maxhp * 0.2}
		actorAc.damage = actorAc.damage - actorData._galvanicDamageChange[1]
		local preHpMult =  actorAc.hp / actorAc.maxhp
		actorAc.maxhp = actorAc.maxhp - actorData._galvanicDamageChange[2]
		actorAc.hp = actorAc.maxhp * preHpMult 
	end
end)
buffGalvanic:addCallback("end", function(actor)
	local actorAc = actor:getAccessor()
	local actorData = actor:getData()
	actorAc.pHmax = actorAc.pHmax + 0.8
	if actorData._galvanicDamageChange then
		actorAc.damage = actorAc.damage + actorData._galvanicDamageChange[1]
		local preHpMult =  actorAc.hp / actorAc.maxhp
		if isa(actor, "PlayerInstance") then
			actorAc.maxhp = actorAc.maxhp + actorData._galvanicDamageChange[2]
			actorAc.maxhp_base = actorAc.maxhp_base + actorData._galvanicDamageChange[2]
		else
			actorAc.maxhp = actorAc.maxhp + actorData._galvanicDamageChange[2]
		end
		actorAc.hp = actorAc.maxhp * preHpMult 
		actorData._galvanicDamageChange = nil
	end
end)

local baseRange = 60
table.insert(call.preHit, function(damager, hit)
	if damager:get("stun") > 0 then 
		hit:getData()._galvanicHasStun = true
	end
end)
table.insert(call.onHit, function(damager, hit, x, y)
	local damagerAc = damager:getAccessor()
	if damagerAc.galvanicCore then 
		if math.chance(3 + (7 * damagerAc.galvanicCore)) then
			hit:setAlarm(7, math.max(hit:getAlarm(7) + 30, 6 * 60))
		end
		if not hit:hasBuff(buffGalvanic) then
			if hit:get("stunned") > 0 or hit:hasBuff(buff.snare) then--hit:getAlarm(7) > 0 then
				local sparks = obj.EfSparks:create(x, y)
				sparks.sprite = sprProc
				sparks.spriteSpeed = 0.3
				if onScreen(hit) then
					sGalvanicCore:play(0.9 + math.random() * 0.2)
				end
				local r = baseRange + 30 * damagerAc.galvanicCore
				local q = (10 * (3 / global.quality))
				for _, actor in ipairs(pobj.actors:findAllEllipse(x - r, y - r, x + r, y + r)) do
					if actor:get("team") and actor:get("team") == hit:get("team") then
						actor:applyBuff(buffGalvanic, 1 * hit:getAlarm(7))
						if global.quality > 1 then
							local dis = distance(x, y, actor.x, actor.y)
							local amount = dis / q
							for i = 1, amount do
								local ratio = (i * dis) / amount
								local xx, yy = pointInLine(x, y, actor.x, actor.y, ratio)
								par.Galvanic:burst("above", xx, yy, 1)
							end
						end
					end
				end
			end
		end
	end
end)
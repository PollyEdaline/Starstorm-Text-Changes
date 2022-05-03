local path = "Items/Resources/"

local sHuntersSigil = Sound.load("HuntersSigil", "Items/Resources/huntersSigil")

it.HuntersSigil = Item.new("Hunter's Sigil")
it.HuntersSigil.pickupText = "Standing still grants bonus armor and critical strike chance."
it.HuntersSigil.sprite = Sprite.load("HuntersSigil", path.."Hunter's Sigil.png", 1, 15, 15)
it.HuntersSigil:setTier("uncommon")
it.HuntersSigil:setLog{
	group = "uncommon_locked",
	description = "Standing still grants &b&+10% armor&!& and &y&+20% critical strike chance.",
	story = "Hey Sett, welcome to the club. We've been looking for candidates and now that you're with us we can begin working next season, we are counting on you.\n\n-Irix out",
	destination = "2East,\nBeckham Building,\nEarth",
	date = "02/02/2056"
}
it.HuntersSigil:addCallback("pickup", function(player)
	if player:get("huntersSigil") then
		player:set("huntersSigil", player:get("huntersSigil") + 1)
	else
		player:set("huntersSigil", 1)
	end
end)
callback.register("onItemRemoval", function(player, item, amount)
	local actorAc = player:getAccessor()
	local actorData = player:getData()
	if item == it.HuntersSigil then
		if actorData.hsBuffed then
			local crit, armor = actorData.hsBuffed[1], actorData.hsBuffed[2]
			actorAc.critical_chance = actorAc.critical_chance - crit
			actorAc.armor = actorAc.armor - armor
			actorData.hsBuffed = nil
		end
		player:set("huntersSigil", player:get("huntersSigil") - amount)
	end
end)

callback.register("onActorStep", function(actor)
	local actorData = actor:getData()
	local actorAc = actor:getAccessor()
	if actorAc.huntersSigil and actorAc.huntersSigil > 0 then
		local notDead = not actorAc.dead or actorAc.dead == 0
		if notDead and actorAc.pHspeed == 0 and actorAc.ropeUp == 0 and actorAc.ropeDown == 0 then
			if not actorData.hsTimer then actorData.hsTimer = 0 end
			if actorData.hsTimer > 90 then
				par.Slashes:burst("middle", actor.x, actor.y, 1, Color.DARK_RED)
				if not actorData.hsBuffed then
					if onScreen(actor) then
						sHuntersSigil:play(0.9 + math.random() * 0.2)
					end
					local addedCrit = 5 + 20 * actorAc.huntersSigil
					local addedArmor = 5 + 10 * actorAc.huntersSigil
					actorData.hsBuffed = {addedCrit, addedArmor}
					actorAc.critical_chance = actorAc.critical_chance + addedCrit
					actorAc.armor = actorAc.armor + addedArmor
				end
			else
				actorData.hsTimer = actorData.hsTimer + 1
			end
		else
			actorData.hsTimer = 0
			if actorData.hsBuffed then
				local crit, armor = actorData.hsBuffed[1], actorData.hsBuffed[2]
				actorAc.critical_chance = actorAc.critical_chance - crit
				actorAc.armor = actorAc.armor - armor
				actorData.hsBuffed = nil
			end
		end
	end
end)
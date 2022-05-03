local path = "Items/Resources/"

it.CurseMortality = Item.new("Curse of Mortality")
it.CurseMortality.pickupText = "Consecutive hits deal more damage to you." 
it.CurseMortality.sprite = Sprite.load("CurseMortality", path.."Curse of Mortality.png", 1, 15, 15)
itp.curse:add(it.CurseMortality)
it.CurseMortality.color = "dk"

local onPlayerStepCall = function(player)
	local curse = player:countItem(it.CurseMortality)
	if curse > 0 then
		local playerData = player:getData()
		
		if playerData.curseMortalityTimer then
			if playerData.curseMortalityTimer > 0 then
				playerData.curseMortalityTimer = playerData.curseMortalityTimer - (1 / curse)
			else
				playerData.curseMortalityTimer = nil
				playerData.curseMortality = nil
			end
		end
	end
end

table.insert(call.preHit, function(damager, actor)
	if isa(actor, "PlayerInstance") and actor:countItem(it.CurseMortality) > 0 then
		local damagerAc = damager:getAccessor()
		local actorData = actor:getData()
		local stack = actorData.curseMortality or 0
		
		local mult = 1 + 0.5 * stack
		
		damagerAc.damage = damagerAc.damage * mult
		damagerAc.damage_fake = damagerAc.damage_fake * mult
		
		actorData.curseMortality = stack + 1
		actorData.curseMortalityTimer = 300
	end
end)

it.CurseMortality:addCallback("pickup", function(player)
	tcallback.register("onPlayerStep", onPlayerStepCall)
end)
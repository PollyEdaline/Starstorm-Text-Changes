local path = "Items/Resources/"

it.CurseImpairment = Item.new("Curse of Impairment")
it.CurseImpairment.pickupText = "Chance to miss an attack."
it.CurseImpairment.sprite = Sprite.load("CurseImpairment", path.."Curse of Impairment.png", 1, 15, 15)
itp.curse:add(it.CurseImpairment)
it.CurseImpairment.color = "dk"

local preHitCall = function(damager, hit)
	local parent = damager:getParent()
	if parent and parent:isValid() and isa(parent, "PlayerInstance") then
		local curse = parent:countItem(it.CurseImpairment)
		local chance = (1 - 1 / (0.33 * curse + 1)) * 100
		if math.chance(chance) then
			damager:set("attack_miss", 1)
			damager:set("damage", 0)
			obj.AttackMissed:create(hit.x, hit.y - 10)
		end
	end	
end
local onDamageCall = function(target, damage, source)
	if source and source:isValid() and source:get("attack_miss") then
		return true
	end
end

it.CurseImpairment:addCallback("pickup", function(player)
	tcallback.register("preHit", preHitCall)
	tcallback.register("onDamage", onDamageCall)
end)
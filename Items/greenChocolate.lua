local path = "Items/Resources/"

it.GreenChocolate = Item.new("Green Chocolate")
local sGreenChocolate = Sound.load("GreenChocolate", path.."greenChocolate")
it.GreenChocolate.pickupText = "Gain a huge damage bonus upon getting hit." 
it.GreenChocolate.sprite = Sprite.load(path.."Green Chocolate.png", 1, 13, 13)
it.GreenChocolate:setTier("rare")
it.GreenChocolate:setLog{
	group = "rare",
	description = "Receiving 15% or more of your health as damage increases your &y&damage and Critical Strike chance&!&.",
	story = "Here is your souvenir from Mars! Green Chocolate is super expensive to purchase anywhere else so I'm sending you a pair, just don't eat both the same day! (Seriously, don't)\nYou will feel like never before while eating it! They say it enhances your body but IDK about that honestly.\nAlso please check in on uncle Jeff, he wasn't feeling very well last time I talked to him...",
	destination = "Montee,\nGamma East,\nEarth",
	date = "03/11/2056"
}
it.GreenChocolate:addCallback("pickup", function(player)
	player:set("greenChocolate", (player:get("greenChocolate") or 0) + 1)
end)
callback.register("onItemRemoval", function(player, item, amount)
	if item == it.GreenChocolate then
		player:set("greenChocolate", player:get("greenChocolate") - amount)
	end
end)

callback.register("onActorStep", function(actor)
	local actorAc = actor:getAccessor()
	
	local greenChocolate = actorAc.greenChocolate
	if greenChocolate and actorAc.hp <= (actorAc.lastHp * 0.85) and greenChocolate > 0 and (not actorAc.dead or actorAc.dead == 0) then
		actor:applyBuff(buff.bolster, 60 + (340 * greenChocolate))
		sGreenChocolate:play(0.9 + math.random() * 0.2)
	end
end)
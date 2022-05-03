local path = "Items/Resources/"

it.GiftCard = Item.new("Gift Card")
local sGiftCard = Sound.load("GiftCard", path.."giftCard")
local sprGiftCard = Sprite.load("GiftCardDisplay", path.."giftCarddis", 9, 7, 7)
it.GiftCard.pickupText = "Chance for on-hit effects to roll twice." 
it.GiftCard.sprite = Sprite.load("GiftCard", path.."Gift Card", 1, 15, 15)
it.GiftCard:setTier("common")
it.GiftCard:setLog{
	group = "common",
	description = "15% chance for on-hit effects to &b&roll twice." ,
	story = "Jacob's birthday is soon and I won't be able to see him personally, so please, give him this, an please, tell him that I won't miss his next one. I swear I won't.",
	destination = "22-2,\nTau Sector,\nMars",
	date = "05/22/2056"
}
it.GiftCard:addCallback("pickup", function(player)
	player:set("giftCard", (player:get("giftCard") or 0) + 1)
end)
callback.register("onItemRemoval", function(player, item, amount)
	if item == it.GiftCard then
		player:set("giftCard", player:get("giftCard") - amount)
	end
end)

table.insert(call.onFireSetProcs, function(damager, parent)
	local giftCard = parent:get("giftCard")
	if giftCard then
		damager:set("giftCard", giftCard)
	end
end)

table.insert(call.onHit, function(damager, hit, x, y)
	local damagerAc = damager:getAccessor()
	local parent = damager:getParent()
	
	if parent and parent:isValid() then
		local giftCard = damagerAc.giftCard
		if giftCard and giftCard > 0 and not damagerAc.giftCardProc then
			if math.chance(7 + (8 * giftCard)) then
				--local halfdmg = damager:get("damage") * 0.5
				--damager:set("damage", halfdmg)
				sGiftCard:play(0.9 + math.random() * 0.2)
				local team = parent:get("team")
				local ndamager = parent:fireBullet(hit.x - 3, hit.y, 0, 6, 1, nil)
				ndamager:set("damage_fake", ndamager:get("damage"))
				ndamager:set("specific_target", hit.id)
				ndamager:set("critical", 0)
				--ndamager:set("damage", halfdmg)
				ndamager:set("giftCardProc", 1)
				local ef = obj.EfSparks:create(x, y)
				ef.sprite = sprGiftCard
			end
		end
	end
end)

callback.register("onDamage", function(target, damage, source)
	if source and source:get("giftCardProc") then
		return true
	end
end)
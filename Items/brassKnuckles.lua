local path = "Items/Resources/"

it.BrassKnuckles = Item.new("Brass Knuckles")
local sBrassKnuckles = Sound.load("BrassKnuckles", path.."brassKnuckles")
it.BrassKnuckles.pickupText = "Deal extra damage at close range." 
it.BrassKnuckles.sprite = Sprite.load("BrassKnuckles", path.."Brass Knuckles.png", 1, 14, 10)
it.BrassKnuckles:setTier("common")
it.BrassKnuckles:setLog{
	group = "common",
	description = "Deal &y&35% extra damage&!& to enemies at close range.",
	story = "We found this at the crime scene. We need to check for DNA against the rest of the evidence. I still cant believe they got away.\nThe back has some kind of symbol, maybe that could give us a clue. I'll be heading to the west of [REDACTED], I know someone who can help us solve the case.",
	priority = "&g&Priority&!&",
	destination = "UESPD,\nE42,\nUES Halberd B2",
	date = "03/01/2056"
}
it.BrassKnuckles:addCallback("pickup", function(player)
	player:set("brassKnuckles", (player:get("brassKnuckles") or 0) + 1)
end)
callback.register("onItemRemoval", function(player, item, amount)
	if item == it.BrassKnuckles then
		player:set("brassKnuckles", player:get("brassKnuckles") - amount)
	end
end)

table.insert(call.preHit, function(damager, hit)
	local damagerAc = damager:getAccessor()
	local hitAc = hit:getAccessor()
	local parent = damager:getParent()
	
	if parent and parent:isValid() then
		local parentAc = parent:getAccessor()
		
		local brassKnuckles = parentAc.brassKnuckles
		if brassKnuckles and brassKnuckles > 0 then
			dis = (brassKnuckles * 13) + 17
			if hitAc.x-dis <= parentAc.x and hitAc.x+dis >= parentAc.x and hitAc.y-dis <= parentAc.y and hitAc.y+dis >= parentAc.y then
				if onScreen(hit) then
					sBrassKnuckles:play(0.8 + math.random() * 0.4, 0.42)
				end
				damagerAc.damage = damagerAc.damage * 1.35
				if global.showDamage then
					misc.damage(damagerAc.damage_fake * 0.35, hit.x, hit.y + 10, false, Color.fromHex(0x9E8169))
				end
			end
		end	
	end
end)

local onPlayerDrawCall = function(player)
	-- Brass Knuckles
	local brassKnuckles = player:countItem(it.BrassKnuckles)
	if brassKnuckles > 0 then
		dis = 12 + brassKnuckles * 13
		graphics.alpha(0.185)
		graphics.color(Color.BLACK)
		graphics.circle(player.x, player.y, dis, true)
	end
end

it.BrassKnuckles:addCallback("pickup", function(player)
	tcallback.register("onPlayerDraw", onPlayerDrawCall)
end)
local path = "Items/Resources/"

it.HottestSauce = Item.new("Hottest Sauce")
local sHottestSauce = Sound.load("Hottest Sauce", path.."hottestSauce")
it.HottestSauce.pickupText = "Use items set the surroundings on fire." 
it.HottestSauce.sprite = Sprite.load("HottestSauce", path.."Hottest Sauce.png", 1, 11, 14)
it.HottestSauce:setTier("uncommon")
it.HottestSauce:setLog{
	group = "uncommon",
	description = "Activating use items &y&sets the surroundings on fire.",
	story = "The branding of this thing is pretty exaggerated, but don't let that trick you. This burns like hell, and I DO MEAN IT.",
	destination = "Home 3,\nApla,\nEarth",
	date = "12/02/2056"
}
callback.register("onUseItemUse", function(player, item)
	if not contains(specialUseItems, item) and item == player.useItem then
		local sauce = player:countItem(it.HottestSauce)
		
		if sauce > 0 then
			sHottestSauce:play()
			for i = -12, 12 do
				local xx = i * 12
				local fTrail = obj.FireTrail:create(player.x + xx, player.y - 20)
				fTrail:setAlarm(1, 60 * (1 + (3 * sauce)))
				fTrail:set("parent", player.id)
				fTrail:set("damage", player:get("damage") * 0.75)
			end
			local range = 200
			for _, actor in ipairs(pobj.actors:findAllEllipse(player.x - range, player.y - range, player.x + range, player.y + range)) do
				if actor:get("team") ~= player:get("team") then
					DOT.applyToActor(actor, DOT_FIRE, player:get("damage") * 0.65, 2 + (7 * sauce), "hottestSauce", false)
				end
			end
		end
	end
end)
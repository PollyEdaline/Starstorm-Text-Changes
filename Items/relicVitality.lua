local relicColor = Color.fromHex(0xC649AD)

local itRelicVitality = Item.new("Relic of Vitality")
local parRelicVitality = par.HealPixel
itRelicVitality.pickupText = "Strongly raise your health regeneration BUT subside your health." 
itRelicVitality.sprite = Sprite.load("RelicVitality", "Items/Resources/Relic of Vitality.png", 1, 12, 13)
itp.relic:add(itRelicVitality)
itRelicVitality.color = relicColor
itRelicVitality:setLog{
	group = "boss_locked",
	description = "&g&Strongly raise your health regeneration &p&BUT &r&subside your health.",
	story = "And so... I was remunerated with a choice: to heal all my wounds and become frail or to carve my own path as a lost survivor.",
	priority = "&b&Field-Found&!&",
	destination = "Unknown",
	date = "Unknown"
}
callback.register("onItemRemoval", function(player, item, amount)
	if item == itRelicVitality then
		for i = 1, amount do
			player:set("hp_regen", player:get("hp_regen") - 0.21)
			player:set("percent_hp", player:get("percent_hp") * 1.75)
		end
		if player:countItem(item) == 0 then
			player:set("hud_health_color", Color.fromHex(0x88D367).gml)
		end
	end
end)

local onPlayerStepCall = function(player)
	local relicVitality = player:countItem(itRelicVitality)
	if global.quality > 1 and relicVitality > 0 and math.chance(10) then
		parRelicVitality:burst("below", player.x, player.y - 3, 1, Color.fromRGB(116,203,146))
	end
end

itRelicVitality:addCallback("pickup", function(player)
	player:set("hp_regen", player:get("hp_regen") + 0.21)
	player:set("percent_hp", player:get("percent_hp") / 1.75)
	local color = Color.mix(Color.fromGML(player:get("hud_health_color")), Color.fromRGB(141, 204, 114), 0.5)
	player:set("hud_health_color", color.gml)
	tcallback.register("onPlayerStep", onPlayerStepCall)
end)
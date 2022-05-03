local path = "Items/Resources/"

it.AgelessTotem = Item.new("Ageless Totem")
local sAgelessTotem = Sound.load("AgelessTotem", path.."agelessTotem")
it.AgelessTotem.pickupText = "You embrace ethereality..." 
it.AgelessTotem.sprite = Sprite.load("AgelessTotem", path.."Ageless Totem.png", 2, 15, 15)
it.AgelessTotem.isUseItem = true
it.AgelessTotem.useCooldown = 25
it.AgelessTotem.color = "or"
itp.elite:add(it.AgelessTotem)
it.AgelessTotem:setLog{
	group = "use_locked",
	description = "&y&Become an aspect of ethereality.",
	story = "Just as words stop making sense the more you repeat them, time does. Reliving the same moment, over and over again. I thought I would lose my sanity, but all I felt was a slow, ethereal descent into what I now see as the true eternity.",
	priority = "&b&Field-Found&!&",
	destination = "Unknown",
	date = "Unknown"
}
table.insert(specialUseItems, it.AgelessTotem)
it.AgelessTotem:addCallback("use", function(player)
	local bomb = obj.etherealBomb:create(player.x, player.y)
	bomb:set("damage", 10 * player:get("damage"))
	bomb:getData().parent = player
	bomb:set("color", Color.fromHex(0x70AFAA).gml)
	bomb:set("team", player:get("team"))
end)
local postPlayerStepCall = function(player)
	local playerAc = player:getAccessor()
	local playerData = player:getData()
	if player.useItem == it.AgelessTotem or contains(playerData.mergedItems, it.AgelessTotem) then
		if not playerData.agelessTotemEf then
			if sAgelessTotem then 
				sAgelessTotem:play()
			end
			playerAc.ethereal = 1
			playerAc.percent_hp = playerAc.percent_hp + 1
			playerData.agelessTotemEf = true
		end
	elseif playerData.agelessTotemEf then
		playerData.agelessTotemEf = nil
		playerAc.ethereal = nil
		playerAc.percent_hp = playerAc.percent_hp - 1
		player.alpha = 1
	end
end
itp.use:remove(it.AgelessTotem)

it.AgelessTotem:addCallback("pickup", function(player)
	tcallback.register("postPlayerStep", postPlayerStepCall)
end)
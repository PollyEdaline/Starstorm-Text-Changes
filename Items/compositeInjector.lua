local path = "Items/Resources/"


it.CompositeInjector = Item.new("Composite Injector")
local sCompositeInjector = Sound.load("CompositeInjector", path.."compositeInjector")
it.CompositeInjector.pickupText = "Ability to merge a use item." 
it.CompositeInjector.sprite = Sprite.load("CompositeInjector", path.."Composite Injector.png", 1, 12, 14)
it.CompositeInjector:setTier("rare")
it.CompositeInjector:setLog{
	group = "rare_locked",
	description = "Ability to &y&merge a use item.",
	story = "Technology is getting weird, like seriously weird. There's some things you just can't do these days without one of these, so use it wisely and don't break it like all the other stuff I send you (sigh).\n\nOh, I almost forget! Remember to tell your uncle about the... you-know-what. He's naive but he has to know sooner or later.",
	destination = "Mimnat H3,\nOfeee St.,\nEarth",
	date = "02/02/2056"
}

callback.register("onItemPickup", function(item, player)
	local injector = player:countItem(it.CompositeInjector)
	if injector > 0 and item:getItem().isUseItem then
		player:getData().mergedItems = {}
	end
end)
local onDrawCall = function()
	for _, item in ipairs(pobj.items:findMatching("is_use", 1)) do
		if item:get("item_switch") == 1 then
			local itemObject = item:getItem()
			local player = obj.P:findNearest(item.x, item.y)
			if player and player:isValid() and player.useItem ~= itemObject then
				local injector = player:countItem(it.CompositeInjector)
				if injector > 0 and item:get("used") == 0 and #player:getData().mergedItems < injector and not contains(player:getData().mergedItems, itemObject) then
					local gamepad = input.getPlayerGamepad(player)
					local activate = player:control("enter")
					local actString = input.getControlString("enter", player)
					local fString = "Press &y&'"..actString.."'&!& to merge with the current use item"
					local fStringRaw = "Press '"..actString.."' to merge with the current use item"
					if gamepad then fString = fStringRaw end
					local strLen = graphics.textWidth(fStringRaw, 1)
					
					graphics.alpha(1)
					graphics.color(Color.WHITE)
					graphics.printColor(fString, item.x - (strLen * 0.5), item.y + 37)
					
					if activate == input.PRESSED then
						table.insert(player:getData().mergedItems, itemObject)
						item:set("used", 1)
						item:set("owner", player.id)
						if onScreen(item) then
							sCompositeInjector:play()
						end
					end
				end
			end
		end
	end
end
callback.register("onUseItemUse", function(player, item)
	if item == player.useItem then
		if player:countItem(it.CompositeInjector) > 0 and #player:getData().mergedItems > 0 then
			local cooldown = player.useItem.useCooldown
			for i, item in ipairs(player:getData().mergedItems) do
				if item ~= player.useItem then
					player:activateUseItem(true, item)
					local echelon = player:getData().echelonAdd or 0
					cooldown = cooldown + item.useCooldown + echelon
				else
					table.remove(player:getData().mergedItems, i)
				end
			end
			local finalCooldown = (cooldown / (#player:getData().mergedItems + 1))
			local mitosis = player:countItem(it.RapidMitosis)
			if mitosis > 0 then
				finalCooldown = (0.75 ^ mitosis) * (cooldown / (#player:getData().mergedItems + 1))
			end
			player:setAlarm(0, finalCooldown * 60)
		end
	end
end)
local onPlayerHUDDrawCall = function(player, x, y)
	if player:countItem(it.CompositeInjector) > 0 and misc.hud:get("show_skills") == 1 then
		local cItem = player.useItem
		
		if cItem and player:getAlarm(0) <= 0 then
			local xx = x + 107
			local yy = y + 6
			
			for i, item in ipairs(player:getData().mergedItems) do
				local yoffset = i * 8
				graphics.drawImage{
					image = item.sprite,
					subimage = 2,
					x = xx,
					y = yy - yoffset,
					alpha = 0.5
				}
			end
			
			graphics.drawImage{
				image = cItem.sprite,
				subimage = 2,
				x = xx,
				y = yy
			}
		end
	end
end

local onHitCall = function(damager, hit)
	local player = damager:getParent()
	if player and player:getData().mergedItems and contains(player:getData().mergedItems, it.DynamitePlunger) then
		local dynamite = obj.EfTNTStick:create(player.x, player.y)
		dynamite:set("parent", player.id)
	end
end

it.CompositeInjector:addCallback("pickup", function(player)
	if not player:getData().mergedItems then
		player:getData().mergedItems = {}
		tcallback.register("onHit", onHitCall)
		tcallback.register("onDraw", onDrawCall)
		tcallback.register("onPlayerHUDDraw", onPlayerHUDDrawCall)
	end
end)
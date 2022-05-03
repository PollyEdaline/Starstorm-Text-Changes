-- BOSS ITEM MANAGER

itp.legendary = ItemPool.new("Legendary")

callback.register("postLoad", function()
	for _, namespace in ipairs(namespaces) do
		for _, item in ipairs(Item.findAll(namespace)) do
			if item.color == "y" and item ~= it.DivineRight then
				itp.legendary:add(item)
			end
		end
	end
end)

obj.BossCrate = itp.legendary:getCrate()
obj.BossCrate.sprite = Sprite.load("LegendaryCrate", "Interactables/Resources/legendaryCrate", 1, 12, 16)

local monsterItemData = {}

local nothing = "Nothing"

local vanillaBossDrops = {
	[obj.WispB] = it.LegendarySpark,
	[obj.ImpG] = it.ImpOverlordsTentacle,
	[obj.ImpGS] = it.ImpOverlordsTentacle,
	[obj.Worm] = it.BurningWitness,
	[obj.WormHead] = it.BurningWitness,
	[obj.GolemG] = it.ColossalKnurl,
	[obj.Ifrit] = it.IfritsHorn,
	[obj.GiantJelly] = it.NematocystNozzle,
	[obj.Scavenger] = nothing,
	[obj.Turtle] = nothing,
	[obj.Boar] = nothing
}
local specialTypes = {
	[obj.Worm] = 1,
	[obj.WormHead] = 1,
	[obj.GiantJelly] = 1
}

function NPC.registerBossDrops(object, chance, type, ignoreCommand)
	
	monsterItemData[object] = {items = {}, type = type or 0, chance = chance or 15}
	
	local data = monsterItemData[object]
	
	object:addCallback("create", function(instance)
		local doBossDrop = ar.Eminence and ar.Eminence.active or math.chance(data.chance)
		if doBossDrop and #monsterItemData[instance:getObject()].items > 0 and net.host then
			instance:set("boss_drop_item", 0)
			if ar.Command.active and not ignoreCommand then
				local i = table.irandom(monsterItemData[instance:getObject()].items)
				if itp.sibylline and itp.sibylline:contains(i) then
					instance:getData()._ItemDrop = obj.sibyllineCrate
				else
					instance:getData()._ItemDrop = obj.BossCrate
				end
			else
				instance:getData()._ItemDrop = table.irandom(monsterItemData[instance:getObject()].items)
			end
		end
		instance:set("boss_drop_unique", 0)
	end)
end

function NPC.addBossItem(object, item)
	local data = monsterItemData[object]
	
	if data then
		table.insert(data.items, item)
	end
end

for boss, item in pairs(vanillaBossDrops) do
	local type = 0
	
	if specialTypes[boss] then
		type = specialTypes[boss]
	end
	
	NPC.registerBossDrops(boss, 15, type)
	if item ~= nothing then
		NPC.addBossItem(boss, item)
	end
end

onNPCDeath.itemdrop = function(npc, object)
	if npc:getData()._ItemDrop and net.host then
		local toDrop = npc:getData()._ItemDrop
		
		if monsterItemData[object] then
			if monsterItemData[object].type == 0 then
			
				toDrop:create(npc.x, npc.y - 5)
				
			elseif monsterItemData[object].type == 1 then
				
				local player = obj.P:findNearest(npc.x, npc.y)
				toDrop:create(player.x + 8, player.y - 10)

			end
		else
			local image = npc.mask or npc.sprite
			local ground = obj.B:findLine(npc.x, npc.y, npc.x, npc.y + image.height - image.yorigin + 1) or obj.B:findNearest(npc.x, npc.y)
			local groundL = ground.x - (ground.sprite.boundingBoxLeft * ground.xscale)
			local groundR = ground.x + (ground.sprite.boundingBoxRight * ground.xscale)
			local x = math.clamp(npc.x, groundL, groundR)
			toDrop:create(x, ground.y - 15)
		end
	end
end

table.insert(call.onStep, function()
	for _, worm in ipairs(obj.WormHead:findAll()) do
		local wormData = worm:getData()
		if not wormData._bossDropChecked then
			wormData._bossDropChecked = true
			local controller = Object.findInstance(worm:get("controller") or -4)
			if controller and controller:isValid() then
				worm:set("boss_drop_item", controller:get("boss_drop_item"))
				worm:set("boss_drop_unique", controller:get("boss_drop_unique"))
				wormData._ItemDrop = controller:getData()._ItemDrop
			end
		end
	end
end)

-- BOSS ITEM DISPLAY

table.insert(call.preHUDDraw, function()
	local hudBoss = Object.findInstance(misc.hud:get("boss_id"))
	if hudBoss and hudBoss:isValid() and misc.hud:get("show_boss") > 0 then
		local items = hudBoss:getData().items_Held
		if items then
			local i = 0
			local w, h = graphics.getHUDResolution()
			local mx, my = input.getMousePos(true)
			
			local ww = w / 2
			local count = 0
			for _, _ in pairs(items) do
				count = count + 1
			end
			
			local itemSize = 29
			local rowAmount = math.floor(w / itemSize)
			
			local itemHover = nil
			
			for item, a in pairs(items) do
			
				local row = math.floor((i / rowAmount))
				local ii = i - (row * rowAmount)
				
				i = i + 1
				
				local xOffset = ii * itemSize - ((itemSize / 2) * (math.min(rowAmount, count - (row * rowAmount)) - 1))
				
				local itemX = ww + xOffset
				local itemY = 64 + (itemSize * row)
				
				graphics.drawImage{
					image = item.sprite,
					x = itemX,
					y = itemY,
					scale = 1,
					alpha = 0.6
				}
				if a > 1 then
					graphics.color(Color.WHITE)
					graphics.alpha(0.75)
					graphics.print("x"..tostring(a), itemX, itemY + 8, 1, 1, 1)
				end
				
				if mx > itemX - 12 and mx < itemX + 12 and
				my > itemY - 12 and my < itemY + 12 then
					local xx = mx - 2
					local yy = my + 14
					itemHover = {item = item, x = xx, y = yy}
				end
			end
			if itemHover then
				local item, xx, yy = itemHover.item, itemHover.x, itemHover.y
				local c = item.color
				local str = item.displayName.."&!&\n"..item.pickupText
				local strw = math.max(graphics.textWidth(item.displayName, 1), graphics.textWidth(item.pickupText, 1))
				if isa(item.color, "Color") then
					c = tostring(c.gml)
				end
				str = "&"..c.."&"..str
				graphics.alpha(0.6)
				graphics.color(Color.BLACK)
				if mx > ww then xx = xx - strw end
				graphics.rectangle(xx, yy, xx + strw + 3, yy + 24, false)
				graphics.alpha(1)
				graphics.color(Color.WHITE)
				graphics.printColor(str, xx + 3, yy)
			end
		end
	end
end)
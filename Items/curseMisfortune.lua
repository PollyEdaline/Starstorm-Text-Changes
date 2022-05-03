local path = "Items/Resources/"

it.CurseMisfortune = Item.new("Curse of Misfortune")
it.CurseMisfortune.pickupText = "Downgrade nearby items."
it.CurseMisfortune.sprite = Sprite.load("CurseMisfortune", path.."Curse of Misfortune.png", 1, 15, 15)
itp.curse:add(it.CurseMisfortune)
it.CurseMisfortune.color = "dk"

local sprEf = Sprite.load("CurseMisfortuneEf", path.."misfortuneEf.png", 11, 15, 15)

callback.register("onItemRemoval", function(player, item, amount)
	if item == it.CurseMisfortune and player:countItem(it.CurseMisfortune) == 0 then
		local playerData = player:getData()
		local playerAc = player:getAccessor()
		if playerData.curseMisfortune then
			playerAc.hp_regen = playerAc.hp_regen + playerData.curseMisfortune
			playerData.curseMisfortune = nil
		end
	end	
end)

local r = 50

local effectFunc = setFunc(function(anim, depth)
	anim.sprite = sprEf
	anim.yscale = 1
	anim.depth = depth
end)

local onPlayerStepCall =  function(player)
	if net.host then
		local playerData = player:getData()
		local playerAc = player:getAccessor()
		local curseMisfortune = player:countItem(it.CurseMisfortune)
		if curseMisfortune > 0 then
			if ar.Command.active then
				for _, crate in ipairs(pobj.commandCrates:findAllEllipse(player.x - r, player.y - r, player.x + r, player.y + r)) do
					if not crate:getData().misfortune then
						local bcrate = crate:getObject()
						local toCreate
						local depth = crate.depth - 1
						local x, y = crate.x, crate.y
						if bcrate == obj.Artifact8Box3 then
							if curseMisfortune > 1 then
								toCreate = obj.Artifact8Box1
							else
								toCreate = obj.Artifact8Box2
							end
							syncDestroy(crate)
							crate:destroy()
						elseif bcrate == obj.Artifact8Box2 then
							toCreate = obj.Artifact8Box1
							syncDestroy(crate)
							crate:destroy()
						elseif bcrate == obj.BossCrate then
							if curseMisfortune > 1 then
								toCreate = obj.Artifact8Box1
							else
								toCreate = obj.Artifact8Box2
							end
							syncDestroy(crate)
							crate:destroy()
						end
						if toCreate then
							createSynced(obj.EfSparks, x, y, effectFunc, depth)
							local newCrate = toCreate:create(x, y)
							newCrate:getData().misfortune = true
						end
					end
				end
			else
				for _, item in ipairs(pobj.items:findAllEllipse(player.x - r, player.y - r, player.x + r, player.y + r)) do
					if not item:getData().misfortune then
						local bitem = item:getItem()
						local toCreate
						local depth = item.depth - 1
						local x, y = item.x, item.y
						if bitem.color == "r" then
							if curseMisfortune > 1 then
								toCreate = itp.common
							else
								toCreate = itp.uncommon
							end
							syncDestroy(item)
							item:destroy()
						elseif bitem.color == "g" then
							toCreate = itp.common
							syncDestroy(item)
							item:destroy()
						elseif bitem.color == "y" and bitem ~= it.DivineRight then
							if curseMisfortune > 1 then
								toCreate = itp.common
							else
								toCreate = itp.uncommon
							end
							syncDestroy(item)
							item:destroy()
						end
						if toCreate then
							createSynced(obj.EfSparks, x, y, effectFunc, depth)
							local newItem = toCreate:roll():create(x, y)
							newItem:getData().misfortune = true
						end
					end
				end
			end
		end
	end
end

it.CurseMisfortune:addCallback("pickup", function(player)
	tcallback.register("onPlayerStep", onPlayerStepCall)
end)
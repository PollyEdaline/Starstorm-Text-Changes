local path = "Items/Resources/"

it.PylonFragment = Item.new("Pylon Fragment")
local sPylonFragment = Sound.load("PylonFragment", path.."pylonFragment")
it.PylonFragment.pickupText = "Partially restore the Pylon (Single use)." 
it.PylonFragment.sprite = Sprite.load("PylonFragment", path.."Pylon Fragment.png", 2, 13, 14)
it.PylonFragment.isUseItem = true
it.PylonFragment.useCooldown = 20
it.PylonFragment.color = "or"
it.PylonFragment:addCallback("use", function(player, embryo)
	local playerAc = player:getAccessor()
	local pylon = obj.Pylon:find(1)
	
	if pylon and pylon:isValid() then
		local mult = 1
		if embryo then mult = 2 end
		local healVal = pylon:get("maxhp") * 0.1 * mult
		pylon:set("hp", pylon:get("hp") + healVal)
		pylon:set("lasthp", pylon:get("lasthp") + healVal)
		local flash = obj.EfFlash:create(0,0):set("parent", pylon.id):set("rate", 0.08)
		flash.blendColor = Color.GREEN
	end
	
	sPylonFragment:play()
	if player.useItem == it.PylonFragment then
		player.useItem = nil
	elseif contains(player:getData().mergedItems, it.PylonFragment) then
		local index
		for i, item in ipairs(player:getData().mergedItems) do
			if item == it.PylonFragment then
				index = i
				break
			end
		end
		if index then
			table.remove(player:getData().mergedItems, index)
		end
	end
end)

callback.register("onItemRoll", function(pool, item)
	if pool == itp.use then
		if Stage.getCurrentStage() == stg.RedPlane then
			return it.PylonFragment
		end
	end
end)

local lastStage = nil
table.insert(call.onStageEntry, function()
	local stage = Stage.getCurrentStage()
	if lastStage and not contains(getRule(1, 23), it.PylonFragment) then
		if stage == stg.RedPlane then
			itp.use:add(it.PylonFragment)
		elseif lastStage == stg.RedPlane then
			itp.use:remove(it.PylonFragment)
		end
	end
	lastStage = stage
end)
local path = "Items/Resources/"

it.BeatingHeart = Item.new("Beating Heart")
it.BeatingHeart.pickupText = "Alive as long as a fragment remains..." 
it.BeatingHeart.sprite = Sprite.load("Beating Heart", path.."Beating Heart.png", 1, 15, 15)
spr.BeatingHeartUsed = Sprite.load("Beating Heart Used", path.."Beating Heart Used.png", 1, 15, 15)
itp.legendary:add(it.BeatingHeart)
it.BeatingHeart.color = "y"
it.BeatingHeart:setLog{
	group = "boss",
	description = "&y&Opportunity to reanimate after death.",
	story = "My frail body was once more dependant. Not of a shield or any kind of armor, but a beating heart; to keep going, to have one last breath and reach the end.\nTo this time, I do not know if I made it out alive for my body was once more dependant.",
	priority = "&b&Field-Found&!&",
	destination = "#33,\nGate B,\nUES Delta",
	date = "Unknown"
}
if obj.Eye then
	NPC.registerBossDrops(obj.Eye)
	NPC.addBossItem(obj.Eye, it.BeatingHeart)
end

local sBeatingHeart = Sound.load("BeatingHeart", path.."beatingHeart")

local efColor = Color.fromHex(0xE15F63)

local stageBlacklist

callback.register("onLoad", function()
	stageBlacklist = {
		[stg.RedPlane] = true,
		[stg.Unknown] = true 
	}
end)

local onStepCall = function()
	if not stageBlacklist[Stage.getCurrentStage()] then
		if not runData.bhtimer then
			local heart = false
			local deadList = {}
			local players = obj.P:findAll()
			for _, player in ipairs(players) do
				--if player:get("activity") ~= 99 then
					local useCount = player:getData().beatingHeartUsed or 0
					local itemCount = player:countItem(it.BeatingHeart)
					if not heart and itemCount > useCount then
						heart = true
					end
					if player:get("dead") == 1 then
						table.insert(deadList, player)
					end
				--end
			end
			--print(#deadList, #players)
			
			if heart and #deadList == #players then
				runData.bhtimer = 0
				sBeatingHeart:play()
			end
		else
			for _, player in ipairs(obj.EfPlayerDead:findAll()) do
				player:set("post_game", 0)
				player:set("show_post_game", 0)
				player:set("death_message", "Alive as long as a fragment remains..." )
			end
			if runData.bhtimer < 240 then
				runData.bhtimer = runData.bhtimer + 1
			else
				for _, player in ipairs(obj.P:findAll()) do
					player.mask = spr.PMask
				end
				if net.host then
					Stage.transport(stg.RedPlane)
				end
				runData.bhtimer = nil
			end
		end
	else
		runData.bhtimer = nil
	end
end

it.BeatingHeart:addCallback("pickup", function(player)
	player:setItemSprite(it.BeatingHeart, it.BeatingHeart.sprite)
	tcallback.register("onStep", onStepCall)
end)

table.insert(call.preHUDDraw, function()
	if runData.bhtimer then
		local w, h = graphics.getGameResolution()
		graphics.alpha((runData.bhtimer - 140) * 0.01)
		graphics.color(efColor)
		graphics.rectangle(0, 0, w, h, false)
	end
end)
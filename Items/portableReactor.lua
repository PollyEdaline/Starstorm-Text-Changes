local path = "Items/Resources/"

it.PortableReactor = Item.new("Portable Reactor")
local sPortableReactor = Sound.load("PortableReactor", path.."portableReactor")
it.PortableReactor.pickupText = "Become temporarily invincible after entering a stage." 
it.PortableReactor.sprite = Sprite.load(path.."Portable Reactor.png", 1, 15, 15)
local sEf = Sprite.load(path.."portableReactordis.png", 10, 15, 15)
it.PortableReactor:setTier("rare")
it.PortableReactor:setLog{
	group = "rare",
	description = "Become &b&invincible for 40 seconds&!& after entering a stage.",
	story = "Hey buddy, this should fix your engine problem for the time being. It's a little banged up, but it does the trick marvelously! Uhh, I forgot if I sent the manual but you know the drill: hook it up, fuse the core and voila. I think that was all, maybe I'm wrong. I really hope not but mail me if so.",
	destination = "Floor 1,\nR&C co.,\nEarth",
	date = "07/25/2056"
}
table.insert(call.onStageEntry, function()
	for _, player in ipairs(misc.players) do
		local count = player:countItem(it.PortableReactor)
		if count > 0 then
			local timer = 60 * (25 + (15 * math.min(count, 8)))
			player:getData().pReactorField = timer --1200 + 1200 * math.min(count, 8)
		end
	end
end)

local onPlayerStepCall = function(player)
	local playerData = player:getData()
	
	if playerData.pReactorField then
		if playerData.pReactorField > 0 then
			playerData.pReactorField = playerData.pReactorField - 1
			player:set("invincible", 9000)
			if not sPortableReactor:isPlaying() and player.visible then
				sPortableReactor:loop()
			end
		else
			playerData.pReactorField = nil
			player:set("invincible", 0)
			if sPortableReactor:isPlaying() then
				sPortableReactor:stop()
			end
		end
	end
end

local onPlayerDrawAboveCall = function(player)
	local playerData = player:getData()
	if playerData.pReactorField then
		graphics.drawImage{
			image = sEf,
			x = player.x,
			y = player.y,
			subimage = ((global.timer * 0.2) % 10) + 1,
			scale = player.yscale,
			alpha = player.alpha,
		}
	end
end

it.PortableReactor:addCallback("pickup", function(player)
	tcallback.register("onPlayerStep", onPlayerStepCall)
	tcallback.register("onPlayerDrawAbove", onPlayerDrawAboveCall)
end)
local path = "Items/Resources/"

it.SwiftSkateboard = Item.new("Swift Skateboard")
it.SwiftSkateboard.pickupText = "Attack while moving." 
it.SwiftSkateboard.sprite = Sprite.load("SwiftSkateboard", path.."Swift Skateboard.png", 1, 16, 16)
local pMaskSkate = Sprite.clone(spr.PMask, "SwiftSkateboardMask", spr.PMask.xorigin, spr.PMask.yorigin - 1)
local sprSwiftSkateDis = Sprite.load("SwiftSkateboardDis", path.."swiftSkateDis.png", 2, 4, 0)
it.SwiftSkateboard:setTier("rare")
it.SwiftSkateboard:setLog{
	group = "rare_locked",
	description = "&b&Attack while moving.",
	story = "Good day Sir Morse, This month's GOLDEN reward is the Rudolph D30 Skateboard Replica.\nEnjoy your freebie!\nDescription: In the last Century the D30s were widely praised as the peak in performance for the D series, particularly after the professional skateboarder Hobbert used one at Sydney's Skate Championship and won at first place.",
	destination = "221,\nHill Hills,\nEarth",
	date = "01/03/2056"
}
callback.register("onItemRemoval", function(player, item, amount)
	if item == it.SwiftSkateboard then
		player:set("swiftSkateboard", player:get("swiftSkateboard") - amount)
		if amount >= player:countItem(item) then
			player.mask = spr.PMask
		end
	end
end)

local onPlayerDrawAboveCall = function(player)
    local stack = player:countItem(it.SwiftSkateboard)
    
	if stack > 0 and player:get("activity") ~= 30 then
		local subimage = 1
		if player:get("free") == 1 then subimage = 2 end
		graphics.drawImage{
			image = sprSwiftSkateDis,
			x = player.x,
			y = player.y + 4,
			xscale = player.xscale,
			subimage = subimage
		}
	end
end

table.insert(call.postStep, function()
    for _, actor in ipairs(pobj.actors:findAll()) do
        
        local skateboard = actor:get("swiftSkateboard")
        
        if skateboard and skateboard > 0 then
            local activity = actor:get("activity")
			local isPlayer = isa(actor, "PlayerInstance") 
			
			if isPlayer then
				if activity == 30 and actor:getData().swiftSkateMasked then
					actor.mask = spr.PMask
					actor:getData().swiftSkateMasked = false
				elseif activity ~= 30 and not actor:getData().swiftSkateMasked then
					actor.mask = pMaskSkate
					actor:getData().swiftSkateMasked = true
				end
			end
			
            if activity > 0 and activity < 5 then
                local speed = actor:get("pHmax") * math.min((0.7 * skateboard) + 0.3, 3.8)
                local direction = 0
                
                if actor:get("moveRight") == 1 then
                    direction = 1
                elseif actor:get("moveLeft") == 1 then
                    direction = -1
                end
				
				if actor:hasBuff(buff.daze) then
					direction = direction * -1
				end
				
				for i = 1, speed * 10 do
					if not actor:collidesMap(actor.x + 0.1 * direction, actor.y) then
						 actor.x = actor.x + 0.1 * direction
					else
						break
					end
				end				
				
                --if not actor:collidesMap(actor.x + speed * direction, actor.y) then
                    --actor.x = actor.x + speed * direction
                --end
            end
            if activity == 0 and actor:get("free") == 0 then
                actor.sprite = actor:getAnimation("idle")
				if isPlayer then -- ew edge case
					if actor:getSurvivor() == sur.HAND or actor:getSurvivor() == sur.Huntress then
						local skin = SurvivorVariant.getActive(actor)
						if skin then
							if actor.sprite == spr.JanitorIdle then
								actor:setAnimation("idle", skin.animations.idle)
							elseif actor.sprite == spr.JanitorIdleHot then
								actor:setAnimation("idle", skin.animations.idlehot)
							elseif actor.sprite == spr.Huntress1Idle then
								actor:setAnimation("idle", skin.animations.idle)
								actor.sprite = skin.animations.idle
							end
						end
					end
				end
            end
        end
    end
end)

it.SwiftSkateboard:addCallback("pickup", function(player)
	player:set("swiftSkateboard", (player:get("swiftSkateboard") or 0) + 1)
	player.mask = pMaskSkate
	player:getData().swiftSkateMasked = true
	tcallback.register("onPlayerDrawAbove", onPlayerDrawAboveCall)
end)

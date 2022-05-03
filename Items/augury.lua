local path = "Items/Resources/"

it.Augury = Item.new("Augury")
local sAugury = Sound.load("Augury", path.."augury")
it.Augury.pickupText = "Something speaks to me." 
it.Augury.sprite = Sprite.load("Augury", path.."Augury.png", 1, 14, 13)
itp.sibylline:add(it.Augury)
it.Augury.color = Color.fromHex(0xFFCCED)
it.Augury:setLog{
	group = "end",
	description = "Taking damage charges a &y&hidden power.",
	story = "A voice began to whisper my name, over and over again. It also told me about them.\nI don't think it was a warning, it was a presage.",
	priority = "&"..it.Augury.color.gml.."&Unknown",
	destination = "",
	date = "Unknown"
}
callback.register("onItemRemoval", function(player, item, amount)
	if item == it.Augury then
		if amount >= player:countItem(it.Augury) then
			player:getData().augury = nil
		end
	end
end)
local auguryMult = 6
local onHitCall = function(damager, hit, x, y)
	local damagerAc = damager:getAccessor()
	
	local parent = damager:getParent()
	
	if hit:getData().augury then
		local damage = damagerAc.damage
		
		hit:getData().augury = math.min(hit:getData().augury + damage, hit:get("maxhp") * auguryMult)
	end
end
local auguryBlacklist = {
	[obj.WurmBody] = true,
	[obj.WurmController] = true,
	[obj.WurmHead] = true
}
if obj.Arraign1 then
	auguryBlacklist[obj.Arraign1] = true
	auguryBlacklist[obj.Arraign2] = true
end
local onPlayerStepCall = function(player)
	if player:getData().augury then
		local augury = player:getData().augury
		
		if player:getData().auguryCooldown then
			if player:getData().auguryCooldown > 0 then
				player:getData().auguryCooldown = player:getData().auguryCooldown - 1
			else
				player:getData().auguryCooldown = nil
			end
		else
			if augury >= player:get("maxhp") * auguryMult then
				player:getData().augury = 0
				player:getData().auguryCharge = 100
				misc.setTimeStop(100)
			end
		end
		
		if player:getData().auguryCharge then
			if player:getData().auguryCharge > 0 then
				player:getData().auguryCharge = player:getData().auguryCharge - 1
			else
				misc.shakeScreen(10)
				sAugury:play()
				local flash = obj.WhiteFlash:create(0, 0)
				flash.blendColor = Color.BLACK
				flash.alpha = 0.5
				flash:set("rate", 0.006)
				for _, actor in ipairs(pobj.actors:findAll()) do
					local actorObj = actor:getObject()
					if actor:get("team") ~= player:get("team") and not auguryBlacklist[actorObj] and not actor:getData().isNemesis then
						if onScreen(actor) and global.quality > 1 then
							local sprite = actor.sprite or spr.Nothing
							for i = 0, 10 do
								local xx = math.random(actor.x - sprite.xorigin + sprite.boundingBoxLeft, actor.x - sprite.xorigin + sprite.boundingBoxRight)
								local yy = math.random(actor.y - sprite.yorigin + sprite.boundingBoxTop, actor.y - sprite.yorigin + sprite.boundingBoxBottom)
								par.Dust2:burst("above", xx, yy, 1, Color.BLACK)
								par.TempleSnow:burst("above", xx, yy, 1, Color.BLACK)
							end
						end
						actor.blendColor = Color.BLACK
						actor:kill()
					end
				end
				misc.director:set("points", 0)
				misc.director:setAlarm(1, 200)
				player:getData().auguryCooldown = 30 * 60
				player:getData().auguryCharge = nil
			end
		end
	end
end
local onDrawCall = function(player)
	for _, player in ipairs(misc.players) do
		if player:get("dead") == 0 then
			if player:getData().augury then
				local augury = player:getData().augury
				
				local percent = augury / (player:get("maxhp") * auguryMult)
				
				graphics.color(Color.BLACK)
				graphics.setBlendModeAdvanced("sourceAlphaSaturation", "destColourInv")
				graphics.alpha(1)
				graphics.circle(player.x, player.y, 30 * percent, false)
				
				if player:getData().auguryCharge then
					local charge = player:getData().auguryCharge
					graphics.alpha((100 - charge) / 100)
					graphics.setBlendModeAdvanced("destAlphaInv", "sourceColour")
					graphics.circle(player.x, player.y, (100 - charge) * 20, false)
				end
				
				graphics.setBlendMode("normal")
				
				for _, pplayer in ipairs(misc.players) do
					if pplayer.visible then
						if player:getData().auguryCharge or player == pplayer and percent > 0.2 then
							graphics.drawImage{
								image = pplayer.sprite,
								angle = pplayer.angle,
								alpha = pplayer.alpha,
								color = pplayer.blendColor,
								x = pplayer.x,
								y = pplayer.y,
								xscale = pplayer.xscale,
								yscale = pplayer.yscale,
								subimage = pplayer.subimage
							}
						end
					end
				end
			end
		end
	end
end
if obj.NemesisEnforcer then
	NPC.registerBossDrops(obj.NemesisEnforcer, 100)
	NPC.addBossItem(obj.NemesisEnforcer, it.Augury)
end
callback.register("onItemPickup", function(item, player)
	if item:getItem() == it.Augury then
		if not player:getData().augury then
			player:getData().augury = 0
		end
		
		local name = ""
		if net.online then
			name = player:get("user_name")
		else
			name = player:get("name")
		end
		item:set("text2", "They are coming, "..name.."...")
		
		tcallback.register("onPlayerStep", onPlayerStepCall)
		tcallback.register("onDraw", onDrawCall)
		tcallback.register("onHit", onHitCall)
	end
end)
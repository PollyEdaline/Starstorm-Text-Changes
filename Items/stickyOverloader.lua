local path = "Items/Resources/"

it.StickyBattery = Item.new("Sticky Overloader")
--local sStickyBattery = Sound.load("StickyBattery", path.."")
it.StickyBattery.pickupText = "Attacking a foe builds up damage. Stop attacking to unleash."
it.StickyBattery.sprite = Sprite.load("StickyOverloader", path.."Sticky Overloader.png", 1, 16, 15)
it.StickyBattery:setTier("uncommon")
it.StickyBattery:setLog{
	group = "uncommon_locked",
	description = "&y&Attacking a foe charges damage by 32%, up to 800%.&!& Stop attacking to &y&unleash the damage&!&.",
	story = "So you're telling me they took a literal BOMB and reengineered it into a throwable BATTERY?\nHow do these things relate??? I'm not even going to try and use it, you can't just use a battery like that, it's asking for chaos.\nI don't blame them, they're jerks, but [REDACTED], really? It's widely known that contact energy transfers NEED to be stable for them to fundamentally WORK.\nIf this is considered, stable then call me a pig and watch me fly.",
	destination = "Amber's,\nDesean Lake,\nVenus",
	date = "06/07/2056"
}
callback.register("onItemRemoval", function(player, item, amount)
	if item == it.StickyBattery then
		player:set("sticky2", player:get("sticky2") - 1)
	end
end)

local objBigSticky = Object.new("BigSticky")
objBigSticky.sprite = Sprite.load("StickyBatteryEf", path.."stickyBatteryEf.png", 2, 9, 9)
objBigSticky.depth = -9
objBigSticky:addCallback("create", function(self)
	local data = self:getData()
	data.timer = 60
	data.damage = 10
	data.team = "player"
	data.x = 0
	data.y = 0
	data.scale = 0.1
	self.spriteSpeed = 0.2
	sfx.SpiderHit:play(2, 0.8)
end)
objBigSticky:addCallback("step", function(self)
	local data = self:getData()
	if data.timer > 0 then
		data.timer = data.timer - 1
		self.xscale = data.scale
		self.yscale = data.scale
		if data.parent and data.parent:isValid() then
			self.x = data.parent.x + data.x
			self.y = data.parent.y + data.y
		else
			self:delete()
		end
	else
		self:destroy()
	end
end)
objBigSticky:addCallback("destroy", function(self)
	local data = self:getData()
	if data.parent and data.parent:isValid() and data.master and data.master:isValid() then
		data.parent:getData()["stickyBatteryInst"..data.master.id] = nil
	end
	misc.fireExplosion(self.x, self.y, 10 / 19, 10 / 4, data.damage * data.scale, data.team, spr.EfExplosive)
	if data.scale >= 0.2 then
		sfx.MinerShoot4:play(1)
	else
		sfx.MinerShoot4:play(1.5)
	end
	if data.scale >= 1 then
		sfx.MinerShoot2:play(0.75)
	end
end)

table.insert(call.onHit, function(damager, hit, x, y)
	local parent = damager:getParent()
	
	if parent and parent:isValid() and parent:get("sticky2") then 
		local parentAc = parent:getAccessor()
		
		local sticky = parent:get("sticky2")
		if sticky and sticky > 0 then
			if hit:getData()["stickyBatteryInst"..parent.id] then
				local stickyl = hit:getData()["stickyBatteryInst"..parent.id]
				local stickyData = stickyl:getData()
				stickyData.timer = 1 * 60
				if stickyData.scale < 1 then --sticky then
					local add = 0.02 + 0.02 * sticky--math.min(damager:get("damage") / parentAc.damage, 1) * 0.25
					stickyData.scale = stickyData.scale + add
					obj.EfFlash:create(0,0):set("parent", stickyl.id):set("rate", 0.1):set("depth", stickyl.depth - 1).blendColor = Color.WHITE
				end
			else
				local image = hit.mask or hit.sprite
				local lbound, rbound, tbound, bbound = image.boundingBoxLeft, image.boundingBoxRight, image.boundingBoxTop, image.boundingBoxBottom
				local stickyI = objBigSticky:create(hit.x, hit.y)
				local stickyData = stickyI:getData()
				stickyData.timer = 1 * 60
				stickyData.damage = parentAc.damage * 8
				stickyData.team = parentAc.team
				stickyData.x = math.random(lbound - image.xorigin, rbound - image.xorigin)
				stickyData.y = math.random(bbound - image.yorigin, tbound - image.yorigin)
				stickyData.scale = 0.09 + 0.01 * sticky
				stickyData.parent = hit
				stickyData.master = parent
				hit:getData()["stickyBatteryInst"..parent.id] = stickyI
			end
		end
	end
end)

it.StickyBattery:addCallback("pickup", function(player)
	player:set("sticky2", (player:get("sticky2") or 0) + 1)
	--tcallback.register("onHit", onHitCall)
end)

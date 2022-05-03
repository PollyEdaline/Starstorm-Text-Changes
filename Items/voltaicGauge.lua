local path = "Items/Resources/"

it.MagneticGauge = Item.new("Voltaic Gauge")
it.MagneticGauge.pickupText = "Killing elites creates orbs of temporary shield." 
it.MagneticGauge.sprite = Sprite.load("GaugeMagnetic", path.."Voltaic Gauge.png", 1, 13, 12)
it.MagneticGauge:setTier("uncommon")
it.MagneticGauge:setLog{
	group = "uncommon",
	description = "Killing elites &y&generates orbs&!& that &y&grant a temporary shield on pickup.",
	story = "Hola primo.\nThe 30th is gaming night, you probably should practice more so we don't leave you behind during the boss fight.\nIf anything this could help you out. I'll send an overclocker the next week so your system doesn't hold you back lol.",
	destination = "Tebas 3,\nTriple G,\nEarth",
	date = "08/04/2056"
}
obj.mgOrb = Object.new("MgOrb")
obj.mgOrb.sprite = spr.EfExp2
obj.mgOrb:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	
	self.spriteSpeed = 0.18
	self.blendColor = Color.fromHex(0x5bc282)
	
	selfAc.pVspeed = 0
	selfAc.target = -4
	selfAc.value = 10
	selfAc.range = 80
	self:getData().life = 600
end)
obj.mgOrb:addCallback("step", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	
	local selfDestroy = false
	
	if not self:collidesMap(self.x, self.y + 5) then
		selfAc.pVspeed = math.min(selfAc.pVspeed + 0.09, 4)
	elseif selfAc.pVspeed > 0 then
		selfAc.pVspeed = 0
	end
	
	self.y = self.y + selfAc.pVspeed
	
	local targetInstance = Object.findInstance(selfAc.target)
	
	if not targetInstance or not targetInstance:isValid() then
		local range = selfAc.range
		local nearPlayer = obj.P:findEllipse(self.x - range, self.y - range, self.x + range, self.y + range)
		
		if nearPlayer then
			local target = nearestMatchingOp(self, obj.P, "dead", "==", 0)
			if target then
				selfAc.target = target.id
			end
		end
	else
		local xdif = self.x - targetInstance.x
		local ydif = self.y - targetInstance.y
		
		self.x = math.approach(self.x, targetInstance.x, xdif * 0.14)
		self.y = math.approach(self.y, targetInstance.y, ydif * 0.14)
		
		if self:collidesWith(targetInstance, self.x, self.y) then
			local targetInstanceData = targetInstance:getData()
			targetInstanceData.tempShield = (targetInstanceData.tempShield or 0) + selfAc.value
			local sparks = obj.EfSparks:create(self.x, self.y)
			sparks.sprite = spr.EfExpDeath
			sfx.Shield:play(2.5, 0.7)
			selfDestroy = true
		end
	end
	
	if selfData.life > 0 then
		selfData.life = selfData.life - 1
		if selfData.life < 100 then
			self.alpha =  selfData.life / 100
		end
	else
		selfDestroy = true
	end
	
	if selfDestroy then
		self:destroy()
	end
end)

local onNPCDeathProcCall = function(npc, player)
	if npc:get("prefix_type") and npc:get("prefix_type") == 1 then
		local magneticGauge = player:countItem(it.MagneticGauge)
		if magneticGauge > 0 then
			local orb = obj.mgOrb:create(npc.x, npc.y)
			local mult = 1
			if ar.Glass.active then mult = 0.5 end
			orb:set("value", math.ceil(((10 * magneticGauge) + 5) * mult))
		end
	end
end

it.MagneticGauge:addCallback("pickup", function(player)
	tcallback.register("onNPCDeathProc", onNPCDeathProcCall)
end)
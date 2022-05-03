local path = "Items/Resources/"


it.CrowningValiance = Item.new("Crowning Valiance")
local sCrownValiance = Sound.load("CrowningValiance", path.."crowningValiance")
objCrownValiance = Object.new("CrowningValianceDisplay")
objCrownValiance.sprite = Sprite.load("CrowningValianceDisplay", path.."crowningValiancedis.png", 2, 4, 4)
it.CrowningValiance.pickupText = "Increases all stats when fighting bosses." 
it.CrowningValiance.sprite = Sprite.load("CrowningValiance", path.."Crowning Valiance.png", 1, 11, 11)
it.CrowningValiance:setTier("uncommon")
it.CrowningValiance:setLog{
	group = "uncommon_locked",
	description = "&y&All stats are increased&!& when a boss is nearby.",
	story = "Remarkable object recovered from tomb #24. It is engraved in a foreign language and seems to have carried a meaning of bravery or heroism. There are no signs of it being used for any functional purpose. Could have been merely for identification, although our devices display a dense flux of energy from within. Please confirm and fully detail the results before the deadline.",
	destination = "Yoss H1,\nSml,\nSaturn",
	date = "07/17/2056"
}
objCrownValiance:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	local parent = self:getData().parent
	self:getData().active = false
	self:getData().boss = nil
	self:getData().xx = {}
	self:getData().yy = {}
	self.spriteSpeed = 0
	self.subimage = 1
	if parent ~= nil and parent:isValid() then
		selfAc.xx = parent.x
		selfAc.yy = parent.y
	end
end)
objCrownValiance:addCallback("step", function(self)
	local selfAc = self:getAccessor()
	local parent = self:getData().parent
	if parent ~= nil and parent:isValid() then
		if parent:getFacingDirection() == 180 then
			self.xscale = -1
		else
			self.xscale = 1
		end
		if self:getData().xx[2] ~= nil then
			self.x = self:getData().xx[2]
			self.y = self:getData().yy[2]
		end
		self:getData().xx[6] = self:getData().xx[5]
		self:getData().yy[6] = self:getData().yy[5]
		self:getData().xx[5] = self:getData().xx[4]
		self:getData().yy[5] = self:getData().yy[4]
		self:getData().xx[4] = self:getData().xx[3]
		self:getData().yy[4] = self:getData().yy[3]
		self:getData().xx[3] = self:getData().xx[2]
		self:getData().yy[3] = self:getData().yy[2]
		self:getData().xx[2] = self:getData().xx[1]
		self:getData().yy[2] = self:getData().yy[1]
		self:getData().xx[1] = parent.x + 20
		self:getData().yy[1] = parent.y + math.sin(misc.director:getAlarm(0) * 0.1)
	else
		self:destroy()
	end
end)
objCrownValiance:addCallback("draw", function(self)
	local selfAc = self:getAccessor()
	local parent = self:getData().parent
	local active = false
	if parent and parent:getData().bossBuff and parent:get("dead") == 0 then
		active = true
		graphics.color(Color.WHITE)
		graphics.line(parent.x, parent.y, self.x, self.y)
		self.subimage = 2
	else
		self.subimage = 1
	end
	if self:getData().xx[6] ~= nil then
		local xx = self:getData().xx[6]
		local yy = self:getData().yy[6]
		graphics.color(Color.fromRGB(102, 88, 99))
		graphics.line(xx, yy + 4, self.x - 3, self.y - 1, 1)
		graphics.line(xx, yy + 4, self.x + 3, self.y - 1, 1)
	end
end)

local onPlayerStepCall = function(player)
	local playerData = player:getData()
	local playerAc = player:getAccessor()
	
	-- Crowning Valiance
	local crownValiance = player:countItem(it.CrowningValiance)
	if crownValiance > 0 then
		if not playerData.crownValiance or not playerData.crownValiance:isValid() then
			local display = objCrownValiance:create(player.x, player.y)
			display:getData().parent = player
			playerData.crownValiance = display
		end
		local active = false
		for _, enemy in ipairs(pobj.enemies:findAllEllipse(player.x - 800, player.y - 800, player.x + 800, player.y + 800)) do
			if enemy:isBoss() then
				active = true
				break
			end
		end
		if active then
			playerData.bossBuff = true
		else
			playerData.bossBuff = false
		end
		if playerData.bossBuff and not playerData.bossBuffApplied then
			playerData.crownVal = {maxhp_base = 30 * crownValiance, hp_regen = 0.001 * crownValiance,
			damage = 2 * crownValiance, armor = 5 * crownValiance, critical_chance = 4 * crownValiance,
			pHmax = 0.13 * crownValiance, pVmax = 0.08 * crownValiance, attack_speed = 0.1 * crownValiance}
			
			playerAc.maxhp_base = playerAc.maxhp_base + playerData.crownVal.maxhp_base
			playerAc.hp_regen = playerAc.hp_regen + playerData.crownVal.hp_regen
			playerAc.attack_speed = playerAc.attack_speed + playerData.crownVal.attack_speed
			playerAc.damage = playerAc.damage + playerData.crownVal.damage
			playerAc.armor = playerAc.armor + playerData.crownVal.armor
			playerAc.critical_chance = playerAc.critical_chance + playerData.crownVal.critical_chance
			playerAc.pHmax = playerAc.pHmax + playerData.crownVal.pHmax
			playerAc.pVmax = playerAc.pVmax + playerData.crownVal.pVmax
			playerData.bossBuffApplied = true
			sCrownValiance:play(0.9 + math.random() * 0.2)
			
		elseif not playerData.bossBuff and playerData.bossBuffApplied then
			playerAc.maxhp_base = playerAc.maxhp_base - playerData.crownVal.maxhp_base
			playerAc.hp_regen = playerAc.hp_regen - playerData.crownVal.hp_regen
			playerAc.attack_speed = playerAc.attack_speed - playerData.crownVal.attack_speed
			playerAc.damage = playerAc.damage - playerData.crownVal.damage
			playerAc.armor = playerAc.armor - playerData.crownVal.armor
			playerAc.critical_chance = playerAc.critical_chance - playerData.crownVal.critical_chance
			playerAc.pHmax = playerAc.pHmax - playerData.crownVal.pHmax
			playerAc.pVmax = playerAc.pVmax - playerData.crownVal.pVmax
			playerData.bossBuffApplied = false
		end
	end
end

it.CrowningValiance:addCallback("pickup", function(player)
	tcallback.register("onPlayerStep", onPlayerStepCall)
end)
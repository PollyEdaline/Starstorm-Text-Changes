local relicColor = Color.fromHex(0xC649AD)

local itRelicForce = Item.new("Relic of Force") 
itRelicForce.pickupText = "All skills deal an extra attack, BUT cooldowns are longer." 
itRelicForce.sprite = Sprite.load("RelicForce", "Items/Resources/Relic of Force.png", 1, 14, 14)
itp.relic:add(itRelicForce)
itRelicForce.color = relicColor
itRelicForce:setLog{
	group = "end",
	description = "&y&All skills deal an extra attack for 100% damage, &p&BUT &r&cooldown durations are increased by 40%.",
	story = "Nothing in life is free. This strange object glows with a power I can only harness with concentration. I can become vigorous, unstoppable, but I will never be the same again. I lost something and I can't recall what it was.. Once again, nothing in life was free.",
	priority = "&b&Field-Found&!&",
	destination = "Unknown",
	date = "Unknown"
}
itRelicForce:addCallback("pickup", function(player)
	player:set("cdr", player:get("cdr") - 0.4)
end)
callback.register("onItemRemoval", function(player, item, amount)
	if item == itRelicForce then
		player:set("cdr", player:get("cdr") + 0.4 * amount)
	end
end)

local hitSprite = Sprite.load("RelicForceHit", "Items/Resources/RelicForceHit.png", 5, 10, 10)
local hitSound = Sound.load("RelicForce", "Items/Resources/relicForce")

local objForceAttack = Object.new("ForceAttack")
objForceAttack:addCallback("create", function(self)
	local selfData = self:getData()
	selfData.team = "player"
	selfData.damage = 20
	selfData.life = 50
	selfData.rand = math.random(360)
end)
objForceAttack:addCallback("step", function(self)
	local selfData = self:getData()
	if selfData.life > 0 then
		selfData.life = selfData.life - 1
		if selfData.life == 10 then
			local nearestEnemy = nearestMatchingOp(self, pobj.actors, "team", "~=", selfData.team)
			if nearestEnemy and distance(self.x, self.y, nearestEnemy.x, nearestEnemy.y) <= 250 then
				local angle = posToAngle(self.x, self.y, nearestEnemy.x, nearestEnemy.y)
				if onScreen(self) then
					misc.shakeScreen(1)
				end
				hitSound:play(0.9 + math.random() * 0.2, 0.8)
				local bullet = misc.fireBullet(self.x, self.y, angle, 250, selfData.damage, selfData.team, hitSprite)
				addBulletTrailLine(bullet, relicColor, 1.5, 50, false, false)
				if math.chance(selfData.critical) then
					bullet:set("damage", selfData.damage * 2)
					bullet:set("damage_fake", bullet:get("damage_fake") * 2)
					bullet:set("critical", 1)
				end
			end
		end
	else
		self:destroy()
	end
end)
objForceAttack:addCallback("draw", function(self)
	local selfData = self:getData()
	graphics.alpha((50 - selfData.life) * 0.2)
	graphics.color(relicColor)
	local points = {}
	for i = 1, 3 do
		local angle = math.rad((360 / 3) * (i - 1) + selfData.rand) + selfData.life * 0.01 * (50 - selfData.life)
		local dis = selfData.life * 0.4
		local x = self.x + math.cos(angle) * dis
		local y = self.y + math.sin(angle) * dis
		points[i] = {x = x, y = y}
	end
	graphics.triangle(points[1].x, points[1].y, points[2].x, points[2].y, points[3].x, points[3].y, true)
end)

local onPlayerStepCall = function(player)
	local relicForce = player:countItem(itRelicForce)
	if relicForce > 0 then
		local playerAc = player:getAccessor()
		if player:getData().relicForceCd and playerAc.activity == 0 then
			player:getData().relicForceCd = nil
		end
		--if playerAc.activity ~= player:getData().rfLastSkill then
			--if playerAc.activity > 0 and playerAc.activity <= 5 then
				--local attack = objForceAttack:create(player.x, player.y)
				--attack:getData().damage = playerAc.damage * 0.8
				--attack:getData().team = playerAc.team
		--	end
		--end
		player:getData().rfLastSkill = playerAc.activity
		if global.quality > 1 then
			if math.chance(7) then
				if math.chance(50) then
					par.FloatingRocks:burst("below", player.x, player.y + 1, 1, relicColor)
				else
					par.FloatingRocks:burst("below", player.x, player.y + 1, 1, Color.fromRGB(122,122,122))
				end
			end
		end
	end
end
callback.register("postLoad", function()
	for _, survivor in ipairs(Survivor.findAll()) do
		survivor:addCallback("useSkill", function(player, skill)
			local relicForce = player:countItem(itRelicForce)
			if relicForce > 0 and player:get("activity") <  6 and not player:getData().relicForceCd then -- aaaaa edge caseees
				local doCount
				if player:getSurvivor() == sur.DUT and skill == 1 or player:getSurvivor() == sur.Chirr and skill == 4 then
					local c = 35
					if player:getSurvivor() == sur.Chirr then c = 100 end
					player:getData().rfCount = ((player:getData().rfCount or 0) - 1) % c
					doCount = true
				end
				if not doCount or player:getData().rfCount == 1 then
					local playerAc = player:getAccessor()
					--for i = 1, relicForce do
						local attack = objForceAttack:create(player.x, player.y)
						attack:getData().damage = playerAc.damage * relicForce
						attack:getData().team = playerAc.team
						attack:getData().critical = playerAc.critical_chance
						--if i > 1 then
							--attack:getData().life = math.ceil((50 / relicForce) * i)
						--end
					--end
					player:getData().relicForceCd = true
				end
			end
		end)
	end
end)


itRelicForce:addCallback("pickup", function(player)
	tcallback.register("onPlayerStep", onPlayerStepCall)
	player:getData().rfLastSkill = player:get("activity")
end)
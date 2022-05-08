-- Boaroness

local path = "Survivors/Baroness/Skins/Boaroness/"

local survivor = Survivor.find("Baroness", "Starstorm")
local sprSelect = Sprite.load("BoaronessSelect", path.."Select", 16, 2, 0)

local Boaroness = SurvivorVariant.new(survivor, "Boaroness", sprSelect, {
	idle_1 = Sprite.load("Boaroness_Idle", path.."Idle", 1, 5, 9),
	walk_1 = Sprite.load("Boaroness_Walk", path.."Walk", 8, 6, 9),
	jump_1 = Sprite.load("Boaroness_Jump", path.."Jump", 1, 5, 8),
	climb = Sprite.load("Boaroness_Climb", path.."Climb", 2, 6, 9),
	death = Sprite.load("Boaroness_Death", path.."Death", 8, 30, 8),
	decoy = Sprite.load("Boaroness_Decoy", path.."Decoy", 1, 9, 10),
	
	idle_2 = Sprite.load("Boaroness_Idle_Bike", path.."IdleBike", 1, 9, 11),
	walk_2 = Sprite.load("Boaroness_Walk_Bike", path.."WalkBike", 4, 9, 11),
	jump_2 = Sprite.load("Boaroness_Jump_Bike", path.."JumpBike", 1, 9, 11),
	
	shoot1_1 = Sprite.load("Boaroness_Shoot1A", path.."Shoot1a", 13, 9, 14),
	shoot1_2 = Sprite.load("Boaroness_Shoot1B", path.."Shoot1b", 11, 11, 12),
	shoot1_3 = Sprite.load("Boaroness_Shoot1BW", path.."Shoot1bw", 11, 11, 13),
	shoot2_1 = Sprite.load("Boaroness_Shoot2A", path.."Shoot2a", 7, 5, 14),
	shoot2_2 = Sprite.load("Boaroness_Shoot2B", path.."Shoot2b", 7, 15, 15),
	shoot3_1 = Sprite.load("Boaroness_Shoot3A", path.."Shoot3a", 6, 12, 19),
	shoot3_2 = Sprite.load("Boaroness_Shoot3B", path.."Shoot3b", 8, 19, 18),
	shoot4_1 = Sprite.load("Boaroness_Shoot4A", path.."Shoot4a", 7, 5, 14),
	shoot4_2 = Sprite.load("Boaroness_Shoot4B", path.."Shoot4b", 7, 17, 14),
}, Color.fromHex(0x9B9183))
SurvivorVariant.setInfoStats(Boaroness, {{"Strength", 6}, {"Vitality", 5}, {"Toughness", 2}, {"Agility", 9}, {"Difficulty", 4}, {"Instinct", 8}})
SurvivorVariant.setDescription(Boaroness, "Molded by the planet, the &y&Boaroness&!& makes use of tamed boars to get whatever she wants, whenever she wants it.")

local sprSkills = Sprite.load("BoaronessSkills", path.."Skills", 6, 0, 0)
local sShoot4 = Sound.load("BoaronessShoot4", path.."Shoot4")

SurvivorVariant.setLoadoutSkill(Boaroness, "Bo Lance", "Attack at a short range for &y&120% piercing damage&!&.", sprSkills)
--SurvivorVariant.setLoadoutSkill(Boaroness, "Steady Target", "Pick up an enemy, &y&pulling it close and disabling it for 4 seconds&!&.", sprSkills, 2)
SurvivorVariant.setLoadoutSkill(Boaroness, "Active Relocation", "Summon a war boar, &b&increasing movement speed. Can attack while moving&!&.", sprSkills, 3)
SurvivorVariant.setLoadoutSkill(Boaroness, "Ambush", "Command a &y&group of boars&!& to &y&charge&!& towards the direction you are facing for &y&120% DPS&!&.", sprSkills, 4)

Boaroness.endingQuote = "..and so she left, ready to start all over again."

local objInvokedBoar = Object.new("InvokedBoar")
objInvokedBoar.sprite = Sprite.load("BoaronessBoar", path.."Shoot4Boar", 4, 9, 10)
objInvokedBoar:addCallback("create", function(self)
	local selfData = self:getData()
	local selfAc = self:getAccessor()
	
	selfData.cd = 0
	selfData.cd2 = 0
	selfData.life = 240
	selfData.speed = 1.2
	selfData.maxspeed = 2.3
	selfData.vspeed = 0
	selfData.damage = 0.3
	selfData.knockback = 4
	self.spriteSpeed = 0.2
	
	obj.EfFlash:create(0,0):set("parent", self.id):set("rate", 0.08)
end)
objInvokedBoar:addCallback("step", function(self)
	local selfData = self:getData()
	local selfAc = self:getAccessor()
	
	if selfData.parent and selfData.parent:isValid() and selfData.life > 0 then
		if selfData.cd == 0 then
			local r = 20
			for _, actor in ipairs(pobj.enemies:findAllEllipse(self.x - r, self.y - r, self.x + r, self.y +r)) do
				if actor:get("team") ~= selfData.parent:get("team") and self:collidesWith(actor, self.x, self.y) then
					selfData.parent:fireExplosion(self.x, self.y, 10 / 19, 8 / 4, selfData.damage, nil, spr.Sparks2):set("knockback", selfData.knockback)
					selfData.cd = 7
					break
				end
			end
		else
			selfData.cd = selfData.cd - 1
		end
		selfData.life = selfData.life - 1
		
		self.alpha = selfData.life * 0.04
		
		local speed = selfData.speed * math.sign(self.xscale)
		
		selfData.speed = math.min(selfData.speed + 0.04, selfData.maxspeed)
		
		if not self:collidesMap(self.x + speed, self.y) then
			self.x = self.x + speed
		elseif selfData.cd2 == 0 then
			selfData.vspeed = - 3
			selfData.cd2 = 15
		end
		
		if misc.getTimeStop() == 0 and self:collidesWith(obj.Geyser, self.x, self.y) then
			selfData.vspeed = - 7
		end
		
		if selfData.cd2 > 0 then
			selfData.cd2 = selfData.cd2 - 1
		end
		
		if not self:collidesMap(self.x, self.y + selfData.vspeed) then
			self.y = self.y + selfData.vspeed
			selfData.vspeed = selfData.vspeed + 0.2
			selfData.cd2 = 1
		else
			selfData.cd2 = 0
			if selfData.vspeed ~= 0 then
				selfData.vspeed = 0
			end
		end
		
		if self:collidesMap(self.x, self.y) then
			self.y = self.y - 2
		end
	else
		self:destroy()
	end
end)

callback.register("onSkinInit", function(player, skin)
	if skin == Boaroness then
		local playerData = player:getData()
		
		player:set("pHmax", player:get("pHmax") - 0.1)
		playerData.skin_skill1Override = true
		playerData.skin_skill4Override = true
		if Difficulty.getActive() == dif.Drizzle then
			player:survivorSetInitialStats(149, 12, 0.042)
		else
			player:survivorSetInitialStats(99, 12, 0.012)
		end
		player:setSkill(1,
		"Bo Lance",
		"Attack at a short range for 120% piercing damage.",
		sprSkills, 1, 23)
		player:setSkill(2,
		"Steady Target",
		"Pick up and disable an enemy, dealing 100% damage.",
		sprSkills, 2, 6 * 60)
		player:setSkill(4,
		"Ambush",
		"Command a group of boars to charge in the direction you are facing for 120% DPS.",
		sprSkills, 5, 7 * 60)
		playerData._EfColor = Color.fromHex(0xCC6A78)
		playerData._SteadyDistance = 30
		playerData._SteadyDuration = 300
		playerData._EnableJump = true
		playerData._SpeedBoost = 1.35
		playerData.sounds.skill3_1 = sfx.BoarHit
		playerData.sounds.skill3_2 = sfx.BoarHit
	end
end)
survivor:addCallback("scepter", function(player)
	if SurvivorVariant.getActive(player) == Boaroness then
		player:setSkill(4,
		"Alpha Ambush",
		"Command a group of boars to charge in the direction you are facing for 240% DPS.",
		sprSkills, 6, 7 * 60)
	end
end)
survivor:addCallback("levelUp", function(player)
	if SurvivorVariant.getActive(player) == Boaroness then
		player:survivorLevelUpStats(-3, 0, 0.0014, 0)
	end
end)
survivor:addCallback("step", function(player)
	if SurvivorVariant.getActive(player) == Boaroness then
		if player:getData().vehicle then
			player:setAnimation("shoot1", player:getAnimation("shoot1_2"))
			player:setSkill(1,
			"Bo Lance",
			"Attack twice at a short range for 60% piercing damage each.",
			sprSkills, 1, 23)
			player:setSkill(3,
			"Face to Face",
			"Unmount the war boar.",
			sprSkills, 3, 6 * 60)
		else
			player:setAnimation("shoot1", player:getAnimation("shoot1_1"))
			player:setSkill(1,
			"Bo Lance",
			"Attack at a short range for 120% piercing damage.",
			sprSkills, 1, 23)
			player:setSkill(3,
			"Active Relocation",
			"Summon a war boar to increase your movement speed.",
			sprSkills, 3, 3 * 60)
		end
	end
end)
survivor:addCallback("onSkill", function(player, skill, relevantFrame)
	local playerAc = player:getAccessor()
	local playerData = player:getData()
	
	if SurvivorVariant.getActive(player) == Boaroness then
		if skill == 1 then
			if playerData.vehicle then
				local damage = 0.7
				
				local subimage = player.subimage
				
				local moving = false
				if playerAc.moveRight == 1 then
					playerAc.pHspeed = playerAc.pHmax
					moving = true
					player.xscale = math.abs(player.xscale)
				elseif playerAc.moveLeft == 1 then
					playerAc.pHspeed = -playerAc.pHmax
					moving = true
					player.xscale = math.abs(player.xscale) * -1 --sucks
				end
				
				if moving then
					player:setAnimation("shoot1", player:getAnimation("shoot1_3"))
					player.sprite = player:getAnimation("shoot1_3")
					damage = 0.5 --sucks bad
				else
					player:setAnimation("shoot1", player:getAnimation("shoot1_2"))
					player.sprite = player:getAnimation("shoot1_2")
				end
				
				if relevantFrame == 6 and not playerData.skin_onActivity then
					playerData.skin_onActivity = true
					sfx.ClayShoot1:play(1.1 + math.random() * 0.2)
					for i = 0, playerAc.sp do
						bullet = player:fireBullet(player.x, player.y, player:getFacingDirection(), 30, damage, nil, DAMAGER_BULLET_PIERCE)
						bullet:getData().skin_spark = spr.Sparks1
						bullet:set("knockback", 2.5)
						if i ~= 0 then
							bullet:set("climb", i * 8)
						end
					end
				elseif relevantFrame == 9 and not playerData.skin_onActivity then
					playerData.skin_onActivity = true
					sfx.ClayShoot1:play(1.2 + math.random() * 0.2)
					if not player:survivorFireHeavenCracker(0.9) then
						for i = 0, playerAc.sp do
							bullet = player:fireBullet(player.x, player.y, player:getFacingDirection(), 30, damage, nil, DAMAGER_BULLET_PIERCE)
							bullet:getData().skin_spark = spr.Sparks1
							bullet:set("knockback", 2.5)
							if i ~= 0 then
								bullet:set("climb", i * 8)
							end
						end
					end
				elseif relevantFrame ~= 1 then
					playerData.skin_onActivity = nil
				end
			else
				if relevantFrame == 3 and not playerData.skin_onActivity then
					playerData.skin_onActivity = true
					sfx.ClayShoot1:play(0.7 + math.random() * 0.2)
					for i = 0, playerAc.sp do
						bullet = player:fireExplosion(player.x + 3 * player.xscale, player.y, 10 / 19, 10 / 4, 0.5, nil, spr.Sparks7)
						bullet:set("knockback", 4)
						bullet:set("knockup", 2)
						if i ~= 0 then
							bullet:set("climb", i * 8)
						end
					end
				elseif relevantFrame == 7 and not playerData.skin_onActivity then
					playerData.skin_onActivity = true
					sfx.ClayShoot1:play(1.1 + math.random() * 0.2)
					if not player:survivorFireHeavenCracker(1) then
						for i = 0, playerAc.sp do
							bullet = player:fireBullet(player.x, player.y, player:getFacingDirection(), 48, 1.2, nil, DAMAGER_BULLET_PIERCE)
							bullet:getData().skin_spark = spr.Sparks1
							bullet:set("knockback", 6.5)
							if i ~= 0 then
								bullet:set("climb", i * 8)
							end
						end
					end
				elseif relevantFrame ~= 1 then
					playerData.skin_onActivity = nil
				end

			end
		elseif skill == 4 then
			if relevantFrame == 1 then
				sShoot4:play(1.1 + math.random() * 0.2)
			end
			if relevantFrame == 1 or relevantFrame == 3 or relevantFrame == 5 or relevantFrame == 6 then
				local o = objInvokedBoar:create(player.x, player.y - 4)
				o:getData().parent = player
				o:getData().speed = 1 + math.random() * 0.5
				if playerAc.scepter > 0 then
					o:getData().damage = 0.6
					o:getData().maxspeed = 2.9
					o:getData().knockback = 6
				end
				o.xscale = math.sign(player.xscale)
			end
		end
		
	end
end)
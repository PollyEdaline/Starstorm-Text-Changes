-- LEGIONARY

local path = "Survivors/Mercenary/Skins/Legionary/"

local survivor = sur.Mercenary
local sprSelect = Sprite.load("LegionarySelect", path.."Select", 15, 2, 0)
local Legionary = SurvivorVariant.new(survivor, "Legionary", sprSelect, {
	idle = Sprite.load("LegionaryIdle", path.."Idle", 1, 3, 7),
	walk = Sprite.load("LegionaryWalk", path.."Walk", 8, 6, 7),
	jump = Sprite.load("LegionaryJump", path.."Jump", 1, 6, 6),
	climb = Sprite.load("LegionaryClimb", path.."Climb", 2, 3, 7),
	death = Sprite.load("LegionaryDeath", path.."Death", 8, 17, 3),
	decoy = Sprite.load("LegionaryDecoy", path.."Decoy", 1, 9, 18),
	
	shoot1_1 = Sprite.load("LegionaryShoot1A", path.."Shoot1_1", 20, 8, 25),
	shoot1_2 = Sprite.load("LegionaryShoot1B", path.."Shoot1_2", 20, 8, 25),
	shoot2 = Sprite.load("LegionaryShoot2", path.."Shoot2", 11, 17, 12),
	shoot3 = Sprite.load("LegionaryShoot3", path.."Shoot3", 8, 10, 8),
	shoot4 = Sprite.load("LegionaryShoot4", path.."Shoot4", 18, 30, 16),
	shoot5 = Sprite.load("LegionaryShoot5", path.."Shoot5", 18, 30, 16),
}, Color.fromHex(0xF8D83C))
SurvivorVariant.setInfoStats(Legionary, {{"Strength", 8}, {"Vitality", 5.5}, {"Toughness", 6}, {"Agility", 3.1}, {"Difficulty", 3.5}, {"Blessing", 7.5}})
SurvivorVariant.setDescription(Legionary, "The &y&Legionary&!& is an elder warrior who fights in favor of glory with heavy equipment.")

local sprSkills = Sprite.load("LegionarySkills", path.."Skills", 2, 0, 0)
local sprShoot2_2 = Sprite.load("LegionaryShoot2_2", path.."Shoot2_2", 4, 14, 14)
local sShoot1_1 = Sound.load("LegionaryShoot1A", path.."Shoot1_1")
local sShoot1_2 = Sound.load("LegionaryShoot1B", path.."Shoot1_2")
local sShoot2 = Sound.load("LegionaryShoot2", path.."Shoot2")

local shieldDebuff = Buff.new("ShieldBreak")
shieldDebuff.sprite =  Sprite.load("LegionaryBuff", path.."Debuff", 1, 9, 9)
shieldDebuff:addCallback("start", function(actor)
	actor:set("armor", actor:get("armor") - 50)
end)
shieldDebuff:addCallback("end", function(actor)
	actor:set("armor", actor:get("armor") + 50)
end)

SurvivorVariant.setLoadoutSkill(Legionary, "Sovereign Bash", "Impact your sword against the ground for &y&340% damage&!& to nearby enemies.", sprSkills)
SurvivorVariant.setLoadoutSkill(Legionary, "Shield Breaker", "Swing your sword, creating a moving whirlwind that &b&weakens enemies&!& for &y&50% damage&!&.", sprSkills, 2)

Legionary.endingQuote = "..and so he left, determined to prove his legacy."

obj.LegionarySlash = Object.new("LegionarySlash")
obj.LegionarySlash.sprite = sprShoot2_2
obj.LegionarySlash.depth = -8
obj.LegionarySlash:addCallback("create", function(self)
	local selfData = self:getData()
	selfData.life = 60
	selfData.speed = 3
	selfData.team = "player"
	self.spriteSpeed = 0.25
end)
obj.LegionarySlash:addCallback("step", function(self)
	local selfData = self:getData()
	if selfData.life > 0 then
		if selfData.life % 10 == 0 and selfData.parent and selfData.parent:isValid() then
			local b = selfData.parent:fireExplosion(self.x, self.y, 15 / 19, 15 / 4, 0.5, nil, spr.Sparks7)
			b:set("stun", 1)
			for _, actor in ipairs(pobj.actors:findAllRectangle(self.x - 15, self.y - 15, self.x + 15, self.y + 15)) do
				if actor:get("team") ~= selfData.team then
					actor:applyBuff(shieldDebuff, 3 * 60)
				end
			end
		end
		
		selfData.life = selfData.life - 1
		self.x = self.x + self.xscale * selfData.speed
		
		self.alpha = selfData.life * 0.2
	else
		self:destroy()
	end
end)

callback.register("onSkinInit", function(player, skin)
	if skin == Legionary then
		player:set("armor", player:get("armor") + 5)
		player:set("pHmax", player:get("pHmax") - 0.15)
		if Difficulty.getActive() == dif.Drizzle then
			player:survivorSetInitialStats(167, 12.5, 0.043)
		else
			player:survivorSetInitialStats(117, 12.5, 0.013)
		end
		player:setSkill(1,
		"Sovereign Bash",
		"Impact your sword against the ground for 340% damage on nearby enemies.",
		sprSkills, 1, 85)
		player:setSkill(2,
		"Shield Breaker",
		"Swing your sword, creating a moving whirlwind that weakens enemies for 50% damage.",
		sprSkills, 2, 5 * 60)
	end
end)
survivor:addCallback("levelUp", function(player)
	if SurvivorVariant.getActive(player) == Legionary then
		player:survivorLevelUpStats(3, 0.3, -0.002, 1)
	end
end)
SurvivorVariant.setSkill(Legionary, 1, function(player)
	SurvivorVariant.activityState(player, 1, player:getAnimation("shoot1_1"), 0.25, true, true)
end)
SurvivorVariant.setSkill(Legionary, 2, function(player)
	SurvivorVariant.activityState(player, 2, player:getAnimation("shoot2"), 0.25, true, true)
	player:set("pVspeed", 0)
end)
callback.register("onSkinSkill", function(player, skill, relevantFrame, variant)
	if variant == Legionary then
		local playerAc = player:getAccessor()
		if skill == 1 then
			if relevantFrame == 4 then
				if onScreen(player) then
					misc.shakeScreen(1)
				end
			end
			if relevantFrame == 1 then
				sShoot1_1:play(1 + math.random() * 0.2)
			elseif relevantFrame == 10 then
				if onScreen(player) then
					misc.shakeScreen(10)
				end
				sShoot1_2:play(1 + math.random() * 0.2)
				player:survivorFireHeavenCracker(3)
				for i = 0, playerAc.sp do
					local bullet = player:fireExplosion(player.x + 30 * player.xscale, player.y, 40 / 19, 10 / 4, 4.4, nil, spr.Sparks11)
					bullet:set("direction", player:getFacingDirection())
					if i ~= 0 then
						bullet:set("climb", i * 8)
					end
				end
			end
		elseif skill == 2 then
			if relevantFrame == 1 then
				player:set("pHspeed", 0)
				sShoot1_1:play(0.8 + math.random() * 0.2)
			elseif relevantFrame == 5 then
				sShoot2:play(0.9 + math.random() * 0.2)
				local slash = obj.LegionarySlash:create(player.x + 4 * player.xscale, player.y)
				slash:getData().team = playerAc.team
				slash:getData().parent = player
				slash.xscale = player.xscale
			end
			if player.subimage < 5 then
				if playerAc.invincible < 5 then
					playerAc.invincible = 5
				end
				player:set("pVspeed", - player:get("pGravity1"))
			end
		end
	end
end)
-- NINJA

local path = "Survivors/CHEF/Skins/NINJA/"

local survivor = sur.CHEF
local sprSelect = Sprite.load("NINJASelect", path.."Select", 18, 2, 0)
local NINJA = SurvivorVariant.new(survivor, "NINJA", sprSelect, {
	idle = Sprite.load("NINJAIdle", path.."Idle", 1, 8, 10),
	walk = Sprite.load("NINJAWalk", path.."Walk", 8, 13, 24),
	jump = Sprite.load("NINJAJump", path.."Jump", 1, 10, 11),
	climb = Sprite.load("NINJAClimb", path.."Climb", 2, 5, 13),
	death = Sprite.load("NINJADeath", path.."Death", 5, 14, 12),
	decoy = Sprite.load("NINJADecoy", path.."Decoy", 1, 9, 18),
	
	shoot1_1 = Sprite.load("NINJAShoot1A", path.."Shoot1_1", 5, 9, 30),
	shoot2_1 = Sprite.load("NINJAShoot2A", path.."Shoot2_1", 9, 16, 17),
	shoot2_2 = Sprite.load("NINJAShoot2B", path.."Shoot2_2", 9, 9, 17),
	shoot3_1 = Sprite.load("NINJAShoot3A", path.."Shoot3_1", 10, 13, 25),
	shoot3_2 = Sprite.load("NINJAShoot3B", path.."Shoot3_2", 16, 13, 25),
	
	cleaver = Sprite.load("NINJAShuriken", path.."Cleaver", 1, 5, 6),
	flash = Sprite.load("NINJAFlash", path.."Flash", 8, 27, 73),
}, Color.fromHex(0x5C9C8C))
SurvivorVariant.setInfoStats(NINJA, {{"Strength", 5}, {"Vitality", 4}, {"Toughness", 3}, {"Agility", 7}, {"Difficulty", 5}, {"Mastery", 8}})
SurvivorVariant.setDescription(NINJA, "The &y&NINJA&!& is merely a show asset, however, circumstances can push it to do much more.")

local sprSkill = Sprite.load("NINJASkill", path.."Skill", 4, 0, 0)
local sShoot1 = Sound.load("NINJAShootImpact", path.."Shoot1")

SurvivorVariant.setLoadoutSkill(NINJA, "SHURIKEN", "THROW A PIERCING SHURIKEN FOR &y&115% DAMAGE.", sprSkill)

NINJA.endingQuote = "..and so it left, taking the mantle of the Space Ninja Robot."

callback.register("onSkinInit", function(player, skin)
	if skin == NINJA then
		player:getData().skin_skill1Override = true
		player:getData().isNinja = true
		player:set("pHmax", player:get("pHmax") + 0.3)
		if Difficulty.getActive() == dif.Drizzle then
			player:survivorSetInitialStats(159, 11.5, 0.043)
		else
			player:survivorSetInitialStats(109, 11.5, 0.013)
		end
		player:setSkill(1,
		"SHURIKEN",
		"THROW A PIERCING SHURIKEN FOR 115% DAMAGE.",
		sprSkill, 1, 25)
		player:setSkill(4,
		"SHINOBI",
		"ENHANCE MARTIAL ARTS, BOOSTING THE NEXT ABILITY CAST.",
		sprSkill, 3, 60 * 7)
	end
end)
survivor:addCallback("scepter", function(player)
	if SurvivorVariant.getActive(player) == NINJA then
		player:setSkill(4,
		"SHINOBI MASTER",
		"ENHANCE MARTIAL ARTS, BOOSTING THE NEXT TWO ABILITY CASTS.",
		sprSkill, 4, 60 * 7)
	end
end)
survivor:addCallback("levelUp", function(player)
	if SurvivorVariant.getActive(player) == NINJA then
		player:survivorLevelUpStats(-5, 0.1, 0, 1)
	end
end)

local changeFlash = 0
callback.register("onGameEnd", function()
	changeFlash = 0 --sucks
end)

-- Shuriken Object
local objShuriken = Object.new("NINJA_Shuriken")
local mask = Sprite.load("NINJAShurikenMask", path.."CleaverMask", 1, 5, 6)

local enemies = pobj.enemies

objShuriken.sprite = NINJA.animations.cleaver
objShuriken.depth = 0.1

objShuriken:addCallback("create", function(self)
	local selfAc = self:getAccessor()
	self.mask = mask
	self:getData().life = 90
	self:getData().team = "player"
	self:getData().hitEnemies = {}
	selfAc.speed = 4.5
end)
objShuriken:addCallback("step", function(self)
	local selfAc = self:getAccessor()
	local selfData = self:getData()
	local enemy = enemies:findNearest(self.x, self.y)
	
	self.angle = self.angle + 10
	
	if selfData.parent and selfData.parent:isValid() then
		local xr, yr = 10 * self.xscale, 12 * self.yscale
		for _, actor in ipairs(pobj.actors:findAllRectangle(self.x - xr, self.y - yr, self.x + xr, self.y + yr)) do
			if actor:get("team") ~= selfData.team and self:collidesWith(actor, self.x, self.y) and not selfData.hitEnemies[enemy] then
				if global.quality > 1 then
					par.Spark:burst("middle", self.x, self.y, 2)
				end
				sShoot1:play(0.9 + math.random() * 0.2)
				
				selfData.hitEnemies[enemy] = true
				local parent = selfData.parent
				for i = 0, parent:get("sp") do
					local damager = parent:fireExplosion(self.x, self.y, 9 / 19, 9 / 4, 1.15, spr.Sparks7, nil)
					damager:set("direction", parent:getFacingDirection())
					if i ~= 0 then
						damager:set("climb", i * 8)
					end
				end
			end
		end
	end
	
	if selfData.life == 0 or selfData.pass == nil and Stage.collidesPoint(self.x, self.y) then
		if Stage.collidesPoint(self.x, self.y) and onScreen(self) then
			sShoot1:play(0.9 + math.random() * 0.2)
		end
		if global.quality > 1 then
			par.Spark:burst("middle", self.x, self.y, 4)
		end
		self:destroy()
	else
		selfData.life = selfData.life - 1
	end
end)

local onStepCall = function()
	for _, obj in ipairs(obj.ChefKnife:findAll()) do
		local parent = obj:get("parent")
		if parent and parent > 0 then
			local parentI = Object.findInstance(parent)
			if parentI and parentI:getData().isNinja then
				obj:destroy()
			end
		end
	end
	
	for _, obj in ipairs(obj.EfSparks:findAll()) do
		if obj.sprite == spr.ChefUltFlash then
			if not obj:getData().checked then
				obj:getData().checked = true
				if changeFlash > 0 then
					changeFlash = changeFlash - 1
					obj.sprite = NINJA.animations.flash
				end
			end
		end
	end
end

survivor:addCallback("useSkill", function(player, skill)
	if SurvivorVariant.getActive(player) == NINJA then
		if skill == 4 then
			changeFlash = changeFlash + 1
		end
	end
end)

survivor:addCallback("onSkill", function(player, skill, relevantFrame)
	if SurvivorVariant.getActive(player) == NINJA then
		local playerAc = player:getAccessor()
		if skill >= 1 and skill < 2 then
			--if playerAc.free == 0 then
				--playerAc.pHspeed = 0.35 * player.xscale
			--end
			if relevantFrame == 4 then
				if not player:getData().skin_onActivity then
					player:getData().skin_onActivity = true
					if skill == 1.2 then
						for i = -3, 3 do
							local shuriken = objShuriken:create(player.x, player.y - 3)
							shuriken:set("direction", player:getFacingDirection() + (i * 10))
							shuriken:getData().parent = player
							shuriken:getData().pass = true
							shuriken:getData().team = playerAc.team
						end
					else
						local shuriken = objShuriken:create(player.x, player.y - 3)
						shuriken:set("direction", player:getFacingDirection())
						shuriken:getData().parent = player
						shuriken:getData().team = playerAc.team
					end
				end
			elseif relevantFrame ~= 3 then
				player:getData().skin_onActivity = nil
			end
		end
	end
end)
local onPlayerStepCall = function(player)
	if SurvivorVariant.getActive(player) == NINJA then
		local playerAc = player:getAccessor()
		if playerAc.empower then
			if playerAc.empower > 0 then
				changeFlash = changeFlash + 1
				player:setSkill(1,
				"SHURIKEN SWARM",
				"THROW 7 PIERCING SHURIKENS FORWARD FOR 115% DAMAGE EACH.",
				sprSkill, 2, 25)
			else
				player:setSkill(1,
				"SHURIKEN",
				"THROW A PIERCING SHURIKEN FOR 115% DAMAGE.",
				sprSkill, 1, 25)
			end
		end
	end
end

callback.register("onSkinInit", function(_, skin)
	if skin == NINJA then
		tcallback.register("onStep", onStepCall)
		tcallback.register("onPlayerStep", onPlayerStepCall)
	end
end)
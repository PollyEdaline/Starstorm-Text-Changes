-- Fungus Man

local path = "Survivors/Engineer/Skins/N-G/"

local survivor = sur.Engineer
local sprSelect = Sprite.load("NGSelect", path.."Select", 14, 2, 0)
local NG = SurvivorVariant.new(survivor, "N-G", sprSelect, {
	idle = Sprite.load("NGIdle", path.."Idle", 1, 9, 11),
	walk = Sprite.load("NGWalk", path.."Walk", 8, 10, 11),
	jump = Sprite.load("NGJump", path.."Jump", 1, 10, 14),
	climb = Sprite.load("NGClimb", path.."Climb", 2, 11, 8),
	death = Sprite.load("NGDeath", path.."Death", 9, 10, 15),
	decoy = Sprite.load("NGDecoy", path.."Decoy", 1, 9, 18),
	
	shoot1 = Sprite.load("NGShoot1", path.."Shoot1", 5, 12, 14),
	shoot3 = Sprite.load("NGShoot3", path.."Shoot3", 19, 29, 14),
	
	turretBase1 = Sprite.load("NGTurretBase1", path.."Turret1Base", 1, 10, 7),
	turretRotate1 = Sprite.load("NGTurretRotate1", path.."Turret1Turn", 7, 13, 7),
	turretSpawn1 = Sprite.load("NGTurretSpawn1", path.."Turret1Spawn", 11, 10, 7),
}, Color.fromHex(0x9B9877))
SurvivorVariant.setInfoStats(NG, {{"Strength", 7}, {"Vitality", 5}, {"Toughness", 3}, {"Agility", 6}, {"Difficulty", 5}, {"Battery",7}})
SurvivorVariant.setDescription(NG, "&y&N-G&!&: AUTONOMOUS INDUSTRIAL UNIT PROTOCOL A_23.\nDESIGNATED CORE UTILITIES:")

local sprSkills = Sprite.load("NGSkills", path.."Skills", 2, 0, 0)
local sShoot1= Sound.load("NGShoot1", path.."Shoot1")
local sShoot3= Sound.load("NGShoot3", path.."Shoot3")

SurvivorVariant.setLoadoutSkill(NG, "WELDING BEAM DISCHARGE", "RELEASE A BEAM DEALING &y&100% IMPACT + 100% ELECTRIC DAMAGE. &y&STUNS USERS BRIEFLY.", sprSkills, 1)
SurvivorVariant.setLoadoutSkill(NG, "RAPID DISPLACEMENT", "&b&MOVE FORWARD, &!&PUSHING ANY USERS IN THE WAY FOR &y&100% DAMAGE.", sprSkills, 2)

NG.endingQuote = "..and so it left, calculating an improbable fate."

survivor:addCallback("levelUp", function(player)
	if SurvivorVariant.getActive(player) == NG then
		player:survivorLevelUpStats(-2, 0, 0.002, 0)
	end
end)

SurvivorVariant.setSkill(NG, 1, function(player)
	SurvivorVariant.activityState(player, 1, player:getAnimation("shoot1"), 0.25, true, true)
end)
SurvivorVariant.setSkill(NG, 3, function(player)
	SurvivorVariant.activityState(player, 3, player:getAnimation("shoot3"), 0.25, false, true)
end)

local onHitCall = function(damager, hit, x, y)
	if damager:getData().lightning then
		local parent = damager:getParent()
		local lightning = obj.ChainLightning:create(x, y)
		lightning:set("damage", math.ceil(damager:getData().lightning))
		lightning:set("bounce", 3)
		lightning:set("team", parent:get("team"))
		lightning:set("parent", parent.id)
		lightning:set("critical", damager:get("critical"))
		if damager:getData().lightningColor then
			lightning:set("blend", damager:getData().lightningColor.gml)
		end
	end
end

callback.register("onSkinSkill", function(player, skill, relevantFrame, variant)
	if variant == NG then
		local playerAc = player:getAccessor()
		if skill == 1 then
			if relevantFrame == 1 then
				sShoot1:play(0.9 + math.random() * 0.2, 0.8)
				if not player:survivorFireHeavenCracker(1) then
					local color = Color.fromHex(0x25DE70)
					for i = 0, playerAc.sp do
						local bullet = player:fireBullet(player.x, player.y + 2, player:getFacingDirection(), 310, 1, spr.EngiGrenadeExplosion)
						bullet:set("stun", 1)
						bullet:getData().lightning = playerAc.damage
						bullet:getData().lightningColor = color
						addBulletTrailLine(bullet, color, 2, 30, false, false)
						if i ~= 0 then
							bullet:set("climb", i * 8)
						end
					end
				end
			end
		elseif skill == 3 then
			playerAc.invincible = 2
			if relevantFrame == 1 then
				sShoot3:play(0.9 + math.random() * 0.2, 0.8)
				player:getData()._hi = player:getData()._hi + 1
			elseif relevantFrame > 7 and relevantFrame <= 16 then
				playerAc.pHspeed = playerAc.pHmax * 3 * player.xscale
			elseif relevantFrame == 17 then
				playerAc.pHspeed = playerAc.pHmax * 1.5 * player.xscale
			elseif relevantFrame == 18 then
				playerAc.pHspeed = playerAc.pHmax * 0.5 * player.xscale
			end
			
			if player.subimage > 7 and player.subimage <= 17 then
				local playerTeam = playerAc.team
				local r = 7
				local t = player:getData()._hi
				for _, actor in ipairs(pobj.actors:findAllRectangle(player.x - r, player.y - r, player.x + r, player.y + r)) do
					if actor:get("team") ~= playerTeam and player:collidesWith(actor, player.x, player.y) then
						local damage = 1
						if actor:getData()["_p"..player.id..t] then damage = 0.1 end
						local push = player:fireExplosion(player.x, player.y, 10 / 19, 10 / 4, damage)
						push:set("knockback", 7)
						push:set("knockback_direction", player.xscale)
						push:set("stun", 1)
						actor:getData()["_p"..player.id..t] = true
					end
				end
				for _, mine in ipairs(obj.EngiMine:findAllRectangle(player.x - r, player.y - r, player.x + r, player.y + r)) do
					if not mine:getData().instant then
						mine:getData().instant = true
						--mine.spriteSpeed = mine.spriteSpeed * 2
					end
				end
			end
		end
	end
end)

local onStepCall = function()
	for _, mine in ipairs(obj.EngiMine:findAll()) do
		local parent = Object.findInstance(mine:get("parent"))
		if parent and parent:isValid() and isa(parent, "PlayerInstance") then
			local skin = SurvivorVariant.getActive(parent)
			if skin == NG then
				local data = mine:getData()				
				if data.instant and mine.sprite == spr.EngiMineJump then
					mine.spriteSpeed = 1.25
				end
			end
		end
	end
end

callback.register("onSkinInit", function(player, skin)
	if skin == NG then
		if Difficulty.getActive() == dif.Drizzle then
			player:survivorSetInitialStats(170, 12, 0.042)
		else
			player:survivorSetInitialStats(120, 12, 0.012)
		end
		player:setSkill(1,
		"WELDING BEAM DISCHARGE", "RELEASE A BEAM DEALING 100% IMPACT + 100% ELECTRIC DAMAGE. STUNS USERS BRIEFLY.",
		sprSkills, 1, 1 * 60)
		player:setSkill(3,
		"RAPID DISPLACEMENT", "MOVE FORWARD, PUSHING ANY USERS IN THE WAY FOR 100% DAMAGE.",
		sprSkills, 2, 5 * 60)
		
		player:getData()._hi = 0
		
		tcallback.register("onStep", onStepCall)
		tcallback.register("onHit", onHitCall)
	end
end)
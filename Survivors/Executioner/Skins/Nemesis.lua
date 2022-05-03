-- NEMESIS EXECUTIONER

local path = "Survivors/Executioner/Skins/Nemesis/"

local survivor = Survivor.find("Executioner", "Starstorm")
local NExecutioner = SurvivorVariant.new(survivor, "Nemesis Executioner",
Sprite.load("NemesisExecutionerSelect", path.."Select", 19, 2, 0),
{
	idle = Sprite.find("NemesisExecutionerIdle", "Starstorm"),
	walk = Sprite.find("NemesisExecutionerWalk", "Starstorm"),
	jump = Sprite.find("NemesisExecutionerJump", "Starstorm"),
	climb = Sprite.find("NemesisExecutionerClimb", "Starstorm"),
	death = Sprite.find("NemesisExecutionerDeath", "Starstorm"),
	decoy = Sprite.load("NemesisExecutionerDecoy", path.."Decoy", 1, 9, 10),
	
	shoot1 = Sprite.find("NemesisExecutionerShoot1", "Starstorm"),
	shoot2 = Sprite.find("NemesisExecutionerShoot2", "Starstorm"),
	shoot3 = Sprite.find("NemesisExecutionerShoot3", "Starstorm"),
	shoot4 = Sprite.find("NemesisExecutionerShoot4", "Starstorm"),
	shoot5 = Sprite.load("NemesisExecutionerShoot5", path.."Shoot5", 14, 29, 24)
}, Color.fromHex(0xCC4D4D))
SurvivorVariant.setInfoStats(NExecutioner, {{"Strength", 7}, {"Vitality", 5}, {"Toughness", 4}, {"Agility", 5}, {"Difficulty", 4}, {"Punishment", 8}})
SurvivorVariant.setDescription(NExecutioner, "The &y&Nemesis Executioner&!& takes away the lives of those who he condemns for what he envisions as the greater welfare. Use the energy from slain enemies to raise ion allies.")

local sprSkills = Sprite.load("NemesisExecutionerSkills", path.."Skills", 8, 0, 0)
local sShoot1a = Sound.find("NemesisExecutionerShoot1a", "Starstorm")
local sShoot1b = Sound.find("NemesisExecutionerShoot1b", "Starstorm")
local sShoot2a = Sound.find("NemesisExecutionerShoot2a", "Starstorm")
local sShoot2b = Sound.find("NemesisExecutionerShoot2b", "Starstorm")
local sShoot4a = Sound.find("NemesisExecutionerShoot4a", "Starstorm")
local sShoot4b = Sound.find("NemesisExecutionerShoot4b", "Starstorm")

SurvivorVariant.setLoadoutSkill(NExecutioner, "Chaotic Energy", 
"Materialize 3 projectiles, each dealing &y&90% damage&!& on impact.", sprSkills)

SurvivorVariant.setLoadoutSkill(NExecutioner, "Puppeteer", 
"Every slain enemy adds a charge. Spend all charges to unearth up to 10 allied ion minions which attack foes for &y&50% damage&!&.", sprSkills, 3)

SurvivorVariant.setLoadoutSkill(NExecutioner, "Reaper", 
"Charge forward and slash with a projected scythe for &y&900% damage.", sprSkills, 7)

NExecutioner.endingQuote = "..and so he left, fading into the unknown."

local efColor = Color.fromHex(0xCC4D4D) --Color.RED

local sprSkills2 = Sprite.find("Executioner_Skills_2")

local onPlayerHUDDrawCall = function(player, x, y)
	if SurvivorVariant.getActive(player) == NExecutioner then
		local bullets = player:get("ionBullets")
		
		graphics.drawImage{
			image = sprSkills2,
			subimage = bullets + 1,
			y = y - 11,
			x = x + 18 + 5
		}
	end
end

callback.register("onSkinInit", function(player, skin)
	if skin == NExecutioner then
		player:getData().skin_skill1Override = true
		player:getData().skin_skill2Override = true
		player:getData().skin_skill4Override = true
		player:getData()._EfColor = efColor
		if Difficulty.getActive() == dif.Drizzle then
			player:survivorSetInitialStats(150, 12.5, 0.044)
		else
			player:survivorSetInitialStats(100, 12.5, 0.014)
		end
		player:setSkill(1,
		"Chaotic Energy",
		"Materialize 3 projectiles, each dealing 90% damage on impact.",
		sprSkills, 1, 60)
		player:setSkill(2,
		"Puppeteer",
		"Unearth allied ion minions which attack foes for 50% damage.",
		sprSkills, 2, 60 * 5)
		player:setSkill(4,
		"Reaper",
		"Slash forward with a projected scythe for 900% damage.",
		sprSkills, 7, 60 * 9)
		
		tcallback.register("onPlayerHUDDraw", onPlayerHUDDrawCall)
	end
end)
survivor:addCallback("levelUp", function(player)
	if SurvivorVariant.getActive(player) == NExecutioner then
		player:survivorLevelUpStats(6, -2, 0.002, 1)
	end
end)

survivor:addCallback("scepter", function(player)
	if SurvivorVariant.getActive(player) == NExecutioner then
		player:setSkill(4,
			"Abyssal Reaper",
			"Slash forward with a projected scythe for 900% damage, fearing surviving enemies.",
			sprSkills, 8,
			9 * 60
		)
	end
end)

local objNExeBullet = Object.find("NExeBullet", "Starstorm")
local objNExeSkeleton = Object.find("NExeSkeleton", "Starstorm")

local spawnSkeleFunc = setFunc(function(actor, parent)
	if parent:isValid() then
		local parentAc = parent:getAccessor()
		local actorAc = actor:getAccessor()
		
		for _, item in ipairs(parent:getData().items) do
			NPCItems.giveItem(actor, item.item, item.count)
		end
		
		actorAc.maxhp = parentAc.maxhp * 0.75
		actorAc.hp = actorAc.maxhp
		actorAc.armor = parentAc.armor
		actorAc.damage = parentAc.damage
		--actorAc.pHmax = parentAc.pHmax + 0.05
		--actorAc.attack_speed = parentAc.attack_speed
		--actorAc.cdr = parentAc.cdr
		--actorAc.critical_chance = parentAc.critical_chance
		--actorAc.hp_regen = parentAc.hp_regen * 0.5
		
		actorAc.team = parentAc.team
	end
end)

SurvivorVariant.setSkill(NExecutioner, 2, function(player)
	if player:get("ionBullets") > 0 then
		SurvivorVariant.activityState(player, 2, player:getAnimation("shoot2"), 0.2, true, true)
	end
end)
SurvivorVariant.setSkill(NExecutioner, 4, function(player)
	if player:get("scepter") == 0 then
		SurvivorVariant.activityState(player, 4, player:getAnimation("shoot4"), 0.2, true, true)
	else
		SurvivorVariant.activityState(player, 4, player:getAnimation("shoot5"), 0.2, true, true)
	end
end)

survivor:addCallback("onSkill", function(player, skill, relevantFrame)
	if SurvivorVariant.getActive(player) == NExecutioner then
		local playerAc = player:getAccessor()
		local playerData = player:getData()
		if skill == 1 then
			if relevantFrame == 1 then
				sShoot1a:play(0.9 + math.random() * 0.2, 1)
				if not player:survivorFireHeavenCracker(2.5) then
					for i = 1, 3 do
						local l = objNExeBullet:create(player.x + (17 * (i - 1) + 6) * player.xscale, player.y + math.random(0, 4) - 2)
						l:getData().parent = player
						l:getData().life = 70 - (10 * i) --- 5 + 100
						l.xscale = player.xscale
						l:getData().team = playerAc.team
						l:getData().speed = playerAc.attack_speed * 1.5
					end
				end
			end
		elseif skill == 2.01 then
			if relevantFrame >= 3 and playerAc.ionBullets > 0 then
				if relevantFrame == 3 then
					sShoot2a:play(0.9 + math.random() * 0.2, 1)
				else
					sShoot2b:play(0.9 + math.random() * 0.2, 1)
				end
				--for i = 1, playerAc.ionBullets do
					createSynced(objNExeSkeleton, player.x + 3 * relevantFrame * player.xscale, player.y, spawnSkeleFunc, player)
				--end
				playerAc.ionBullets = playerAc.ionBullets - 1
			end
		elseif skill == 4.01 then
			if global.quality == 3 then
				if playerAc.scepter > 0 then
					par.Hologram:burst("middle", player.x + math.random(-15, 15), player.y + math.random(-7, 7), 1, Color.WHITE)
				else
					par.Hologram:burst("middle", player.x + math.random(-15, 15), player.y + math.random(-7, 7), 1, playerData._EfColor)
				end
			end
			if relevantFrame == 1 then
				sShoot4a:play(0.9 + math.random() * 0.2, 1)
			end
			if relevantFrame == 4 or relevantFrame == 5 or relevantFrame == 6 or relevantFrame == 7 or relevantFrame == 8 or relevantFrame == 9 then
				playerAc.pHspeed = 0
			end
			if playerAc.invincible < 5 then
				playerAc.invincible = 5
			end
			if relevantFrame == 9 then
				obj.MinerDust:create(player.x + player.xscale * 10, player.y).xscale = player.xscale
				local n = 0
				while not player:collidesMap(player.x + 2 * player.xscale, player.y) and n < math.max(math.ceil(20 * playerAc.pHmax), 1) do
					player.x = player.x + 2 * player.xscale
					n = n + 1
				end
				if playerAc.free == 1 then
					playerData.xAccel = 3 * playerAc.pHmax * player.xscale
				end
				
				sShoot4b:play(1, 1)
				
				misc.shakeScreen(5)
				local xadd = n
				for i = 0, playerAc.sp do
					
					local damage
					if playerAc.scepter > 0 then
						damage = 7 + (3 * playerAc.scepter)
					else
						damage = 10
					end
					local addHalf = xadd
					local bullet = player:fireExplosion(player.x + addHalf * player.xscale * -1, player.y - 7, (xadd + 4) / 19, 14 / 4, damage, nil, sprExSparks3)
					bullet:set("knockback", bullet:get("knockback") + 2)
					--bullet:set("bleed", bullet:get("bleed") + 0.08)
					--bullet:getData().isExecution = true
					if playerAc.scepter > 0 then
						bullet:set("fear", 1)
					end
					if i ~= 0 then
						bullet:set("climb", i * 8)
					end
				end
			end
		end
	end
end)

survivor:addCallback("step", function(player)
	if SurvivorVariant.getActive(player) == NExecutioner then
		local playerData = player:getData()
		local bullets = player:get("ionBullets")

		if playerData.lastBullets ~= bullets then
			if bullets == 0 then
				player:setSkillIcon(2, sprSkills, 2)
			elseif bullets < 4 then
				player:setSkillIcon(2, sprSkills, 3)
			elseif bullets < 7 then
				player:setSkillIcon(2, sprSkills, 4)
			elseif bullets < 10 then
				player:setSkillIcon(2, sprSkills, 5)
			else
				player:setSkillIcon(2, sprSkills, 6)
			end
			
			playerData.lastBullets = bullets
		end
	end
end)
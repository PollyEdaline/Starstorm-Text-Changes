-- Crusader (Comission)

local path = "Survivors/Knight/Skins/Crusader/"

local survivor = sur.Knight
local sprSelect = Sprite.load("CrusaderSelect", "Survivors/Knight/Skins/Crusader/Select", 24, 2, 0)
local crusader = SurvivorVariant.new(survivor, "Crusader", sprSelect, {
	idle = Sprite.load("Crusader_Idle", path.."idle", 1, 10, 15),
	walk = Sprite.load("Crusader_Walk", path.."walk", 8, 12, 16),
	jump = Sprite.load("Crusader_Jump", path.."jump", 1, 11, 15),
	climb = Sprite.load("Crusader_Climb", path.."climb", 2, 5, 9),
	death = Sprite.load("Crusader_Death", path.."death", 9, 9, 11),
	decoy = Sprite.load("Crusader_Decoy", path.."decoy", 1, 9, 18),
	
	shoot1_1 = Sprite.load("Crusader_Shoot1_1", path.."shoot1_1", 9, 12, 16),
	shoot1_3 = Sprite.load("Crusader_Shoot1_3", path.."shoot1_3", 9, 12, 17),
	shoot2 = Sprite.load("Crusader_Shoot2", path.."shoot2", 5, 12, 16),
	shoot3 = Sprite.load("Crusader_Shoot3", path.."shoot3", 7, 15, 22),
	shoot4 = Sprite.load("Crusader_Shoot4", path.."shoot4", 18, 30, 23),
	shoot4ef = Sprite.load("Crusader_Shoot4Ef", path.."shoot4ef", 5, 76, 19)
}, Color.fromHex(0xDEEAE5))
SurvivorVariant.setInfoStats(crusader, {{"Strength", 8}, {"Vitality", 4}, {"Toughness", 5}, {"Agility", 3}, {"Difficulty", 6}, {"Faith", 8}})
SurvivorVariant.setDescription(crusader, "The &y&Crusader&!& embarks on a journey to spread faith to those who follow her and death to those who dare oppose. Contending with her shield turns her next primary attack into deadly bullet fire.")
crusader.tag = "Comission"

local shootSounds = {
	Sound.load("Crusader_Shoot1A", path.."shoot1_1A"),
	Sound.load("Crusader_Shoot1B", path.."shoot1_1B")
}
local sShoot1_3 = Sound.load("Crusader_Shoot1_3", path.."shoot1_3")

crusader.endingQuote = "..and so she left, still bound by conviction."

local sprSkills = Sprite.load("CrusaderSkill", path.."Skills", 6, 0, 0)

SurvivorVariant.setLoadoutSkill(crusader, "Impale", "Stab with your halberd for &y&150% damage.", sprSkills, 1)
SurvivorVariant.setLoadoutSkill(crusader, "Sacrilege's End", "Fire a concealed gun twice for &y&400% total damage on both sides. Strike your halberd against the ground, knocking all enemies back. &y&Allies receive a fire damage bonus for 5 seconds.", sprSkills, 4)

local buffV = Buff.new("crusaderBuff")
buffV.sprite = Sprite.load("Crusader_Buff", path.."buff", 1, 9, 9)
buffV:addCallback("start", function(actor)
	actor:getData().fireDamage = true
end)
buffV:addCallback("end", function(actor)
	actor:getData().fireDamage = false
end)

table.insert(call.onFireSetProcs, function(damager, parent)
	if parent:isValid() and parent:getData().fireDamage then
		DOT.addToDamager(damager, DOT_FIRE, damager:get("damage") * 0.2, 5, "crusader", false)
	end
end)

callback.register("onSkinInit", function(player, skin)
	if skin == crusader then
		player:getData().skin_skill1Override = true
		player:getData()._EfColor = Color.fromHex(0xC5C0DE)
		player:getData().vBuff = buffV
		player:set("pHmax", player:get("pHmax") - 0.1)
		if Difficulty.getActive() == dif.Drizzle then
			player:survivorSetInitialStats(153, 13, 0.035)
		else
			player:survivorSetInitialStats(103, 13, 0.005)
		end
		player:setSkill(1, "Impale", "Stab with your halberd for 150% damage.",
		sprSkills, 1, 50)
		
		player:setSkill(2, "Contend", "Hold to reduce incoming damage by 50%. Parry attacks, deflecting them for 800% damage. Can interrupt other skills.",
		sprSkills, 2, 2 * 60)
		
		player:setSkill(3, "Strike", "Dash and strike forward for 200% damage. Stuns enemies briefly.",
		sprSkills, 3, 4 * 60)
		
		player:setSkill(4, "Sacrilege's End", "Fire twice for 400% total damage. Strike your halberd, knocking enemies back. Allies receive a fire damage bonus for 3 seconds.",
		sprSkills, 4, 11 * 60)
	end
end)

survivor:addCallback("levelUp", function(player)
	if SurvivorVariant.getActive(player) == crusader then
		player:survivorLevelUpStats(1, 0, -0.0002, 0)
	end
end)

SurvivorVariant.setSkill(crusader, 1, function(player)
	if player:getData().fireGun then
		SurvivorVariant.activityState(player, 1.3, player:getAnimation("shoot1_3"), 0.25, true, true)
	else
		SurvivorVariant.activityState(player, 1.1, player:getAnimation("shoot1_1"), 0.25, true, true)
	end
end)
SurvivorVariant.setSkill(crusader, 4, function(player)
	SurvivorVariant.activityState(player, 4, player:getAnimation("shoot4"), 0.25, true, true)
end)
callback.register("onSkinSkill", function(player, skill, relevantFrame, variant)
	if variant == crusader then
		local playerAc = player:getAccessor()
		if skill == 1.1 then
			if relevantFrame == 4 then
				table.irandom(shootSounds):play(0.8 + math.random() * 0.2)
			end
			if relevantFrame == 5 then
				if onScreen(player) then
					misc.shakeScreen(1)
				end
				if playerAc.free == 0 then
					playerAc.pHspeed = (1 / playerAc.attack_speed) * player.xscale
				end
				if not player:survivorFireHeavenCracker(1.7) then
					for i = 0, playerAc.sp do
						local bullet = player:fireExplosion(player.x + 16 * player.xscale, player.y, 23 / 19, 8 / 4, 1.5, nil, spr.Sparks2)
						bullet:set("knockback", 6)
						bullet:set("knockback_direction", player.xscale)
						if i ~= 0 then
							bullet:set("climb", i * 8)
						end
					end
				end
			end
		elseif skill == 1.3 then
			if relevantFrame == 6 then
				sShoot1_3:play(0.9 + math.random() * 0.2)
			end
			if relevantFrame == 6 then
				if player:getData().fireGun then
					player:getData().fireGun = nil
					player:setSkill(1, "Impale", "Stab with your halberd for 150% damage.", sprSkills, 1, 50)
				end
				if onScreen(player) then
					misc.shakeScreen(2)
				end
				if not player:survivorFireHeavenCracker(5) then
					for i = 0, playerAc.sp do
						local bullet = player:fireBullet(player.x, player.y, player:getFacingDirection(), 500, 4.5, spr.Sparks1)
						bullet:set("knockback", 6)
						bullet:set("knockback_direction", player.xscale)
						if i ~= 0 then
							bullet:set("climb", i * 8)
						end
					end
				end
			end
		elseif skill > 1.9 and skill < 3 and not player:getData().fireGun then
			player:getData().fireGun = true
			player:setSkill(1, "Coup De Grace", "Fire a concealed gun for 450% damage.", sprSkills, 6, 20)
		elseif skill == 4 then
			if playerAc.invincible < 2 then
				playerAc.invincible = 2
			end
			if playerAc.free == 0 and player.subimage > 5 and player.subimage < 15 then
				playerAc.pHspeed = 0.5 * player.xscale * -1
			end
			if relevantFrame == 3 then
				sShoot1_3:play(0.9 + math.random() * 0.2)
				if onScreen(player) then
					misc.shakeScreen(2)
				end
				for i = 0, playerAc.sp do
					local bullet = player:fireBullet(player.x, player.y, player:getFacingDirection(), 500, 2, spr.Sparks1)
					bullet:set("knockback", 5)
					bullet:set("knockback_direction", player.xscale)
					if i ~= 0 then
						bullet:set("climb", i * 8)
					end
				end
			elseif relevantFrame == 7 then
				table.irandom(shootSounds):play(0.7 + math.random() * 0.2)
				if onScreen(player) then
					misc.shakeScreen(1)
				end
				for i = 0, playerAc.sp do
					local bullet = player:fireExplosion(player.x + 7 * (player.xscale * -1), player.y, 15 / 19, 8 / 4, 2, nil, spr.Sparks2)
					bullet:set("knockback", 2)
					bullet:set("knockback_direction", player.xscale * -1)
					if i ~= 0 then
						bullet:set("climb", i * 8)
					end
				end
			elseif relevantFrame == 7 then
				if onScreen(player) then
					misc.shakeScreen(1)
				end
				for i = 0, playerAc.sp do
					local bullet = player:fireExplosion(player.x + 7 * player.xscale, player.y, 15 / 19, 8 / 4, 2, nil, spr.Sparks2)
					bullet:set("knockback", 2)
					bullet:set("knockback_direction", player.xscale)
					if i ~= 0 then
						bullet:set("climb", i * 8)
					end
				end
			elseif relevantFrame == 10 then
				sShoot1_3:play(0.9 + math.random() * 0.2)
				if onScreen(player) then
					misc.shakeScreen(2)
				end
				for i = 0, playerAc.sp do
					local bullet = player:fireBullet(player.x, player.y, player:getFacingDirection() + 180, 500, 2, spr.Sparks1)
					bullet:set("knockback", 5)
					bullet:set("knockback_direction", player.xscale)
					if i ~= 0 then
						bullet:set("climb", i * 8)
					end
				end
			elseif relevantFrame == 16 then
				if playerAc.free == 0 then
					local sparks = obj.EfSparks:create(player.x, player.y + 6)
					sparks.sprite = player:getAnimation("shoot4ef")
					sparks.yscale = 1
				end
				
				Sound.find("KnightShoot4"):play(0.9 + math.random() * 0.2)
				
				local pushRange, buffRange = 80, 145
				
				local c = obj.EfCircle:create(player.x, player.y)
				c:set("radius", buffRange - 10)
				c.blendColor = player:getData()._EfColor
				
				player:fireExplosion(player.x, player.y - 5, 15 / 19, 10 / 4, 4)
				if playerAc.scepter > 0 then
					for i = 0, 15 do
						local xx = i * 12
						local fTrail = obj.FireTrail:create(player.x + xx * player.xscale, player.y - 20)
						fTrail:setAlarm(1, 60 + 60 * playerAc.scepter)
						fTrail:set("parent", player.id)
						fTrail:set("damage", player:get("damage") * 0.75)
					end
				end
				for _, actor in ipairs(pobj.actors:findAllEllipse(player.x - buffRange, player.y - buffRange, player.x + buffRange, player.y + buffRange)) do
					if actor:get("team") ~= playerAc.team and distance(actor.x, actor.y, player.x, player.y) <= pushRange then
						local xx = math.sign(actor.x - player.x)
						
						if not actor:isBoss() then
							if actor:isClassic() then
								actor:setAlarm(7, 2 * 60)
								actor:set("stunned", 1)
								obj.EfStun:create(actor.x, actor.y):set("parent", actor.id)
								actor:set("pVspeed", -2)
								actor:getData().xAccel = 3 * xx
							else
								actor:getData().xAccel = 6 * xx
							end
						end
					elseif actor:get("team") == playerAc.team and not isaDrone(actor) then
						actor:applyBuff(player:getData().vBuff, 300 + playerAc.scepter * 120)
					end
				end
				if onScreen(player) then
					misc.shakeScreen(15)
				end
			end
		end
	end
end)

survivor:addCallback("scepter", function(player)
	if SurvivorVariant.getActive(player) == crusader then
		player:setSkill(4,
		"Hell's Gate", "Fire twice for 400% total damage. Strike your halberd, knocking enemies back. Allies receive a fire damage bonus for 6 seconds. Sets the ground on fire.",
		sprSkills, 5, 11 * 60)
	end
end)
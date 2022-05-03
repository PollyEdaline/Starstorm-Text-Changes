-- FATMANDO (THANKS, SCOOT!)

local path = "Survivors/Commando/Skins/Fatmando/"

local survivor = sur.Commando -- Setting the survivor, in your code it would be 'Survivor.find("Commando", "vanilla")'
local sprSelect = Sprite.load("FatmandoSelect", "Survivors/Commando/Skins/Fatmando/Select", 12, 2, 0) -- Selection sprite
local commandoFat = SurvivorVariant.new(survivor, "Fatmando", sprSelect, {
	idle = Sprite.load("FatmandoIdle", path.."Idle", 1, 6, 6),
	walk = Sprite.load("FatmandoWalk", path.."Walk", 8, 8, 16),
	jump = Sprite.load("FatmandoJump", path.."Jump", 1, 4, 4),
	climb = Sprite.load("FatmandoClimb", path.."Climb", 2, 4, 5),
	death = Sprite.load("FatmandoDeath", path.."Death", 5, 10, 3),
	
	shoot1 = Sprite.load("FatmandoShoot1", path.."Shoot1", 5, 4, 7),
	shoot2 = Sprite.load("FatmandoShoot2", path.."Shoot2", 5, 6, 6),
	shoot3 = Sprite.load("FatmandoShoot3", path.."Shoot3", 13, 9, 6),
	shoot4_1 = Sprite.load("FatmandoShoot4A", path.."Shoot4_1", 15, 17, 8),
	shoot4_2 = Sprite.load("FatmandoShoot4B", path.."Shoot4_2", 15, 17, 8),
	shoot5_1 = Sprite.load("FatmandoShoot5A", path.."Shoot4_1", 15, 17, 8),
	shoot5_2 = Sprite.load("FatmandoShoot5B", path.."Shoot4_2", 15, 17, 8),
}) -- Setting the skin with the appropiate animation sprites and keys
SurvivorVariant.setInfoStats(commandoFat, {{"Strength", 5}, {"Vitality", 6}, {"Toughness", 2}, {"Agility", 4}, {"Difficulty", 5}, {"Weight", 10}})
SurvivorVariant.setDescription(commandoFat, "Who gave him &y&cake&!&?!") -- Setting info

commandoFat.endingQuote = "..and so he left, with everything but his diet."

local sprSkill = Sprite.load("FatmandoSkill", path.."Skill", 1, 0, 0)

SurvivorVariant.setLoadoutSkill(commandoFat, "Total Dive", "&b&Launch yourself into the air&!& and &y&knock enemies back on impact for 100% damage. &y&Fatmando&!& deals damage on impact from great heights.", sprSkill, 1)

callback.register("onSkinInit", function(player, skin)
	if skin == commandoFat then
		player:set("pHmax", player:get("pHmax") - 0.3)
		player:set("pVmax", player:get("pVmax") - 1.2)
		if Difficulty.getActive() == dif.Drizzle then
			player:survivorSetInitialStats(180, 11, 0.042)
		else
			player:survivorSetInitialStats(130, 11, 0.012)
		end
		player:setSkill(3,
		"Total Dive",
		"Launch yourself into the air and knock enemies back on impact for 100% damage.",
		sprSkill, 1, 2 * 60)
	end
end)
survivor:addCallback("onSkill", function(player, skill, relevantFrame)
	if SurvivorVariant.getActive(player) == commandoFat then
		local playerAc = player:getAccessor()
		if skill == 3 and playerAc.pVspeed > -1 then
			if relevantFrame == 1 then
				playerAc.pVspeed = -3.5
			elseif global.timer % 3 == 0 then
				player:fireBullet(player.x + 10 * player.xscale * -1, player.y, player:getFacingDirection(), 10, 1, nil, DAMAGER_NO_PROC):set("knockback", 15):set("knockup", 3)
			end
			if player:collidesWith(obj.Rope, player.x + playerAc.pHspeed, player.y) and playerAc.ropeUp == 1 then
				player.subimage = player.sprite.frames
			end
			if player.xscale > 0 and playerAc.moveLeft == 1 or player.xscale < 0 and playerAc.moveRight == 1 then
				player.subimage = player.sprite.frames
			end
		end
		
	end
end)
survivor:addCallback("step", function(player)
	if SurvivorVariant.getActive(player) == commandoFat then
		local playerAc = player:getAccessor()
		if playerAc.free == 0 and (player:getData()._lastpVspeed or 0) > 5 then
			sfx.ExplosiveShot:play()
			misc.shakeScreen(5)
			player:fireExplosion(player.x, player.y, 30 / 19, 30 / 4, player:getData()._lastpVspeed - 2, spr.EfMissileExplosion)
		end
		player:getData()._lastpVspeed = player:get("pVspeed")
	end
end)
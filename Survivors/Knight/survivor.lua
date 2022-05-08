local path = "Survivors/Knight/"

local Knight = Survivor.new("Knight")

-- Sounds
local sKnightShoot1 = {
	Sound.load("KnightShoot1A", path.."skill1a"),
	Sound.load("KnightShoot1B", path.."skill1b"),
	Sound.load("KnightShoot1C", path.."skill1c"),
	Sound.load("KnightShoot1D", path.."skill1d")
}
local sKnightShoot2a = Sound.load("KnightShoot2A", path.."skill2")
local sKnightShoot2b = Sound.load("KnightShoot2B", path.."skill2impact")
local sKnightShoot2c = Sound.load("KnightShoot2C", path.."skill2deflect")
local sKnightShoot3 = {
	Sound.load("KnightShoot3A", path.."skill3a"),
	Sound.load("KnightShoot3B", path.."skill3b")
}
local sKnightShoot4 = Sound.load("KnightShoot4", path.."skill4")

-- Table sprites
local sprites = {
	idle = Sprite.load("Knight_Idle", path.."idle", 1, 8, 12),
	walk = Sprite.load("Knight_Walk", path.."walk", 8, 8, 12),
	jump = Sprite.load("Knight_Jump", path.."jump", 1, 8, 12),
	climb = Sprite.load("Knight_Climb", path.."climb", 2, 4, 8),
	death = Sprite.load("Knight_Death", path.."death", 9, 9, 11),
	decoy = Sprite.load("Knight_Decoy", path.."decoy", 1, 9, 18),
	
	shoot1_1 = Sprite.load("Knight_Shoot1_1", path.."shoot1_1", 4, 8, 14),
	shoot1_2 = Sprite.load("Knight_Shoot1_2", path.."shoot1_2", 4, 8, 16),
	shoot1_3 = Sprite.load("Knight_Shoot1_3", path.."shoot1_3", 6, 8, 12),
	shoot2 = Sprite.load("Knight_Shoot2", path.."shoot2", 5, 8, 12),
	shoot3 = Sprite.load("Knight_Shoot3", path.."shoot3", 7, 10, 22),
	shoot4 = Sprite.load("Knight_Shoot4", path.."shoot4", 18, 17, 19),
	shoot4ef = Sprite.load("Knight_Shoot4Ef", path.."shoot4ef", 5, 76, 19)
}

-- Skill sprites
local sprSkills = Sprite.load("Knight_Skills", path.."skills", 6, 0, 0)

local sprSparks1 = Sprite.load("Knight_Sparks1", path.."sparks1", 4, 7, 7)
local sprSparks2 = Sprite.load("Knight_Sparks2", path.."sparks2", 4, 10, 10)

-- Selection sprite
Knight.loadoutSprite = Sprite.load("Knight_Select", path.."select", 19, 2, 0)

-- Selection description
Knight:setLoadoutInfo(
[[The &y&Knight&!& is a seasoned swordsman who is determined to protect
and empower his allies with an old-school sword and shield combo.
Capable of deflecting attacks when timed correctly, his shield mastery
brings him a level of protection unlike any other warrior of his class.
Every primary attack after using &y&Contend &b&stuns enemies&!&.]], sprSkills)

-- Skill descriptions

Knight:setLoadoutSkill(1, "Duel",
[[Slash forward for &y&100% damage&!&.]])

Knight:setLoadoutSkill(2, "Contend",
[[Hold to &b&reduce all incoming damage by 50%&!&.
For a short window of time, parry enemy attacks for &y&800% damage&!&.]])

Knight:setLoadoutSkill(3, "Strike",
[[Dash and slash forward for &y&200% damage&!&.
&y&Stuns enemies briefly&!&.]])

Knight:setLoadoutSkill(4, "Invigorate",
[[Slash twice for &y&400% damage&!&. Strike your shield, &b&knocking all
&b&enemies back&!&. &b&Allies receive an attack speed bonus for 3 seconds&!&.]])

-- Color of highlights during selection
Knight.loadoutColor = Color.fromHex(0xEAB779)

-- Misc. menus sprite
Knight.idleSprite = sprites.idle

-- Main menu sprite
Knight.titleSprite = sprites.walk

-- Endquote
Knight.endingQuote = "..and so he left, stripped of all hope."
 
local buffInvigorate = Buff.new("knightBuff")
buffInvigorate.sprite = Sprite.load("Knight_Buff", path.."buff", 1, 9, 9)
buffInvigorate:addCallback("start", function(actor)
	actor:set("attack_speed", actor:get("attack_speed") + 0.4)
end)
buffInvigorate:addCallback("end", function(actor)
	actor:set("attack_speed", actor:get("attack_speed") - 0.4)
end)

Knight:addCallback("init", function(player)
	local playerAc = player:getAccessor()
	local playerData = player:getData()
	
	playerAc.pHmax = playerAc.pHmax - 0.1
	playerData._EfColor = Color.fromHex(0xD8E5A2)
	playerData.vBuff = buffInvigorate
	playerData.count = 0
	playerData.otherSkill = false
	
	player:setAnimations(sprites)
	
	if Difficulty.getActive() == dif.Drizzle then
		player:survivorSetInitialStats(151, 13, 0.0395)
	else
		player:survivorSetInitialStats(101, 13, 0.0095)
	end
	
	player:setSkill(1, "Duel", "Slash forward for 100% damage.",
	sprSkills, 1, 25)
		
	player:setSkill(2, "Contend", "Hold to reduce incoming damage by 50%. Parry attacks, deflecting them for 800% damage. Can interrupt other skills.",
	sprSkills, 2, 2 * 60)
		
	player:setSkill(3, "Strike", "Dash and slash forward for 200% damage. Stuns enemies briefly.",
	sprSkills, 3, 4 * 60)
		
	player:setSkill(4, "Invigorate", "Slash twice for 400% damage. Strike your shield, knocking enemies back. Allies receive an attack speed bonus for 3 seconds.",
	sprSkills, 4, 10 * 60)
end)

-- Called when the player levels up
Knight:addCallback("levelUp", function(player)
	player:survivorLevelUpStats(24, 5, 0.0013, 3)
end)

-- Called when the player picks up the Ancient Scepter
Knight:addCallback("scepter", function(player)
	player:setSkill(4,
		"Invigorate", "Slash twice for 400% damage. Strike your shield, knocking enemies back. Allies receive an attack speed bonus for 6 seconds. Sets the ground on fire.",
		sprSkills, 5, 10 * 60
	)
end)

-- Skills
Knight:addCallback("useSkill", function(player, skill)
	local playerAc = player:getAccessor()
	local playerData = player:getData()
	if playerAc.activity == 0 then
		local cd = true
		
		if skill == 1 then
			-- Z skill
			if playerData.otherSkill then
				playerData.otherSkill = false
				player:survivorActivityState(1.2, player:getAnimation("shoot1_3"), 0.25, true, true)
			else
				if playerData.count == 0 then
					player:survivorActivityState(1.1, player:getAnimation("shoot1_1"), 0.2, true, true)
				elseif playerData.count == 1 then
					player:survivorActivityState(1.1, player:getAnimation("shoot1_2"), 0.2, true, true)
				end
			end
		elseif skill == 2 then
			-- X skill
			player:survivorActivityState(2, player:getAnimation("shoot2"), 0.25, false, true)
			if not player:getData().skin_skill1Override then
				playerData.otherSkill = true
			end
		elseif skill == 3 then
			-- C skill
			player:survivorActivityState(3, player:getAnimation("shoot3"), 0.25, true, false)
			if not player:getData().skin_skill1Override then
				--playerData.otherSkill = true
			end
		elseif skill == 4 then
			-- V skill
			player:survivorActivityState(4, player:getAnimation("shoot4"), 0.25, false, true)
			if not player:getData().skin_skill1Override then
				--playerData.otherSkill = true
			end
		end
		if cd then
			player:activateSkillCooldown(skill)
		end
		if not player:getData().skin_skill1Override then
			if playerData.otherSkill then
				player:setSkill(1, "Clash", "Stun enemies forward for 100% damage.", sprSkills, 6, 25)
			else
				player:setSkill(1, "Duel", "Slash forward for 100% damage.", sprSkills, 1, 25)
			end
		end
	elseif skill == 2 and playerAc.activity ~= 2 then
		player.subimage = player.sprite.frames
	end
end)

Knight:addCallback("onSkill", function(player, skill, relevantFrame)
	local playerAc = player:getAccessor()
	local playerData = player:getData()
	
	if skill == 1.1 and not player:getData().skin_skill1Override then
		-- Duel
		if relevantFrame == 1 then
			playerData.count = playerData.count + 1
			if playerData.count > 1 then
				playerData.count = 0
			end
			table.irandom(sKnightShoot1):play(0.9 + math.random() * 0.2)
			if not player:survivorFireHeavenCracker(1) then
				for i = 0, playerAc.sp do
					local bullet = player:fireExplosion(player.x + player.xscale * 10, player.y, 27 / 19, 5 / 4, 1, nil, sprSparks1)
					bullet:getData().pushSide = 1.2 * player.xscale
					if i ~= 0 then
						bullet:set("climb", i * 8)
					end
				end
			end
			player:getData().xAccel = 1 * player.xscale
			if onScreen(player) then
				misc.shakeScreen(1)
			end
		end
	elseif skill == 1.2 and not player:getData().skin_skill1Override then
		if relevantFrame == 1 then
			sKnightShoot2b:play(0.8 + math.random() * 0.2)
			for i = 0, playerAc.sp do
				local bullet = player:fireExplosion(player.x + player.xscale * 15, player.y, 25 / 19, 5 / 4, 1, nil, sprSparks1)
				bullet:getData().pushSide = 1.5 * player.xscale
				bullet:set("stun", 0.75)
				if i ~= 0 then
					bullet:set("climb", i * 8)
				end
			end
			player:getData().xAccel = 1 * player.xscale
			if onScreen(player) then
				misc.shakeScreen(1)
			end
		end
	elseif skill == 2 and not player:getData().skin_skill2Override then
		-- Contend
		if relevantFrame == 1 then
			sKnightShoot2a:play(0.9 + math.random() * 0.2)
			playerData.skill2Used = true
			if not playerData.knightShield then
				playerData.knightShield = true
				playerAc.armor = playerAc.armor + 100
				if not playerData.k_scarf then
					playerData.k_scarf = player:get("scarf")
					player:set("scarf", 0)
				end
			end
			playerData.parry = 19
			if onScreen(player) then
				misc.shakeScreen(2)
			end
			--playerAc.invincible = 18
		end
		
		if player.subimage > 4 then
			if playerData.skill2Used then
				player.subimage = 4
				player:activateSkillCooldown(2)
			elseif player.subimage < player.sprite.frames - 2 then
				player.subimage = player.sprite.frames - 2
			end
		end
		
	elseif skill == 3 and not player:getData().skin_skill3Override then
        -- Strike
		if relevantFrame == 1 then
			if onScreen(player) then
				misc.shakeScreen(1)
			end
			table.irandom(sKnightShoot3):play(0.9 + math.random() * 0.2)
			player:getData().xAccel = player.xscale * (playerAc.pHmax * 2.3)
			
			local add = playerAc.pHmax * 4
			
			for i = 0, playerAc.sp do
				local bullet = player:fireExplosion(player.x + (add * 0.5) + player.xscale * 6, player.y - 5, (36 + add) / 19, 20 / 4, 2, nil, sprSparks2)
				bullet:getData().pushSide = player:getData().xAccel
				bullet:set("stun", 0.5)
				if i ~= 0 then
					bullet:set("climb", i * 8)
				end
			end
			if onScreen(player) then
				misc.shakeScreen(2)
			end
		end
		if playerAc.invincible < 5 then
			playerAc.invincible = 5
		end
		
	elseif skill == 4 and not player:getData().skin_skill4Override then
		-- Execution
		if relevantFrame == 3 or relevantFrame == 6 then
			table.irandom(sKnightShoot1):play(0.7 + math.random() * 0.2)
			for i = 0, playerAc.sp do
				local bullet = player:fireExplosion(player.x + player.xscale * 13, player.y - 5, 18 / 19, 10 / 4, 4, nil, sprSparks2)
				--bullet:getData().pushSide = player:getData().xAccel
				if i ~= 0 then
					bullet:set("climb", i * 8)
				end
			end
			if onScreen(player) then
				misc.shakeScreen(2)
			end
		elseif relevantFrame == 13 then
			if playerAc.free == 0 then
				local sparks = obj.EfSparks:create(player.x, player.y + 6)
				sparks.sprite = player:getAnimation("shoot4ef")
				sparks.yscale = 1
			end
			
			sKnightShoot4:play(0.9 + math.random() * 0.2)
			
			local pushRange, buffRange = 80, 145
			
			local c = obj.EfCircle:create(player.x, player.y)
			c:set("radius", buffRange - 10)
			c.blendColor = playerData._EfColor
			
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
					actor:applyBuff(playerData.vBuff, 180 + playerAc.scepter * 60)
				end
			end
			if onScreen(player) then
				misc.shakeScreen(15)
			end
		end
		if playerAc.invincible < 5 then
			playerAc.invincible = 5
		end
	end
end)

local preHitCall = function(damager, hit)
	local parent = damager:getParent()
	if hit:getData().parry then
		local damagerAc = damager:getAccessor()
		damager:getData().cancelDamage = true
		sKnightShoot2c:play(0.9 + math.random() * 0.2)
		
		if parent and parent:isValid() then
			local bullet = hit:fireExplosion(parent.x, parent.y, 1 / 19, 1 / 4, (damagerAc.damage * 8) / hit:get("damage"), spr.SpaceshipFlash)
			--bullet:set("specific_target", parent.id)
			obj.EfFlash:create(0,0):set("parent", hit.id):set("rate", 0.08).depth = -9
			obj.EfFlash:create(0,0):set("parent", parent.id):set("rate", 0.08).depth = -9
			hit:getData().parryEffect = {t = 15, x = parent.x, y = parent.y, x2 = hit.x, y2 = hit.y}
			local c = obj.EfCircle:create(hit.x, hit.y)
			c:set("radius", 5)
			c.blendColor = Color.WHITE
			
			hit:getData().achievementAdd = (hit:getData().achievementAdd or 0) + 1
		end
		
		damagerAc.damage = 0
	elseif hit:getData().knightShield then
		sKnightShoot2b:play(0.9 + math.random() * 0.2)
	end
end

local onDamageCall = function(target, damage, source)
	if target and target:isValid() then
		if target:getData().parry then
			return true
		end
	end
end

local preHitCall2 = function(damager, hit)
	if damager:getData().pushSide and not hit:isBoss() then
		hit:getData().xAccel = damager:getData().pushSide
	end
end

Knight:addCallback("step", function(player)
	local playerData = player:getData()
	local playerAc = player:getAccessor()
	
	if playerData.parry then
		if playerData.parry > 0 then
			playerData.parry = playerData.parry - 1
		else
			if playerData.k_scarf then
				player:set("scarf", player:get("scarf") + playerData.k_scarf)
				playerData.k_scarf = nil
			end
			playerData.parry = nil
		end
	end
	
	local syncRelease = syncControlRelease(player, "ability2")
	if playerAc.activity == 2 and not playerData.skin_skill2Override then
		if syncRelease and playerData.skill2Used then
			playerData.skill2Used = nil
			if player.subimage > 3 then
				player.subimage = player.sprite.frames - 2
			end
		end
	end
	
	if playerData.knightShield and not playerData.skill2Used then
		playerData.knightShield = nil
		playerAc.armor = playerAc.armor - 100
	end
end)
Knight:addCallback("draw", function(player)
	local playerData = player:getData()
	
	if playerData.parryEffect then
		if playerData.parryEffect.t > 0 then
			local mult = playerData.parryEffect.t / 15
			graphics.color(playerData._EfColor)
			graphics.alpha(mult)
			graphics.line(playerData.parryEffect.x, playerData.parryEffect.y, playerData.parryEffect.x2, playerData.parryEffect.y2, mult * 5)
			playerData.parryEffect.t = playerData.parryEffect.t - 1
		else
			playerData.parryEffect = nil
		end
	end
	
	if player.visible and playerData.parry and playerData.parry > 0 then
		graphics.alpha(0.5)
		graphics.color(playerData._EfColor)
		graphics.drawImage{
			image = player.sprite,
			x = player.x,
			y = player.y,
			subimage = player.subimage,
			solidColor = Color.WHITE,--playerData._EfColor,
			alpha = 0.5,
			angle = player.angle,
			xscale = player.xscale,
			yscale = player.yscale,
			width = player.sprite.width,
			height = player.sprite.height
		}
	end
end)

Knight:addCallback("init", function(player)
	tcallback.register("onDamage", onDamageCall)
	tcallback.register("preHit", preHitCall)
	tcallback.register("preHit", preHitCall2)
end)

sur.Knight = Knight
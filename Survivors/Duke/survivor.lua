local path = "Survivors/Duke/"

local Duke = Survivor.new("Duke")

if not global.rormlflag.ss_test then
	Duke.disabled = true
end

-- Sounds
--local sDukeShoot1 = Sound.load("DukeShoot1", path.."skill1")

local sprite = Sprite.load("Duke_Idle_1", path.."idle_1", 1, 5, 11)

-- Table sprites
local sprites = {
	idle = sprite,
	idle_1 = sprite,
	idle_2 = Sprite.load("Duke_Idle_2", path.."idle_2", 1, 5, 11),
	walk = Sprite.load("Duke_Walk", path.."walk", 8, 6, 11),
	jump = Sprite.load("Duke_Jump", path.."jump", 1, 5, 11),
	climb = Sprite.load("Duke_Climb", path.."climb", 2, 4, 8),
	death = Sprite.load("Duke_Death", path.."death", 10, 5, 11),
	decoy = sprite,
	
	shoot1_1 = Sprite.load("Duke_Shoot1_1", path.."shoot1_1", 3, 5, 11),
	shoot1_2 = Sprite.load("Duke_Shoot1_2", path.."shoot1_2", 4, 5, 11),
	shoot2 = Sprite.load("Duke_Shoot2", path.."shoot2", 5, 5, 16),
	shoot3 = Sprite.load("Duke_Shoot3", path.."shoot3", 5, 31, 11),
	shoot4 = Sprite.load("Duke_Shoot4", path.."shoot2", 5, 5, 16),
	shoot5 = Sprite.load("Duke_Shoot5", path.."shoot2", 5, 5, 16),
}

-- Skill sprites
local sprSkills = Sprite.load("Duke_Skills", path.."skills", 5, 0, 0)

-- Selection sprite
Duke.loadoutSprite = Sprite.load("Duke_Select", path.."select", 4, 2, 0)

-- Selection description
Duke:setLoadoutInfo(
[[The &y&Duke&!& is a strategic gunslinger.]], sprSkills)

-- Skill descriptions

Duke:setLoadoutSkill(1, "Royal Gun",
[[Fire for 80% damage.
Every fourth shot deals 270% additional damage.]])

Duke:setLoadoutSkill(2, "Kinetic Replicator",
[[Mark an enemy with a kinetic replicator.
Marked enemies receive the damage dealt to other enemies.]])

Duke:setLoadoutSkill(3, "Ambush",
[[Dash forward, becoming immune to attacks for a brief moment.
Loads the Royal Gun's fourth bullet.]])

Duke:setLoadoutSkill(4, "Watcher's Watch",
[[Slow down all enemies in an area around you for 6 seconds.]])

-- Color of highlights during selection
Duke.loadoutColor = Color.fromHex(0xB1454D)

-- Misc. menus sprite
Duke.idleSprite = sprites.idle

-- Main menu sprite
Duke.titleSprite = sprites.walk

-- Endquote
Duke.endingQuote = "..and so he left, plotting a new conquest."

Duke:addCallback("init", function(player)
	local playerAc = player:getAccessor()
	local playerData = player:getData()
	
	playerData._tList = {}
	
	playerAc.bulletCount = 0
	
	player:setAnimations(sprites)
	
	if Difficulty.getActive() == dif.Drizzle then
		player:survivorSetInitialStats(150, 13, 0.038)
	else
		player:survivorSetInitialStats(100, 13, 0.008)
	end
	
	player:setSkill(1, "", "",
	sprSkills, 1, 40)
		
	player:setSkill(2, "", "",
	sprSkills, 2, 4 * 60)
		
	player:setSkill(3, "", "",
	sprSkills, 3, 4 * 60)
		
	player:setSkill(4, "", "",
	sprSkills, 4, 10 * 60)
end)


-- Called when the player levels up
Duke:addCallback("levelUp", function(player)
	player:survivorLevelUpStats(24, 4, 0.0012, 2)
end)

-- Called when the player picks up the Ancient Scepter
Duke:addCallback("scepter", function(player)
	player:setSkill(4,
		"",
		"",
		sprSkills, 9,
		9 * 60
	)
end)

-- Skills
Duke:addCallback("useSkill", function(player, skill)
	local playerAc = player:getAccessor()
	if player:get("activity") == 0 then
		local cd = true
		
		if skill == 1 then
			-- Z skill
			if playerAc.bulletCount == 3 then
				player:survivorActivityState(1, player:getAnimation("shoot1_2"), 0.2, true, true)
			else
				player:survivorActivityState(1, player:getAnimation("shoot1_1"), 0.2, true, true)
			end
		elseif skill == 2 then
			-- X skill
			player:survivorActivityState(2, player:getAnimation("shoot2"), 0.25, true, true)
		elseif skill == 3 then
			-- C skill
			player:survivorActivityState(3, player:getAnimation("shoot3"), 0.25, false, false)
		elseif skill == 4 then
			-- V skill
			if playerAc.scepter > 0 then
				player:survivorActivityState(4, player:getAnimation("shoot5"), 0.25, true, false)
			else
				player:survivorActivityState(4, player:getAnimation("shoot4"), 0.25, true, false)
			end
		end
		if cd then
			player:activateSkillCooldown(skill)
		end
	end
end)

local buffSlowdown = Buff.new("slowdown")
buffSlowdown.sprite = Sprite.load("SlowdownBuff", path.."buff2", 1, 9, 9)

local slowdownMult = 0.8

buffSlowdown:addCallback("start", function(actor)
	local val1, val2 = actor:get("pHmax") * slowdownMult, actor:get("attack_speed") * slowdownMult
	actor:set("pHmax", actor:get("pHmax") - val1):set("attack_speed", actor:get("attack_speed") - val2)
	actor:getData().slowdownBuff = {val1, val2}
end)
buffSlowdown:addCallback("end", function(actor)
	if actor:getData().slowdownBuff then
		local val1, val2 = actor:getData().slowdownBuff[1], actor:getData().slowdownBuff[2]
		actor:set("pHmax", actor:get("pHmax") + val1):set("attack_speed", actor:get("attack_speed") + val2)
		actor:getData().slowdownBuff = nil
	end
end)

local buffDamageShare = Buff.new("damageshare")
buffDamageShare.sprite = Sprite.load("DamageShareBuff", path.."buff", 1, 9, 9)

buffDamageShare:addCallback("start", function(actor)
	if actor:getData().damageShareParent then
		actor:getData().damageShareParent:getData()._tList[actor] = true
	end
end)
buffDamageShare:addCallback("end", function(actor)
	if actor:getData().damageShareParent then
		actor:getData().damageShareParent:getData()._tList[actor] = nil
	end
	actor:getData().damageShareParent = nil
end)

local onDamageCall = function(target, damage, source)
	if source and source:isValid() and isa(source, "DamagerInstance") then
		local parent = source:getParent()
		if parent and parent:isValid() and parent:getData()._tList then
			for actor, _ in pairs(parent:getData()._tList) do
				if actor:isValid() then
					--if actor ~= target then
						actor:set("hp", actor:get("hp") - damage)
						actor:setAlarm(6, 60)
						
						local crit = false or source:get("critical") > 0
						
						if global.showDamage then
							misc.damage(source:get("damage_fake"), actor.x, actor.y - 10 , crit, Color.WHITE)
						end
						
						local outline = obj.EfOutline:create(0, 0):set("parent", actor.id):set("rate", 0.04)
						outline.blendColor = Color.RED
					--end
				else
					parent:getData()._tList[actor] = nil
				end
			end
		end
	end
	--[[if target:getData().damageShareParent then
		for _, actor in ipairs(pobj.actors:findAll()) do
			if actor:getData().damageShareParent == target:getData().damageShareParent and actor ~= target then
				actor:set("hp", actor:get("hp") - damage)
				actor:setAlarm(6, 60)
				
				local crit = false or source:get("critical") > 0
				
				misc.damage(source:get("damage_fake"), actor.x, actor.y - 10 , crit, Color.WHITE)
			end
		end
	end]]
end

callback.register("postSelection", function()
	for _, player in ipairs(misc.players) do
		if player:getSurvivor() == Duke then
			player:setAnimation("idle", player:getAnimation("idle_1"))
		end
	end
end)


Duke:addCallback("onSkill", function(player, skill, relevantFrame)
	local playerAc = player:getAccessor()
	
	if skill == 1 then
		-- Mortar
		if relevantFrame == 1 and not player:getData().skin_skill1Override then
			playerAc.bulletCount = playerAc.bulletCount + 1
			if playerAc.bulletCount == 4 then
				sfx.CowboyShoot4_2:play(1.5)
				for i = 0, playerAc.sp do
					local bullet = player:fireBullet(player.x, player.y, player:getFacingDirection(), 500, 3.5, nil)
					if i ~= 0 then
						bullet:set("climb", i * 8)
					end
				end
				if onScreen(player) then
					misc.shakeScreen(2)
				end
				playerAc.bulletCount = 0
			else
				sfx.Bullet2:play(1.3)
				for i = 0, playerAc.sp do
					local bullet = player:fireBullet(player.x, player.y, player:getFacingDirection(), 300, 0.8, nil)
					if i ~= 0 then
						bullet:set("climb", i * 8)
					end
				end
			end
		end
		player:setAnimation("idle", player:getAnimation("idle_2"))
		
	elseif skill == 2 and not player:getData().skin_skill2Override then
		-- Overcharge
		if relevantFrame == 2 then
			sfx.JanitorShoot2_1:play(1.3)
			local bullet = player:fireBullet(player.x, player.y, player:getFacingDirection(), 400, 0.1, nil)
			bullet:getData().applyDamageShareBuff = true
		end
		
	elseif skill == 3 and not player:getData().skin_skill3Override then
        -- Launch
		if relevantFrame == 1 then
			if playerAc.invincible < 15 then
				playerAc.invincible = 15
			end
			sfx.ClayShoot1:play(1.3)
			for i = 0, 20 do
				if player:collidesMap(player.x + player.xscale, player.y) then
					break
				else
					player.x = player.x + player.xscale
				end
			end
			player:getData().xAccel = playerAc.pHmax * 1 * player.xscale
			--player:set("pHspeed", playerAc.pHmax * 2 * player.xscale)
			playerAc.bulletCount = 3
		end

	elseif skill == 4 and not player:getData().skin_skill4Override then
		-- Execution
		if relevantFrame == 1 then
			sfx.Crowbar:play(0.5)
			local r = 200
			for _, actor in ipairs(pobj.actors:findAllRectangle(player.x - r, player.y - r, player.x + r, player.y + r)) do
				if actor:get("team") ~= playerAc.team then
					actor:applyBuff(buffSlowdown, 360)
				end
			end
		end
	end
end)

local preHitCall = function(damager, hit)
	if damager:getData().applyDamageShareBuff then
		hit:getData().damageShareParent = damager:getParent()
		hit:applyBuff(buffDamageShare, 480)
	end
end

callback.register("postSelection", function()
	for _, player in ipairs(misc.players) do
		if player:getSurvivor() == Duke then
			player:setAnimation("idle", player:getAnimation("idle_1"))
		end
	end
end)

Duke:addCallback("step", function(player)
	local playerData = player:getData()
	local playerAc = player:getAccessor()
	
	if playerAc.activity == 0 and player:getAnimation("idle") ~= player:getAnimation("idle_1") then
		if playerAc.moveRight == 1 or playerAc.moveLeft == 1 or playerAc.free == 1 then
			player:setAnimation("idle", player:getAnimation("idle_1"))
		end
	end
end)

Duke:addCallback("draw", function(player)
	local playerData = player:getData()
	local playerAc = player:getAccessor()
	
	for _, actor in ipairs(pobj.actors:findAll()) do
		if actor:getData().damageShareParent == player then
			
		end
	end
end)

Duke:addCallback("init", function(player)
	tcallback.register("onDamage", onDamageCall)
	tcallback.register("preHit", preHitCall)
end)

sur.Duke = Duke

-- All Beastmaster data

local path = "Survivors/Beastmaster/"

local beastmaster = Survivor.new("Chirr")

-- Sounds
local sShoot1 = Sound.load("Beastmaster_Shoot1A", path.."skill1")
local sShoot2 = Sound.load("Beastmaster_Shoot1B", path.."skill2")
local sShoot3a = Sound.load("Beastmaster_Shoot2A", path.."skill3A")
local sShoot3b = Sound.load("Beastmaster_Shoot2B", path.."skill3B")
local sShoot4 = Sound.load("Beastmaster_Shoot3A", path.."skill4")

-- Sprite Table
local sprites = {
	idle = Sprite.load("Beastmaster_Idle", path.."idle", 1, 12, 11),
	walk = Sprite.load("Beastmaster_Walk", path.."walk", 8, 13, 13),
	jump_2 = Sprite.load("Beastmaster_Jump", path.."jump", 1, 11, 13),
	flight = Sprite.load("Beastmaster_Flight", path.."flight", 1, 11, 15),
	wings = Sprite.load("Beastmaster_Wings", path.."wings", 3, 11, 15),
	climb = Sprite.load("Beastmaster_Climb", path.."climb", 2, 11, 10),
	death = Sprite.load("Beastmaster_Death", path.."death", 8, 16, 11),
	decoy = Sprite.load("Beastmaster_Decoy", path.."decoy", 1, 9, 10),
	
	shoot1 = Sprite.load("Beastmaster_Shoot1", path.."shoot1", 5, 17, 11),
	shoot2 = Sprite.load("Beastmaster_Shoot2", path.."shoot2", 7, 23, 11),
	shoot3 = Sprite.load("Beastmaster_Shoot3", path.."shoot3", 13, 19, 27),
	shoot4 = Sprite.load("Beastmaster_Shoot4", path.."shoot4", 10, 3, 4),
}
-- Hit sprites
local sprSparks = Sprite.load("Beastmaster_Sparks", path.."sparks", 3, 11, 3)

-- Skill sprites
local sprSkills = Sprite.load("Beastmaster_Skills", path.."skills", 6, 0, 0)

-- Selection sprite
beastmaster.loadoutSprite = Sprite.load("Beastmaster_Select", path.."select", 15, 2, 0)

-- Selection description
beastmaster:setLoadoutInfo(
[[&y&Chirr&!& is a mystical creature who holds a pure connection with the planet.
Her innate healing properties give her a highly supportive role, able to withdraw
from any battle easily thanks to her ability to hover.
Chirr can befriend one creature at a time through her &y&Natural Link&!& skill.]], sprSkills)

-- Skill descriptions
beastmaster:setLoadoutSkill(1, "Life Thorns",
[[Shoot 3 projectiles for &y&260% total damage.&y&]])

beastmaster:setLoadoutSkill(2, "Headbutt",
[[Headbutt enemies in front of you for &y&300% damage,
&y&stunning them&!& for 3 seconds.]])

beastmaster:setLoadoutSkill(3, "Sanative Aura",
[[&g&Heal yourself and nearby allies for 25% of their total health.&!&
Healed allies gain &g&increased health regeneration&!& for 6 seconds.]])

beastmaster:setLoadoutSkill(4, "Natural Link / Unbreakable Bond",
[[&g&Befriend&!& the last hit creature if it's &y&below 50% of its total health.
&y&Pull or call the befriended creature. Redirect damage to it for as long as you hold it.]])

-- Color of highlights during selection
beastmaster.loadoutColor = Color.fromHex(0x81A762)

-- Misc. menus sprite
beastmaster.idleSprite = sprites.idle

-- Main menu sprite
beastmaster.titleSprite = sprites.walk

-- Endquote
beastmaster.endingQuote = "..and so she left, carrying new life in her spirit."

-- Stats & Skills
beastmaster:addCallback("init", function(player)
	local playerAc = player:getAccessor()
	playerAc.pGravity1 = 0.2
	playerAc.pGravity2 = 0.08
	playerAc.pHmax = 0.9
	player:getData().wingStep = 1
	
	player:setAnimations(sprites)
	
	if Difficulty.getActive() == dif.Drizzle then
		player:survivorSetInitialStats(152, 11, 0.034)
	else
		player:survivorSetInitialStats(102, 11, 0.014)
	end
	
	player:setSkill(1, "Life Thorns", "Shoot 3 projectiles for 260% total damage",
	sprSkills, 1, 30)
		
	player:setSkill(2, "Headbutt", "Headbutt and stun enemies for 300% damage.",
	sprSkills, 2, 4 * 60)
		
	player:setSkill(3, "Sanative Aura", "Heal nearby allies for 25% of their health, leaving them with a heal over time.",
	sprSkills, 3, 15 * 60)
		
	player:setSkill(4, "Natural Link", "Tame the last hit enemy if it's below 50% of its max health.",
	sprSkills, 4, 4 * 60)
end)

-- Called when the player levels up
beastmaster:addCallback("levelUp", function(player)
	player:survivorLevelUpStats(29, 3, 0.0023, 2)
end)


-- Skills

-- Skill Activation

local actors = pobj.actors
local enemies = pobj.enemies
local players = obj.P
local playertarget = obj.POI

local syncTamed
syncTamed = net.Packet.new("SSTamedActor", function(sender, actor, parent)
	local actorI = actor:resolve()
	local parentI = parent:resolve()
	if actorI and actorI:isValid() and parentI and parentI:isValid() then
		makeTamed(actorI, parentI)
		if parentI:getData().e_outline and parentI:getData().e_outline:isValid() then
			parentI:getData().e_outline:destroy()
		end
		if net.host then
			syncTamed:sendAsHost(net.EXCLUDE, sender, actor, parent)
		end
	end
end)

local tameBlacklist = {
	[obj.LizardF] = true,
	[obj.LizardFG] = true,
	[obj.Turtle] = true,
	[obj.Worm] = true,
	[obj.WormBody] = true,
	[obj.WormHead] = true,
	[obj.WurmBody] = true,
	[obj.WurmHead] = true
}

if not global.rormlflag.ss_disable_enemies then
	tameBlacklist[obj.ArcherBugHive] = true
	tameBlacklist[obj.TotemPart] = true
	tameBlacklist[obj.WyvernHead] = true
	tameBlacklist[obj.WyvernTail] = true
	tameBlacklist[obj.Arraign1] = true
	tameBlacklist[obj.Arraign2] = true
end

beastmaster:addCallback("useSkill", function(player, skill)
	local playerAc = player:getAccessor()
	if player:get("activity") == 0 then
		if skill == 1 then
			-- Z skill
			player:survivorActivityState(1, player:getAnimation("shoot1"), 0.25, true, true)
		elseif skill == 2 then
			-- X skill
			player:survivorActivityState(2, player:getAnimation("shoot2"), 0.26, true, true)
		elseif skill == 3 then
			-- C skill
			player:survivorActivityState(3, player:getAnimation("shoot3"), 0.2, false, true)
		elseif skill == 4 and not player:getData().skin_skill4Override then
			-- V skill
			local child = player:getData().tameChild 
			if child and child:isValid() then
				player:getData().linked = child
				--child:getData().linked = player
				playerAc.hp = math.max(playerAc.hp, 1)
				
				-- I am terrible at coding physics
				
				local cx, cy = child.x, child.y
				local px, py = player.x, player.y
				
				local ph, pv = playerAc.pHspeed, playerAc.pVspeed
				
				local dis = distance(child.x, child.y, px, py)
				local speed = dis
				local capM = 1
				
				if dis > 340 and player:getData().teleport and player:getData().teleport > 1 or dis > 280 and not child:isClassic() then
					if child:isClassic() and not child:getData().rx then
						child.x = player.x
						child.y = player.y
						obj.EfFlash:create(0,0):set("parent", child.id):set("rate", 0.08)
					else
						local ground = obj.B:findNearest(player.x, player.y)
						if ground and ground:isValid() then
							local image = child.mask or child.sprite
							child.x = ground.x + (image.yorigin)
							child.y = ground.y - (image.height - image.yorigin)
							obj.EfFlash:create(0,0):set("parent", child.id):set("rate", 0.08)
						end
					end
				end
				player:getData().teleport = 2
				
				if child:isClassic() and not child:getData().rx then
					local deccel = 0.15
					if child:get("free") == 0 then
						deccel = 0.5
					end
					
					if not player:getData().teleport or player:getData().teleport < 1.6 then
						speed = speed * 3.5
						capM = 2.5
						deccel = 0
					end
					
					local pH = (px - child.x) * (speed * 0.000036)
					local pV = (py - child.y) * (speed * 0.000037)
					
					if not child:getData().xAccel then
						child:getData().xAccel = 0
					end
					if not child:getData().yAccel then --had to check separately, there is a really rare bug where this errored
						child:getData().yAccel = 0
					end
					
					if child:collidesMap(child.x + child:getData().xAccel, child.y) or child:collidesMap(child.x - child:getData().xAccel, child.y) then
						child:getData().xAccel = 0
					end
					
					-- I can't code physics ok
					
					child:getData().xAccel = math.clamp(math.approach(child:getData().xAccel + pH, 0, deccel), -7 * capM, 7 * capM)
					child:getData().yAccel = math.clamp(math.approach(child:getData().yAccel + pV + 0.25, 0, deccel), -9 * capM, 6 * capM)
					
					child.x = child.x + child:getData().xAccel
					child.y = child.y + child:getData().yAccel
					child:set("pHspeed", 0)
					child:set("pVspeed", 0)
				end
				
				child:set("ghost_x", child.x)
				child:set("ghost_y", child.y)
				
			else
				local display = obj.EfSparks:create(player.x, player.y - 15)
				display.sprite = player:getAnimation("shoot4")
				display.yscale = 1
				sShoot4:play(0.9 + math.random() * 0.07, 0.8)	
				if player:getData().TlastHit and player:getData().TlastHit:isValid() then
					local actor = player:getData().TlastHit
					local actorAc = actor:getAccessor()
					if actorAc.team ~= playerAc.team and not tameBlacklist[actor:getObject()] and not isa(actor, "PlayerInstance") then
						if actor:isBoss() == false and actorAc.show_boss_health == 0 and actorAc.hp <= actorAc.maxhp * 0.5 or playerAc.scepter > 0 and actorAc.hp <= actorAc.maxhp * 0.3 then
							if net.online then
								if net.localPlayer == player then
									makeTamed(actor, player)
									if net.host then
										syncTamed:sendAsHost(net.ALL, nil, actor:getNetIdentity(), player:getNetIdentity())
									else
										syncTamed:sendAsClient(actor:getNetIdentity(), player:getNetIdentity())
									end
								end
							else
								makeTamed(actor, player)
							end
							if player:getData().e_outline and player:getData().e_outline:isValid() then
								player:getData().e_outline:destroy()
							end
						end
						
					end
				end
			end
		end
		player:activateSkillCooldown(skill)
	end
end)

beastmaster:addCallback("onSkill", function(player, skill, relevantFrame)
	local playerAc = player:getAccessor()
	
	if skill == 1 and not player:getData().skin_skill1Override then
		-- Thorns
		if relevantFrame == 2 or relevantFrame == 3 or relevantFrame == 4 then
			sShoot1:play(1.5 + math.random() * 0.07, 0.4)	
			if relevantFrame == 2 then
				if player:survivorFireHeavenCracker() == nil then
					for i = 0, playerAc.sp do
						local bullet = player:fireBullet(player.x, player.y, player:getFacingDirection(), 200, 1, sprSparks)
						bullet:getData()._chirrTag = true
						if i ~= 0 then
							bullet:set("climb", i * 8)
						end
					end
				end
			else
				for i = 0, playerAc.sp do
					local bullet = player:fireBullet(player.x, player.y, player:getFacingDirection(), 190, 0.6, sprSparks)
					bullet:getData()._chirrTag = true
					if i ~= 0 then
						bullet:set("climb", i * 8)
					end
				end
			end
		end
		
	elseif skill == 2 and not player:getData().skin_skill2Override then
		-- Quarantine
		if relevantFrame == 2 then
			sShoot2:play(0.9 + math.random() * 0.07, 0.7)	
			for i = 0, playerAc.sp do
				local bullet = player:fireBullet(player.x, player.y, player:getFacingDirection(), 50, 3, spr.Sparks7, DAMAGER_BULLET_PIERCE)
				bullet:getData()._chirrTag = true
				bullet:set("knockback", bullet:get("knockback") + 5)
				bullet:set("knockup", bullet:get("knockup") + 1)
				bullet:set("climb", i * 8)
				bullet:set("stun", bullet:get("stun") + 2)
			end
		end
		
	elseif skill == 3 and not player:getData().skin_skill3Override then
        -- Headbutt
		local range = 150
		
		local size = player:getData().skillCircleAnim
		if relevantFrame < player.sprite.frames - 1 then
			if size then
				player:getData().skillCircleAnim = math.approach(size, 1, (1 - size) * 0.2)
			else
				player:getData().skillCircleAnim = 0
			end
			size = player:getData().skillCircleAnim
			if	player:getData().skillCircle then
				player:getData().skillCircle.radius = size * range -- ugly code ugh.
			end
		end

		if relevantFrame > 0 and relevantFrame < player.sprite.frames - 1 then
			local power = relevantFrame / (player.sprite.frames - 1)
			player:getData().skillCircle = {alpha = power, color = Color.mix(Color.WHITE, Color.DAMAGE_HEAL, power), radius = size * range}
			if relevantFrame == 1 then
				sShoot3a:play(0.9 + math.random() * 0.07, 0.7)
			end
        elseif relevantFrame == player.sprite.frames - 1 then
			sShoot3b:play(0.9 + math.random() * 0.07, 0.8)
			player:getData().skillCircle = nil
			for _, actor in ipairs(actors:findAllEllipse(player.x - range, player.y - range, player.x + range, player.y + range)) do
				if actor:get("team") == player:get("team") then
					if not actor:get("dead") or actor:get("dead") == 0 then 
						par.HealPixel:burst("above", actor.x, actor.y, 1, Color.DAMAGE_HEAL)
						local dif = actor:get("maxhp") - actor:get("hp")
						local heal = (actor:get("maxhp") * 0.25)
						actor:set("hp", actor:get("hp") + heal)
						if not isaDrone(actor) then
							actor:applyBuff(buff.chirrHeal, 360)
						end
						if dif > 0 then
							local circle = obj.EfCircle:create(actor.x, actor.y)
							circle:set("radius", 0.1)
							circle:set("rate", 5)
							circle.blendColor = Color.DAMAGE_HEAL
							if global.showDamage then
								misc.damage(math.min(heal, dif), actor.x, actor.y - 7, false, Color.DAMAGE_HEAL)
							end
						end
						if not isa(actor, "PlayerInstance") then
							actor:setAlarm(6, math.max(360, actor:getAlarm(6)))
						end
					end
				end
			end
			player:getData().skillCircleAnim = 0
			local circle = obj.EfCircle:create(player.x, player.y)
			circle:set("radius", range)
			circle.blendColor = Color.DAMAGE_HEAL
		end
		
	end
end)

-- Taming

table.insert(call.preHit, function(damager, actor)
	local parent = damager:getParent()
	local actorAc = actor:getAccessor()
	
	if damager:getData()._chirrTag and parent and parent:isValid() then
		if actorAc.team ~= parent:get("team") then
			parent:getData().TlastHit = actor
		end
	end
	
	if actor:getData().linked and actor:getData().linked:isValid() then
		local linkActor = actor:getData().linked
		local otherDmg = damager:get("damage")
		damager:set("damage", 0)
		damager:set("damage_fake", 0)
		linkActor:set("hp", linkActor:get("hp") - otherDmg)
		
		local crit = false
		if damager:get("critical") == 1 then crit = true end
		if global.showDamage then
			misc.damage(otherDmg, linkActor.x, linkActor.y, crit, Color.DAMAGE_ENEMY)
		end
	end
end)

callback.register("onItemPickup", function(item, player)
	if player:getSurvivor() == beastmaster then
		local child = player:getData().tameChild 
		if child and child:isValid() then
			NPCItems.giveItem(child, item:getItem(), 1)
		end
		--player:getData().updateVariables = true
	end
end)
callback.register("onItemRemoval", function(player, item, amount)
	if player:getSurvivor() == beastmaster then
		local child = player:getData().tameChild 
		if child and child:isValid() then
			NPCItems.removeItem(child, item, amount)
		end
	end
end)


beastmaster:addCallback("step", function(player)
	local playerData = player:getData()
	if playerData.tameChild and playerData.tameChild:isValid() then
		if playerData.teleport and playerData.teleport > 0 then
			playerData.teleport = playerData.teleport - 0.1
		end
		
		playerData.tameChild:getData().linked = nil
		player:setSkill(4, "Unbreakable Bond", "Pull your befriended creature. Redirects all damage taken to the creature as long as you hold it.",
		sprSkills, 5, 0)
	else
		if player:get("scepter") > 0 then
			player:setSkill(4, "Prime Natural Link", "Befriend the last hit enemy if it's below 50% health, or 30% if it's a boss.",
			sprSkills, 6, 4 * 60)
		else
			player:setSkill(4, "Natural Link", "Befriend the last hit enemy if it's below 50% health.",
			sprSkills, 4, 4 * 60)
		end
		if playerData.skill4IconOverride then
			player:setSkillIcon(4, playerData.skill4IconOverride.sprite, playerData.skill4IconOverride.index)
		end
	end
	if not playerData.disableFlight then
		if player:get("free") == 1 and player:get("activity") ~= 30 then
			if player:get("moveUpHold") == 1 then
				if not playerData.flightBonus then
					playerData.flightBonus = true
					player:set("pHmax", player:get("pHmax") + 0.9)
				end
				
				playerData.wingStep = playerData.wingStep + (0.07 * (player:get("pHmax") + player:get("pVmax")))
				
				if player:get("pVspeed") > 0 then
					player:set("pVspeed", player:get("pVspeed") - 0.07)
				else
					player:set("pVspeed", player:get("pVspeed") - 0.02)
				end
				player:set("pVspeed", math.max(player:get("pVspeed"), -6))
				
				if playerData.wingStep >= 4 then
					playerData.wingStep = 1
				end
				player:setAnimation("jump", player:getAnimation("flight"))
			else
				if playerData.flightBonus then
					playerData.flightBonus = nil
					player:set("pHmax", player:get("pHmax") - 0.9)
				end
				player:setAnimation("jump", player:getAnimation("jump_2"))
			end
		else
			if playerData.flightBonus then
				playerData.flightBonus = nil
				player:set("pHmax", player:get("pHmax") - 0.9)
			end
		end
	end
	if player:get("hp") <= 0 then
		playerData.skillCircle = nil
	end
end)

beastmaster:addCallback("draw", function(player)
	local playerData = player:getData()
	if playerData.TlastHit and playerData.TlastHit:isValid() and not tameBlacklist[playerData.TlastHit:getObject()] then
		local TlastHit = playerData.TlastHit
		if player:get("scepter") > 0 and TlastHit:isBoss() and TlastHit:get("hp") <= TlastHit:get("maxhp") * 0.3 or TlastHit:isBoss() == false and TlastHit:get("hp") <= TlastHit:get("maxhp") * 0.5 then
			if not playerData.tameChild or not playerData.tameChild:isValid() then
				if not playerData.e_outline or not playerData.e_outline:isValid() then
					playerData.e_outline = obj.EfOutline:create(0, 0)
					playerData.e_outline:set("parent", TlastHit.id)
					playerData.e_outline:set("rate", 0)
					playerData.e_outline.blendColor = Color.ROR_GREEN
					playerData.e_outline.alpha = 0.7
				end
			end
		elseif TlastHit:get("hp") > TlastHit:get("maxhp") * 0.5 and playerData.e_outline and playerData.e_outline:isValid() or TlastHit:get("tamed") == 1 and playerData.e_outline and playerData.e_outline:isValid() then
			playerData.e_outline:destroy()
		end
	end
	if not playerData.disableFlight then
		if player:get("free") == 1 and player:get("activity") ~= 30 then
			if player:get("moveUpHold") == 1 then
				graphics.drawImage{
					image = player:getAnimation("wings"),
					x = player.x,
					y = player.y,
					xscale = player.xscale,
					yscale = player.yscale,
					color = player.blendColor,
					alpha = player.alpha,
					angle = player.angle,
					subimage = playerData.wingStep
				}
			end
		end
	end
end)

beastmaster:addCallback("step", function(player)
	local child = player:getData().tameChild 
	if child and not child:isValid() then
		player:getData().tameChild = nil
		player:getData().tameObject = nil
	end
	--[[if player:getData().updateVariables then
		for _, actor in pairs(enemies:findMatching("tamed", 1)) do
			if actor:getData().parent == player then
				copyParentVariables(actor, player)
			end
		end
		player:getData().updateVariables = nil
	end]]
end)

local buffWhitelist = {
	buff.burstSpeed,
	buff.burstHealth,
	buff.shield,
	buff.dice1,
	buff.dice2,
	buff.dice3,
	buff.dice4,
	buff.dice5,
	buff.dice6,
	buff.dash,
	buff.burstAttackSpeed,
	buff.burstSpeed2,
	buff.bolster
}

local postStepCall = function()
	for _, b in ipairs(obj.EfMissileEnemy:findAll()) do
		if not b:getData().bedited then
			b:getData().bedited = true
			local parent = Object.findInstance(b:get("parent"))
			if parent and parent:isValid() and parent:get("tamed") then
				local new = obj.EfMissile:create(b.x, b.y)
				new:set("damage", b:get("damage"))
				new:set("explosive_shot", b:get("explosive_shot"))
				new:set("hit", b:get("hit"))
				new:set("yy", b:get("yy"))
				new:set("missile", b:get("missile"))
				new:set("critical", b:get("critical"))
				new:set("angdiff", b:get("angdiff"))
				new:set("lightning", b:get("lightning"))
				new:set("rad", b:get("rad"))
				new:set("team", parent:get("team"))
				
				local target = nearestMatchingOp(b, pobj.actors, "team", "~=", b:get("team"))
				if target then
					new:set("target", target.id)
					new:set("targetx", target.x)
					new:set("targety", target.y)
				else
					new:set("target", -4)
				end
				
				b:destroy()
			end
		end
	end
	for _, b in ipairs(obj.ChainLightning:findAll()) do
		if not b:getData().bedited then
			b:getData().bedited = true
			if b:get("blend") == 14378680 then
				local parent = obj.P:findNearest(b.x, b.y)
				b:set("parent", parent.id)
				b:set("team", parent:get("team"))
			end
		end
	end
	for _, b in ipairs(obj.GuardBullet:findAll()) do
		if not b:getData().edited then
			b:getData().edited = true
			local parent = b:get("parent")
			if parent and Object.findInstance(parent) then
				b:set("team", Object.findInstance(parent):get("team"))
				parent = Object.findInstance(parent)
				if parent:get("tamed") then
					b:set("target", parent:get("target"))
					b:getData().targetI = Object.findInstance(parent:get("target"))
				end
			end
		end
		local targetI = b:getData().targetI
		if targetI and targetI:isValid() then
			local angle = math.deg( math.atan2((targetI.x - b.x) * -1, b.y - targetI.y) ) + 90 -- 45
			b:set("direction", angle)
			b:set("target", targetI.id)
			b:set("target_x", targetI.x)
			b:set("target_y", targetI.y)
			b:set("team", "player")
		end
	end
	for _, b in ipairs(obj.Body:findAll()) do
		if not b:getData().edited then
			b:getData().edited = true
			local objectid = b:get("parent")
			local tamedActors = enemies:findMatching("tamed", 1)
			local matchingActors = {}
			for _, actor in ipairs(tamedActors) do
				if actor:getObject() == Object.fromID(objectid) and actor:getData().awaitingBodyRemoval then
					actor:getData().awaitingBodyRemoval = nil
					b.y = -9000
				end
			end
		end
	end
	for _, i in ipairs(obj.ImpFriend:findAll()) do
		local target = i:get("target")
		if target > 0 and Object.findInstance(target) and Object.findInstance(target):get("tamed") then
			i:set("target", -4)
		end
	end
	for _, i in ipairs(pobj.drones:findAll()) do
		local target = i:get("target")
		if target > 0 and Object.findInstance(target) and Object.findInstance(target):get("tamed") then
			i:set("target", -4)
		end
	end
end

callback.register("preStep", function()
	for _, v in ipairs(enemies:findMatchingOp("tamed", "==", 1)) do
		v:set("disable_ai", 0)
		v:set("death_timer", 100)
	end
end)

local parentSeekingEnemies = {
	[obj.ImpG] = true,
	[obj.GiantJelly] = true,
	[obj.JellyG2] = true,
	[obj.Jelly] = true
}

local disabledEnemySkills = {
	[obj.GolemG] = 3,
	[obj.Boar] = 2
}

local tameCreateFunc = setFunc(function(actor, parent)
	if parent:getData().tameChild_elite then
		actor:makeElite(parent:getData().tameChild_elite)
	end
	--setID(newActor)
	makeTamed(actor, parent)
	if parent:getData().childHippo then
		actor:set("hippo2", parent:getData().childHippo)
		parent:getData().childHippo = nil
	end
	parent:getData().tameChild = actor
end)

local postStepCall2 = function()
	for _, v in ipairs(enemies:findMatchingOp("tamed", "==", 1)) do
		if parentSeekingEnemies[v:getObject()] then
			local target = Object.findInstance(v:get("target") or -4)
			if target and target:isValid() then
				local tpid = target:get("parent") or -4
				local tparent = Object.findInstance(tpid)
				if not tparent or not tparent:isValid() then
					target:set("parent", target.id)
				end 
			end
		end
	end
end

local onStepCall = function()
	for _, v in pairs(enemies:findMatching("tamed", 1)) do
		local parent = v:getData().parent
		
		if parent and parent:isValid() then
			if v:get("target") == -4 and parent and v:get("activity") == 0 then
				if v.x < parent.x - 80 or v.x > parent.x + 80 then
					if v:get("pHspeed") == 0 and v:get("moveLeft") == 1 or v:get("pHspeed") == 0 and v:get("moveRight") == 1 then
						if v:getData().jumpTimer == 18 then
							v:set("moveUp", 1)
							v:getData().jumpTimer = 0
						else
							v:getData().jumpTimer = v:getData().jumpTimer + 1
						end
					else
						v:set("moveUp", 0)
						if parent.x > v.x then
							if not v:collidesMap(v.x + 6, v.y + 17) then
								v:set("moveUp", 1)
							end
							v:set("moveRight", 1)
							v:set("moveLeft", 0)
						else
							if not v:collidesMap(v.x - 6, v.y + 17) then
								v:set("moveUp", 1)
							end
							v:set("moveRight", 0)
							v:set("moveLeft", 1)
						end
					end
				else
					if v.x < parent.x + 30 and v.x > parent.x - 30 and v.y < parent.y + 50 and v.y > parent.y - 50 then 
						v:set("moveRight", 0)
						v:set("moveLeft", 0)
					end
				end
			end
			if v:isClassic() then
				local n = 0
				while v:collidesMap(v.x, v.y) and n < 100 do
					if not v:collidesMap(v.x + 5, v.y) then
						v.x = v.x + 5
					elseif not v:collidesMap(v.x - 5, v.y) then
						v.x = v.x - 5
					elseif not v:collidesMap(v.x, v.y + 6) then
						v.y = v.y + 6
					else
						v.y = v.y - 1
						n = n + 1
					end
				end
			end
		end
	end
	if net.host then
		local command = obj.Command:find(1)
		if command and command:isValid() then
			if not command:getData().beastmasterCorrection and command:get("active") == 2 then
				command:getData().beastmasterCorrection = true
				for _, player in ipairs(misc.players) do
					if player:getSurvivor() == beastmaster then
						local object = player:getData().tameObject
						if object then
							createSynced(object, player.x, player.y, tameCreateFunc, player)
						end
					end
				end
			end
		end
	end
end
local postStepCall3 = function()
	for _, v in pairs(enemies:findAll()) do
		local poi = playertarget:findNearest(v.x, v.y)
		if v:get("team") == "enemy" then
			if v:isClassic() and not v:getData()._tameNoTarget then
				local foundTarget = false
				for _, playerNpc in pairs(enemies:findMatching("tamed", 1)) do
					if playerNpc.x > v.x - 100 and playerNpc.x < v.x + 100 and playerNpc.y > v.y - 50 and playerNpc.y < v.y + 20 then
						v:set("target", playerNpc.id)
						foundTarget = true
					end
				end
				if foundTarget == false then
					if poi then
						v:set("target", poi.id)
					end
				end
			end
		elseif v:get("tamed") == 1 then
			local parent = v:getData().parent
			
			--print(v:getAlarm(0), v:getAlarm(1), v:getAlarm(2), v:getAlarm(3), v:getAlarm(4))
			if parent and parent:isValid() then
				local vObject = v:getObject()
				
				if v:get("can_jump") then
					v:set("can_jump", 1)
					v:set("can_drop", 1)
				end
				
				otherNpcItems(v, parent)
				
				for _, teleporter in pairs(obj.Teleporter:findAll()) do
					if teleporter:get("active") >= 2 then
						v:set("ghost", 1)
						--misc.director:set("ghost_count", misc.director:get("ghost_count") + 1)
						break
					end
				end
				
				local parentBuffs = parent:getBuffs()
				for _, buff in ipairs(parentBuffs) do
					if contains(buffWhitelist, buff) then
						v:applyBuff(buff, 2)
					end
				end
				
				if disabledEnemySkills[vObject] then
					v:setAlarm(disabledEnemySkills[vObject], 11)
				end
				
				if not v:getData()._tameNoTarget then
					--local pretarget = v:get("target")
					v:set("target", -4)
					local range = 100 + (v:get("z_range") or 1000)
					local yrange = 50 + (v:get("z_range") or 1000)
					
					if vObject == obj.Guard then
						range = range * 1.5
					elseif vObject == obj.GiantJelly then
						range = 5000
					end
					
					local inRange = {}
					for _, enemy in pairs(enemies:findAllEllipse(v.x - range, v.y - yrange, v.x + range, v.y + (yrange * 0.5))) do
						if enemy.id ~= v.id and enemy:get("team") ~= v:get("team") then
							table.insert(inRange, enemy)
						end
					end
					
					local currentNearest = nil
					
					if not currentNearest or currentNearest.inst:isValid() then
						for _, instance in ipairs(inRange) do
							if currentNearest then
								local dis = distance(instance.x, instance.y, v.x, v.y)
								if dis < currentNearest.dis then
									currentNearest = {inst = instance, dis = dis}
								end
							else
								currentNearest = {inst = instance, dis =  distance(instance.x, instance.y, v.x, v.y)}
							end
						end
						
						if currentNearest then
							if parentSeekingEnemies[vObject] then
								local targetI = Object.findInstance(currentNearest.inst:get("parent") or -4)
								if not targetI or not targetI:isValid() then
									currentNearest.inst:set("parent", currentNearest.inst.id)
								end
								v:set("target", currentNearest.inst.id)
							else
								v:set("target", currentNearest.inst.id)
							end
						end
					end
					
					if v:get("target") == -4 and misc.getTimeStop() == 0 then
						if vObject == obj.Jelly or vObject == obj.GiantJelly or vObject == obj.JellyG2 or vObject == obj.Bug then
							local cdir = v:get("direction")
							local newAngle = posToAngle(v.x, v.y, parent.x, parent.y)
							local dir = cdir +(angleDif(cdir, newAngle) * -0.0135)
							v:set("direction", dir)
							v:set("speed", v:get("pHmax"))
						end
						v:setAlarm(1, 11)
						v:setAlarm(2, 11)
						v:setAlarm(3, 11)
						v:setAlarm(4, 11)
					end
				end
			end
		end
	end
end

local tamedHeart = Sprite.load("Beastmaster_TameIcon", path.."tameIcon", 1, 3, 3)

local onDrawCall = function()
	for _, actor in ipairs(enemies:findMatching("tamed", 1)) do
		local image = actor.mask or actor.sprite
		graphics.drawImage{
			image = tamedHeart,
			x = actor.x,
			y = actor.y - image.yorigin - 13,
			alpha = 0.75
		}
	end
end

local onHUDDrawCall = function()
	for _, actor in ipairs(enemies:findMatching("tamed", 1)) do
		local parent = actor:getData().parent
		if parent then
			for p, player in ipairs(misc.players) do
				if player == parent then
					graphics.color(playerColor(player, p))
					break
				end
			end
		end
		drawOutOfScreen(actor)
	end
end

beastmaster:addCallback("init", function()
	tcallback.register("onStep", onStepCall)
	tcallback.register("postStep", postStepCall)
	tcallback.register("postStep", postStepCall2)
	tcallback.register("postStep", postStepCall3)
	tcallback.register("onDraw", onDrawCall)
	tcallback.register("onHUDDraw", onHUDDrawCall)
end)

beastmaster:addCallback("draw", function(player)
	if player:getData().teleport and player:getData().teleport > 0 then
		local child = player:getData().tameChild
		
		if child and child:isValid() then
			graphics.color(Color.ROR_GREEN)
			graphics.alpha(player:getData().teleport)
			graphics.line(child.x, child.y, player.x, player.y, player:getData().teleport * 1)
			
			graphics.alpha(player:getData().teleport / 2)
			graphics.line(child.x, child.y, player.x, player.y, player:getData().teleport * 2)
			
		end
	elseif player:getData().linked then
		player:getData().linked = nil
	end
	local circle = player:getData().skillCircle
	if circle and player:get("activity") == 3 then
		graphics.color(circle.color)
		graphics.alpha(1 * circle.alpha)
		graphics.circle(player.x, player.y, circle.radius, true)
		graphics.alpha(0.1 * circle.alpha)
		graphics.circle(player.x, player.y, circle.radius, false)
	end
end)

table.insert(call.onStageEntry, function()
	for _, player in ipairs(misc.players) do
		if player:getData().tameChild and player:getData().tameChild:isValid() then
			if player:getData().tameChild:isClassic() then
				player:getData().tameChild.x = player.x
				player:getData().tameChild.y = player.y
			else
				local child = player:getData().tameChild
				local ground = obj.B:findNearest(player.x, player.y)
				if ground and ground:isValid() then
					local image = child.mask or child.sprite
					child.x = ground.x + (image.yorigin)
					child.y = ground.y - (image.height - image.yorigin)
				end
			end
			player:getData().tameChild:set("ghost", 0)
		end
	end
end)

sur.Chirr = beastmaster
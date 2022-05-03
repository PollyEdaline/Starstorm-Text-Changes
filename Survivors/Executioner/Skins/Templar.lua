-- TEMPLAR (Comission)

local path = "Survivors/Executioner/Skins/Templar/"

local survivor = Survivor.find("Executioner", "Starstorm")
local sprSelect = Sprite.load("TemplarSelect", path.."Select", 24, 2, 0)
local Templar = SurvivorVariant.new(survivor, "Templar", sprSelect, {
	idle = Sprite.load("TemplarIdle", path.."Idle", 1, 6, 5),
	walk = Sprite.load("TemplarWalk", path.."Walk", 8, 9, 5),
	jump = Sprite.load("TemplarJump", path.."Jump", 1, 6, 5),
	climb = Sprite.load("TemplarClimb", path.."Climb", 2, 4, 7),
	death = Sprite.load("TemplarDeath", path.."Death", 12, 9, 9),
	decoy = Sprite.load("TemplarDecoy", path.."Decoy", 1, 9, 10),
	
	shoot1 = Sprite.load("TemplarShoot1", path.."Shoot1", 3, 7, 14),
	shoot2 = Sprite.load("TemplarShoot2", path.."Shoot2", 9, 10, 14),
	shoot3 = Sprite.load("TemplarShoot3", path.."Shoot3", 8, 24, 20),
	shoot4 = Sprite.load("TemplarShoot4", path.."Shoot4", 16, 15, 26),
	shoot5 = Sprite.load("TemplarShoot5", path.."Shoot5", 16, 15, 26),
}, Color.fromHex(0x6B94DB))
SurvivorVariant.setInfoStats(Templar, {{"Strength", 7}, {"Vitality", 5}, {"Toughness", 6}, {"Agility", 6}, {"Difficulty", 5}, {"Faith", 7}})
SurvivorVariant.setDescription(Templar, "The &y&Templar&!& carves her own path towards a hidden truth, and the planet won't hold her back. Each kill earns templar a charge.")
Templar.tag = "Comission"

local sprSkills = Sprite.load("TemplarSkills", path.."SkillsLoadout", 3, 0, 0)
local sprSkills2 = Sprite.load("TemplarSkills2", path.."Skills", 6, 0, 0)
local sShoot1 = Sound.load("TemplarShoot1",  path.."shoot1")
local sShoot2 = Sound.load("TemplarShoot2",  path.."shoot2")
local sShoot4_1 = Sound.load("TemplarShoot4_1",  path.."shoot4_1")
local sShoot4_2 = Sound.load("TemplarShoot4_2",  path.."shoot4_2")

SurvivorVariant.setLoadoutSkill(Templar, "Custom Tuned Weapon", "Fire a bullet with high firerate dealing &y&50% damage.", sprSkills)
SurvivorVariant.setLoadoutSkill(Templar, "Consecration", "Consume all charges and become consecrated, healing yourself and dealing &y&Cryo damage.&!& 10 charges also grants an &b&attack and movement speed bonus.", sprSkills, 2)
SurvivorVariant.setLoadoutSkill(Templar, "Heretic's End", "The Templar uses her ion longsword to sweep in front of her &y&dealing 550x2% damage.&!& Cryo affected kills give the Templar &b&Frost Armor, reducing incoming damage and freezing enemies when hit.", sprSkills, 3)

Templar.endingQuote = "..and so she left, illuminated with newly attained knowledge."

callback.register("onSkinInit", function(player, skin)
	if skin == Templar then
		player:getData().skin_skill2Override = true
		player:getData()._EfColor = Color.fromHex(0xD8E2E8)
		if Difficulty.getActive() == dif.Drizzle then
			player:survivorSetInitialStats(152, 12, 0.042)
		else
			player:survivorSetInitialStats(102, 12, 0.012)
		end
		player:setSkill(1,
		"Custom Tuned Weapon",
		"Fire a bullet with high firerate dealing 60% damage.",
		sprSkills2, 1, 5)
		player:setSkill(2,
		"Consecration",
		"Templar becomes Consecrated, healing herself and dealing Cryo damage. Cryo slows enemies down. At maximum charges also grants an attack and movement speed bonus.",
		sprSkills2, 2, 8 * 60)
		player:setSkill(4,
		"Heretic's End", "The Templar uses her ion longsword to sweep in front of her dealing 550x2% damage. Cryo affected kills give the Templar Frost Armor, reducing incoming damage and freezing enemies when hit.",
		sprSkills2, 5, 9 * 60)
	end
end)
survivor:addCallback("levelUp", function(player)
	if SurvivorVariant.getActive(player) == Templar then
		player:survivorLevelUpStats(5, -1.5, 0.002, 1)
	end
end)

survivor:addCallback("scepter", function(player)
	if SurvivorVariant.getActive(player) == Templar then
		player:setSkill(4,
		"Heretic's Demise", "The Templar uses her ion longsword to sweep in front of her dealing 650x2% damage. Cryo affected kills give the Templar Frost Armor, reducing incoming damage and freezing enemies when hit.",
		sprSkills2, 6, 9 * 60)
	end
end)

local buffConsecration = Buff.new("Consecration")
buffConsecration.sprite = Sprite.load("TemplarBuff1", path.."buff1", 1, 9, 9)
buffConsecration:addCallback("start", function(actor)
	actor:getData().consecrated = true
end)
buffConsecration:addCallback("end", function(actor)
	actor:getData().consecrated = nil
end)

local buffConsecration2 = Buff.new("Consecration2")
buffConsecration2.sprite = Sprite.load("TemplarBuff2", path.."buff2", 1, 9, 9)
buffConsecration2:addCallback("start", function(actor)
	actor:removeBuff(buffConsecration)
	actor:getData().consecrated = true
	actor:set("pHmax", actor:get("pHmax") + 0.5)
	actor:set("attack_speed", actor:get("attack_speed") + 0.6)
end)
buffConsecration2:addCallback("end", function(actor)
	actor:getData().consecrated = nil
	actor:set("pHmax", actor:get("pHmax") - 0.5)
	actor:set("attack_speed", actor:get("attack_speed") - 0.6)
end)

local buffFrostArmor = Buff.new("FrostArmor")
buffFrostArmor.sprite = Sprite.load("TemplarBuff3", path.."buff3", 1, 9, 9)
buffFrostArmor:addCallback("start", function(actor)
	actor:getData().frostOutline = obj.EfOutline:create(0, 0):set("persistent", 1):set("parent", actor.id):set("rate", 0)
	actor:getData().frostOutline.blendColor = Color.fromHex(0x8CD6FF)
	actor:getData().frostArmored = true
	actor:set("armor", actor:get("armor") + 50)
end)
buffFrostArmor:addCallback("end", function(actor)
	if actor:getData().frostOutline and actor:getData().frostOutline:isValid() then
		actor:getData().frostOutline:destroy()
	end
	actor:getData().frostOutline = nil
	actor:getData().frostArmored = nil
	actor:set("armor", actor:get("armor") - 50)
end)

local buffCryo = Buff.new("Cryo")
buffCryo.sprite = Sprite.load("TemplarBuff4", path.."buff4", 1, 9, 9)
buffCryo:addCallback("start", function(actor)
	actor:set("pHmax", actor:get("pHmax") - 0.4)
	actor:getData().cryod = true
end)
buffCryo:addCallback("end", function(actor)
	actor:set("pHmax", actor:get("pHmax") + 0.4)
	actor:getData().cryod = nil
end)

SurvivorVariant.setSkill(Templar, 1, function(player)
	SurvivorVariant.activityState(player, 1, player:getAnimation("shoot1"), 0.25, true, true)
end)
SurvivorVariant.setSkill(Templar, 2, function(player)
	SurvivorVariant.activityState(player, 2, player:getAnimation("shoot2"), 0.3, false, true)
end)
SurvivorVariant.setSkill(Templar, 4, function(player)
	if player:get("scepter") > 0 then
		SurvivorVariant.activityState(player, 4, player:getAnimation("shoot5"), 0.25, true, true)
	else
		SurvivorVariant.activityState(player, 4, player:getAnimation("shoot4"), 0.25, true, true)
	end
end)
callback.register("onSkinSkill", function(player, skill, relevantFrame, variant)
	if variant == Templar then
		local playerData = player:getData()
		local playerAc = player:getAccessor()
		if skill == 1 then
			if relevantFrame == 1 then
				sShoot1:play(0.9 + math.random() * 0.2, 0.8)
				if not player:survivorFireHeavenCracker(0.6) then
					for i = 0, playerAc.sp do
						bullet = player:fireBullet(player.x, player.y, player:getFacingDirection(), 250, 0.6, spr.Sparks10)
						if player:getData().consecrated then
							bullet:getData().ccryo = true
						end
						if i ~= 0 then
							bullet:set("climb", i * 8)
						end
					end
				end
			end
		elseif skill == 2 then
			if playerAc.invincible < 2 then
				playerAc.invincible = 2
			end
			if relevantFrame == 5 then
				sShoot2:play(0.9 + math.random() * 0.2)
				local flash = obj.EfFlash:create(0,0):set("parent", player.id):set("rate", 0.02)
				flash.depth = player.depth - 1
				if playerAc.ionBullets == 10 then
					player:applyBuff(buffConsecration2, 660)
				elseif playerAc.ionBullets > 0 then
					player:applyBuff(buffConsecration, 60 + playerAc.ionBullets * 60)
				end
				local val = playerAc.maxhp * 0.08 * playerAc.ionBullets
				if global.showDamage then
					local healVal = math.min(val, math.max(playerAc.maxhp - val, 0))
					misc.damage(healVal, player.x, player.y - 8, false, Color.DAMAGE_HEAL)
				end
				playerAc.hp = playerAc.hp + val
				playerAc.ionBullets = 0
			end
		elseif skill == 4 then
			if playerAc.invincible < 2 then
				playerAc.invincible = 2
			end
			if global.quality == 3 then
				if playerAc.scepter > 0 then
					par.Hologram:burst("middle", player.x + math.random(-6,20) * player.xscale, player.y + math.random(-8,3), 1, Color.fromHex(0xC7BFFE))
				else
					par.Hologram:burst("middle", player.x + math.random(-6,20) * player.xscale, player.y + math.random(-8,3), 1, playerData._EfColor)
				end
			end
			if relevantFrame == 1 then
				Sound.find("ExecutionerSkill4A"):play(1.2 + math.random() * 0.2)
			elseif relevantFrame == 8 then
				sShoot4_1:play(0.9 + math.random() * 0.2)
				playerAc.pHspeed = 4 * player.xscale
				local bullet = player:fireExplosion(player.x + player.xscale * 12, player.y, 30 / 19, 10 / 4, 5.5 + playerAc.scepter, nil, spr.Sparks9)
				bullet:getData().csword = true
				bullet:set("knockback", 4)
				if player:getData().consecrated then
					bullet:getData().ccryo = true
				end
			elseif relevantFrame == 9 then
				playerAc.pHspeed = 0
			elseif relevantFrame == 13 then
				sShoot4_2:play(0.9 + math.random() * 0.2)
				playerAc.pHspeed = 4 * player.xscale
				local bullet = player:fireExplosion(player.x + player.xscale * 12, player.y, 30 / 19, 10 / 4, 5.5 + playerAc.scepter, nil, spr.Sparks9)
				bullet:getData().csword = true
				bullet:set("knockback", 4)
				if player:getData().consecrated then
					bullet:getData().ccryo = true
				end
			elseif relevantFrame == 14 then
				playerAc.pHspeed = 0
			end
		end
		
	end
end)

local onHitCall = function(damager, hit)
	if damager:getData().ccryo then
		hit:applyBuff(buffCryo, 120)
	elseif hit:getData().frostArmored then
		local parent = damager:getParent()
		if parent and parent:isValid() then
			parent:applyBuff(buff.slow2, 240)
			parent:setAlarm(7, 220)
			
			local circle = obj.EfCircle:create(hit.x, hit.y)
			circle:set("radius", 10)
			circle:set("rate", 5)
			circle.blendColor = Color.fromHex(0x8CD6FF)
		end
	end
	if damager:getData().csword then
		local dmg = math.ceil(damager:get("damage") * (100 / (100 + hit:get("armor"))))
		if dmg >= hit:get("hp") and hit:getData().cryod then
			local parent = damager:getParent()
			if parent and parent:isValid() then
				parent:applyBuff(buffFrostArmor, 300)
			end
		--else
		--	hit:applyBuff(buffCryo, 30)
		end
	end
end

sur.Executioner:addCallback("step", function(player)
	if SurvivorVariant.getActive(player) == Templar then
		local playerData = player:getData()
		local bullets = player:get("ionBullets")
		
		if playerData.lastBullets ~= bullets then
			if bullets == 0 then
				player:setSkillIcon(2, sprSkills2, 2)
			elseif bullets < 10 then
				player:setSkillIcon(2, sprSkills2, 3)
			else
				player:setSkillIcon(2, sprSkills2, 4)
			end
			
			playerData.lastBullets = bullets
		end
	end
end)

local onPlayerHUDDrawCall = function(player, x, y)
	if SurvivorVariant.getActive(player) == Templar then
		local bullets = player:get("ionBullets")
		
		graphics.drawImage{
			image = Sprite.find("Executioner_Skills_2", "Starstorm"),
			subimage = bullets + 1,
			y = y - 11,
			x = x + 18 + 5
		}
	end
end

callback.register("onSkinInit", function(player, skin)
	if skin == Templar then
		tcallback.register("onHit", onHitCall)
		tcallback.register("onPlayerHUDDraw", onPlayerHUDDrawCall)
	end
end)
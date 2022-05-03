
-- All Skins data


------------------------------------------- COMMANDO -------------------------------------------

require("Survivors.Commando.Skins.Specialist")
require("Survivors.Commando.Skins.Nemesis")
require("Survivors.Commando.Skins.Fatmando")
require("Survivors.Commando.Skins.Anointed")

------------------------------------------- ENFORCER -------------------------------------------

require("Survivors.Enforcer.Skins.Heavy")
require("Survivors.Enforcer.Skins.Nemesis")
require("Survivors.Enforcer.Skins.Anointed")

------------------------------------------- HUNTRESS -------------------------------------------

require("Survivors.Huntress.Skins.Arbalist")
require("Survivors.Huntress.Skins.Nemesis")
require("Survivors.Huntress.Skins.Anointed")

------------------------------------------- BANDIT -------------------------------------------

require("Survivors.Bandit.Skins.Poacher")
require("Survivors.Bandit.Skins.Nemesis")
require("Survivors.Bandit.Skins.Reaper")
require("Survivors.Bandit.Skins.Anointed")

------------------------------------------- HAN-D -------------------------------------------

require("Survivors.HAN-D.Skins.R-MOR")
require("Survivors.HAN-D.Skins.Nemesis")
require("Survivors.HAN-D.Skins.Anointed")

table.insert(call.onPlayerDraw, function(player)
	if player:getSurvivor() == sur.HAND then
		local skin = SurvivorVariant.getActive(player)
		if skin then
			if #obj.JanitorGauge:findMatching("parent", player.id) > 0 then
				if not player:getData()._skinStateMemory then
					player:getData()._skinStateMemory = true
					player:setAnimation("shoot1", skin.animations.shoot1hot or spr.JanitorShoot1Hot)
					player:setAnimation("shoot4", skin.animations.shoot4hot or spr.JanitorShoot4Hot)
					player:setAnimation("walk", skin.animations.walkhot or spr.JanitorWalkHot)
					player:setAnimation("idle", skin.animations.idlehot or spr.JanitorIdleHot)
					player:setAnimation("jump", skin.animations.jumphot or spr.JanitorJumpHot)
					player:setAnimation("climb", skin.animations.climbhot or spr.JanitorClimbHot)
					player:setAnimation("death", skin.animations.death or spr.JanitorHead)
				end
			else
				if player:getData()._skinStateMemory then
					player:setAnimation("shoot1", skin.animations.shoot1 or spr.JanitorShoot1)
					player:setAnimation("shoot4", skin.animations.shoot4 or spr.JanitorShoot4)
					player:setAnimation("walk", skin.animations.walk or spr.JanitorWalk)
					player:setAnimation("idle", skin.animations.idle or spr.JanitorIdle)
					player:setAnimation("jump", skin.animations.jump or spr.JanitorJump)
					player:setAnimation("climb", skin.animations.climb or spr.JanitorClimb)
					player:setAnimation("death", skin.animations.death or spr.JanitorHead)
					player:getData()._skinStateMemory = nil
				end
			end
		end
	end
end)

------------------------------------------- ENGINEER -------------------------------------------

require("Survivors.Engineer.Skins.N-G")
--require("Survivors.Engineer.Skins.Nemesis")
require("Survivors.Engineer.Skins.FungusMan")
require("Survivors.Engineer.Skins.Anointed")

table.insert(call.postStep, function()
	for _, turret in ipairs(obj.EngiTurret:findAll()) do
		local data = turret:getData()
		if not data._skinCheck then
			data._skinCheck = true
			local parent = Object.findInstance(turret:get("parent"))
			if parent and parent:isValid() and isa(parent, "PlayerInstance") then
				local skin = SurvivorVariant.getActive(parent)
				
				if skin then
					if parent:get("scepter") <= 0 then
						turret.sprite = skin.animations.turretBase1 or spr.EngiTurret1Base
						turret:setAnimation("base", turret.sprite)

						turret:setAnimation("index2", skin.animations.turretRotate1 or spr.EngiTurret1HeadRotate)
						turret:setAnimation("rotate", skin.animations.turretRotate1 or spr.EngiTurret1HeadRotate)
						
						turret:setAnimation("shoot1", skin.animations.turretShoot1 or spr.EngiTurret1HeadShoot1)

						turret:setAnimation("index", skin.animations.turretSpawn1 or spr.EngiTurret1Spawn)
					else
						turret.sprite = skin.animations.turretBase2 or spr.EngiTurret2Base
						turret:setAnimation("base", turret.sprite)
							
						turret:setAnimation("index2", skin.animations.turretRotate2 or spr.EngiTurret2HeadRotate)
						turret:setAnimation("rotate", skin.animations.turretRotate2 or spr.EngiTurret2HeadRotate)
						
						turret:setAnimation("shoot1", skin.animations.turretShoot2 or spr.EngiTurret2HeadShoot1)

						turret:setAnimation("index", skin.animations.turretSpawn2 or spr.EngiTurret2Spawn)
					end
				end
			end
		end
	end
	--[[for _, mine in ipairs(obj.EngiTurret:findAll()) do
		local data = mine:getData()
		if not data._skinCheck then
			data._skinCheck = true
			local parent = Object.findInstance(mine:get("parent"))
			if parent and parent:isValid() and isa(parent, "PlayerInstance") then
				local skin = SurvivorVariant.getActive(parent)
				
				if skin then
					mine.sprite = skin.animations.MineIdle or spr.EngieMineIdle
				end
			end
		end
	end]]
end)

------------------------------------------- MINER -------------------------------------------

require("Survivors.Miner.Skins.Blacksmith")
require("Survivors.Miner.Skins.Nemesis")
require("Survivors.Miner.Skins.Anointed")

------------------------------------------- ACRID -------------------------------------------

require("Survivors.Acrid.Skins.Acerbid")
--require("Survivors.Acrid.Skins.Nemesis")
require("Survivors.Acrid.Skins.Anointed")

------------------------------------------- MERCENARY -------------------------------------------

require("Survivors.Mercenary.Skins.Legionary")
require("Survivors.Mercenary.Skins.Nemesis")
require("Survivors.Mercenary.Skins.Combatant")
require("Survivors.Mercenary.Skins.Anointed")

------------------------------------------- SNIPER -------------------------------------------

require("Survivors.Sniper.Skins.Assassin")
require("Survivors.Sniper.Skins.Nemesis")
require("Survivors.Sniper.Skins.Hunter")
require("Survivors.Sniper.Skins.Anointed")

table.insert(call.postStep, function()
	for _, obj in ipairs(obj.SniperBar:findAll()) do
		local parent = obj:get("parent")
		if parent and parent > 0 then
			local parentI = Object.findInstance(parent)
			if parentI and parentI:getData().skill1 == true then
				parentI:set("bullet_ready", 1)
				parentI:getData().skill1 = false
				obj:destroy()
			end
		end
	end
	for _, obj in ipairs(obj.SniperDrone:findAll()) do
		local parent = obj:get("master")
		if parent and parent > 0 then
			local parentI = Object.findInstance(parent)
			if parentI and parentI:isValid() then
				local skin = SurvivorVariant.getActive(parentI)
				if skin and skin.animations.drone_idle then
					if obj.sprite == spr.SniperDroneIdle then
						obj.sprite = skin.animations.drone_idle
					elseif obj.sprite == spr.SniperDroneZap then
						obj.sprite = skin.animations.drone_zap
					elseif obj.sprite == spr.SniperDroneWarp then
						obj.sprite = skin.animations.drone_warp
					elseif obj.sprite == spr.SniperDroneShoot1 then
						obj.sprite = skin.animations.drone_shoot
					end
					if skin.animations.drone_turn and obj:get("sprite_turn") == spr.SniperDroneTurn.id then
						obj:set("sprite_turn", skin.animations.drone_turn.id)
					end
				end
			end
		end
	end
end)

------------------------------------------- LOADER -------------------------------------------

require("Survivors.Loader.Skins.Prosecutor")
require("Survivors.Loader.Skins.Nemesis")
require("Survivors.Loader.Skins.Pirate")
require("Survivors.Loader.Skins.Anointed")

------------------------------------------- CHEF -------------------------------------------

require("Survivors.CHEF.Skins.NINJA")
require("Survivors.CHEF.Skins.Anointed")

if not global.rormlflag.ss_disable_survivors then
------------------------------------------- EXECUTIONER -------------------------------------------

require("Survivors.Executioner.Skins.Electrocutioner")
require("Survivors.Executioner.Skins.Nemesis")
require("Survivors.Executioner.Skins.Templar")
require("Survivors.Executioner.Skins.Anointed")

------------------------------------------- MULE -------------------------------------------

--require("Survivors.MULE.Skins.HINNY") neber eber
require("Survivors.MULE.Skins.Anointed")

------------------------------------------- Cyborg -------------------------------------------

require("Survivors.Cyborg.Skins.Imp")
require("Survivors.Cyborg.Skins.Anointed")

------------------------------------------- Technician -------------------------------------------

require("Survivors.Technician.Skins.Operator")
require("Survivors.Technician.Skins.Anointed")

------------------------------------------- Nucleator -------------------------------------------

require("Survivors.Nucleator.Skins.Anointed")

------------------------------------------- Baroness -------------------------------------------

require("Survivors.Baroness.Skins.Boaroness")
require("Survivors.Baroness.Skins.Anointed")

------------------------------------------- Chirr -------------------------------------------

require("Survivors.Beastmaster.Skins.Maid")
require("Survivors.Beastmaster.Skins.Anointed")

------------------------------------------- Pyro -------------------------------------------

require("Survivors.Pyro.Skins.Anointed")

------------------------------------------- DU-T -------------------------------------------

require("Survivors.DU-T.Skins.Delivery")
require("Survivors.DU-T.Skins.Anointed")

------------------------------------------- Knight -------------------------------------------

require("Survivors.Knight.Skins.Guardian")
require("Survivors.Knight.Skins.Crusader")
require("Survivors.Knight.Skins.Anointed")

------------------------------------------- Seraph -------------------------------------------

require("Survivors.Seraph.Skins.Precursor")
require("Survivors.Seraph.Skins.Anointed")

------------------------------------------- Spectator -------------------------------------------

require("Survivors.Spectator.Skins.Anointed")

end

-- MISC

local function disableDamager(damager)
	damager.x = 0
	damager.y = 0
	damager:set("damage", 0)
	damager:set("damage_fake", 0)
	damager:set("poison_dot", 0)
	damager:set("knockback", 0)
	damager:set("stun", 0)
	damager:set("critical", 0)
	damager:set("knockup", 0)
	damager:set("steam", 0)
	damager:set("oil", 0)
	damager:set("fire", 0)
	damager:set("lifesteal", 0)
	damager:set("explosive_shot", 0)
	damager:set("scythe", 0)
	damager:set("skull_ring", 0)
	damager:set("crowbar_hit", 0)
	damager:set("blaster", 0)
	damager:set("sunder", 0)
	damager:set("wolfblood", 0)
	damager:set("axe", 0)
	damager:set("slow_on_hit", 0)
	damager:set("horn", 0)
	damager:set("spark", 0)
	damager:set("sticky", 0)
	damager:set("nugget", 0)
	damager:set("thallium", 0)
	damager:set("mortar", 0)
	damager:set("taser", 0)
	damager:set("lightning", 0)
	damager:set("missile", 0)
	damager:set("missile_tri", 0)
	damager:set("bleed", 0)
	damager:set("scope", 0)
	damager:set("freeze", 0)
	damager:set("stun_ef", 0)
	damager:set("fear", 0)
	damager:set("taunt", 0)
	damager:set("knockback_glove", 0)
	damager:set("plasma", 0)
	damager:set("gold_gun", 0)
	damager:set("gold", 0)
	damager:set("dynamite_on_hit", 0)
	damager:set("poison", 0)
	damager:set("parent", -4)
end -- sucks

local damagers = {obj.Bullet, obj.Explosion}

local postStepCall = function()
	for _, damagertype in ipairs(damagers) do
		for _, damager in ipairs(damagertype:findAll()) do
			if not damager:getData().checked then -- ugly code ugly code
				local parent = damager:getParent()
				if parent and isa(parent, "PlayerInstance") and parent:getData().vanillaDamageOverride then
					if parent:getData().skin_skill1Override and parent:get("activity") >= 1 and parent:get("activity") < 2 or parent and parent:getData().usingMinigun and parent:get("z_skill") == 1 then
						if damager:getData().skin_noFakeDamage then
							damager:set("damage_fake", damager:get("damage"))
						elseif not damager:getData().skin_newDamager then
							disableDamager(damager)
						end
					elseif parent:getData().skin_skill2Override and parent:get("activity") >= 2 and parent:get("activity") < 3 then
						if damager:getData().skin_noFakeDamage then
							damager:set("damage_fake", damager:get("damage"))
						elseif not damager:getData().skin_newDamager then
							disableDamager(damager)
						end
					elseif parent:getData().skin_skill3Override and parent:get("activity") >= 3 and parent:get("activity") < 4 then
						if damager:getData().skin_noFakeDamage then
							damager:set("damage_fake", damager:get("damage"))
						elseif not damager:getData().skin_newDamager then
							disableDamager(damager)
						end
					elseif parent:getData().skin_skill4Override and parent:get("activity") >= 4 and parent:get("activity") < 5 then
						if damager:getData().skin_noFakeDamage then
							damager:set("damage_fake", damager:get("damage"))
						elseif not damager:getData().skin_newDamager then
							disableDamager(damager)
						end
					end
				end
				damager:getData().checked = true
			end
		end
	end
end

local onPlayerStepCall = function(player)
	if player:getData().skin_replacesSound then
		if player:getData().skin_stopSound and player:getData().skin_stopSound > 0 and player:getData().skin_replacesSound:isPlaying() then
			player:getData().skin_stopSound = player:getData().skin_stopSound - 1
			player:getData().skin_replacesSound:stop()
		end
	end
end

callback.register("onSkinInit", function(player, skin)
	if player:getData().vanillaDamageOverride then
		tcallback.register("postStep", postStepCall)
	end
	if player:getData().skin_replacesSound then
		tcallback.register("onPlayerStep", onPlayerStepCall)
	end
end)

table.insert(call.preHit, function(damager, hit)
	local parent = damager:getParent()
	if damager:getData().skin_spark then
		local sparks = obj.EfSparks:create(hit.x, hit.y)
		sparks.sprite = damager:getData().skin_spark
		sparks.depth = -222
		if parent and parent:isValid() and parent.x > hit.x then
			sparks.xscale = -1
		end
	end
	if damager:getData().skinFireDamage then
		DOT.applyToActor(hit, DOT_FIRE, damager:get("damage") * 0.2, damager:getData().skinFireDamage, "skin", false)
	end
	local parent = damager:getParent()
	if parent and damager:getData().skin_electricDamage then
		local lightning = obj.ChainLightning:create(hit.x, hit.y)
		lightning:set("parent", parent.id)
		lightning:set("bounce", 3)
		lightning:set("damage", math.ceil(damager:get("damage")))
		lightning:set("team", parent:get("team"))
		lightning:set("blend", Color.fromHex(0xA6EAEA).gml)
		if damager:get("critical") == 1 then
			lightning:set("blend", Color.ROR_YELLOW.gml)
			lightning:set("damage", lightning:get("damage") * 2)
			lightning:set("critical", 1)
		end
	end
	if parent and isa(parent, "PlayerInstance") and parent:getData().skin_skill1Override and parent:get("activity") == 1 and damager:get("skin_noFakeDamage") and not damager:getData().skin_newDamager then
		disableDamager(damager)
	end
end)
table.insert(call.onImpact, function(damager)
	if damager:getData().impactSound then
		damager:getData().impactSound:play(1 + math.random() * 0.2)
	end
end)

callback.register("onSkinInit", function(player, skin)
	if player:get("hp_regen") < 0 then
		player:set("hp_regen", 0)
	end
end)

-- ugly code thx
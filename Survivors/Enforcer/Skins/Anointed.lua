-- ANOINTED

local path = "Survivors/Enforcer/Skins/Anointed/"

local survivor = sur.Enforcer
local sprSelect = Sprite.load("AEnforcerSelect", path.."Select", 18, 2, 0)
local AEnforcer = SurvivorVariant.new(survivor, "Anointed Enforcer", sprSelect, {
	idle_1 = Sprite.load("AEnforcerIdle_1", path.."Idle_1", 1, 6, 10),
	idle_2 = Sprite.load("AEnforcerIdle_2", path.."Idle_2", 1, 4, 10),
	walk_1 = Sprite.load("AEnforcerWalk_1", path.."Walk_1", 8, 8, 18),
	walk_2 = Sprite.load("AEnforcerWalk_2", path.."Walk_2", 8, 6, 18),
	jump = Sprite.load("AEnforcerJump", path.."Jump", 1, 11, 15),
	climb = Sprite.load("AEnforcerClimb", path.."Climb", 2, 5, 8),
	death = Sprite.load("AEnforcerDeath", path.."Death", 5, 12, 8),
	decoy = Sprite.load("AEnforcerDecoy", path.."Decoy", 1, 9, 18),
	
	shoot1_1 = Sprite.load("AEnforcerShoot1_1", path.."Shoot1_1", 6, 8, 15),
	shoot1_2 = Sprite.load("AEnforcerShoot1_2", path.."Shoot1_2", 6, 7, 15),
	shoot2_1 = Sprite.load("AEnforcerShoot2", path.."Shoot2", 14, 7, 10),
	shoot3_1 = Sprite.load("AEnforcerShoot3_1", path.."Shoot3_1", 8, 5, 10),
	shoot3_2 = Sprite.load("AEnforcerShoot3_2", path.."Shoot3_2", 6, 5, 10),
}, Color.fromHex(0xB5F7FF))
SurvivorVariant.setInfoStats(AEnforcer, {{"Strength", 5}, {"Vitality", 7}, {"Toughness", 7}, {"Agility", 3}, {"Difficulty", 4}, {"Lawfulness", 10}})
SurvivorVariant.setDescription(AEnforcer, "The unbreakable officer is enlightened, unknowingly serving a higher court.")

table.insert(call.onPlayerDraw, function(player)
	if SurvivorVariant.getActive(player) == AEnforcer then
		if player:get("bunker") == 0 then
			player:setAnimation("idle", AEnforcer.animations.idle_1)
			player:setAnimation("walk", AEnforcer.animations.walk_1)
			player:setAnimation("shoot1", AEnforcer.animations.shoot1_1)
		else
			player:setAnimation("idle", AEnforcer.animations.idle_2)
			player:setAnimation("walk", AEnforcer.animations.walk_2)
			player:setAnimation("shoot1", AEnforcer.animations.shoot1_2)
		end
		player:setAnimation("shoot2", AEnforcer.animations.shoot2_1)
	end
end)
-- REAPER

local path = "Survivors/Bandit/Skins/Reaper/"

local survivor = sur.Bandit
local sprSelect = Sprite.load("ReaperSelect", path.."Select", 12, 2, 0)
local Reaper = SurvivorVariant.new(survivor, "Reaper", sprSelect, {
	idle = Sprite.load("ReaperIdle", path.."Idle", 1, 3, 8),
	walk = Sprite.load("ReaperWalk", path.."Walk", 8, 9, 10),
	jump = Sprite.load("ReaperJump", path.."Jump", 1, 4, 8),
	climb = Sprite.load("ReaperClimb", path.."Climb", 2, 5, 7),
	death = Sprite.load("ReaperDeath", path.."Death", 8, 19, 7),
	decoy = Sprite.load("ReaperDecoy", path.."Decoy", 1, 9, 18),
	
	shoot1 = Sprite.load("ReaperShoot1", path.."Shoot1", 4, 6, 9),
	shoot2 = Sprite.load("ReaperShoot2", path.."Shoot2", 6, 4, 13),
	shoot4 = Sprite.load("ReaperShoot4", path.."Shoot4", 9, 7, 13),
	shoot5 = Sprite.load("ReaperShoot5", path.."Shoot5", 9, 7, 13),
}, Color.fromHex(0xA36929))
SurvivorVariant.setInfoStats(Reaper, {{"Strength", 10}, {"Vitality", 1}, {"Toughness", 1}, {"Agility", 7.5}, {"Difficulty", 7}, {"Souls Reaped", 8}})
SurvivorVariant.setDescription(Reaper, "The &y&Reaper&!&'s mission is to bring beings to the afterlife. Sent by The Fireplace, the &y&Reaper&!& found an opportunity amongst the survivors. Although very fragile, every shot he deals is fatal.")

Reaper.endingQuote = "..and so he left, seeking more souls to take."

local sprSkill = Sprite.load("ReaperSkill", path.."Skill", 1, 0, 0)
local sprSparks = Sprite.load("ReaperSparks", path.."Sparks", 3, 9, 5)
local sShoot = Sound.load("ReaperShoot1", path.."Shoot1")

SurvivorVariant.setLoadoutSkill(Reaper, ".32 Revolver", "Fire a bullet for &y&175% damage&!&.", sprSkill)

callback.register("onSkinInit", function(player, skin)
	if skin == Reaper then
		player:set("pHmax", player:get("pHmax") + 0.05)
		if Difficulty.getActive() == dif.Drizzle then
			player:survivorSetInitialStats(68, 50, 0.055)
		else
			player:survivorSetInitialStats(18, 50, 0.025)
		end
		player:setSkill(1,
		".32 Revolver",
		"Fire a bullet for 175% damage.",
		sprSkill, 1, 10)
	end
end)
survivor:addCallback("levelUp", function(player)
	if SurvivorVariant.getActive(player) == Reaper then
		player:survivorLevelUpStats(-28, 14, 0.003, -1)
		player:set("attack_speed", player:get("attack_speed") + 0.015)
	end
end)
SurvivorVariant.setSkill(Reaper, 1, function(player)
	SurvivorVariant.activityState(player, 1, player:getAnimation("shoot1"), 0.2, true, true)
end)
survivor:addCallback("onSkill", function(player, skill, relevantFrame)
	local playerAc = player:getAccessor()
	if SurvivorVariant.getActive(player) == Reaper then
		if skill == 1.01 then
			if relevantFrame == 1 and not player:getData().skin_onActivity then
				player:getData().skin_onActivity = true
				playerAc.darksight_timer = 0
				sShoot:play(0.95 + math.random() * 0.1)
				if not player:survivorFireHeavenCracker(1.2) then
					for i = 0, playerAc.sp do
						local bullet = player:fireBullet(player.x, player.y - 2, player:getFacingDirection() + math.random(1), 450, 1.2, sprSparks)
						if i ~= 0 then
							bullet:set("climb", i * 8)
						end
					end
				end
			elseif relevantFrame ~= 1 then
				player:getData().skin_onActivity = nil
			end
		end
		
	end
end)
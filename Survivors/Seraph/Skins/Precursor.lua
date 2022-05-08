local path = "Survivors/Seraph/Skins/Precursor/"

local survivor = sur.Seraph
local sprSelect = Sprite.load("PrecursorSelect", "Survivors/Seraph/Skins/Precursor/Select", 16, 2, 0)
local precursor = SurvivorVariant.new(survivor, "Precursor", sprSelect, {
	idle = Sprite.load("Precursor_Idle", path.."idle", 8, 6, 11),
	walk = Sprite.load("Precursor_Walk", path.."walk", 8, 6, 11),
	jump = Sprite.load("Precursor_Jump", path.."jump", 1, 6, 11),
	climb = Sprite.load("Precursor_Climb", path.."climb", 2, 8, 10),
	death = Sprite.load("Precursor_Death", path.."death", 18, 7, 9),
	decoy = Sprite.load("Precursor_Decoy", path.."decoy", 1, 9, 10),
	
	shoot1 = Sprite.load("Precursor_Shoot1", path.."shoot1", 5, 5, 11),
	shoot2 = Sprite.load("Precursor_Shoot2", path.."shoot2", 6, 8, 11),
	shoot3 = Sprite.load("Precursor_Shoot3", path.."shoot3", 7, 5, 14),
	shoot4 = Sprite.load("Precursor_Shoot4", path.."shoot4", 9, 16, 24),
	shoot5 = Sprite.load("Precursor_Shoot5", path.."shoot5", 9, 16, 24),
}, Color.fromHex(0xCE776D))
SurvivorVariant.setInfoStats(precursor, {{"Strength", 7}, {"Vitality", 5}, {"Toughness", 2}, {"Agility", 3}, {"Difficulty", 5}, {"Soul", 0}})
SurvivorVariant.setDescription(precursor, "The &y&Precursor&!& is the first of its kind, constructed from within the Void to do its creator's bidding, only left to be forgotten.")

local sShoot1 = Sound.load("Precursor_Shoot1", path.."shoot1")
local sShoot3 = Sound.load("Precursor_Shoot3", path.."shoot3")

precursor.endingQuote = "..and so it left, forever undoing its legacy."

local sprSkills = Sprite.load("PrecursorSkill", path.."Skills", 2, 0, 0)

SurvivorVariant.setLoadoutSkill(precursor, "Precursor's Grasp", "Pull enemies in front of you for &y&30% damage&!&.", sprSkills, 1)
SurvivorVariant.setLoadoutSkill(precursor, "Derange", "Push enemies forward for &y&280% damage&!&.", sprSkills, 2)

callback.register("onSkinInit", function(player, skin)
	if skin == precursor then
		if Difficulty.getActive() == dif.Drizzle then
			player:survivorSetInitialStats(149, 14, 0.043)
		else
			player:survivorSetInitialStats(99, 14, 0.013)
		end
		player:setSkill(1, "Precursor's Grasp", "Pull enemies in front of you for 30% damage.",
		sprSkills, 1, 10)
		
		player:setSkill(3, "Derange", "Push enemies forward for 280% damage.",
		sprSkills, 2, 2 * 60)
	end
end)

survivor:addCallback("levelUp", function(player)
	if SurvivorVariant.getActive(player) == precursor then
		player:survivorLevelUpStats(1, 0.2, 0.0002, 0)
	end
end)

SurvivorVariant.setSkill(precursor, 1, function(player)
	SurvivorVariant.activityState(player, 1, player:getAnimation("shoot1"), 0.25, true, true)
end)
SurvivorVariant.setSkill(precursor, 3, function(player)
	SurvivorVariant.activityState(player, 3, player:getAnimation("shoot3"), 0.25, true, true)
end)

callback.register("onSkinSkill", function(player, skill, relevantFrame, variant)
	if variant == precursor then
		local playerAc = player:getAccessor()
		if skill == 1 then
			if relevantFrame == 1 then
				sShoot1:play(0.9 + math.random() * 0.2)
				local playerTeam = playerAc.team
				for _, actor in ipairs(pobj.actors:findAllRectangle(player.x + 3 * player.xscale, player.y - 3, player.x + 200 * player.xscale, player.y + 3)) do
					if actor:get("team") ~= playerTeam then
						actor:getData().xAccel = (actor:getData().xAccel or 0) + player.xscale * -2.2
					end
				end
				for _, actor in ipairs(pobj.actors:findAllRectangle(player.x + 2 * player.xscale, player.y - 3, player.x + 15 * player.xscale * -1, player.y + 3)) do
					if actor:get("team") ~= playerTeam then
						actor:getData().xAccel = (actor:getData().xAccel or 0) + player.xscale * 2.2
					end
				end
				if not player:survivorFireHeavenCracker(0.4) then
					for i = 0, playerAc.sp do
						local bullet = player:fireBullet(player.x + 4 * player.xscale * -1, player.y, player:getFacingDirection(), 200, 0.3, nil, DAMAGER_BULLET_PIERCE)
						if i ~= 0 then
							bullet:set("climb", i * 8)
						end
					end
				end
			end
		elseif skill == 3 then
			if relevantFrame == 1 then
				sShoot3:play(0.9 + math.random() * 0.2)
				player:getData().xAccel = (player:getData().xAccel or 0) + player.xscale * -1
				if onScreen(player) then
					misc.shakeScreen(6)
				end
				local playerTeam = playerAc.team
				for _, actor in ipairs(pobj.actors:findAllRectangle(player.x + 6 * player.xscale * -1, player.y - 5, player.x + 50 * player.xscale, player.y + 5)) do
					if actor:get("team") ~= playerTeam then
						actor:getData().xAccel = (actor:getData().xAccel or 0) + player.xscale * 5.5
					end
				end
				for i = 0, playerAc.sp do
					local bullet = player:fireBullet(player.x + 4 * player.xscale * -1, player.y, player:getFacingDirection(), 52, 2.8, nil, DAMAGER_BULLET_PIERCE)
					bullet:set("stun", 2)
					--bullet:set("damage_degrade", 0.8)
					bullet:set("knockback_direction", player.xscale)
					if i ~= 0 then
						bullet:set("climb", i * 8)
					end
				end
			end
		end
	end
end)
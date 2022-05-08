-- ELECTROCUTIONER

local path = "Survivors/Executioner/Skins/Electrocutioner/"

local survivor = Survivor.find("Executioner", "Starstorm")
local sprSelect = Sprite.load("ElectrocutionerSelect", path.."Select", 14, 2, 0)
local Electrocutioner = SurvivorVariant.new(survivor, "Electrocutioner", sprSelect, {
	idle = Sprite.load("ElectrocutionerIdle", path.."Idle", 1, 5, 6),
	walk = Sprite.load("ElectrocutionerWalk", path.."Walk", 8, 5, 7),
	jump = Sprite.load("ElectrocutionerJump", path.."Jump", 1, 5, 6),
	climb = Sprite.load("ElectrocutionerClimb", path.."Climb", 2, 4, 7),
	death = Sprite.load("ElectrocutionerDeath", path.."Death", 5, 7, 3),
	decoy = Sprite.load("ElectrocutionerDecoy", path.."Decoy", 1, 9, 10),
	
	shoot1 = Sprite.load("ElectrocutionerShoot1", path.."Shoot1", 3, 9, 10),
	shoot2 = Sprite.load("ElectrocutionerShoot2", path.."Shoot2", 22, 9, 10),
	shoot3 = Sprite.load("ElectrocutionerShoot3", path.."Shoot3", 8, 24, 20),
	shoot4 = Sprite.load("ElectrocutionerShoot4", path.."Shoot4", 14, 17, 34),
	shoot5 = Sprite.load("ElectrocutionerShoot5", path.."Shoot5", 14, 17, 34),
}, Color.fromHex(0x8882C4))
SurvivorVariant.setInfoStats(Electrocutioner, {{"Strength", 8}, {"Vitality", 5}, {"Toughness", 4}, {"Agility", 6}, {"Difficulty", 4}, {"Social Skills", 0}})
SurvivorVariant.setDescription(Electrocutioner, "The &y&Electrocutioner&!& manipulates voltage into deadly doses of electric bolts to stop all and any contenders. Slain enemies charge your &y&Ion Pistol&!&.")

local sprSkill = Sprite.load("ElectrocutionerSkill", path.."Skill", 1, 0, 0)
local sShoot = Sound.load("ElectrocutionerShoot1", path.."Shoot1")

SurvivorVariant.setLoadoutSkill(Electrocutioner, "Deadly Voltage", "Shoot lightning forward, dealing &y&200% damage per second&!&.", sprSkill)

Electrocutioner.endingQuote = "..and so he left, with a spark of uncertainty."

callback.register("onSkinInit", function(player, skin)
	if skin == Electrocutioner then
		player:getData().skin_skill1Override = true
		player:getData().electrocutioner = true
		player:getData()._EfColor = Color.fromHex(0xA6EAEA)
		if Difficulty.getActive() == dif.Drizzle then
			player:survivorSetInitialStats(152, 12, 0.042)
		else
			player:survivorSetInitialStats(102, 12, 0.012)
		end
		player:setSkill(1,
		"Deadly Voltage",
		"Shoot lightning forward, dealing 200% damage per second.",
		sprSkill, 1, 13)
	end
end)
survivor:addCallback("levelUp", function(player)
	if SurvivorVariant.getActive(player) == Electrocutioner then
		player:survivorLevelUpStats(5, -2, 0.002, 1)
	end
end)
survivor:addCallback("onSkill", function(player, skill, relevantFrame)
	local playerAc = player:getAccessor()
	if SurvivorVariant.getActive(player) == Electrocutioner then
		if skill == 1 then
			if relevantFrame == 1 then
				if not sShoot:isPlaying() then
					sShoot:play(0.9 + math.random() * 0.2)
				end
				player:getData().skin_onActivity = true
				if not player:survivorFireHeavenCracker(1.4) then
					for i = 0, playerAc.sp do
						bullet = player:fireBullet(player.x, player.y, player:getFacingDirection(), 125, 0.3, nil)
						bullet:getData().skin_electricDamage = true
						bullet:set("stun", 0.2)
						if i ~= 0 then
							bullet:set("climb", i * 8)
						end
					end
				end
			end
		end
	end
end)
survivor:addCallback("draw", function(player)
	local playerAc = player:getAccessor()
	if SurvivorVariant.getActive(player) == Electrocutioner then
		if player.visible and playerAc.activity == 1 then
			graphics.alpha(1)
			local color = player:getData()._EfColor
			if player:get("critical_chance") >= 100 then
				color = Color.ROR_YELLOW
			end
			drawRodLightning2(player.x + 3 * player.xscale, player.y - 3, player.x + 125 * player.xscale, player.y - 3, 5, 10, color, 2)
		end
	end
end)
survivor:addCallback("step", function(player, skill, relevantFrame)
	local playerAc = player:getAccessor()
	if SurvivorVariant.getActive(player) == Electrocutioner then
		if syncControlRelease(player, "ability1") then
			sShoot:stop()
		end
	end
end)

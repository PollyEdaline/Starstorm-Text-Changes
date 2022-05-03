local path = "Survivors/Knight/Skins/Guardian/"

local survivor = sur.Knight
local sprSelect = Sprite.load("GuardianSelect", "Survivors/Knight/Skins/Guardian/Select", 16, 2, 0)
local guardian = SurvivorVariant.new(survivor, "Guardian", sprSelect, {
	idle = Sprite.load("Guardian_Idle", path.."idle", 1, 8, 12),
	walk = Sprite.load("Guardian_Walk", path.."walk", 8, 10, 12),
	jump = Sprite.load("Guardian_Jump", path.."jump", 1, 8, 12),
	climb = Sprite.load("Guardian_Climb", path.."climb", 2, 4, 8),
	death = Sprite.load("Guardian_Death", path.."death", 9, 9, 11),
	decoy = Sprite.load("Guardian_Decoy", path.."decoy", 1, 9, 18),
	
	shoot1_1 = Sprite.load("Guardian_Shoot1_1", path.."shoot1_1", 11, 16, 24),
	shoot1_2 = Sprite.load("Guardian_Shoot1_2", path.."shoot1_2", 10, 17, 24),
	shoot1_3 = Sprite.load("Guardian_Shoot1_3", path.."shoot1_3", 11, 17, 24),
	shoot2 = Sprite.load("Guardian_Shoot2", path.."shoot2", 5, 8, 12),
	shoot3 = Sprite.load("Guardian_Shoot3", path.."shoot3", 7, 10, 22),
	shoot4 = Sprite.load("Guardian_Shoot4", path.."shoot4", 18, 17, 19),
	shoot4ef = Sprite.load("Guardian_Shoot4Ef", path.."shoot4ef", 5, 76, 19)
}, Color.fromHex(0xC5C0DE))
SurvivorVariant.setInfoStats(guardian, {{"Strength", 8}, {"Vitality", 4}, {"Toughness", 6}, {"Agility", 3}, {"Difficulty", 6}, {"Endurance", 8}})
SurvivorVariant.setDescription(guardian, "The &y&Guardian&!& is a heavy bruiser dealing slow but hard strikes. Every primary attack after contending &y&throws a hammer.")

local sShoot1_1 = Sound.load("Guardian_Shoot1_1", path.."shoot1_1")
local sShoot1_2 = Sound.load("Guardian_Shoot1_2", path.."shoot1_2")
local sShoot1_3 = Sound.load("Guardian_Shoot1_3", path.."shoot1_3")

guardian.endingQuote = "..and so he left, leaving all heavy armor behind."

local sprSkills = Sprite.load("GuardianSkill", path.."Skills", 6, 0, 0)

SurvivorVariant.setLoadoutSkill(guardian, "Maul", "Swing a hammer dealing &y&250% damage forward.", sprSkills, 1)
SurvivorVariant.setLoadoutSkill(guardian, "Fortify", "Bash twice for &y&400% damage and strike your shield knocking all enemies back&y&, &b&allies receive a shield bonus for 3 seconds.", sprSkills, 4)

local buffV = Buff.new("guardianBuff")
buffV.sprite = Sprite.load("Guardian_Buff", path.."buff", 1, 9, 9)
buffV:addCallback("start", function(actor)
	if isa(actor, "PlayerInstance") then
		local buff = math.ceil(actor:get("maxhp") * 0.5)
		actor:getData().guardianBuff = buff
		actor:set("maxshield", actor:get("maxshield") + buff)
		actor:set("shield", actor:get("shield") + buff)
	else
		actor:set("armor", actor:get("armor") + 75)
	end
end)
buffV:addCallback("end", function(actor)
	if isa(actor, "PlayerInstance") then
		local buff = actor:getData().guardianBuff
		actor:set("maxshield", actor:get("maxshield") - buff)
		actor:getData().guardianBuff = nil
	else
		actor:set("armor", actor:get("armor") - 75)
	end
end)

callback.register("onSkinInit", function(player, skin)
	if skin == guardian then
		player:getData().skin_skill1Override = true
		player:getData()._EfColor = Color.fromHex(0xC5C0DE)
		player:getData().vBuff = buffV
		player:set("pHmax", player:get("pHmax") - 0.1)
		if Difficulty.getActive() == dif.Drizzle then
			player:survivorSetInitialStats(153, 13, 0.035)
		else
			player:survivorSetInitialStats(103, 13, 0.005)
		end
		player:setSkill(1, "Maul", "Swing a hammer dealing 250% damage forward.",
		sprSkills, 1, 20)
		
		player:setSkill(2, "Contend", "Hold to reduce incoming damage by 50%. Parry any incoming attacks for a short window of time, deflecting them back for 800% damage. Can interrupt other skills.",
		sprSkills, 2, 2 * 60)
		
		player:setSkill(3, "Strike", "Dash and strike forward for 200% damage. Stuns enemies briefly.",
		sprSkills, 3, 4 * 60)
		
		player:setSkill(4, "Fortify", "Bash twice for 400% damage and strike your shield knocking all enemies back, allies receive a shield bonus for 3 seconds.",
		sprSkills, 4, 10 * 60)
	end
end)

survivor:addCallback("levelUp", function(player)
	if SurvivorVariant.getActive(player) == guardian then
		player:survivorLevelUpStats(1, 0, -0.0002, 0)
	end
end)

local objHammer = Object.new("GuardianHammer")
objHammer.sprite = Sprite.load("GuardianHammer", path.."hammer", 1, 7, 6)
objHammer.depth = 0.1

objHammer:addCallback("create", function(self)
	self:getData().life = 120
	self:getData().team = "player"
	self:getData().speed = 3
end)
objHammer:addCallback("step", function(self)
	local selfData = self:getData()
	
	self.x = self.x + selfData.speed * self.xscale
	self.angle = self.angle + 15 * self.xscale * -1
	
	local parent = selfData.parent
	
	if parent and parent:isValid() then
		local r = 5 * self.xscale
		for _, actor in ipairs(pobj.actors:findAllRectangle(self.x - r, self.y - r, self.x + r, self.y + r)) do
			if actor:get("team") ~= selfData.team and self:collidesWith(actor, self.x, self.y) then
				if global.quality > 1 then
					par.Spark:burst("middle", self.x, self.y, 2)
				end
				
				selfData.life = 0
				for i = 0, parent:get("sp") do
					damage = parent:fireExplosion(self.x, self.y, 9 / 19, 9 / 4, 2.5, spr.Sparks8, nil)
					if i ~= 0 then
						damage:set("climb", i * 8)
					end
				end
				break
			end
		end
	end
	
	if selfData.life == 0 or Stage.collidesPoint(self.x, self.y) then
		if onScreen(self) then
			sShoot1_1:play(1.3 + math.random() * 0.2)
		end
		if global.quality > 1 and self.visible then
			par.Spark:burst("middle", self.x, self.y, 4)
		end
		self:destroy()
	else
		selfData.life = selfData.life - 1
	end
end)

SurvivorVariant.setSkill(guardian, 1, function(player)
	if player:getData().throwHammer then
		SurvivorVariant.activityState(player, 1.3, player:getAnimation("shoot1_3"), 0.25, true, true)
	else
		if player:getData().switch then
			SurvivorVariant.activityState(player, 1.1, player:getAnimation("shoot1_1"), 0.25, true, true)
			player:getData().switch = nil
		else
			SurvivorVariant.activityState(player, 1.2, player:getAnimation("shoot1_2"), 0.25, true, true)
			player:getData().switch = true
		end
	end
end)
callback.register("onSkinSkill", function(player, skill, relevantFrame, variant)
	if variant == guardian then
		local playerAc = player:getAccessor()
		if skill == 1.1 then
			if relevantFrame == 7 then
				sShoot1_1:play(0.9 + math.random() * 0.2)
			end
			if relevantFrame == 8 then
				if onScreen(player) then
					misc.shakeScreen(5)
				end
				if playerAc.free == 0 then
					playerAc.pHspeed = (1 / playerAc.attack_speed) * player.xscale * -1
				end
				if not player:survivorFireHeavenCracker(2.5) then
					for i = 0, playerAc.sp do
						local bullet = player:fireExplosion(player.x + 14 * player.xscale, player.y, 18 / 19, 8 / 4, 2.5)
						bullet:set("knockback", 1)
						bullet:set("knockback_direction", player.xscale)
						if i ~= 0 then
							bullet:set("climb", i * 8)
						end
					end
				end
			elseif player.subimage < 8 and playerAc.free == 0 then
				playerAc.pHspeed = 0.25 * player.xscale
			end
		elseif skill == 1.2 then
			if relevantFrame == 6 then
				if onScreen(player) then
					misc.shakeScreen(2)
				end
				playerAc.pHspeed = (1 / playerAc.attack_speed) * player.xscale * -1
				sShoot1_2:play(0.9 + math.random() * 0.2)
				if not player:survivorFireHeavenCracker(5) then
					for i = 0, playerAc.sp do
						local bullet = player:fireExplosion(player.x + 14 * player.xscale, player.y, 18 / 19, 8 / 4, 2.5)
						bullet:set("knockback", 1)
						bullet:set("knockback_direction", player.xscale)
						if i ~= 0 then
							bullet:set("climb", i * 8)
						end
					end
				end
			end
		elseif skill == 1.3 then
			if relevantFrame == 5 then
				sShoot1_3:play(0.9 + math.random() * 0.2)
			end
			if relevantFrame == 6 then
				if player:getData().throwHammer then
				player:getData().throwHammer = nil
				player:setSkill(1, "Maul", "Swing a hammer dealing 250% damage forward.", sprSkills, 1, 20)
				end
				for i = 0, playerAc.sp do
					local hammer = objHammer:create(player.x, player.y - 4 - i * 4)
					hammer:getData().parent = player
					hammer:getData().team = playerAc.team
					hammer.xscale = player.xscale
				end
			end
		elseif skill > 1.9 and skill < 3 and not player:getData().throwHammer then
			player:getData().throwHammer = true
			player:setSkill(1, "Hammer Throw", "Throw your hammer dealing 250% damage on impact.", sprSkills, 6, 20)
		end
	end
end)

survivor:addCallback("scepter", function(player)
	if SurvivorVariant.getActive(player) == guardian then
		player:setSkill(4,
		"Invigorate", "Bash twice for 400% damage and strike your shield knocking all enemies back, allies receive a shield bonus for 6 seconds. Sets the ground forward on fire.",
		sprSkills, 5, 10 * 60)
	end
end)
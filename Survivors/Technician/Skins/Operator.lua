-- Operator

local path = "Survivors/Technician/Skins/Operator/"

local survivor = Survivor.find("Technician", "Starstorm")
local sprIdle = Sprite.load("Operator_IdleR", path.."idler", 1, 4, 6)
local sprWalk = Sprite.load("Operator_WalkR", path.."walkr", 8, 5, 7)
local sprJump = Sprite.load("Operator_JumpR", path.."jumpr", 1, 4, 6)
local sprShoot1 = Sprite.load("Operator_Shoot1R", path.."shoot1r", 5, 5, 12)
local sprShoot2 = Sprite.load("Operator_Shoot2R", path.."shoot2r", 6, 6, 7)
local sprShoot3 = Sprite.load("Operator_Shoot3R", path.."shoot3", 6, 4, 7)
local sprShoot4 = Sprite.load("Operator_Shoot4R", path.."shoot4r", 6, 4, 7)

local sprSelect = Sprite.load("OperatorSelect", path.."Select", 18, 2, 0)
local Operator = SurvivorVariant.new(survivor, "Operator", sprSelect, {
	-- Right
	idle_1 = sprIdle,
	walk_1 = sprWalk,
	jump_1 = sprJump,
	shoot1_1 = Sprite.load("Operator_Shoot1_1", path.."shoot1_1r", 5, 5, 12),
	shoot1_2 = Sprite.load("Operator_Shoot1_2", path.."shoot1_2r", 5, 5, 12),
	shoot2_1 = sprShoot2,
	shoot3 = sprShoot3,
	shoot4_1 = sprShoot4,
	
	-- Left
	idle_2 = sprIdle,
	walk_2 = sprWalk,
	jump_2 = sprJump,
	shoot2_2 = sprShoot2,
	shoot4_2 = sprShoot4,
	
	death = Sprite.load("Operator_Death", path.."death", 5, 6, 7),
	climb = Sprite.load("Operator_Climb", path.."climb", 2, 3, 7),
	decoy = Sprite.load("Operator_Decoy", path.."decoy", 1, 9, 12),
	
	-- Objects
	mine1 = Sprite.load("OperatorMineA", path.."minea", 6, 5, 8),
	mine2 = Sprite.load("OperatorMineB", path.."mineb", 6, 5, 8),
	
	turret1_1 = Sprite.load("OperatorTurretA", path.."turreta", 2, 7, 7),
	turret1_2 = Sprite.load("OperatorTurretA_Shoot", path.."turretashoot", 4, 7, 7),
	
	turret2_1 = Sprite.load("OperatorTurretB", path.."turretb", 2, 8, 9),
	turret2_2 = Sprite.load("OperatorTurretB_Shoot", path.."turretbshoot", 4, 9, 9),
	
	turret3_1 = Sprite.load("OperatorTurretC", path.."turretc", 2, 8, 9),
	turret3_2 = Sprite.load("OperatorTurretC_Shoot", path.."turretcshoot", 4, 9, 9),
}, Color.fromHex(0x82A070))
SurvivorVariant.setInfoStats(Operator, {{"Strength", 5}, {"Vitality", 5}, {"Toughness", 3}, {"Agility", 3}, {"Difficulty", 6}, {"Training", 7}})
SurvivorVariant.setDescription(Operator, "The &y&Operator&!& controls different devices to stand offensively against groups of enemies.")

local sprSkill = Sprite.load("OperatorSkill", path.."Skill", 2, 0, 0)
local sShoot = Sound.find("Technician_Shoot1A", "Starstorm")

SurvivorVariant.setLoadoutSkill(Operator, "Fine Tune", "Swing a wrench for &y&150% damage&!&. Hitting &y&gadgets&!& three times &b&upgrades them&!&.", sprSkill)
SurvivorVariant.setLoadoutSkill(Operator, "Radial Amplifier", "Place a stationary antenna. &y&All damage done around it is increased by 50%.&!& &b&Upgraded:&!& Double range&!&.", sprSkill, 2)
Operator.endingQuote = "..and so he left, by striking the control panel three times."


callback.register("onSkinInit", function(player, skin)
	if skin == Operator then
		player:getData().skin_skill1Override = true
		if Difficulty.getActive() == dif.Drizzle then
			player:survivorSetInitialStats(152, 12, 0.042)
		else
			player:survivorSetInitialStats(102, 12, 0.012)
		end
		player:setSkill(1,
		"Fine Tune",
		"Swing a wrench for 150% damage. Can upgrade gadgets.",
		sprSkill, 1, 1)
		player:setSkill(3,
		"Radial Amplifier",
		"All damage dealt inside its radius is increased by 50%.",
		sprSkill, 2, 10 * 60)
		player:getData().attackCount = 1
	end
end)
survivor:addCallback("levelUp", function(player)
	if SurvivorVariant.getActive(player) == Operator then
		player:survivorLevelUpStats(5, -2, 0.002, 1)
	end
end)


local objWrench = Object.find("Technician_Wrench", "Starstorm")

local buffExpose = Buff.new("exposed")
buffExpose.sprite = Sprite.load("Operator_ExposeBuff", path.."buff", 1, 9, 9)

local objExposer = Object.new("Exposer")
objExposer.sprite = Sprite.load("Operator_Exposer", path.."exposer", 2, 5, 19)
objExposer.depth = 5

local sShoot3 = Sound.load("Operator_Shoot3", path.."skill3")
local sShoot3Up = Sound.load("Operator_Shoot3UP", path.."skill3Up")

local sShoot1Up = sfx.Technician_Shoot1UP
local sShoot4Up = sfx.Technician_Shoot4UP

objExposer:addCallback("create", function(self)
	local mineAc = self:getAccessor()
	self:set("team", "player")
	self:getData().timer = 0
	self:getData().counter = 0
	self.spriteSpeed = 0
	for i = 0, 500 do
		if self:collidesMap(self.x, self.y + 1) then
			break
		else
			self.y = self.y + 1
		end
	end
end)
objExposer:addCallback("step", function(self)
	local selfAc = self:getAccessor()
	local wrench = objWrench:findNearest(self.x, self.y)
	local enemy = pobj.enemies:findNearest(self.x, self.y)
	local parent = self:getData().parent
	
	local data = self:getData()
	
	if wrench and self:collidesWith(wrench, self.x, self.y) and data.timer == 0 then
		data.timer = 8
		data.counter = data.counter + 1
		if data.counter <= 3 then
			--data.life = 100
			sShoot1Up:play(1 + math.random() * 0.2)
			if global.quality > 1 then
				par.Spark:burst("middle", self.x, self.y, 4)
			end
		end
		if data.counter == 3 then
			--data.life = 380
			sShoot3Up:play(1 + math.random() * 0.2)
			self.subimage = 2
		end
	end
	
	if data.timer > 0 then
		data.timer = data.timer - 1
	end
	
	local r = 60
	if data.counter >= 3 then
		r = 120
	end
	local team = selfAc.team
	for _, actor in ipairs(pobj.actors:findAllEllipse(self.x - r, self.y - r, self.x + r, self.y + r)) do
		if actor:get("team") ~= team then
			actor:applyBuff(buffExpose, 30)
		end
	end
	
	if data.parent and data.parent:isValid() then
		if data.parent:getData().exposerChild ~= self then
			self:destroy()
		end
	end
end)
local onDrawCall = function()
	for _, self in ipairs(objExposer:findAll()) do
		local selfAc = self:getAccessor()
		
		local color = Color.RED
		local r = 60
		if self:getData().counter >= 3 then
			r = 120
			color = Color.ORANGE
		end
		if self:getData().drawCounter then
			self:getData().drawCounter = self:getData().drawCounter + 0.07
			graphics.alpha((0.3 * math.sin(self:getData().drawCounter)) + 0.2)
			graphics.color(color)
			graphics.circle(self.x, self.y, r, true)
		else 
			self:getData().drawCounter = 0
		end
	end
end

local preHitCall = function(damager, target)
	if target:hasBuff(buffExpose) then
		local damage = damager:get("damage")
		local bonus = damage * 0.5
		damager:set("damage", damage + bonus)
		local crit = damager:get("critical") > 0
		if global.showDamage then
			misc.damage(bonus, target.x, target.y - 20 , crit, Color.DARK_RED)
		end
		local flash = obj.EfFlash:create(0,0):set("parent", target.id):set("rate", 0.08)
		flash.alpha = 0.75
		flash.blendColor = Color.RED
		flash.depth = target.depth - 1
		sfx.SpitterHit:play(0.8)
	end
end

SurvivorVariant.setSkill(Operator, 1, function(player)
	if player:getData().attackCount % 2 == 0 then
		SurvivorVariant.activityState(player, 1, player:getAnimation("shoot1_1"), 0.2, true, true)
	else
		SurvivorVariant.activityState(player, 1, player:getAnimation("shoot1_2"), 0.2, true, true)
	end
	player:getData().attackCount = player:getData().attackCount + 1
end)
SurvivorVariant.setSkill(Operator, 3, function(player)
	SurvivorVariant.activityState(player, 3, player:getAnimation("shoot3"), 0.2, true, true)
end)

callback.register("onSkinSkill", function(player, skill, relevantFrame, variant)
	if variant == Operator then
		local playerAc = player:getAccessor()
		if skill == 1 then
			if relevantFrame == 1 then
				sShoot:play(0.8 + math.random() * 0.2)
				if not player:survivorFireHeavenCracker(1.4) then
					local wrench = objWrench:create(player.x + player.xscale * -2, player.y)
					wrench:set("direction", player:getFacingDirection())
					wrench:getData().parent = player
					wrench:getData().life = 3
					wrench:getData().speed = 8
					wrench:getData().team = playerAc.team
					wrench.visible = false
				end
			end
		elseif skill == 3 then
			if relevantFrame == 1 then
				local exposer = objExposer:create(player.x + 4 * player.xscale, player.y + 4)
				exposer:set("team", playerAc.team)
				exposer:getData().parent = player
				player:getData().exposerChild = exposer
				
				sShoot3:play(1 + math.random() * 0.2)
			end
		end
	end
end)

callback.register("onSkinInit", function(player, skin)
	if skin == Operator then
		tcallback.register("onDraw", onDrawCall)
		tcallback.register("preHit", preHitCall)
	end
end)
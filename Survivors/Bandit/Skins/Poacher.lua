-- POACHER

local path = "Survivors/Bandit/Skins/Poacher/"

local survivor = sur.Bandit
local sprSelect = Sprite.load("PoacherSelect", path.."Select", 18, 2, 0)
local Poacher = SurvivorVariant.new(survivor, "Poacher", sprSelect, {
	idle = Sprite.load("PoacherIdle", path.."Idle", 1, 7, 9),
	walk = Sprite.load("PoacherWalk", path.."Walk", 8, 10, 16),
	jump = Sprite.load("PoacherJump", path.."Jump", 1, 4, 8),
	climb = Sprite.load("PoacherClimb", path.."Climb", 2, 5, 7),
	death = Sprite.load("PoacherDeath", path.."Death", 8, 19, 7),
	decoy = Sprite.load("PoacherDecoy", path.."Decoy", 1, 9, 18),
	
	shoot1 = Sprite.load("PoacherShoot1", path.."Shoot1", 6, 6, 9),
	shoot2 = Sprite.load("PoacherShoot2", path.."Shoot2", 6, 4, 13),
	shoot4 = Sprite.load("PoacherShoot4", path.."Shoot4", 9, 7, 13),
	shoot5 = Sprite.load("PoacherShoot5", path.."Shoot5", 11, 7, 13),
}, Color.fromHex(0x6B6B6B))
SurvivorVariant.setInfoStats(Poacher, {{"Strength", 5}, {"Vitality", 6}, {"Toughness", 3}, {"Agility", 6}, {"Difficulty", 5}, {"Reputation", 4}})
SurvivorVariant.setDescription(Poacher, "The &y&Poacher&!& has infiltrated to secure contraband. The law has failed to catch up with him.")

Poacher.endingQuote = "..and so he left, after the hunt of a lifetime."

local sprSkills = Sprite.load("PoacherSkill", path.."Skills", 2, 0, 0)
local sShoot = Sound.load("PoacherShoot1", path.."Shoot1")

SurvivorVariant.setLoadoutSkill(Poacher, "Night Time", "Fire a tranquilizer dart for &y&140% damage&!&, slowing down enemies. &y&Consecutive hits stun foes, making them vulnerable&!&.", sprSkills)
SurvivorVariant.setLoadoutSkill(Poacher, "Metal Trap", "Place a trap that &y&stuns an enemy on contact&!&, dealing &y&4x120% damage&!&.", sprSkills, 2)

local buffSprite = Sprite.load("PoacherBuff", path.."Buff", 4, 9, 9)
local buffPoacher1 = Buff.new("poacher1")
buffPoacher1.sprite = buffSprite
buffPoacher1.subimage = 1
buffPoacher1:addCallback("start", function(actor)
	actor:set("pHmax", actor:get("pHmax") - 0.3)
end)
buffPoacher1:addCallback("end", function(actor)
	actor:set("pHmax", actor:get("pHmax") + 0.3)
end)

local buffPoacher2 = Buff.new("poacher2")
buffPoacher2.sprite = buffSprite
buffPoacher2.subimage = 2
buffPoacher2:addCallback("start", function(actor)
	actor:set("pHmax", actor:get("pHmax") - 0.5)
	actor:removeBuff(buffPoacher1)
end)
buffPoacher2:addCallback("step", function(actor, t)
	actor:getData().poachT = t
end)
buffPoacher2:addCallback("end", function(actor)
	actor:set("pHmax", actor:get("pHmax") + 0.5)
	if actor:getData().poachT <= 1 then
		actor:applyBuff(buffPoacher1, 1 * 60)
	end
end)

local buffPoacher3 = Buff.new("poacher3")
buffPoacher3.sprite = buffSprite
buffPoacher3.subimage = 3
buffPoacher3:addCallback("start", function(actor)
	actor:set("pHmax", actor:get("pHmax") - 0.7)
	actor:removeBuff(buffPoacher2)
end)
buffPoacher3:addCallback("step", function(actor, t)
	actor:getData().poachT = t
end)
buffPoacher3:addCallback("end", function(actor)
	actor:set("pHmax", actor:get("pHmax") + 0.7)
	if actor:getData().poachT <= 1 then
		actor:applyBuff(buffPoacher2, 1 * 60)
	end
end)

local buffPoacher4 = Buff.new("poacher4")
buffPoacher4.sprite = buffSprite
buffPoacher4.subimage = 4
buffPoacher4:addCallback("start", function(actor)
	--actor:set("activity", 48)
	actor:set("armor", actor:get("armor") - 50)
	actor:set("pHmax", actor:get("pHmax") - 0.8)
	actor:removeBuff(buffPoacher3)
end)
buffPoacher4:addCallback("step", function(actor,t )
	actor:setAlarm(7, 10)
	actor:getData().poachT = t
end)
buffPoacher4:addCallback("end", function(actor)
	---actor:set("activity", 0)
	actor:set("armor", actor:get("armor") + 50)
	actor:set("pHmax", actor:get("pHmax") + 0.8)
	if actor:getData().poachT <= 1 then
		actor:applyBuff(buffPoacher3, 1 * 60)
	end
end)

local onHitCall = function(damager, hit)
	if damager:getData().poacherBuff then
		if hit:hasBuff(buffPoacher4) or hit:hasBuff(buffPoacher3) then
			hit:applyBuff(buffPoacher4, 2 * 60)
		elseif hit:hasBuff(buffPoacher2) then
			hit:applyBuff(buffPoacher3, 2 * 60)
		elseif hit:hasBuff(buffPoacher1) then
			hit:applyBuff(buffPoacher2, 2 * 60)
		else
			hit:applyBuff(buffPoacher1, 2 * 60)
		end
	end
end

callback.register("onSkinInit", function(player, skin)
	if skin == Poacher then
		player:set("pHmax", player:get("pHmax") + 0.05)
		if Difficulty.getActive() == dif.Drizzle then
			player:survivorSetInitialStats(162, 12, 0.05)
		else
			player:survivorSetInitialStats(112, 12, 0.02)
		end
		player:setSkill(1,
		"Night Time",
		"Fire a tranquilizer dart for 140% damage, slowing down enemies. Consecutive hits stun foes.",
		sprSkills, 1, 31)
		player:setSkill(2,
		"Metal Trap",
		"Place a trap that stuns an enemy on contact, dealing 4x120% damage.",
		sprSkills, 2, 4 * 60)
		tcallback.register("onHit", onHitCall)
	end
end)
survivor:addCallback("levelUp", function(player)
	if SurvivorVariant.getActive(player) == Poacher then
		player:survivorLevelUpStats(-1, 0.5, 0.001, 0)
	end
end)
SurvivorVariant.setSkill(Poacher, 1, function(player)
	SurvivorVariant.activityState(player, 1, player:getAnimation("shoot1"), 0.2, true, true)
end)
SurvivorVariant.setSkill(Poacher, 2, function(player)
	SurvivorVariant.activityState(player, 2, player:getAnimation("shoot2"), 0.2, true, true)
end)

obj.PoacherTrap = Object.new("PoacherTrap")
obj.PoacherTrap.sprite = Sprite.load("PoacherTrap", path.."Trap", 5, 7, 15)
obj.PoacherTrap:addCallback("create", function(self)
	local selfData = self:getData()
	selfData.team = "player"
	selfData.damage = 20
	selfData.life = 480
	self.spriteSpeed = 0
	selfData.ySpeed = 0.1
end)
obj.PoacherTrap:addCallback("step", function(self)
	local selfData = self:getData()
	if selfData.trapChild then
		if selfData.trapChild:isValid() then
			if selfData.life % 60 == 0 then
				if selfData.parent and selfData.parent:isValid() then
					selfData.parent:fireBullet(selfData.trapChild.x, selfData.trapChild.y, selfData.trapChild:getFacingDirection(), 2, 1.2):set("specific_target", selfData.trapChild.id)
				else
					misc.fireBullet(selfData.trapChild.x, selfData.trapChild.y, selfData.trapChild:getFacingDirection(), 2, selfData.damage, selfData.team):set("specific_target", selfData.trapChild.id)
				end
			end
			selfData.trapChild:setAlarm(7, 30)
			selfData.trapChild.x = self.x
		else
			selfData.life = 0
		end
	else
		local w, h = 6, 10 
		for _, actor in ipairs(pobj.actors:findAllRectangle(self.x - w, self.y - h, self.x + w, self.y + 2)) do
			if actor:get("team") ~= selfData.team then
				selfData.trapChild = actor
				selfData.life = 60 * 4
				actor:setAlarm(7, 60 * 4)
				self.spriteSpeed = 0.2
				if selfData.parent and selfData.parent:isValid() then
					selfData.parent:fireBullet(actor.x, actor.y, actor:getFacingDirection(), 2, 1.2):set("specific_target", actor.id)
				else
					misc.fireBullet(actor.x, actor.y, actor:getFacingDirection(), 2, selfData.damage, selfData.team):set("specific_target", actor.id)
				end
				sfx.JanitorShoot1_2:play(3.9 + math.random() * 0.2)
				self.subimage = 2
				break
			end
		end
	end
	if self.subimage >= self.sprite.frames then
		self.spriteSpeed = 0
	end
	if self:collidesMap(self.x, self.y + 1) then
		selfData.ySpeed = 0
	else
		selfData.ySpeed = selfData.ySpeed + 0.1
	end
	if selfData.ySpeed > 0 then
		local yMove = 0
		for i = 1, selfData.ySpeed do
			if self:collidesMap(self.x, self.y + i) then
				break
			else
				yMove = i
			end
		end
		self.y = self.y + yMove
	end
	if selfData.life > 0 then
		selfData.life = selfData.life - 1
	else
		self:destroy()
	end
end)

callback.register("onSkinSkill", function(player, skill, relevantFrame, skin)
	if skin == Poacher then
		local playerAc = player:getAccessor()
		if skill == 1 then
			if relevantFrame == 1 then
				player:getData().skin_onActivity = true
				playerAc.darksight_timer = 0
				sShoot:play(0.9 + math.random() * 0.2)
				if not player:survivorFireHeavenCracker(1.2) then
					for i = 0, playerAc.sp do
						local bullet = player:fireBullet(player.x, player.y - 2, player:getFacingDirection() + math.random(1), 450, 1.4)
						bullet:getData().poacherBuff = true
						if i ~= 0 then
							bullet:set("climb", i * 8)
						end
					end
				end
			end
		elseif skill == 2 then
			if relevantFrame == 2 then
				local trap = obj.PoacherTrap:create(player.x, player.y + 6)
				trap:getData().damage = playerAc.damage * 1.2
				trap:getData().team = playerAc.team
				trap:getData().parent = player
				sfx.MinerShoot1:play(2.9 + math.random() * 0.2)
			end
		end
	end
end)
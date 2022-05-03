-- Fungus Man

local path = "Survivors/Engineer/Skins/FungusMan/"

local survivor = sur.Engineer
local sprSelect = Sprite.load("FungusManSelect", path.."Select", 4, 2, 0)
local FungusMan = SurvivorVariant.new(survivor, "Fungus Man", sprSelect, {
	idle = Sprite.load("FungusManIdle", path.."Idle", 1, 10, 11),
	walk = Sprite.load("FungusManWalk", path.."Walk", 8, 20, 28),
	jump = Sprite.load("FungusManJump", path.."Jump", 1, 9, 8),
	climb = Sprite.load("FungusManClimb", path.."Climb", 2, 11, 8),
	death = Sprite.load("FungusManDeath", path.."Death", 11, 16, 18),
	decoy = Sprite.load("FungusManDecoy", path.."Decoy", 1, 9, 18),
	
	shoot1 = Sprite.load("FungusManShoot1", path.."Shoot1", 4, 29, 45),
	shoot3 = Sprite.load("FungusManShoot3", path.."Shoot3", 21, 10, 17),
	
	turretBase1 = Sprite.load("FungusManTurretBase1", path.."TurretBase1", 1, 10, 7),
	turretRotate1 = Sprite.load("FungusManTurretRotate1", path.."TurretRotate1", 7, 13, 7),
	turretSpawn1 = Sprite.load("FungusManTurretSpawn1", path.."TurretSpawn1", 11, 10, 7),
	
	turretBase2 = Sprite.load("FungusManTurretBase2", path.."TurretBase2", 1, 10, 7),
	turretRotate2 = Sprite.load("FungusManTurretRotate2", path.."TurretRotate2", 7, 13, 13),
	turretSpawn2 = Sprite.load("FungusManTurretSpawn2", path.."TurretSpawn2", 11, 10, 15)
}, Color.fromHex(0x74CD7A))
SurvivorVariant.setInfoStats(FungusMan, {{"Fungus", 10}, {"Fungus", 10}, {"Fungus", 10}, {"Fungus", 10}, {"Fungus", 10}, {"Fungus", 10}})
SurvivorVariant.setDescription(FungusMan, "The Engineer's passion for fungi is well known so his &y&Fungus Man&!& halloween costume came as no surprise, let's just hope he isn't losing his sanity...")

local sprSkill = Sprite.load("FungusManSkill", path.."Skill", 2, 0, 0)
local sprSkill2 = Sprite.load("FungusManSkill2", path.."Skill2", 25, 0, 11)

SurvivorVariant.setLoadoutSkill(FungusMan, "Fungi-Turret", "&y&Drop a turret&!& that &g&heals nearby allies&!& and shoots &y&poisonous roots at enemies.", sprSkill, 2)

FungusMan.endingQuote = "..and so he left, more spore and fungus than man."

local itFungus1 = it.BustlingFungus
local itFungus2 = Item.find("Dormant Fungus", "Starstorm")

survivor:addCallback("levelUp", function(player)
	if SurvivorVariant.getActive(player) == FungusMan then
		player:survivorLevelUpStats(-2, 0, 0.002, 0)
	end
end)

survivor:addCallback("scepter", function(player)
	if SurvivorVariant.getActive(player) == FungusMan then
		player:setSkill(4,
		"Alpha Fungi-Turret",
		"Drop a turret that heals nearby allies and shoots poisonous roots at enemies.",
		sprSkill2, 22, 35 * 60)
	end
end)

local onStepCall = function()
	for _, turret in ipairs(obj.EngiTurret:findAll()) do
		local parent = Object.findInstance(turret:get("parent"))
		if parent and parent:isValid() and isa(parent, "PlayerInstance") then
			local skin = SurvivorVariant.getActive(parent)
			local data = turret:getData()
			local ac = turret:getAccessor()
			
			if skin == FungusMan then
				ac.target = -4
				if not data._cd then
					data._cd = 100
				end
				if not data._cd2 then
					data._cd2 = 100
				end
				
				if data._cd > 0 then
					data._cd = data._cd - 1
				else
					data._cd = 600
					local r = 150
					local c = obj.EfCircle:create(turret.x, turret.y)
					c:set("radius", r)
					c.blendColor = Color.GREEN
					for _, actor in ipairs(pobj.actors:findAllEllipse(turret.x - r, turret.y - r, turret.x + r, turret.y + r)) do
						if actor:get("team") == ac.team then
							if actor:get("hp") < actor:get("maxhp") then
								local heal = parent:get("damage") * 2
								actor:set("hp", actor:get("hp") + heal)
								if global.showDamage then
									misc.damage(heal, actor.x, actor.y - 2, false, Color.DAMAGE_HEAL)
								end
							end
						end
					end
				end
				if data._cd2 > 0 then
					data._cd2 = data._cd2 - 1
				else
					data._cd2 = 120
					local r = 80
					local aggro = false
					for _, actor in ipairs(pobj.actors:findAllEllipse(turret.x - r, turret.y - r, turret.x + r, turret.y + r)) do
						if actor:get("team") ~= ac.team then
							aggro = actor
							break
						end
					end
					if aggro then
						local o = obj.EfPoisonMine:create(turret.x, turret.y)
						o:set("team", parent:get("team"))
						o:set("damage", parent:get("damage") * 0.8)
						o:set("speed", 1) 
						o:setAlarm(1, 60)
						o:setAlarm(0, 1)
						o.alpha = 0
						if aggro:isValid() then
							if aggro.x < turret.x then
								o:set("direction", 180) 
							end
						end
					end
				end
			end
		end
	end
end

callback.register("onSkinInit", function(player, skin)
	if skin == FungusMan then
		if Difficulty.getActive() == dif.Drizzle then
			player:survivorSetInitialStats(170, 12, 0.042)
		else
			player:survivorSetInitialStats(120, 12, 0.012)
		end
		player:setSkill(4,
		"Fungi-Turret",
		"Drop a turret that heals nearby allies and shoots poisonous roots at enemies.",
		sprSkill2, 19, 35 * 60)
		
		tcallback.register("onStep", onStepCall)
	end
end)
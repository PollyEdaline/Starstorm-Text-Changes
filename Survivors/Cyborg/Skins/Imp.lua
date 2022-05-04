-- PROTOTYPE

local path = "Survivors/Cyborg/Skins/Imp/"

local survivor = Survivor.find("Cyborg", "Starstorm")
local sprSelect = Sprite.load("CyImpSelect", path.."Select", 20, 2, 0)
local CyImp = SurvivorVariant.new(survivor, "Beta", sprSelect, {
	idle = Sprite.load("CyImpIdle", path.."idle", 1, 7, 11),
	walk = Sprite.load("CyImpWalk", path.."walk", 6, 9, 14),
	jump = Sprite.load("CyImpJump", path.."jump", 1, 9, 12),
	climb = Sprite.load("CyImpClimb", path.."climb", 2, 5, 11),
	death = Sprite.load("CyImpDeath", path.."death", 6, 10, 12),
	decoy = Sprite.load("CyImpDecoy", path.."decoy", 1, 9, 12),

	shoot1 = Sprite.load("CyImpShoot1", path.."shoot1", 7, 9, 14),
	shoot2 = Sprite.load("CyImpShoot2", path.."shoot2", 8, 12, 19),
	shoot3_1 = Sprite.load("CyImpShoot3", path.."shoot3", 4, 10, 14),
	
	shoot4 = Sprite.load("CyImpShoot4", path.."shoot4", 8, 14, 12),
	
	projectile = Sprite.load("CyImpBullet", path.."bullet", 2, 30, 12)
}, Color.fromHex(0xBF4A4E))
SurvivorVariant.setInfoStats(CyImp, {{"Strength", 5}, {"Vitality", 4}, {"Toughness", 3}, {"Agility", 5}, {"Difficulty", 4}, {"Soul", 7}})
SurvivorVariant.setDescription(CyImp, [["Report 102-B: Subject M. [REDACTED] has gone missing, failure declared. The Crimson Link seems to have melded a juvenile fiend into the Cyberbody. All clearance procedures have initialized. &y&Prototype 23&!& seems to be moderately tame. Administration suggests we evaluate the situation further."]])

local sprSkills = Sprite.load("CyImpSkills", path.."Skills", 2, 0, 0)
local sShoot = sfx.ImpGShoot1--Sound.load("CyImpShoot1", path.."Shoot1")

SurvivorVariant.setLoadoutSkill(CyImp, "Fierce", "Slice twice in front of you for &y&170% total damage.", sprSkills)
SurvivorVariant.setLoadoutSkill(CyImp, "Hunter", "Teleport to the nearest grounded enemy.", sprSkills, 2)

CyImp.endingQuote = "..and so it left, ready to assimilate a new identity."

callback.register("onSkinInit", function(player, skin)
	if skin == CyImp then
		player:getData().skin_skill1Override = true
		player:getData().skin_skill3Override = true
		if Difficulty.getActive() == dif.Drizzle then
			player:survivorSetInitialStats(158, 12, 0.056)
		else
			player:survivorSetInitialStats(108, 12, 0.026)
		end
		player:setSkill(1,
		"Fierce",
		"Slice twice in front of you for 170% total damage.",
		sprSkills, 1, 40)
		player:setSkill(3,
		"Hunter",
		"Teleport to the nearest grounded enemy.",
		sprSkills, 2, 5 * 60)
		player:getData()._EfColor2 = Color.fromHex(0xFF636B)
	end
end)
survivor:addCallback("levelUp", function(player)
	if SurvivorVariant.getActive(player) == CyImp then
		player:survivorLevelUpStats(1, 0, -0.003, 1)
	end
end)
local rangeBase = 150
survivor:addCallback("onSkill", function(player, skill, relevantFrame)
	local playerAc = player:getAccessor()
	if SurvivorVariant.getActive(player) == CyImp then
		if skill == 1 then
			if relevantFrame == 1 then
				sShoot:play(1.2 + math.random() * 0.2, 0.6)
				if not player:survivorFireHeavenCracker(1.4) then
					for i = 0, playerAc.sp do
						player:fireExplosion(player.x, player.y, 20 / 19, 6 / 4, 1.1, nil, spr.Sparks10):set("stun", 0.25)
					end
				end
			elseif relevantFrame == 5 then
				sShoot:play(1.6 + math.random() * 0.2, 0.6)
				for i = 0, playerAc.sp do
					player:fireExplosion(player.x, player.y, 20 / 19, 6 / 4, 0.6, nil, spr.Sparks10r):set("stun", 0.25)
				end
			end
		elseif skill == 3 then
			--par.CyborgTele:burst("middle", player.x + math.random(-4,4), player.y + math.random(2-,4), 2)
			if relevantFrame == 1 then
				sfx.ImpShoot2:play(1 + math.random() * 0.2, 1)
			end
			if playerAc.invincible < 15 then
				playerAc.invincible = 15
			end
			if relevantFrame == 3 then
				local free = playerAc.free
				
				local teleRange = playerAc.pHmax * rangeBase
				
				local nearestActor = nil
				local nearestOffRange = nil
				for _, actor in ipairs(pobj.actors:findAll()) do
					if not isa(actor, "PlayerInstance") or actor:get("dead") == 0 then
						if actor:get("team") ~= playerAc.team and math.sign(actor.x - player.x) == player.xscale then
							local dis = distance(player.x, player.y, actor.x, actor.y)
							if dis < teleRange and actor:collidesWith(obj.B, actor.x, actor.y + 1) and dis > 35 then
								if not nearestActor or dis < nearestActor.dis then
									nearestActor = {inst = actor, dis = dis}
								end
							elseif dis < 400 then
								if not nearestOffRange or dis < nearestOffRange.dis then
									nearestOffRange = {inst = actor, dis = dis}
								end
							end
						end
					end
				end
				if nearestActor then
					
					nearestActor = nearestActor.inst
					local image = nearestActor.mask or nearestActor.sprite
					local yy = nearestActor.y - image.yorigin + image.height - 6
					player.x = nearestActor.x
					player.y = nearestActor.y
					playerAc.ghost_x = player.x
					playerAc.ghost_y = player.y
					
				elseif nearestOffRange then
					
					local dis = nearestOffRange.dis
					nearestOffRange = nearestOffRange.inst
					local angle = math.rad(posToAngle(player.x, nearestOffRange.y, nearestOffRange.x, player.y))
					
					local ignorey = free == 0 and nearestOffRange.y > player.y
					
					local x, y = player.x, player.y
					
					-- ... I forgot the more efficient way to do all this ...
					
					local iterations = math.floor(math.min(dis, teleRange))
					
					for i = 1, iterations do
						local xx, yy
						
						xx = player.x + math.cos(angle)
						if ignorey then
							yy = player.y
						else
							yy = player.y + math.sin(angle)
						end
						if player:collidesMap(xx, yy) or i == iterations then
							if free == 0 then
								for ii = 1, 400 do
									if player:collidesMap(player.x, player.y + ii) then
										player.y = player.y + ii - 1
										break
									end
								end
							end
							break
						end
						player.x = xx
						player.y = yy
					end
					
				else
					local xx = 0
					for ii = 0, math.floor(teleRange * 0.5) do
						if player:collidesMap(player.x + ii * player.xscale, player.y) then
							break
						end
						xx = xx + player.xscale
					end
					
					player.x = player.x + xx
				end
			end
			
		end
	end
end)
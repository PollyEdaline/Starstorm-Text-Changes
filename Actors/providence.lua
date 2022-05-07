local path = "Actors/Providence/"

local bossShootZ1 = Sprite.load("Boss1ShootZ1", path.."Boss1ShootZ1", 14, 22, 30)
local bossShootZ2 = Sprite.load("Boss1ShootZ2", path.."Boss1ShootZ2", 24, 41, 86)

local sprites = {
	idle = {
		current = spr.Boss1Idle,
		new = Sprite.load("Boss1Idle", path.."Boss1Idle", 7, 10, 22)
	},
	jump = {
		current = spr.Boss1Jump,
		new = Sprite.load("Boss1Jump", path.."Boss1Jump", 1, 10, 22)
	},
	walk = {
		current = spr.Boss1Walk,
		new = Sprite.load("Boss1Walk", path.."Boss1Walk", 8, 10, 22)
	},
	fly = {
		current = spr.Boss3Fly,
		new = Sprite.load("Boss3Fly", path.."Boss3Fly", 7, 10, 22)
	},
	shootc1 = {
		current = spr.Boss1ShootC1_1,
		new = Sprite.load("Boss1ShootC1_1", path.."Boss1ShootC1_1", 12, 20, 66)
	},
	shootc2 = {
		current = spr.Boss1ShootC1_2,
		new = Sprite.load("Boss1ShootC1_2", path.."Boss1ShootC1_2", 4, 11, 21)
	},
	shootx1 = {
		current = spr.Boss1ShootX1,
		new = Sprite.load("Boss1ShootX1", path.."Boss1ShootX1", 25, 30, 66)
	},
	shootz1 = {
		current = spr.Boss1ShootZ1,
		new = bossShootZ1
	},
	shootz2 = {
		current = spr.Boss1ShootZ2,
		new = bossShootZ2
	},
	shootz1_2 = {
		current = spr.Boss3ShootZ1,
		new = bossShootZ1
	},
	shootz2_2 = {
		current = spr.Boss3ShootZ2,
		new = bossShootZ2
	},
	death = {
		current = spr.Boss1Death,
		new = Sprite.load("Boss1Death", path.."Boss1Death", 23, 20, 17)
	},
	portrait = {
		current = spr.ProvidencePortrait,
		new = Sprite.load("UltraProvidencePortrait", path.."portrait", 4, 0, 0)
	}
}

for _, index in pairs(sprites) do
	index.original = Sprite.clone(index.current)
end

local function setProvidenceSkin(boolean)
	if boolean then
		for _, index in pairs(sprites) do
			index.current:replace(index.new)
		end
	else
		for _, index in pairs(sprites) do
			index.current:replace(index.original)
		end
	end
end

callback.register("onExtraDifficultyUpdate", function(dif)
	if dif > 0 then
		setProvidenceSkin(true)
	else
		setProvidenceSkin(false)
	end
end)
callback.register("onGameEnd", function()
	setProvidenceSkin(false)
end)
	
local providenceObjects = {obj.Boss1, obj.Boss2, obj.Boss2Clone, obj.Boss3}
local sprProvMask = Sprite.load("Boss1Mask", path.."Boss1Mask", 1, 10, 22)
local sBossDeath = Sound.load("ProvidenceDeath", path.."death")
local sBossSkill1 = Sound.load("BossSkill1", path.."skill1")
local sBossSkill2 = Sound.load("BossSkill2", path.."skill2")
local objFlash = obj.EfLaserBlast

local ultraBarColor = Color.fromRGB(88, 58, 105)

obj.BossSkill2:addCallback("create", function(self)
	sBossSkill2:play(0.9 + math.random() * 0.2)
end)
obj.BossSkill1:addCallback("create", function(self)
	sBossSkill1:play(0.9 + math.random() * 0.2)
end)

local guardSpawnFunc = setFunc(function(spawn)
	spawn:set("child", 44)
	spawn:set("sound_spawn", 100068)
	spawn.sprite = spr.GuardGSpawn
	objFlash:create(0, -100)
end)

obj.Boss3:addCallback("destroy", function(npc)
		if npc:getObject() == obj.Boss3 then
			sBossDeath:play()
			onProvidenceDefeatCallback(npc)
			misc.hud:set("objective_text", "Activate the terminal.")
		end
end)
--[[table.insert(call.onNPCDeathProc, function(npc, player)
	if getAlivePlayer() == player then
		if npc:getObject() == obj.Boss3 then
			sBossDeath:play()
			onProvidenceDefeatCallback(npc)
			misc.hud:set("objective_text", "Activate the terminal.")
		end
	end
end) -- regular onNPCDeath is bugged at the time i'm making this.]]

local onStepCall = function()
	local providenceRework = getRule(5, 12) == true
	
	local nodamage = false
	if obj.CommandFinal:find(1) then
		if Sound.getMusic() then
			Sound.getMusic():stop()
		end
	end
	if obj.CustomTextbox:find(1) then
		nodamage = true
	end
	for _, c in pairs(obj.Textbox:findAll()) do
		if c:get("text3count") == 2 and not c:getData().dp then
			c:getData().dp = true
			misc.hud:set("objective_text", "Defeat Providence.")
		end
	end
	for _, object in pairs(providenceObjects) do
		for _, providence in pairs(object:findAll()) do
			--providence:removeBuff(buff.intoxication)
			local proviAc = providence:getAccessor()
			
			if not providence:getData().tweaked and providenceRework then
				providence.mask = sprProvMask
				proviAc.pHmax = 1.25
				proviAc.pVmax = 3
				proviAc.pGravity1 = 0.1
				proviAc.attack_speed = 1.25
				proviAc.walk_speed_coeff = 1.25
				proviAc.z_range = 100
				proviAc.sound_death = 0
				if object == obj.Boss1 and not net.online then
					createDialogue({"Why have you come?", "Your kind has stolen so much from us. And yet, you try to plunder us again.", "Die in your gilded casket, for all you've done."}, {{spr.ProvidencePortrait, 3}, {spr.ProvidencePortrait, 3}, {spr.ProvidencePortrait, 4}}, {
						function()
							misc.hud:set("objective_text", "Defeat Providence.")
							--print(3)
						end}
					)
					obj.Black:create(0, 0)
					misc.hud:set("objective_text", "")
				end
				providence:getData().tweaked = true
			end
			if object ~= obj.Boss2Clone then
				if nodamage then
					proviAc.invincible = 2
				end
				if providenceRework then
					if object == obj.Boss3 then
						if nodamage == false and math.chance(1) and math.chance(9) and net.host then
							createSynced(obj.Spawn, providence.x, providence.y, guardSpawnFunc)
						end
					end
					if proviAc.activity == 0 and nodamage == false and math.chance(1) and math.chance(19) and not net.online then
						sfx.BossSkill2:play()
						objFlash:create(0, -100)
						for i = 1, 10 do
							local skill4 = obj.BossSkill2old:create(providence.x + (i * 22 * providence.xscale), providence.y)
							skill4:set("team", proviAc.team)
							skill4:set("damage", proviAc.damage)
						end
					end
					if net.host and proviAc.activity == 0 and nodamage == false and math.chance(1) and math.chance(25) then
						proviAc.moveUp = 1
						if net.online then
							syncInstanceVar:sendAsHost(net.ALL, nil, providence:getNetIdentity(), "moveUp", 1)
						end
					end
				end
			end
			if ExtraDifficulty.getCurrent() > 0 then
				misc.hud:set("boss_hp_color", ultraBarColor.gml)
			end
		end
	end
	for _, t in pairs(obj.BossText:findAll()) do
		if runData.inSpanishPlease and not t:getData().spanished then
			t:set("text1", table.irandom({"¿¿Por qué??", "¡Ayy!", "Eres más fuerte de lo que pensé...", "¿Cómo?", "¿Qué... eres?"}))
			t:getData().spanished = true --lol
		elseif t:get("text1") == "What.. are you..?" then
			t:set("text1", "What... are you..?")
		elseif t:get("text1") == "You thought me defeated..?!" then
			t:set("text1", "You thought me defeated?!")
		elseif t:get("text1") == "How...?" then
			t:set("text1", "How..?")
		elseif t:get("text1") == "A challenge..!" then
			t:set("text1", "A worthy challenge..!")
		elseif t:get("text1") == "Hmm.." then
			t:set("text1", "Hmm... you are strong...")
		elseif t:get("text1") == "Ah.. you are stronger then you look.." then
			t:set("text1", "Ah! You are stronger than you look...")
		elseif t:get("text1") == "Die..!" then
			t:set("text1", "Die!")
		elseif t:get("text1") == "You.. monster..." then
			t:set("text1", "You... monster...")
		end
	end
end

obj.Boss1:addCallback("create", function()
	tcallback.register("onStep", onStepCall)
end)
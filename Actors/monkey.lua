-- Easter egg!!?!

-- Why not?

local path = "Actors/Monkey/"

local animations = {
	imp = {
		idle = spr.ImpMIdle,
		walk = spr.ImpMWalk,
		death = spr.ImpMDeath,
		mask = spr.ImpMMask
	},
	monkey = {
		idle = Sprite.load("MonkeyIdle", path.."Idle", 1, 4, 3),
		walk = Sprite.load("MonkeyWalk", path.."Walk", 4, 5, 4),
		death = Sprite.load("MonkeyDeath", path.."Death", 8, 6, 4),
		mask = Sprite.load("MonkeyMask", path.."Mask", 1, 3, 3)
	}
}

local sfxDeath = Sound.load("MonkeyDeath", path.."Death")

obj.ImpM:addCallback("create", function(imp)
	if math.chance(1) then
		imp:getData().ismonkey = true
		imp.mask = animations.monkey.mask
		imp:set("name", "Monkey")
		imp:set("sound_death", sfxDeath.id)
	end
end)

table.insert(call.postStep, function()
	for _, imp in ipairs(obj.ImpM:findAll()) do
		if imp:getData().ismonkey then
			if imp.sprite ~= animations.monkey.walk then
				for key, sprite in pairs(animations.imp) do
					if imp.sprite == sprite then
						imp.sprite = animations.monkey[key]
						break
					end
				end
			end
		end
	end
end)
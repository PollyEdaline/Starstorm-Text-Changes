local path = "Items/Resources/"
it.Vaccine = Item.new("Vaccine")
it.Vaccine.pickupText = "Chance to negate debuffs." 
local sprVaccineEf = Sprite.load("VaccineDisplay", path.."vaccinedis", 9, 7, 7)
it.Vaccine.sprite = Sprite.load("Vaccine", path.."Vaccine", 1, 14,14)
it.Vaccine:setTier("uncommon")
it.Vaccine:setLog{
	group = "uncommon",
	description = "&b&20% chance to cancel debuffs.",
	story = " I heard about your family. It's a shame really, people as sweet as your mother don't deserve to be victim of such an illness. I do have a solution though. I'm sending you a high-end, state of the art vaccine. It's quite experimental but I promise it will heal and prevent any further replicas. She will be cured, as long as you keep her on a steady intake.\n\nThe first one is on my behalf, but following doses will need to be on you, I hope you can understand this is very costly and even though I wish I could I can't afford all of them.",
	destination = "30,\nRobb Stad,\nEarth",
	date = "3/3/2056"
}
it.Vaccine:addCallback("pickup", function(player)
	player:set("vaccine", (player:get("vaccine") or 0) + 1)
end)
callback.register("onItemRemoval", function(player, item, amount)
	if item == it.Vaccine then
		player:set("vaccine", player:get("vaccine") - amount)
	end
end)

local debuffs = {
  buff.slow,
  buff.slow2,
  buff.snare,
  buff.thallium,
  buff.oil,
  buff.disease,
  buff.intoxication,
  buff.disease,
  buff.daze,
  buff.voided,
  buff.needles,
  buff.weaken1,
  buff.slowdown
}

for _, buff in ipairs(debuffs) do
	buff:addCallback("start", function(actor, timer)
		local vaccine = actor:get("vaccine")
		if vaccine and vaccine > 0 and math.chance((1 - 1 / (0.26 * vaccine + 1)) * 100) then
			actor:removeBuff(buff)
			sfx.Frozen:play(2, 0.4)
			local ef = obj.EfSparks:create(actor.x, actor.y)
			ef.sprite = sprVaccineEf
			ef.depth = -11
		end
	end)
end
for _, buff in ipairs(debuffs) do
	buff:addCallback("step", function(actor, timer)
		if actor:isValid() then
			local vaccine = actor:get("vaccine")
			if vaccine and vaccine > 0 then
				if not actor:getData().buffTimer then
					actor:getData().buffTimer = {}
				end
				if not actor:getData().buffTimer[buff] then
					actor:getData().buffTimer[buff] = timer
				end
				if actor:getData().buffTimer[buff] > timer then
					actor:getData().buffTimer[buff] = timer
				elseif actor:getData().buffTimer[buff] < timer then
					if math.chance((1 - 1 / (0.26 * vaccine + 1)) * 100) then
						actor:removeBuff(buff)
						sfx.Frozen:play(2)
						local ef = obj.EfSparks:create(actor.x, actor.y)
						ef.sprite = sprVaccineEf
						ef.depth = -11
						
						actor:applyBuff(buff, actor:getData().buffTimer[buff])
					else
						actor:getData().buffTimer[buff] = timer
					end
				end
			end
		end
	end)
end

--[[for _, buff in ipairs(debuffs) do
	buff:addCallback("step", function(actor, timer)
		if isa(actor, "PlayerInstance") and actor:countItem(it.Vaccine) > 0 then
			local datakey = "debuffModifier"..buff:getName()
			if not actor:getData().buffTimer then
				actor:getData().buffTimer = {}
			end
			if not actor:getData().buffTimer[buff] then
				actor:getData().buffTimer[buff] = timer
			end
			if timer < actor:getData().buffTimer[buff] then
				actor:getData().buffTimer[buff] = timer
			elseif timer > actor:getData().buffTimer[buff] then
				actor:removeBuff(buff)
				local duration = math.max(0.95 - actor:countItem(it.Vaccine) * 0.15, 0)
				if duration > 0 then
					actor:applyBuff(buff, timer * duration)
					actor:getData().buffTimer[buff] = timer
				else
					actor:getData().buffTimer[buff] = nil
				end
			end
			if not actor:getData()[datakey] then
				actor:getData()[datakey] = 1
				actor:removeBuff(buff)
				local duration = math.max(0.95 - actor:countItem(it.Vaccine) * 0.15, 0)
				if duration > 0 then
					actor:applyBuff(buff, timer * duration)
				end
			end
		end
	end)
	buff:addCallback("start", function(actor, timer)
		local datakey = "debuffModifier"..buff:getName()
		if actor:getData()[datakey] == 1 then
			actor:getData()[datakey] = 0
		end
	end)
	buff:addCallback("end", function(actor, timer)
		local datakey = "debuffModifier"..buff:getName()
		if actor:getData()[datakey] == 0 then
			actor:getData()[datakey] = nil
			actor:getData().buffTimer[buff] = nil
		end
	end)
end]]

callback.register("onActorStep", function(actor)
	local vaccCount = actor:get("vaccine")
	if vaccCount and vaccCount > 0 then 
		if actor:getData().dotData then
			for _, dot in ipairs(actor:getData().dotData) do -- dots
				if not dot.vaccineChecked then
					dot.tics = math.ceil(dot.tics * math.max(0.95 - vaccCount * 0.15, 0))
					dot.vaccineChecked = true
				end
			end
		end
	end
end)
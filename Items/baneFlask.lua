
local path = "Items/Resources/"
it.BaneFlask = Item.new("Bane Flask")
it.BaneFlask.pickupText = "Debuffs spread on enemy death, inflicts bane. " 
it.BaneFlask.sprite = Sprite.load("BaneFlask", path.."Bane Flask", 1, 15, 15)
it.BaneFlask:setTier("rare")
it.BaneFlask:setLog{
	group = "rare",
	description = "All attacks apply &y&Bane&!&, dealing &y&30% damage&!& every 2 seconds. &y&Debuffs spread&!& to nearby enemies when slain.",
	story = "Our team has finally created a valuable product, unlike anything before it. While the rival team has done nothing but dawdle and laze about, creating pointless tonics and useless barrels, we were successful in harvesting the beast's deadliest property. We extracted the contagious toxin EBBA-33. It behaves similarly to a virus, and is extremely contagious. However, our compound takes no time to begin spreading.\n\nI firmly believe no other laboratory will top this for the next century. We have made a large step in chemical warfare. We only await your command, sir.",
	priority = "&r&High Priority/Biological&!&",
	destination = "Delta M,\nZeus Complex,\nPXP Central",
	date = "2/10/2057"
}

-- debuff manager
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
  buff.slowdown,
  buff.damageshare,
  buff.seraph
}

for _, buff in ipairs(debuffs) do
  buff:addCallback("start", function(actor)
    if not isa(actor, "PlayerInstance") then
      if not actor:getData().activeDebuffs then
        actor:getData().activeDebuffs = {}
      end
      actor:getData().activeDebuffs[buff] = 2 -- placeholder time, since we cant get the time at the start
    end
  end)
  buff:addCallback("step", function(actor, timer)
    if not isa(actor, "PlayerInstance") then
      actor:getData().activeDebuffs[buff] = timer -- the actual time
    end
  end)
  buff:addCallback("end", function(actor, timer)
	if not isa(actor, "PlayerInstance") then
      actor:getData().activeDebuffs[buff] = nil
	end
  end)
end

-- spread
local onNPCDeathProcCall = function(npc, player)
	local tubeCount = player:countItem(it.BaneFlask)
	if tubeCount > 0 and npc:getData().lastHitBy == player then
		local ellipsX = 50 + tubeCount * 50
		local ellipsY = 30 + tubeCount * 30
		local enemies = pobj.actors:findAllEllipse(npc.x - ellipsX, npc.y + ellipsY, npc.x + ellipsX, npc.y - ellipsY)
		if npc:getData().activeDebuffs then
			for _, actor in ipairs(enemies) do
				if actor:get("team") ~= player:get("team") then
					for buffHeld, timer in pairs(npc:getData().activeDebuffs) do
						local duration = timer * (1 + tubeCount)
						if actor:getData().activeDebuffs and actor:getData().activeDebuffs[buffHeld] then
							duration = math.max(duration - actor:getData().activeDebuffs[buffHeld], 0)
						end
						if buffHeld == buff.thallium then
							duration = math.min(duration, 60 * 3)
						end
						actor:applyBuff(buffHeld, duration)
                    end
				end
			end
		end
		if npc:getData().lastHitBy and npc:getData().lastHitBy:isValid() then
			DOT.applyToActor(npc, DOT_BANE, math.max(npc:getData().lastHitBy:get("damage") * 0.3, 1), 5 + npc:getData().lastHitBy:countItem(it.BaneFlask), "BaneFlask", false)
		end
		if npc:getData().dotData then
			for _, actor in ipairs(enemies) do
				if actor:get("team") ~= player:get("team") and actor ~= npc then
					for _, dot in ipairs(npc:getData().dotData) do
						if dot.stacks and not DOT.checkActor(actor, dot.dotType) then
							DOT.applyToActor(actor, dot.dotType, dot.damage, dot.tics * (tubeCount + 1), dot.index, dot.stacks)
						elseif not dot.stacks then 
							DOT.applyToActor(actor, dot.dotType, dot.damage, dot.tics + tubeCount, dot.index, dot.stacks)
						end
					end
				end
				--actor:getData().lastHitBy = player this is absolutely op
			end
		end
		
		for _, actor in ipairs(enemies) do
			if actor:get("team") ~= player:get("team") and actor ~= npc then
				for _, dot in ipairs(obj.Dot:findMatching("parent", npc.id)) do
					local newDot = obj.Dot:create(npc.x, npc.y)
					newDot:set("parent", actor.id)
					newDot:set("damage", dot:get("damage") * 0.8)
					newDot:set("textColor", dot:get("textColor"))
					newDot:set("team", dot:get("team"))
					newDot:set("ticks", dot:get("ticks"))
				end
			end
		end
		
	end
end

local onHitCall = function(damager, hit)
	local parent = damager:getParent()
	if parent then
		hit:getData().lastHitBy = parent
	end
end

it.BaneFlask:addCallback("pickup", function(player)
	tcallback.register("onHit", onHitCall)
	tcallback.register("onNPCDeathProc", onNPCDeathProcCall)
end)

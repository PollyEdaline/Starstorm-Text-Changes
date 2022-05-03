local relicColor = Color.fromHex(0xC649AD)

it.RelicTermination = Item.new("Relic of Termination")
--local sRelicGratification = Sprite.load("RelicGratificationDisplay", "Items/Resources/relicGratificationdis.png", 1, 18, 18)
it.RelicTermination.pickupText = "Slaying a marked enemy earns you an item BUT failing to do so increases its power."
it.RelicTermination.sprite = Sprite.load("RelicGratification", "Items/Resources/Relic of Termination.png", 1, 15, 15)
itp.relic:add(it.RelicTermination)
it.RelicTermination.color = relicColor
it.RelicTermination:setLog{
	group = "end",
	description = "&y&Slaying a marked enemy earns you an item &p&BUT &r&failing to do so increases its power.",
	story = "A crescent light and a shivering compass. The danger it led to, always rewarding. But I failed it once, one time too many.",
	priority = "&b&Field-Found&!&",
	destination = "Unknown",
	date = "Unknown"
}

local makeRelicElite = function(actor)
	local instAcc = actor:getAccessor()
	instAcc.maxhp = instAcc.maxhp * 2.4
	instAcc.hp = instAcc.maxhp
	instAcc.damage = instAcc.damage * 1.4
	instAcc.pHmax = instAcc.pHmax * 1.2
	instAcc.knockback_cap =  instAcc.maxhp
	instAcc.name = "Terminal "..instAcc.name
	instAcc.name2 = "Invigorated By An Ancient Force"
	instAcc.prefix_type = 1
	instAcc.relic = 1
	instAcc.elite_type = elt.Relic.id
	local outline = obj.EfOutline:create(0, 0)
	outline:set("rate", 0)
	outline:set("parent", actor.id)
	outline.blendColor = elt.Relic.color
	outline.depth = actor.depth + 1
	--sFailure:play(0.9 + math.random() * 0.2)
end

local syncRelicElite = net.Packet.new("SSReElt", function(sender, player, actor)
	local actorI = actor:resolve()
	if actorI and actorI:isValid() then
		makeRelicElite(actorI)
	end
	local playerI = player:resolve()
	if playerI and playerI:isValid() then
		playerI:getData().termTarget = nil
	end
end)

local syncChoice = net.Packet.new("SSReTer", function(sender, player, actor, timerVal)
	local actorI = actor:resolve()
	local playerI = player:resolve()
	if playerI and playerI:isValid() then
		if actorI and actorI:isValid() then
			playerI:getData().termTarget = {instance = actorI, x = actorI.x, y = actorI.y, timer = timerVal}
		end
	end
end)

local blacklist = {
	[obj.WormBody] = true,
	[obj.WormHead] = true,
	[obj.WurmBody] = true,
	[obj.WurmHead] = true
}
if not global.rormlflag.ss_disable_enemies then
	blacklist[obj.SquallElver] = true
	blacklist[obj.SquallElverC] = true
	blacklist[obj.TotemPart] = true
	blacklist[obj.TotemController] = true
	blacklist[obj.Arraign1] = true
	blacklist[obj.Arraign2] = true
end

local onPlayerStepCall = function(player)
	local relicTermination = player:countItem(it.RelicTermination)
	if relicTermination > 0 then
		local data = player:getData()
		if net.host then
			if data.termTimer > 0 then
				data.termTimer = data.termTimer - 1
			else
				data.termTimer = 8 * 60
				local w, h = 400, 300
				local possibleEnemies = {}
				local playerTeam = player:get("team")
				for _, actor in ipairs(pobj.actors:findAll(player.x - w, player.y - h, player.x + w, player.y + h)) do
					if actor:get("team") ~= playerTeam and actor:get("hp") >= actor:get("maxhp") * 0.9 and actor:get("elite_type") ~= elt.Relic.id and not blacklist[actor:getObject()] then
						table.insert(possibleEnemies, actor)
					end
				end
				local enemy = table.irandom(possibleEnemies)
				if enemy then
					local affix = 1
					if enemy:isBoss() then affix = 2.4 end
					local stackVal = relicTermination - 1
					local stackMult = 1 - 1 * (stackVal / (10 + stackVal))
					data.termTimer = 35 * stackMult * 60 * affix
					local timerValue = 10 * stackMult * 60 * affix
					data.termTarget = {instance = enemy, x = enemy.x, y = enemy.y, timer = timerValue}
					syncChoice:sendAsHost(net.ALL, nil, player:getNetIdentity(), enemy:getNetIdentity(), timerValue)
				end
			end
		end
		if data.termTarget then
			if data.termTarget.instance:isValid() then
				data.termTarget.x = data.termTarget.instance.x
				data.termTarget.y = data.termTarget.instance.y
				if data.termTarget.timer > 0 then
					data.termTarget.timer = data.termTarget.timer - 1
				elseif net.host then
					makeRelicElite(data.termTarget.instance)
					if net.online then
						syncRelicElite:sendAsHost(net.ALL, nil, player:getNetIdentity(), data.termTarget.instance:getNetIdentity())
					end
					data.termTarget = nil
				end
			elseif net.host then
				local itemPool = rollItemPool(2, 0, 30, 100)
				if ar.Command.active then
					itemPool:getCrate():create(data.termTarget.x,data.termTarget.y - 12)
				else
					itemPool:roll():create(data.termTarget.x, data.termTarget.y - 14)
				end
				data.termTarget = nil
			end
		end
	end
end

local onPlayerDrawCall = function(player)
	local relicTermination = player:countItem(it.RelicTermination)
	if relicTermination > 0 then
		local data = player:getData()
		if data.termTarget and data.termTarget.instance:isValid() then
			local target = data.termTarget.instance
			local sides = 3
			local alpha = 1
			graphics.color(Color.fromHex(0xF7D7E3))
			graphics.alpha(alpha)
			local pulse = math.sin(global.timer * 0.15) * 5
			local mult = math.min(data.termTarget.timer / (3 * 60), 1)
			local dis1, dis2 = (30 * mult) + pulse, (60 * (0.1 + mult * 0.9)) + pulse
			local slice = 360 / sides
			for i = 0, sides do
				local angle = math.rad((global.timer * 2) - ((1 - mult) * 200) + slice * i)
				local x1, y1 = target.x + math.sin(angle) * dis1, target.y + math.cos(angle) * dis1
				local x2, y2 = target.x + math.sin(angle) * dis2, target.y + math.cos(angle) * dis2
				graphics.line(x1, y1, x2, y2, 3)
			end
			graphics.circle(target.x, target.y, 10, true)
			--graphics.drawImage{image = , x = player.x, y = player.y, alpha = 0.25}
		end
	end
end

it.RelicTermination:addCallback("pickup", function(player)
	tcallback.register("onPlayerStep", onPlayerStepCall)
	tcallback.register("onPlayerDraw", onPlayerDrawCall)
	if not player:getData().termTimer then
		player:getData().termTimer = 10 * 60
	end
end)
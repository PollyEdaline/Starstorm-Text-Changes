local path = "Items/Resources/"

it.StirringSoul = Item.new("Stirring Soul")
local sStirringSoul = Sound.load("StirringSoul", path.."stirringSoul")
it.StirringSoul.pickupText = "What am I fighting for?" 
it.StirringSoul.sprite = Sprite.load("Stirring Soul", path.."Stirring Soul.png", 1, 13, 14)
itp.sibylline:add(it.StirringSoul)
it.StirringSoul.color = Color.fromHex(0xFFCCED)
it.StirringSoul:setLog{
	group = "end",
	description = "Slain enemies leave a &y&soul&!& that have a chance to &b&turn into an item&!& on contact.",
	story = "Can I really justify my actions with survival? What am I fighting for?\n\nI will never get back everything I lost.",
	priority = "&"..it.StirringSoul.color.gml.."&Unknown",
	destination = "",
	date = "Unknown"
}
callback.register("onItemRemoval", function(player, item, amount)
	if item == it.StirringSoul then
		player:set("stirringSoul", player:get("stirringSoul") - amount)
	end
end)
if obj.NemesisCommando then
	NPC.registerBossDrops(obj.NemesisCommando, 100)
	NPC.addBossItem(obj.NemesisCommando, it.StirringSoul)
end

local souls = {}

local postStepCall = function()
	for _, self in ipairs(obj.Body:findAll()) do
		if not self:getData().ichecked then
			self:getData().ichecked = true
			table.insert(souls, {sprite = self.sprite, x = self.x, y = self.y, xscale = self.xscale, yscale = self.yscale})
		end
	end
end

local function drawSouls()
	if runData.stirringSoulEnabled then
		for _, body in ipairs(souls) do
			if body.used ~= true and onScreenPos(body.x, body.y) then
				local shake = math.random(-1, 1)
				graphics.alpha(math.random(0.6, 0.75))
				graphics.setBlendMode("additive")
				graphics.color(Color.WHITE)
				graphics.circle(body.x, body.y, 3.5 + shake, true)
				graphics.circle(body.x, body.y, 2 + shake, false)
				graphics.setBlendMode("normal")
			end
		end
	end
end 
local onStageEntryCall = function()
	souls = {}
	graphics.bindDepth(2, drawSouls)
end

local onPlayerStepCall = function(player)
	local playerAc = player:getAccessor()
	
	if playerAc.stirringSoul and playerAc.stirringSoul > 0 then
		for _, body in ipairs(souls) do
			if body.used ~= true and body.x > player.x - 50 and body.x < player.x + 50 and body.y > player.y - 50 and body.y < player.y + 50 then
				body.used = true
				sStirringSoul:play(0.85 + math.random() * 0.3)
				if global.quality > 1 then
					par.Heal:burst("above", body.x, body.y, 10)
				end
				if not net.online or net.host then
					if math.chance(20) then
						spawnItem(1, 15, 30, 100, body.x, body.y - 10)
					end
				end
				
			end
		end
	end
end

it.StirringSoul:addCallback("pickup", function(player)
	runData.stirringSoulEnabled = true
	graphics.bindDepth(2, drawSouls)
	player:set("stirringSoul", (player:get("stirringSoul") or 0) + 1)
	tcallback.register("postStep", postStepCall)
	tcallback.register("onStageEntry", onStageEntryCall)
	tcallback.register("onPlayerStep", onPlayerStepCall)
end)
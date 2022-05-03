local path = "Items/Resources/"

it.Remuneration = Item.new("Remuneration")
--local sRemuneration = Sound.load("Remuneration", path.."Remuneration")
it.Remuneration.pickupText = "A deserved opportunity."
it.Remuneration.sprite = Sprite.load("Remuneration", path.."Remuneration.png", 1, 15, 15)
itp.sibylline:add(it.Remuneration)
it.Remuneration.color = Color.fromHex(0xFFCCED)
it.Remuneration:setLog{
	group = "end",
	description = "Each stage entry offers you benefits.",
	story = "A currency unlike any other, my own value felt diminished with every second I held it. Yet, I didn't let go. I needed it in hope it would help me survive what was yet to come.",
	priority = "&"..it.StirringSoul.color.gml.."&Unknown",
	destination = "",
	date = "Unknown"
}
if obj.NemesisMercenary then
	NPC.registerBossDrops(obj.NemesisMercenary, 100)
	NPC.addBossItem(obj.NemesisMercenary, it.Remuneration)
end

spr.Rem1 = Sprite.load("Remuneration1", path.."Remuneration1.png", 1, 16, 16)
spr.Rem2 = Sprite.load("Remuneration2", path.."Remuneration2.png", 1, 16, 16)
spr.Rem3 = Sprite.load("Remuneration3", path.."Remuneration3.png", 1, 16, 16)
obj.Remuneration1 = Object.new("Remuneration1")
obj.Remuneration1:addCallback("create", function(self)
	self:getData().life = 60
end)
obj.Remuneration1:addCallback("step", function(self)
	local data = self:getData()
	if data.life > 0 then
		data.life = data.life - 1
		local gold = obj.EfGold:create(self.x, self.y)
		gold:set("value", Difficulty.getScaling("cost") * 10):set("direction", math.random(180)):set("speed", math.random(0.5, 3))
	else
		self:destroy()
	end
end)

obj.Remuneration2 = Object.new("Remuneration2")
obj.Remuneration2:addCallback("create", function(self)
	if net.host then
		local item = itp.rare:roll()
		item:create(self.x, self.y)
	end
	self:destroy()
end)

obj.Remuneration3 = Object.new("Remuneration3")
obj.Remuneration3:addCallback("create", function(self)
	self:getData().acc = 0
end)
obj.Remuneration3:addCallback("step", function(self)
	local data = self:getData()
	local teles = obj.Teleporter:findMatchingOp("active", ">=", 3)
	if #teles > 0 then
		local tele = teles[1]
		if tele:get("isBig") then
			self:destroy()
		else
			self.x = tele.x + 40
			local dis = distance(self.x, self.y, tele.x, tele.y)
			self.y = math.approach(self.y, tele.y, 0.4 + (dis * 0.03))
			if self.y == tele.y then
				local portal = obj.VoidPortal:create(self.x, self.y)
				local data = portal:getData()
				data.stage = stg.VoidShop
				data.color = Color.fromHex(0x00AEFF)
				data.sprite = spr.VoidPortal2
				data.particles = par.BluePortal
				self:destroy()
			end
		end
	else
		if self.y > -10 then
			data.acc = data.acc + 0.05
			self.x = self.x + math.sin(global.timer * 0.1)
			self.y = self.y - data.acc
		else
			data.acc = 0
		end
	end
end)
obj.Remuneration3:addCallback("draw", function(self)
	local data = self:getData()
	graphics.alpha(0.5)
	graphics.color(Color.fromHex(0x1ACBDB))
	graphics.circle(self.x, self.y, math.random(6, 8))
	graphics.alpha(1)
	graphics.color(Color.WHITE)
	graphics.circle(self.x, self.y, math.random(2, 3))
end)

local onStageEntryCall = function()
	if Stage.getCurrentStage() ~= stg.VoidShop then
		for _, player in ipairs(misc.players) do
			local remuneration = player:countItem(it.Remuneration)
			if remuneration > 0 then
				--[[local bonusGold = math.ceil((misc.director:get("enemy_buff") - 0.5) * (1000 + 1500 * remuneration))
				misc.setGold(misc.getGold() + bonusGold)]]
				
				obj.RemChoice:create(player.x, player.y)
				break
			end
		end
	end
end

it.Remuneration:addCallback("pickup", function(player)
	--if net.host then
		tcallback.register("onStageEntry", onStageEntryCall)
	--end
end)
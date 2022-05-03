local path = "Items/Resources/"

it.BrokenBT = Item.new("Broken Blood Tester")
local sbrokenBT = Sound.load("BrokenBT", path.."brokenBT")
local brokenBTDis = Sprite.load("brokenBTdisplay", path.."brokenBTdis.png", 1, 3, 3)
it.BrokenBT.pickupText = "Earn money when healing." 
it.BrokenBT.sprite = Sprite.load("BrokenCBT", path.."Broken Blood Tester.png", 1, 14, 10)
it.BrokenBT:setTier("uncommon")
it.BrokenBT:setLog{
	group = "uncommon",
	description = "&y&Earn $2&!& for every &g&15 HP regenerated&!&.",
	story = "Look, I already told you in a message, but the UES requires info on all deliveries so let me just make this clear:\nWhen I ordered this Blood Tester unit (which was not cheap at all!), it arrived and functioned perfectly fine. But just two days after normal use it began THROWING OUT the coins instead of, you know... RECEIVING THEM??? Like, all my customers just started staying in front of it, hitting themselves just so your [REDACTED] machine made them rich.\nI want my money back, all of it. I'm really sorry but I'm never buying from you again. I wish you luck but you really have to check your quality control processes.",
	destination = "#11 Looeng St.,\nTRR,\nEarth",
	date = "05/22/2056"
}

local stageEntry = false
table.insert(call.onStageEntry, function()
	for _, player in ipairs(misc.players) do
		player:set("lastHp", player:get("hp"))
	end
	stageEntry = true
end)
callback.register("postStageEntry", function()
	stageEntry = false
end)

local onPlayerStepCall = function(player)
	local playerAc = player:getAccessor()
	local hpDif = 0
	if playerAc.lastHp ~= playerAc.hp then
		hpDif = playerAc.hp - playerAc.lastHp
	end
	if stageEntry then
		hpDif = 0
		playerAc.hpDifSum = 0
	end
	
	local brokenBT = player:countItem(it.BrokenBT)
	local teleReady = #obj.Teleporter:findMatchingOp("active", ">", 3) > 0
	
	if brokenBT > 0 and not teleReady and not obj.CustomTextbox:find(1) then
		if hpDif > 0 then
			if playerAc.hpDifSum then
				playerAc.hpDifSum = playerAc.hpDifSum + hpDif
				if playerAc.hpDifSum >= math.max(15, 1) then
					misc.setGold(misc.getGold() + (2 * brokenBT))
					sbrokenBT:play(0.9 + math.random() * 0.2, 0.3)
					playerAc.hpDifSum = playerAc.hpDifSum - math.max(15, 1)
				end
			else
				playerAc.hpDifSum = 0
			end
		end
	end
end

local onPlayerDrawCall = function(player)
	local playerAc = player:getAccessor()
	
	local brokenBT = player:countItem(it.BrokenBT)
	if brokenBT > 0 then
		graphics.alpha(0.6)
		customBar(player.x - 13, player.y - 19, player.x - 11, player.y - 1, playerAc.hpDifSum, 16 - brokenBT)
		--graphics.drawImage{image = brokenBTDis, x = player.x - 11, y = player.y - 21, alpha = 0.6}
	end
end

it.BrokenBT:addCallback("pickup", function(player)
	player:set("hpDifSum", 0)
	tcallback.register("onPlayerStep", onPlayerStepCall)
	tcallback.register("onPlayerDraw", onPlayerDrawCall)
end)
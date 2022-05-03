local path = "Items/Resources/"

it.PaulTape = Item.new("Paul's Motivational Tape")
it.PaulTape.pickupText = "Increased will to fight!" 
it.PaulTape.sprite = Sprite.load("PaulsTape", path.."Paul's Motivational Tape.png", 1, 16, 11)
it.PaulTape.color = Color.fromHex(0xAB62CA)
local confettiColors = {Color.RED, Color.BLUE, Color.WHITE, Color.YELLOW, Color.PURPLE, Color.PINK, Color.ORANGE, Color.GREEN, Color.AQUA}
if obj.Paul then
	NPC.registerBossDrops(obj.Paul, 100, nil, true)
	NPC.addBossItem(obj.Paul, it.PaulTape)
end

local onNPCDeathProcCall = function(npc, player)
	if player:countItem(it.PaulTape) > 0 then
		sfx.Squeaky:play(0.6 + math.random() * 0.4, 0.5)
		for i = 0, 20 do
			local color = table.irandom(confettiColors)
			par.Confetti:burst("above", npc.x, npc.y, 1, color)
		end
	end
end

it.PaulTape:addCallback("pickup", function(player)
	tcallback.register("onNPCDeathProc", onNPCDeathProcCall)
end)
local path = "Items/Resources/"

it.Midas = Item.new("M.I.D.A.S")
local sMidas = Sound.load("MidasUse", path.."midasUse")
it.Midas.pickupText = "Deduct half your health and gain it as gold." 
it.Midas.sprite = Sprite.load("MIDAS", path.."M.I.D.A.S.png", 2, 19, 11)
it.Midas.isUseItem = true
it.Midas.useCooldown = 60
it.Midas:setTier("use")
itp.enigma:add(it.Midas)
it.Midas:setLog{
	group = "use",
	description = "&r&Deduct 50% of your health, &y&earning the same amount in gold&!&.",
	story = [["A miracle from the gods.."
You keep saying it over and over again. Are you out of your mind? You keep treating us like we're ignorant when all we tried to do was to SAVE YOU.
Do us a favour and keep it. Do whatever you want with it, we do NOT want to see you around here anymore. We do NOT want to be part of whatever is going on with you and this thing.
It's making you a greedy, souless person and I hope you know it.]],
	destination = "R A 5-5,\nPrime,\nTitan",
	date = "05/04/2056"
}
it.Midas:addCallback("use", function(player, embryo)
	local playerAc = player:getAccessor()
	local halfhp = (playerAc.hp / 2) - 1
	playerAc.hp = playerAc.hp - halfhp
	sMidas:play()
	if not net.online or player == net.localPlayer then
		misc.hud:set("gold", misc.hud:get("gold") + halfhp)
		local mult = 1
		if embryo then mult = 2 end
		local gold = (misc.hud:get("total_gold") + halfhp) * mult
		misc.hud:set("total_gold", gold)
	end
end)
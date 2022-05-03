local path = "Items/Resources/"


it.CrypticSource = Item.new("Cryptic Source")
local cCrypticSource = Color.fromHex(0xD3F257)
it.CrypticSource.pickupText = "Changing direction creates bursts of electricity." 
it.CrypticSource.sprite = Sprite.load("CrypticSource", path.."Cryptic Source.png", 1, 14, 15)
it.CrypticSource:setTier("uncommon")
it.CrypticSource:setLog{
	group = "uncommon",
	description = "Changing direction &y&creates bursts of electricity that deal 65% damage.",
	story = "From atoms to sentient beings, everything comes from energy, however this rather cryptic object seems to emanate energy on its own. High amounts of friction seem to trigger a chain reaction which makes it highly unstable, but also, a manipulable source of (infinite?) energy. Wether this will lead us to the utopian future we crave for is completely uncertain, but this completely changes our previous thoughts about the universe.\nUnless we're mistaken.",
	destination = "O32,\nLow End,\nEarth",
	date = "03/30/2058"
}
it.CrypticSource:addCallback("pickup", function(player)
	player:set("crypticSource", (player:get("crypticSource") or 0) + 1)
end)
callback.register("onItemRemoval", function(player, item, amount)
	if item == it.CrypticSource then
		player:set("crypticSource", player:get("crypticSource") - amount)
	end
end)

callback.register("onActorStep", function(actor)
	local actorAc = actor:getAccessor()
	local actorData = actor:getData()
	
	local crypticSource = actorAc.crypticSource
	if crypticSource and crypticSource > 0 then
		if not actorData.lastxscale then actorData.lastxscale = actor.xscale end
		
		if not actorData.cscd then
			if actorData.lastxscale == actor.xscale * -1 then
				if isa(actor, "PlayerInstance") or onScreen(actor) then
					actorData.cscd = 10
					local lightning = obj.ChainLightning:create(actor.x, actor.y)
					lightning:set("damage", math.round(actorAc.damage * (0.15 + (0.55 * crypticSource))))
					local crit = math.chance(actorAc.critical_chance)
					if crit then
						lightning:set("damage", lightning:get("damage") * 2)
						lightning:set("critical", 1)
					end
					lightning:set("blend", cCrypticSource.gml)
					lightning:set("bounce", 2)
					lightning:set("team", actorAc.team)
					lightning:set("parent", actor.id)
					actorData.lastxscale = actor.xscale
				end
			end
		else
			if actorData.cscd > 0 then
				actorData.cscd = actorData.cscd - 1
			else
				actorData.cscd = nil
			end
		end
	end
end)
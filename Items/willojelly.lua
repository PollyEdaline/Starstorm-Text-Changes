local path = "Items/Resources/"

it.Willojelly = Item.new("Man-o'-war")
it.Willojelly.pickupText = "Enemies create an electric discharge on kill."
it.Willojelly.sprite = Sprite.load("Willojelly", path.."Man-o'-war.png", 1, 13, 14)
it.Willojelly:setTier("uncommon")
it.Willojelly:setLog{
	group = "uncommon_locked",
	description = "Killing an enemy creates an &y&electric discharge for 70% damage.",
	story = "Guys, remember the tiny guy I sent over some time ago? Well... This one is somewhat more agressive... although she is a funny little gal! She loves spinnin' around and watching me from inside the bottle. Man if I had not rescued her she would be in some alien stomach right now.\nI kinda want to name her Ann, thoughts?",
	destination = "Hidden Cubby,\nMt. Creation,\nVenus",
	date = "11/20/2056"
}

local efColor = Color.fromHex(0xC6AAFF)

local onNPCDeathProcCall = function(actor, player)
	local count = player:countItem(it.Willojelly)
	if count > 0 then
		obj.ChainLightning:create(actor.x, actor.y):set("team", player:get("team")):set("damage", math.ceil(player:get("damage") * (0.3 + 0.4 * count))):set("bounce", 2):set("blend", efColor.gml)
		if onScreen(actor) then
			sfx.ChainLightning:play(1.1 + math.random() * 0.2, 0.5)
		end
	end
end

it.Willojelly:addCallback("pickup", function(player)
	tcallback.register("onNPCDeathProc", onNPCDeathProcCall)
end)

-- so simple :)
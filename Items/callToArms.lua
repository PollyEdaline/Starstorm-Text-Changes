local path = "Items/Resources/"

local efColor = Color.fromHex(0xFF6842)

it.CalltoArms = Item.new("Call to Arms")
--local sCalltoArms = Sound.load("CalltoArms", path.."CalltoArms")
it.CalltoArms.pickupText = "I won't be alone."
it.CalltoArms.sprite = Sprite.load("CalltoArms", path.."Call to Arms.png", 1, 14, 12)
itp.sibylline:add(it.CalltoArms)
it.CalltoArms.color = Color.fromHex(0xFFCCED)
it.CalltoArms:setLog{
	group = "end",
	description = "Spawns three ghostly warriors upon activating the teleporter.",
	story = ".",
	priority = "&"..it.StirringSoul.color.gml.."&Unknown",
	destination = "",
	date = "Unknown"
}
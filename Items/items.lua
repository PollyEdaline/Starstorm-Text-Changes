-- Items

local dir = "Items."
local path = "Items/Resources/"

specialUseItems = {}

-- Vanilla Modifications

require("Items.headStompers")

require("Items.spikestrip")

require("Items.snakeEyes")

require("Items.droneRepairKit")

require("Items.safeguardLantern")

-- Common

require("Items.detritiveTrematode")

require("Items.dormantFungus")

require("Items.armedBackpack")

require("Items.brassKnuckles")

require("Items.diary")

require("Items.distinctiveStick")

require("Items.fork")

require("Items.iceTool")

require("Items.malice")

require("Items.moltenCoin")

--require("Items.giftCard")

require("Items.coffeeBag")

require("Items.wonderHerbs")

require("Items.needles")

require("Items.guardingAmulet")

require("Items.x4Stimulant")

-- Uncommon

require("Items.strangeCan")

require("Items.brokenBloodTester")

require("Items.balloon")

require("Items.prototypeJetBoots")

require("Items.poisonousGland")

require("Items.roulette")

require("Items.crowningValiance")

require("Items.metachronicTrinket")

require("Items.hottestSauce")

require("Items.voltaicGauge")

require("Items.watchMetronome")

require("Items.lowQualitySpeakers")

require("Items.crypticSource")

require("Items.fieldAccelerator")

require("Items.goldMedal")

require("Items.huntersSigil")

require("Items.willojelly")

require("Items.vaccine")

require("Items.stickyOverloader")

-- Rare
require("Items.nkotasHeritage")

require("Items.droidHead")

require("Items.greenChocolate")

require("Items.erraticGadget")

require("Items.insecticide")

require("Items.babysToys")

require("Items.compositeInjector")

require("Items.swiftSkateboard")

require("Items.judderingEgg")

require("Items.portableReactor")

require("Items.baneFlask")

require("Items.galvanicCore")

require("Items.gemBreacher")

--require("Items.3dvisor")

-- Legendary
require("Items.shellPiece")

require("Items.unearthlyLamp")

require("Items.toxicTail")

require("Items.scaldingScale")

require("Items.scavengersFortune")

require("Items.beatingHeart")

require("Items.animatedMechanism")

require("Items.regurgitatedRock")

-- Sibylline
itp.sibylline = ItemPool.new("Sibylline")
obj.sibyllineCrate = itp.sibylline:getCrate()
obj.sibyllineCrate.sprite = Sprite.load("SibyllineCrate", "Interactables/Resources/SibyllineCrate", 1, 13, 20)

require("Items.stirringSoul")

require("Items.augury")

require("Items.yearningDemise")

require("Items.entangledEnergy")

require("Items.thrivingGrowth")

require("Items.nucleusGems")

require("Items.oraclesOrdeal")

require("Items.bleedingContract")

require("Items.remuneration")

require("Items.allHoldingHand")

-- Curse
itp.curse = ItemPool.new("Curse")
sfx.CursePickup = Sound.load("CursePickup", "Items/Resources/cursePickup")
callback.register("onItemPickup", function(itemI, player)
	local item = itemI:getItem()
	if itp.curse:contains(item) then
		itemI:destroy()
		if not net.online or player == net.localPlayer then
			runData.cursePickupDisplay = 180
			player:getData().cursePickupDisplay = {title = item.displayName, text = item.pickupText, i = 520}
			sfx.CursePickup:play()
		end
	end
end)
table.insert(call.onDraw, function()
	for _, player in ipairs(misc.players) do
		local curse = player:getData().cursePickupDisplay
		if curse then
			graphics.alpha(curse.i / 280)
			local str = curse.title.."\n"..curse.text
			graphics.color(Color.BLACK)
			local yy = 15
			graphics.print(str, player.x, player.y + yy + 1, graphics.ALIGN_MIDDLE, graphics.ALIGN_CENTRE)
			graphics.print(str, player.x, player.y + yy + 2, graphics.ALIGN_MIDDLE, graphics.ALIGN_CENTRE)
			graphics.color(Color.WHITE)
			graphics.print(str, player.x, player.y + yy, graphics.ALIGN_MIDDLE, graphics.ALIGN_CENTRE)
			if curse.i > 0 then
				curse.i = curse.i - 1
			else
				player:getData().cursePickupDisplay = nil
			end
		end
	end
end)
table.insert(call.onHUDDraw, function()
	if runData.cursePickupDisplay and runData.cursePickupDisplay > 0 then
		runData.cursePickupDisplay = runData.cursePickupDisplay - 1
		local w, h = graphics.getHUDResolution()
		graphics.alpha((runData.cursePickupDisplay / 180) * 0.6)
		graphics.color(Color.BLACK)
		graphics.rectangle(0, 0, w, h, false)
	end
end)

require("Items.curseConfusion")

require("Items.curseAffliction")

require("Items.curseMisfortune")

require("Items.curseImpairment")

require("Items.curseMortality")

require("Items.cursePoverty")

-- USE ITEMS

require("Items.seismicOscillator")

require("Items.midas")

require("Items.counterfeitTeleporter")

require("Items.cloakingHeadband")

require("Items.pressurizedCanister")

require("Items.simpleMagnet")

require("Items.greaterWarbanner")

require("Items.hazardousBarrel")

require("Items.roller")

require("Items.whiteFlag")

require("Items.mindshiftGas")

require("Items.backThruster")

require("Items.gHook")

require("Items.pylonFragment")

-- ELITE ASPECT USE ITEMS

itp.elite = ItemPool.new("Elite")

require("Items.fracturedCrown")

require("Items.eclipsingShard")

require("Items.causticPearl")

require("Items.agelessTotem")

-- Other
require("Items.paulsMotivationalTape")

require("Items.voidKey")

require("Items.peculiarRock")

require("Items.gildedOrnament")

require("Items.providenceSword")

require("Items.arraignSword")

require("Items.bmcontact")

--require("Items.newItems")

if global.rormlflag.ss_april_fools_2020 then
	require("Items.aprilFoolsBoars")
end

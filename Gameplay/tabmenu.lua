
-- All info menu data

local items = {}

-- INFO

	-- VANILLA ITEMS
	local specialInfo = {
		{name = "Barbed Wire", maxStack = nil, info = "Deals 50% damage to nearby enemies.", stackInfo = "+20% radius, +17% DPS."},
		{name = "Bitter Root", maxStack = 38, info = "Gain 8% total health.", stackInfo = "+8% total health."},
		{name = "Bundle of Fireworks", maxStack = nil, info = "Containers fire 8 fireworks for 300% damage.", stackInfo = "+2 fireworks."},
		{name = "Bustling Fungus", maxStack = nil, info = "Heal 4.5% HP after standing still for 2 seconds.", stackInfo = "+4.5% HP."},
		{name = "Crowbar", maxStack = nil, info = "Deal 50% bonus damage to enemies with more than 80% HP.", stackInfo = "+30% damage."},
		{name = "Fire Shield", maxStack = nil, info = "On being hit for 10% of your HP, explode for 400% damage.", stackInfo = "+200% damage, +20% knockback."},
		{name = "First Aid Kit", maxStack = nil, info = "Heal 10 HP 1.1 seconds after being hit.", stackInfo = "+10 HP."},
		{name = "Gasoline", maxStack = nil, info = "Burn the ground upon killing an enemy for 60% DPS.", stackInfo = "+40% DPS."},
		{name = "Headstompers", maxStack = nil, info = "Hurt enemies by falling for up to 507% damage. Hold down to increase speed.", stackInfo = "+30% damage."},
		{name = "Hermit's Scarf", maxStack = 6, info = "10% chance to dodge an attack.", stackInfo = "+5% chance."},
		{name = "Lens Maker's Glasses", maxStack = 14, info = "+7% Critical Strike chance.", stackInfo = "+7% chance."},
		{name = "Life Savings", maxStack = nil, info = "Earn +$1 every 3 seconds.", stackInfo = "increased rate."},
		{name = "Meat Nugget", maxStack = nil, info = "Enemies have an 8% chance to drop meat nuggets, which heal 6 HP.", stackInfo = "+6 HP."},
		{name = "Monster Tooth", maxStack = nil, info = "On kill, heal 10 HP.", stackInfo = "+5 HP."},
		{name = "Mortar Tube", maxStack = nil, info = "9% chance to fire a mortar for 170% damage.", stackInfo = "+170% damage."},
		{name = "Mysterious Vial", maxStack = nil, info = "Increases health regeneration by 1.2.", stackInfo = "+1.2 health regeneration."},
		{name = "Paul's Goat Hoof", maxStack = 25, info = "Increases movement speed by 20%.", stackInfo = "+20% movement speed."},
		{name = "Rusty Blade", maxStack = 7, info = "+15% chance on hit to bleed an enemy for 4x35% damage.", stackInfo = "+15% chance."},
		{name = "Snake Eyes", maxStack = nil, info = "Increases Critical Strike chance by 5% and damage by 1 for every shrine fail. Stacks up to 6 times.", stackInfo = "+3% chance, +1 damage."},
		{name = "Soldier's Syringe", maxStack = 13, info = "+15% attack speed.", stackInfo = "+15% attack speed."},
		{name = "Spikestrip", maxStack = nil, info = "Drop spikestrips on getting hit. Spikestrips slow enemies by 20%, and bleeds them for 25% damage.", stackInfo = "increases duration."},
		{name = "Sprouting Egg", maxStack = nil, info = "+2.4 health regeneration after not being hit for 7 seconds.", stackInfo = "+2.4 health regeneration."},
		{name = "Sticky Bomb", maxStack = nil, info = "8% chance to stick a bomb on enemies for 140% damage.", stackInfo = "+40% damage."},
		{name = "Taser", maxStack = nil, info = "7% chance to snare enemies for 1.5 seconds.", stackInfo = "+0.5 seconds."},
		{name = "Warbanner", maxStack = nil, info = "Drop a banner on level up, which increases attack and movement speed by 30%, and damage by 4.", stackInfo = "+40% radius."},

		{name = "56 Leaf Clover", maxStack = 65, info = "4% chance of dropping an item on killing elites.", stackInfo = "+1.5% chance."},
		{name = "Arms Race", maxStack = nil, info = "Drones get a 9% chance of firing missiles and mortars.", stackInfo = "+10% chance, +170% mortar damage."},
		{name = "AtG Missile Mk. 1", maxStack = 10, info = "10% chance on hit to launch a missile for 300% damage.", stackInfo = "+10% chance."},
		{name = "Boxing Gloves", maxStack = nil, info = "15% chance to deal extra knockback.", stackInfo = "+6% chance, multiplicatively."},
		{name = "Chargefield Generator", maxStack = nil, info = "Kills expand a ring which deals 100% DPS for 6 seconds.", stackInfo = "+10% DPS."},
		{name = "Concussion Grenade", maxStack = nil, info = "+6% chance to stun enemies for 2 seconds.", stackInfo = "+6% chance, multiplicatively."},
		{name = "Dead Man's Foot", maxStack = nil, info = "Reaching low health drops a poison mine for 4x150% damage.", stackInfo = "+1 poison tick."},
		{name = "Energy Cell", maxStack = 4, info = "Attack speed increases in relation to remaining health.", stackInfo = "+20% attack speed."},
		{name = "Filial Imprinting", maxStack = nil, info = "Spawn a creature which drops a buff every 20 seconds.", stackInfo = "+1 creature."},
		{name = "Frost Relic", maxStack = nil, info = "Killing enemies surrounds you with 3 icicles. Each icicle deals 33% damage.", stackInfo = "+1 icicle."},
		{name = "Golden Gun", maxStack = nil, info = "Deal additional damage based on gold, up to 40% at 700 gold (scales over time).", stackInfo = "halves gold amount needed for max damage."},
		{name = "Guardian's Heart", maxStack = nil, info = "+60 shield. Recharges after 7 seconds out of combat.", stackInfo = "+60 shield."},
		{name = "Harvester's Scythe", maxStack = nil, info = "Heal 8 HP on Critical Strikes. +5% Critical Strike chance.", stackInfo = "+2 HP, +5% Critical Strike chance."},
		{name = "Hopoo Feather", maxStack = nil, info = "Gain an additional jump.", stackInfo = "+1 jump."},
		{name = "Infusion", maxStack = nil, info = "Killing an enemy increases total health by 1.", stackInfo = "+0.5 total health."},
		{name = "Leeching Seed", maxStack = nil, info = "Dealing damage heals 2 HP. Doesn't account for pierce.", stackInfo = "+1 HP."},
		{name = "Panic Mines", maxStack = nil, info = "Drop a mine at low health, dealing 500% damage.", stackInfo = "+1 mine."},
		{name = "Predatory Instincts", maxStack = nil, info = "+5% Critical Strike chance. +10% attack speed on Critical Strike, up to 30%.", stackInfo = "+5% Critical Strike chance, +1% attack speed."},
		{name = "Prison Shackles", maxStack = nil, info = "Slow enemies by 20% on hit.", stackInfo = "+0.5 seconds duration."},
		{name = "Red Whip", maxStack = 14, info = "+80% movement speed upon leaving combat for 1.5 seconds.", stackInfo = "+50% movement speed."},
		{name = "Rusty Jetpack", maxStack = 15, info = "Halves gravity, +10% jump height.", stackInfo = "+10% jump height."},
		{name = "Smart Shopper", maxStack = nil, info = "+25% gold earnings from enemies.", stackInfo = "+25% gold."},
		{name = "Time Keeper's Secret", maxStack = 8, info = "Stops time for 3 seconds upon reaching critical health.", stackInfo = "+1 second."},
		{name = "Tough Times", maxStack = nil, info = "Increases Armor by 14.", stackInfo = "+14 Armor."},
		{name = "Toxic Centipede", maxStack = nil, info = "Infect an enemy on touch, dealing 50% DPS.", stackInfo = "increases damage."},
		{name = "Ukulele", maxStack = nil, info = "20% chance to fire chain lightning for 4x33% damage.", stackInfo = "+33% damage."},
		{name = "Will-o'-the-wisp", maxStack = nil, info = "33% chance to detonate slain enemies for 250% damage.", stackInfo = "+100% damage."},

		{name = "Alien Head", maxStack = 3, info = "Decreases all ability cooldowns by 25%.", stackInfo = "stacks multiplicatively."},
		{name = "Ancient Scepter", maxStack = 1, info = "Upgrades your fourth ability.", stackInfo = "Does not stack."},
		{name = "AtG Missile Mk. 2", maxStack = 15, info = "7% chance on hit to launch 3 missiles dealing 300% damage each.", stackInfo = "+7% chance."},
		{name = "Beating Embryo", maxStack = 4, info = "Use items have a 30% chance of doubling the effect.", stackInfo = "+30% chance."},
		{name = "Brilliant Behemoth", maxStack = nil, info = "All damage dealt explodes as 20% extra damage.", stackInfo = "+20% damage."},
		{name = "Ceremonial Dagger", maxStack = nil, info = "Kills create 4 homing daggers, dealing 100% damage.", stackInfo = "+2 daggers."},
		{name = "Dio's Friend", maxStack = nil, info = "Earn an extra life.", stackInfo = "+1 life."},
		{name = "Fireman's Boots", maxStack = nil, info = "Leave a trail of fire while walking which deals 35% damage.", stackInfo = "+20% damage."},
		{name = "Happiest Mask", maxStack = nil, info = "Killed enemies become allied ghosts with 70% HP and 50% damage for 15 seconds.", stackInfo = "increases ghost duration and damage."},
		{name = "Heaven Cracker", maxStack = 4, info = "Every fourth basic attack pierces enemies.", stackInfo = "reduces the amount of attacks required."},
		{name = "Hyper-Threader", maxStack = nil, info = "Every attack fires a laser, bouncing for 40% damage to 2 enemies.", stackInfo = "+1 bounce."},
		{name = "Interstellar Desk Plant", maxStack = nil, info = "Spawn an alien plant on kill which heals you for 8 HP.", stackInfo = "+3 HP."},
		{name = "Laser Turbine", maxStack = nil, info = "Abilities charge a generator. When full, fire a laser dealing 2000% damage.", stackInfo = "increases charge per ability."},
		{name = "Old Box", maxStack = nil, info = "Drop a box at low health, fearing enemies for 2 seconds.", stackInfo = "increases minimun health required."},
		{name = "Permafrost", maxStack = nil, info = "Chance to freeze enemies for 1.5 seconds.", stackInfo = "+6% chance."},
		{name = "Photon Jetpack", maxStack = nil, info = "Fly for up to 1.6 seconds, charges while not in use.", stackInfo = "+0.8 seconds."},
		{name = "Plasma Chain", maxStack = nil, info = "Chance to tether onto enemies, dealing 60% DPS.", stackInfo = "increases max tethers."},
		{name = "Rapid Mitosis", maxStack = 30, info = "Reduces use item cooldown by 25%.", stackInfo = "stacks multiplicatively."},
		{name = "Repulsion Armor", maxStack = 5, info = "After 6 hits, reduce incoming damage by 83% for 3 seconds.", stackInfo = "+1 second."},
		{name = "Shattering Justice", maxStack = nil, info = "Reduces enemy Armor by 5, up to 25.", stackInfo = "+0.5 second duration."},
		{name = "Telescopic Sight", maxStack = 5, info = "1% chance to instantly kill an enemy.", stackInfo = "+0.5% chance."},
		{name = "Tesla Coil", maxStack = nil, info = "Shock nearby enemies for 150% damage.", stackInfo = "+50% damage."},
		{name = "Thallium", maxStack = 1, info = "Chance to slow enemies by 100% and deal 500% as damage over time.", stackInfo = "Does not stack."},
		{name = "The Hit List", maxStack = nil, info = "Randomly marks an enemy. Killing marked enemies increases damage by 0.5, up to 20.", stackInfo = "increases marked enemies."},
		{name = "The Ol' Lopper", maxStack = 8, info = "Deal Critical Strikes on enemies below 9% health.", stackInfo = "+4% minimum health."},
		{name = "Wicked Ring", maxStack = nil, info = "Critical Strikes reduce all ability cooldowns by 1 second.", stackInfo = "+1 second, +6% Critical Strike chance."},

		{name = "Burning Witness", maxStack = nil, info = "Kills grant a fire trail that gives +5% movement speed speed and +1 damage for 6 seconds.", stackInfo = "+5% movement speed, increases duration."},
		{name = "Colossal Knurl", maxStack = nil, info = "Increases health by 40, health regeneration by 1.2, and Armor by 6.", stackInfo = "+40 health, +1.2 health regeneration, +6 Armor."},
		{name = "Ifrit's Horn", maxStack = nil, info = "8% chance to create a fire wave, hitting enemies for 220% damage.", stackInfo = "+30% damage."},
		{name = "Imp Overlord's Tentacle", maxStack = nil, info = "Spawn a minion imp.", stackInfo = "increases the imp's stats."},
		{name = "Legendary Spark", maxStack = nil, info = "8% chance to spawn two sparks on attacking enemies for 100% damage each.", stackInfo = "+1 spark."},

		{name = "Small Enigma", maxStack = nil, info = "Reduces cooldown of use items by 5%.", stackInfo = "-5% cooldown duration"},
		{name = "Keycard", maxStack = 4, info = nil, stackInfo = nil},
		{name = "White Undershirt (M)", maxStack = nil, info = "Increases Armor by 3.", stackInfo = "+3 Armor."},

		-- STARSTORM ITEMS
		{name = "Detritive Trematode", maxStack = 35, info = "Enemies receive damage over time upon dropping below 3% health.", stackInfo = "increases health threshold."},
		{name = "Dormant Fungus", maxStack = nil, info = "Regenerates 2% of your total health while moving every second.", stackInfo = "increases heatlh amount multiplicatively."},
		{name = "Armed Backpack", maxStack = 14, info = "18.5% chance of firing a bullet behind you for 150% damage.", stackInfo = "+6.5% chance."},
		{name = "Brass Knuckles", maxStack = nil, info = "Deal 35% extra damage to enemies close to you.", stackInfo = "increases range by 45%."},
		{name = "Diary", maxStack = nil, info = "Earn 0.84 experience per second.", stackInfo = "+0.84 experience per second."},
		{name = "Distinctive Stick", maxStack = nil, info = "Grows a tree at the Teleporter's location, healing nearby players.", stackInfo = "increases range."},
		{name = "Fork", maxStack = nil, info = "Increases base damage by 3.", stackInfo = "+3 base damage."},
		{name = "Ice Tool", maxStack = nil, info = "Gain an extra jump on walls. Increases speed while climbing by 50%.", stackInfo = "+1 jump, increases speed up to 250%."},
		{name = "Malice", maxStack = nil, info = "Damage dealt spreads to a nearby enemy for 45% damage.", stackInfo = "+1 target, increased range."},
		--{name = "Gift Card", maxStack = 12, info = "15% chance for on-hit effects to roll twice.", stackInfo = "+8% chance."},
		{name = "Coffee Bag", maxStack = nil, info = "Increases speed by 10% and attack speed by 7.5%.", stackInfo = "+10% movement speed, +7.5% attack speed."},
		{name = "Wonder Herbs", maxStack = nil, info = "Increases all healing by 12%.", stackInfo = "+12% healing from all sources."},
		{name = "Needles", maxStack = 49, info = "4% chance to mark enemies on hit for 100% extra critical strike chance. Lasts 3 seconds.", stackInfo = "+2% chance."},
		{name = "Guarding Amulet", maxStack = nil, info = "Reduces damage taken from behind you by 40%.", stackInfo = "reduces damage multiplicatively."},
		{name = "Molten Coin", maxStack = nil, info = "6% chance to blaze enemies on hit and earn +$1.", stackInfo = "increases blaze ticks by 4, +$1."},
		{name = "X-4 Stimulant", maxStack = nil, info = "Decreases secondary skill cooldown by 20%.", stackInfo = "-20% multiplicatively."},
		
		{name = "Strange Can", maxStack = nil, info = "8.5% chance to intoxicate enemies for damage over time based on target's max HP.", stackInfo = "+5% chance."},
		{name = "Broken Blood Tester", maxStack = nil, info = "Earn +2 gold for every 15 HP regenerated.", stackInfo = "+2 gold."},
		{name = "Balloon", maxStack = 40, info = "Decreases your gravity by 30%.", stackInfo = "-30% multiplicatively."},
		{name = "Prototype Jet Boots", maxStack = nil, info = "Explode on jump for 150% damage.", stackInfo = "+100% damage."},
		{name = "Poisonous Gland", maxStack = nil, info = "On getting hit while at full health,\ncreate a cloud of poison for 300% DPS. Lasts 5 seconds.", stackInfo = "+150% DPS."},
		{name = "Low Quality Speakers", maxStack = nil, info = "Gain 55% movement speed while at or below 50% HP.", stackInfo = "increases duration."},
		{name = "Roulette", maxStack = nil, info = "Get a random stat buff each minute.", stackInfo = "increases buff value by 50%."},
		{name = "Crowning Valiance", maxStack = nil, info = "All stats are increased when a boss is in proximity.", stackInfo = "further increases stats."},
		{name = "Metachronic Trinket", maxStack = "down to 15 seconds.", info = "Teleporter charge time is reduced by 10 seconds.", stackInfo = "-10 seconds."},
		{name = "Hottest Sauce", maxStack = nil, info = "Activating a use item burns the ground and all nearby enemies for 5 seconds.", stackInfo = "+4 seconds."},
		{name = "Voltaic Gauge", maxStack = nil, info = "Killing elites drops orbs that grant 15 temporary shield.", stackInfo = "+10 shield."},
		{name = "Watch Metronome", maxStack = nil, info = "Standing still for up to 4 seconds charges bonus movement speed for up to 2 seconds.", stackInfo = "+2 second duration."},
		{name = "Cryptic Source", maxStack = nil, info = "Changing direction creates bursts of energy that deal 70% damage.", stackInfo = "+55% damage."},
		{name = "Field Accelerator", maxStack = 20, info = "Teleporters charge 100% faster when no enemies are around.", stackInfo = "+100% speed."},
		{name = "Gold Medal", maxStack = 10, info = "Spending gold heals you for 5 seconds.", stackInfo = "+2 seconds."},
		{name = "Hunter's Sigil", maxStack = nil, info = "Standing still increases Armor by 15 and Critical Strike chance by 25%.", stackInfo = "+10 Armor, +20 crit chance."},
		{name = "Man-o'-war", maxStack = nil, info = "Killing enemies creates an electric discharge dealing 70% damage.", stackInfo = "+40% damage."},
		{name = "Vaccine", maxStack = 7, info = "20% chance to negate debuffs.", stackInfo = "Increases chance multiplicatively."},
		{name = "Sticky Overloader", maxStack = 7, info = "Attacking a foe charges damage by 32% up to 800%. Damage is done after the enemy is not attacked for 1 second.", stackInfo = "Increases damage charge by 32%."},
		
		{name = "Nkota's Heritage", maxStack = nil, info = "Creates a free chest on level up.", stackInfo = "increases chances of a higher rarity chest."},
		{name = "Droid Head", maxStack = nil, info = "Spawns a helping drone for 11 seconds after killing boss enemies.", stackInfo = "+4 seconds."},
		{name = "Green Chocolate", maxStack = 5, info = "Receiving 25% or more of your health as damage increases your Critical Strike chance and damage for 5 seconds.", stackInfo = "+4 seconds."},
		{name = "Erratic Gadget", maxStack = nil, info = "Critical strikes deal 50% extra damage.", stackInfo = "+50% damage."},
		{name = "Insecticide", maxStack = nil, info = "All attacks poison enemies for 25% damage over 4 seconds.", stackInfo = "+2 seconds."},
		{name = "Baby's Toys", maxStack = nil, info = "-3 levels on pickup, keeps all stats (reduced level up experience requirement).", stackInfo = "-3 levels."},
		{name = "Composite Injector", maxStack = nil, info = "Merge one dropped use item with the one equipped.", stackInfo = "+1 merge."},
		{name = "Swift Skateboard", maxStack = 5, info = "Allows for movement with every skill use.", stackInfo = "+70% movement speed while using a skill."},
		{name = "Juddering Egg", maxStack = nil, info = "Gain a young wurm follower which attacks nearby enemies.", stackInfo = "+1 young wurm."},
		{name = "Portable Reactor", maxStack = 8, info = "Become invincible for 40 seconds after entering a stage.", stackInfo = "+15 seconds."},
		{name = "Bane Flask", maxStack = 8, info = "Debuffs spread on enemy death. Applies bane, dealing 30% damage every 2 seconds.", stackInfo = "increases range of spread by 100%."},
		{name = "Galvanic Core", maxStack = 8, info = "10% chance to stun. Stunned enemies debuff all nearby enemies, reducing their HP by 20%, movement speed by 0.8, and damage by 30%.", stackInfo = "+7% chance, +30% debuff range."},
		{name = "Gem-Breacher", maxStack = nil, info = "Critical strikes give you +3 temporary shield, up to 500.", stackInfo = "+500 shield cap."},
		
		{name = "Shell Piece", maxStack = nil, info = "Gain immunity for 3 seconds near death (once per stage).", stackInfo = "+1 time per stage."},
		{name = "Toxic Tail", maxStack = nil, info = "Spawn two friendly boars.", stackInfo = "+2 boars."},
		{name = "Scalding Scale", maxStack = nil, info = "Increases Armor by 60.", stackInfo = "+60 Armor."},
		{name = "Unearthly Lamp", maxStack = nil, info = "Every second attack fires a projectile dealing 100% damage.", stackInfo = "+1 projectile."},
		{name = "Scavenger's Fortune", maxStack = nil, info = "Every 10000 gold collected, earn a 50% damage and health buff for 30 seconds.", stackInfo = "+30 seconds."},
		{name = "Beating Heart", maxStack = nil, info = "Get another chance at life after all players are dead. Single use per stack.", stackInfo = "+1 use."},
		{name = "Animated Mechanism", maxStack = nil, info = "Shoot a projectile at the nearest enemy every 3 seconds for 200% damage. Shoots faster at low health.", stackInfo = "+100% damage."},
		{name = "Regurgitated Rock", maxStack = nil, info = "After standing idle for 3 seconds, burrow underground becoming invincible for 2.5 seconds.", stackInfo = "+2.5 seconds of invincibility."},
		
		{name = "Relic of Force", maxStack = nil, info = "Increases damage by 100%, BUT reduces attack speed and cooldowns by 40%.", stackInfo = "stacks multiplicatively."},
		--{name = "Relic of Gratification", maxStack = nil, info = "Enemies drop 150% experience and gold BUT enemies deal 150% damage to you.", stackInfo = "stacks multiplicatively."},
		{name = "Relic of Mass", maxStack = nil, info = "Increases health by 100%, BUT movement has momentum.", stackInfo = "+100% health, slower momentum buildup."},
		{name = "Relic of Duality", maxStack = nil, info = "All attacks apply burning damage over time, BUT getting hit freezes you.", stackInfo = "increases the duration of both effects."},
		{name = "Relic of Termination", maxStack = nil, info = "Slaying a marked enemy earns you an item, BUT failing to do so increases its power.", stackInfo = "decreased mark duration."},
		{name = "Relic of Vitality", maxStack = nil, info = "Increases health regeneration by 12, BUT reduces health by 75% and armor by 50%.", stackInfo = "stacks multiplicatively."},
		{name = "Relic of Extinction", maxStack = 10, info = "A black hole follows you that deals extreme damage, BUT it can also damage you.", stackInfo = "increases size."},
		{name = "Relic of Echelon", maxStack = nil, info = "Activating use items grants a buff that boosts HP by 5000 and base damage by 150\nfor 8 seconds, BUT increases use item cooldown by 15% each use.", stackInfo = "+6 seconds, +15% cooldown."},
		
		{name = "Stirring Soul", maxStack = 1, info = "Killed enemies leave a soul. Souls have a chance of turning into items on contact.", stackInfo = "Doesn't stack."},
		{name = "Augury", maxStack = 1, info = "Receiving damage charges dark energy. Unleash a devastating blackout on full charge.", stackInfo = "Doesn't stack."},
		{name = "Yearning Demise", maxStack = 1, info = "Picking up items annihilates the nearest enemies.", stackInfo = "Doesn't stack."},
		{name = "Entangled Energy", maxStack = 1, info = "Create an energetic discharge if 4 or more enemies stand in a line in front of you.", stackInfo = "Doesn't stack."},
		{name = "Thriving Growth", maxStack = 1, info = "Nearby enemy deaths sprout flowers which heal and buff you.", stackInfo = "Doesn't stack."},
		{name = "Oracle's Ordeal", maxStack = 1, info = "Points of interest are pointed at by arrows.", stackInfo = "Doesn't stack."},
		{name = "Bleeding Contract", maxStack = nil, info = "Restart the stage on death. Consumed on activation.", stackInfo = "+1 use."},
		{name = "Nucleus Gems", maxStack = nil, info = "Gold drops become sharp gems, dealing 25% damage on contact with enemies.", stackInfo = "Doesn't stack."},
		{name = "Remuneration", maxStack = nil, info = "Each stage entry offers you three choices.", stackInfo = "Doesn't stack."},
		{name = "All-Holding Hand", maxStack = nil, info = "Activating the teleporter offers you a random super-buff.", stackInfo = "Doesn't stack."},
		
		{name = "Curse of Confusion", maxStack = nil, info = "Controls are temporarily inverted every minute.", stackInfo = "Halves the time threshold."},
		{name = "Curse of Affliction", maxStack = 5, info = "Falling below 50% health gives negative regeneration.", stackInfo = "+15% health threshold."},
		{name = "Curse of Impairment", maxStack = nil, info = "33% chance to miss an attack.", stackInfo = "Increases chances multiplicatively."},
		{name = "Curse of Misfortune", maxStack = 2, info = "Reduce the rarity of nearby items, rerolling them.", stackInfo = "Items always reroll at common rarity."},
		{name = "Curse of Mortality", maxStack = nil, info = "Consecutive hits deal more damage to you.", stackInfo = "Increases time frame for consecutive hits."},
		{name = "Curse of Poverty", maxStack = nil, info = "Lose gold every second.", stackInfo = "Increases amount of gold lost."}
	}
	
	if disabledstacks then
		specialInfo[45] = {name = "Red Whip", maxStack = 1, info = "+80% speed upon leaving combat for 1.5 seconds.", stackInfo = nil}
		specialInfo[59] = {name = "Dio's Friend", maxStack = 1, info = "Earn an extra life.", stackInfo = "Doesn't stack."}
	end
	if global.rormlflag.ss_og_spikestrip then
		specialInfo[21] = {name = "Spikestrip", maxStack = nil, info = "Drop spikestrips on getting hit. Spikestrips slow enemies by 20%.", stackInfo = "increases duration."}
	end
	if not global.rormlflag.ss_og_snakeeyes then
		specialInfo[19] = {name = "Snake Eyes", maxStack = nil, info = "Increases critical hit chance by 5% for every shrine fail.", stackInfo = "+3% chance."}
	end
	
export("TabMenu")
function TabMenu.setItemInfo(item, maxStack, info, stackInfo)
	if isa(item, "Item") then 
		local name = item:getName()
		local replace = nil
		for i, it in ipairs(specialInfo) do
			if it.name == name then
				replace = i
				break
			end
		end
		if replace ~= nil then
			specialInfo[replace] = {name = name, maxStack = maxStack, info = info, stackInfo = stackInfo}
		else
			table.insert(specialInfo, {name = name, maxStack = maxStack, info = info, stackInfo = stackInfo})
		end
	else
		error("First argument must be an item.", 2)
	end
end

callback.register("postLoad", function()
	for n, namespace in pairs(namespaces) do
		for i, item in ipairs(Item.findAll(namespace)) do
			table.insert(items, item)
		end
	end
end)

callback.register("onPlayerInit", function(player)
	player:getData().items = {}
	player:getData().lastItemCounts = {}
	player:getData().totalKills = 0
	player:getData().totalPlayerKills = 0
end)

table.insert(call.onPlayerStep, function(player)
	local playerData = player:getData()
	for i, item in ipairs(items) do
		local itCount = player:countItem(item)
		if itCount > 0 then
			local noAdd = 0
			
			local maxStack = nil
			local info = nil
			local stackInfo = nil
			
			for _, itemInfo in pairs(specialInfo) do
				if item.displayName == itemInfo.name then
					maxStack = itemInfo.maxStack
					info = itemInfo.info
					stackInfo = itemInfo.stackInfo
					break
				end
			end
			local itemToAdd = {item = item, count = itCount, info = {maxStack = maxStack, info = info, stackInfo = stackInfo}}
			for i2, playerItem in ipairs(playerData.items) do
				if playerItem.item == itemToAdd.item then
					playerItem.count = itemToAdd.count
					noAdd = 1
				end
			end
			if noAdd == 0 then
				table.insert(playerData.items, itemToAdd)
			end
			
			playerData.lastItemCounts[item] = itCount
		elseif playerData.lastItemCounts[item] then
			playerData.lastItemCounts[item] = nil
			local index = nil
			for i, iitem in ipairs(playerData.items) do
				if iitem.item == item then
					index = i
				end
			end
			if index then
				table.remove(playerData.items, index)
			end
		end
		
	end
end)

table.insert(call.preHit, function(damager, hit)
	if hit and hit:isValid() then
		local parent = damager:get("parent")
		if parent then
			local parent = Object.findInstance(parent) 
			if parent and parent:isValid() then
				if isa(parent, "PlayerInstance") then
					hit:getData().lastHit = parent
				end
			end
		end
	end
end)

table.insert(call.onStageEntry, function()
	obj.P.sprite = spr.GManIdle
end)

local objPlayer = obj.P

table.insert(call.onNPCDeathProc, function(npc, player)
	if getAlivePlayer() == player then
		if npc and npc:isValid() and npc:getObject() ~= obj.actorDummy then
			local lastHit = npc:getData().lastHit
			if lastHit and lastHit:isValid() then
				if lastHit:getData().totalKills then
					lastHit:getData().totalKills = lastHit:getData().totalKills + 1
					syncInstanceData:sendAsHost(net.ALL, nil, lastHit:getNetIdentity(), "totalKills", lastHit:getData().totalKills)
				end
			else
				local nearestPlayer = objPlayer:findNearest(npc.x, npc.y)
				if nearestPlayer and nearestPlayer:isValid() then
					nearestPlayer:getData().totalKills = nearestPlayer:getData().totalKills + 1
					syncInstanceData:sendAsHost(net.ALL, nil, nearestPlayer:getNetIdentity(), "totalKills", nearestPlayer:getData().totalKills)
				end
			end
		end
	end
end)

-- Sync Kill
local syncpvpKill = net.Packet.new("SSPVPKill", function(player, killer, killed, pinst, kinst)
	if killer and killed and pinst and kinst then
		local pres, kres = pinst:resolve(), kinst:resolve()
		if pres and pres:isValid() and kres and kres:isValid() then
			table.insert(global.pvpKills, {player = killer, killed = killed, pinst = pres, kinst = kres})
		else
			table.insert(global.pvpKills, {player = killer, killed = killed})
		end
	end
end)

callback.register("onPlayerDeath", function(player)
	if global.pvp and net.host then
		local lastHit = player:getData().lastHit
		if lastHit and lastHit:isValid() and isa(lastHit, "PlayerInstance") then
			if lastHit:getData().totalKills then
				lastHit:getData().totalKills = lastHit:getData().totalKills + 1
				syncInstanceData:sendAsHost(net.ALL, nil, lastHit:getNetIdentity(), "totalKills", lastHit:getData().totalKills)
			end
			if lastHit ~= player and lastHit:getData().totalPlayerKills then
				lastHit:getData().totalPlayerKills = lastHit:getData().totalPlayerKills + 1
				syncInstanceData:sendAsHost(net.ALL, nil, lastHit:getNetIdentity(), "totalPlayerKills", lastHit:getData().totalPlayerKills)
			end
			
			local pname, kname = lastHit:get("name"), player:get("name")
			if net.online then
				pname, kname = lastHit:get("user_name"), player:get("user_name")
			end
			local pinst, kinst = lastHit, player
			syncpvpKill:sendAsHost(net.ALL, nil, pname, kname, pinst:getNetIdentity(), kinst:getNetIdentity())
			table.insert(global.pvpKills, {player = pname, killed = kname, pinst = pinst, kinst = kinst})
			obj.P.sprite = lastHit:getSurvivor().idleSprite
		else
			local nearestPlayer = nil
			for _, pplayer in ipairs(obj.P:findAll()) do
				if pplayer ~= player and pplayer:get("dead") == 0 and pplayer:get("team") ~= player:get("team") then
					local dis = distance(pplayer.x, pplayer.y, player.x, player.y)
					if not nearestPlayer or dis < nearestPlayer.dis then
						nearestPlayer = {dis = dis, inst = pplayer}
					end
				end
			end
			if nearestPlayer and nearestPlayer.inst:isValid() then
				nearestPlayer.inst:getData().totalKills = nearestPlayer.inst:getData().totalKills + 1
				nearestPlayer.inst:getData().totalPlayerKills = nearestPlayer.inst:getData().totalPlayerKills + 1
				syncInstanceData:sendAsHost(net.ALL, nil, nearestPlayer.inst:getNetIdentity(), "totalPlayerKills", nearestPlayer.inst:getData().totalPlayerKills)
				
				local pname, kname = nearestPlayer.inst:get("name"), player:get("name")
				if net.online then
					pname, kname = nearestPlayer.inst:get("user_name"), player:get("user_name")
				end
				local pinst, kinst = nearestPlayer.inst, player
				syncpvpKill:sendAsHost(net.ALL, nil, pname, kname, pinst:getNetIdentity(), kinst:getNetIdentity())
				table.insert(global.pvpKills, {player = pname, killed = kname, pinst = pinst, kinst = kinst})
				obj.P.sprite = nearestPlayer.inst:getSurvivor().idleSprite
			end
		end
	end
end)

local windowSize = 1

local xOffset = 100
local yOffset = 100

local sprDead = Sprite.load("Dead_Player", "Gameplay/deadPlayer", 1, 5, 4)

callback.register("onGameStart", function()
	for p, player in ipairs(misc.players) do
		if not net.online and table.maxn(misc.players) > 1 then
			player:getData().displayName = player:get("user_name").." "..p
		else
			player:getData().displayName = player:get("user_name")
		end
	end
end)
callback.register("postSelection", function()
	for p, player in ipairs(misc.players) do
		if not net.online and table.maxn(misc.players) > 1 then
			player:getData().displayName = player:get("user_name").." "..p
		else
			player:getData().displayName = player:get("user_name")
		end
	end
end)

local bind, padBind = "tab", "stickr"

callback.register("onLoad", function()
	local flags = modloader.getFlags()
	for _, flag in ipairs(flags) do
		if string.find(flag, "ss_menubind_") then
			local s = string.gsub(flag, "ss_menubind_", "")
			if type(s) == "string" then
				print("Starstorm: Found menu keybind: "..s)
				bind = s
			else
				error("Invalid menu bind key! Check ModLoader flags!")
			end
			break
		elseif string.find(flag, "ss_menubind2_") then
			local s = string.gsub(flag, "ss_menubind2_", "")
			if type(s) == "string" then
				print("Starstorm: Found gamepad menu keybind: "..s)
				padBind = s
			else
				error("Invalid gamepad menu keybind! Check ModLoader flags!")
			end
			break
		end
	end
end)

local cc = false
local itemsHidden = false

table.insert(call.onHUDDraw, function()
	if windowSize == 1 and xOffset < 100 then
		xOffset = xOffset + 10
		yOffset = yOffset + 10
	end
	if windowSize == 2 and xOffset > 10 then
		xOffset = xOffset - 10
		yOffset = yOffset - 10
	end
	
	
	local keyBind = bind
	if net.online and bind == "tab" then
		keyBind = "shift"
	end
	
	local altInput = nil
	for _, player in ipairs(misc.players) do
		local gamepad = input.getPlayerGamepad(player)
		if gamepad then
			altInput = input.checkGamepad(padBind, gamepad)
		end
	end
	
	local mx, my = input.getMousePos(true)
	
	local hover = nil
	
	if getRule(5, 7) == true and global.inGame then
		if input.checkKeyboard(keyBind) == input.HELD or altInput == input.HELD then
			
			if yOffset < 50 then
				if not cc then
					cc = true
					misc.hud:set("show_gold", 0)
					misc.hud:set("show_boss", 0)
					misc.hud:set("show_skills", 0)
					misc.hud:set("show_time", 0)
					misc.hud:set("show_items", 0)
				end
			end
			
			local w, h = graphics.getGameResolution()
			local scale = h / (1080 / 3)
			
			local textsize = 1
			if scale > 2 then
				textsize = 2
			end
			
			local xx = xOffset * scale
			local yy = yOffset * scale
			
			local playerAmount = #misc.players
			
			local xxi = xx + (w / 5)
			local block = (h - (yy * 2)) / playerAmount
			if block < 35 then windowSize = 2 end
			
			for p, player in ipairs(misc.players) do
				if player:isValid() then
					local itemScale = scale

					local blockBegin = (block * (p - 1)) 
					local yyy = yy + blockBegin
					local itemSize = 28 * itemScale
					local rowAmount = math.floor((w - (xxi + xx)) / itemSize)
					local rowsSize = (math.floor(table.maxn(player:getData().items) / rowAmount) + 1)
					if (rowsSize * itemSize) > block then
						itemScale = scale * (block / (rowsSize * itemSize )) - 0.05
						itemSize = 28 * itemScale
						rowAmount = math.floor((w - (xxi + xx)) / itemSize)
					end
					
					graphics.alpha(0.32)
					graphics.color(Color.fromHex(0x1A1A1A))
					graphics.rectangle(xx, yyy, w - xx, yyy + block)
					graphics.alpha(0.9)
					graphics.color(Color.fromHex(0x332B3C))
					graphics.rectangle(xx + (w / 6), yyy + 3, w - xx - 3, yyy + block - 3)
					graphics.rectangle(xx + (w / 6) - 38, yyy + 3, xx + (w / 6) - 1, yyy + (10 * scale), false)
					
					-- IMAGE
					if player:get("dead") == 1 then
						graphics.drawImage{
							image = sprDead,
							subimage = player.subimage,
							color = player.blendColor,
							alpha = player.alpha,
							x = xx + (w / 24.5),
							y = yyy + (13 * scale),
							xscale = player.xscale,
							yscale = player.yscale,
							scale = scale
						}
					else
						graphics.drawImage{
							image = player.sprite,
							subimage = player.subimage,
							color = player.blendColor,
							alpha = player.alpha,
							x = xx + (player.sprite.xorigin * player.xscale) - ((player.sprite.width / 2) * player.xscale) + (w / 24.5),
							y = yyy + (13 * scale) - ((player.sprite.height * math.abs(player.yscale)) / 2) + player.sprite.yorigin,
							xscale = player.xscale,
							yscale = player.yscale,
							scale = scale
						}
					end
					
					-- NAME
					graphics.color(Color.WHITE)
					graphics.alpha(0.9)
					if table.maxn(misc.players) > 1 then
						graphics.color(playerColor(player, p))
						graphics.print(player:getData().displayName or "Player", xx + 8, yyy + (29 * scale), textsize, graphics.ALIGN_LEFT, graphics.ALIGN_CENTRE)
					end
					
					-- PING
					if net.online then
						local ping = player:get("ping")
						if ping == "---" then
							local checks = 0
							for p, player in ipairs(misc.players) do
								if player:isValid() and player:get("ping") == "---" then
									checks = checks + 1
								end
							end
							if checks == 1 then
								ping = "(HOST)"
							end
						end
						graphics.color(Color.WHITE)
						graphics.alpha(0.6)
						graphics.print(ping, xx + (w / 6), yyy + (29 * scale), textsize, graphics.ALIGN_RIGHT, graphics.ALIGN_CENTRE)
					end
					
					-- OTHER STATS
					local stats = {}
					
					if playerAmount < 4 or windowSize == 2 and playerAmount < 6 then
						
					else
						table.insert(stats, {"HP: ", math.ceil(player:get("hp")), "Total health points."})
						table.insert(stats, {"MaxHP: ", math.ceil(player:get("maxhp")), "Maximum health points."})
						table.insert(stats, {"Level: ", player:get("level"), "The player's level."})
					end
					if global.versus then
						if global.pvp then
							table.insert(stats, {"Kills: ", player:getData().totalPlayerKills, "Total players killed in this match."})
						else
							table.insert(stats, {"Kills: ", player:getData().totalKills, "Total kills in this run."})
						end
					else
						table.insert(stats, {"Kills: ", player:getData().totalKills, "Total kills in this run."})
						if global.pvp then
							table.insert(stats, {"Player Kills: ", player:getData().totalPlayerKills, "Total player kills in this run."})
						end
					end
					table.insert(stats, {"Damage: ", math.floor(player:get("damage")), "Damage dealt at 100%."})
					table.insert(stats, {"Attack Spd: ", math.round(player:get("attack_speed") * 100).."%", "The speed of attacks."})
					table.insert(stats, {"Armor: ", math.floor(player:get("armor")), "Damage reduction."})
					table.insert(stats, {"Speed: ", math.floor(player:get("pHmax") * 10) / 10, "Movement speed."})
					table.insert(stats, {"Crit Chance: ", math.min(math.floor(player:get("critical_chance")), 100).."%", "Chance to deal double damage."})
					table.insert(stats, {"Regen: ", (math.floor(player:get("hp_regen") * 600) / 10).."hp/s", "Regenerated health per second."})
					
					local yyv = ((30 + (8)) * scale)
					if yyv >= block - (20 * scale) then
						if mx >= xx and mx <= xx + (w / 6)
						and my >= yyy + 3 and my <= yyy + block - 3 then
							local info = ""
							for i, stat in ipairs(stats) do
								info = info..stat[1]..stat[2]
								if i < #stats then info = info.."\n" end
							end
							hover = {item = {displayName = "Stats:"}, info = {info = info}, color = Color.fromHex(0xDFE567)}
							--[[if input.checkMouse("left") == input.PRESSED then
								log("Run seed: "..getSeed())
							end]]
						end
					end
					
					for i, stat in ipairs(stats) do
						local yy = ((30 + (8 * i)) * scale)
						graphics.color(Color.WHITE)
						graphics.alpha(0.4)
						if yy < block - (20 * scale) then
							if mx >= xx + 8 and mx <= xx + 8 + graphics.textWidth(stat[1]..stat[2], textsize)
							and my >= yyy + yy - (3 * scale) and my <= yyy + yy + (4 * scale) then
								hover = {item = {displayName = stat[3]}, info = {info = ""}, color = Color.WHITE}
								graphics.alpha(1)
							end
							graphics.print(stat[1]..stat[2], xx + 8, yyy + yy, textsize, graphics.ALIGN_LEFT, graphics.ALIGN_CENTRE)
						else
							break
						end
					end
					
					if playerAmount < 4 or windowSize == 2 and playerAmount < 6 then
						-- HEALTH
						local staty = (block - (10 * scale))
						graphics.alpha(0.6)
						customBar(xx + 6, yyy + staty - (5 * scale), xx + (w / 6) - 6, yyy + staty + (1 * scale), player:get("hp"), player:get("maxhp"), true, Color.RED, Color.fromHex(0x88D367))
						graphics.print(math.floor(player:get("hp")).."/"..player:get("maxhp"), xx + (w / 11.5), yyy + staty, textsize, graphics.ALIGN_MIDDLE, graphics.ALIGN_CENTRE)
						
						-- EXPERIENCE
						customBar(xx + 6, yyy + staty + (3 * scale), xx + (w / 6) - 6, yyy + staty + (5 * scale), player:get("expr"), player:get("maxexp"), true, Color.fromHex(0xA8DFDA))
						graphics.print("level "..player:get("level"), xx + (w / 11.5), yyy + staty + (5.5 * scale), textsize, graphics.ALIGN_MIDDLE, graphics.ALIGN_CENTRE)
					end
					
					-- DIVIDER LINE
					if p < playerAmount then
						graphics.alpha(0.32)
						graphics.color(Color.fromHex(0x1A1A1A))
						graphics.line(xx, yyy + block, w - xx, yyy + block, scale)
					end
					
					-- ITEMS
					graphics.alpha(0.6)
					graphics.color(Color.WHITE)
					graphics.print("Items:", xx + (w / 6), yyy + (8 * scale), textsize, graphics.ALIGN_RIGHT, graphics.ALIGN_CENTRE)
					
					graphics.alpha(0.9)
					for i, item in ipairs(player:getData().items) do
						local row = math.floor(((i - 1) / rowAmount))
						local ii = (i - 1) - (row * rowAmount)
						
						local itemX = xxi + (itemSize * ii)
						local itemY = yyy + (itemSize / 2) + (itemSize * row) + (3 * scale)
						
						graphics.drawImage{
							image = item.item.sprite,
							x = itemX,
							y = itemY,
							scale = itemScale
						}
						if item.count > 1 then
							graphics.color(Color.BLACK)
							graphics.print("x"..item.count, xxi + 6 + (itemSize * ii), yyy + (itemSize / 2) + (12 * scale) + (itemSize * row), 
							textsize, graphics.ALIGN_MIDDLE, graphics.ALIGN_CENTRE)
							graphics.color(Color.WHITE)
							graphics.print("x"..item.count, xxi + 5 + (itemSize * ii), yyy + (itemSize / 2) + (11 * scale) + (itemSize * row), 
							textsize, graphics.ALIGN_MIDDLE, graphics.ALIGN_CENTRE)
						end
						
						if mx >= itemX - (itemSize / 2) and mx <= itemX + (itemSize / 2)
						and my >= itemY - (itemSize / 2) and my <= itemY + (itemSize / 2) then
							hover = item
						end
					end
					
					-- ITEM AMOUNT
					graphics.color(Color.WHITE)
					graphics.alpha(0.25)
					graphics.print("Item count: "..player:get("item_count_total"), w - xx, yyy + block - (5 * scale), textsize, graphics.ALIGN_RIGHT, graphics.ALIGN_CENTRE)
				end
			end
			
			--[[ SEED
			if net.host or not net.online then
				graphics.color(Color.WHITE)
				graphics.alpha(0.75)
				graphics.print("Seed: "..getSeed(),  5 * scale, h - (5 * scale), textsize, graphics.ALIGN_LEFT, graphics.ALIGN_CENTRE)
				if mx >= 5 * scale and mx <= (5 * scale) + graphics.textWidth("Seed: "..getSeed(), textsize)
				and my >= h - (10 * scale) and my <= h - (2 * scale) then
					hover = {item = {displayName = "The seed of this run. (Click to save in log.)"}, info = {info = "You can change this by setting a ModLoader flag:", stackInfo = "Format: ss_seed_[SEED VALUE]"}, color = Color.fromHex(0xDFE567)}
					if input.checkMouse("left") == input.PRESSED then
						log("Run seed: "..getSeed())
					end
				end
			end]]
			
			-- MENU SIZE
			graphics.color(Color.WHITE)
			graphics.alpha(0.75)
			graphics.print("[Toggle Menu Size]",  5 * scale, h - (5 * scale), textsize, graphics.ALIGN_LEFT, graphics.ALIGN_CENTRE)
			if mx >= 5 * scale and mx <= (5 * scale) + graphics.textWidth("[Toggle Menu Size]", textsize)
			and my >= h - (10 * scale) and my <= h - (2 * scale) then
				hover = {item = {displayName = "Click to toggle the size of the menu."}, info = {info = ""}, color = Color.fromHex(0xDFE567)}
				if input.checkMouse("left") == input.PRESSED then
					if windowSize == 1 then
						windowSize = 2
					else
						windowSize = 1
					end
				end
			end
			
			-- STAGES
			graphics.color(Color.WHITE)
			graphics.alpha(0.4)
			graphics.print("Stages passed: "..misc.director:get("stages_passed"), w / 2, xx + (h - (xx * 2)) + (5 * scale), textsize, graphics.ALIGN_MIDDLE, graphics.ALIGN_CENTRE)

			-- ARTIFACTS
			local artifacts = {}
			for n, namespace in ipairs(namespaces) do
				for a, artifact in ipairs(Artifact.findAll(namespace)) do
					if artifact.active then
						table.insert(artifacts, artifact)
					end
				end
			end
			for a, artifact in ipairs(artifacts) do
				local yy = math.max(yOffset, 15) * scale
				
				local size = 16 * scale
				local xOffset = (a - 1) * size - ((size / 2) * (table.maxn(artifacts) - 1))
				local xx = xOffset + (w / 2)
				local yyy = yy - (10 * scale)
				local alpha = 0.4
				if mx >= xx - (size / 2) and mx <= xx + (size / 2)
				and my >= yyy - (size / 2) and my <= yyy + (size / 2) then
					hover = {item = {displayName = artifact.displayName}, info = {info = artifact.loadoutText}, color = Color.fromHex(0xAC72C2)}
					alpha = 1
				end
				graphics.drawImage{
					image = artifact.loadoutSprite,
					subimage = 1,
					alpha = alpha,
					x = xx,
					y = yyy,
					scale = scale
				}
			end
		--[[else
			local w, h = graphics.getGameResolution()
			
			graphics.color(Color.fromHex(0xC0C0C0))
			graphics.alpha(1)
			if itemsHidden then
				graphics.print("+", 10, h - 10, 1, graphics.ALIGN_MIDDLE, graphics.ALIGN_CENTRE)
			else
				graphics.print("-", 10, h - 10, 1, graphics.ALIGN_MIDDLE, graphics.ALIGN_CENTRE)
			end
			
			if mx >= 0 and mx <= 16
			and my >= h - 20 and my <= h then
				hover = {item = {displayName = "Hide / Show items"}, info = {info = ""}, color = Color.fromHex(0xDFE567)}
				if input.checkMouse("left") == input.PRESSED then
					if itemsHidden then
						misc.hud:set("show_items", 1)
						itemsHidden = false
					else
						misc.hud:set("show_items", 0)
						itemsHidden = true
					end
				end
			end]]
		end
		-- TOOLTIPS
		if hover ~= nil and hover.item then
			local w, h = graphics.getGameResolution()
			local scale = h / (1080 / 3)
			
			local textsize = 1
			if scale > 2 then
				textsize = 2
			end
			
			local mOffset = 10
			local fontOffset = 0
			if textsize == 2 then
				fontOffset = (1 * scale)
			else
				fontOffset = (3 * scale)
			end
			
			local name = hover.item.displayName
			
			local amount = ""
			if hover.count ~= nil and hover.count > 1 then
				amount = " ("..hover.count..")"
			end
			
			local topString = name..amount
			
			local info = hover.info.info
			
			local midString = hover.item.pickupText
			
			if info ~= nil then
				midString = info
			end

			local stackInfo = hover.info.stackInfo
			local maxStack = hover.info.maxStack
			
			local lowString = ""
			if stackInfo ~= nil then
				if hover.count ~= 0 and not stackInfo:find("Format") then
					lowString = "Stacking: "..stackInfo
				else
					lowString = stackInfo
				end
			end
			
			local stackString = ""
			if maxStack ~= nil then
				stackString = "Max Stack: "..maxStack..""
			end
			
			local color = hover.item.color
			if not isa(color, "Color") then
				if color == "w" then
					color = Color.fromHex(0xFFFFFF)
				elseif color == "g" then
					color = Color.fromHex(0x7EB686)
				elseif color == "r" then
					color = Color.fromHex(0xCF6666)
				elseif color == "or" then
					color = Color.fromHex(0xF97322)
				elseif color == "p" then
					color = Color.fromHex(0xEC5ED3)
				elseif color == "bl" then
					color = Color.fromHex(0x000000)
				elseif color == "lt" then
					color = Color.fromHex(0xC0C0C0)
				elseif color == "dk" then
					color = Color.fromHex(0x404040)
				elseif color == "y" then
					color = Color.fromHex(0xEFD27B)
				elseif color == "b" then
					color = Color.fromHex(0x319AD2)
				else
					color = Color.fromHex(0xC649AD)
				end
			end
			if hover.color and type(hover.color) == "Color" then color = hover.color end
			
			local topHeight = graphics.textHeight(topString, textsize)
			local midHeight = graphics.textHeight(midString, textsize)
			local lowHeight = graphics.textHeight(lowString, textsize)
			local stackHeight = graphics.textHeight(stackString, textsize)
			
			local totalWidth = math.max(graphics.textWidth(topString, textsize), graphics.textWidth(midString, textsize), graphics.textWidth(lowString, textsize), graphics.textWidth(stackString, textsize))
			local totalHeight = topHeight + midHeight + lowHeight + stackHeight
			
			if totalWidth + mOffset + mx + (2 * scale) > w then
				local dif = totalWidth + mOffset + mx + (2 * scale) - w
				mx = mx - dif
			end
			if totalHeight + mOffset + my + (2 * scale) > h then
				local dif = totalHeight + mOffset + my + (2 * scale) - h
				my = my - dif
			end
			
			graphics.alpha(1)
			graphics.color(Color.BLACK)
			graphics.rectangle(mx + mOffset, my + mOffset, mx + mOffset + (2 * scale) + totalWidth, my + mOffset + totalHeight + scale)
			graphics.color(color)
			graphics.print(topString, mx + mOffset + fontOffset + (0.5 * scale), my + mOffset + fontOffset, textsize, graphics.ALIGN_LEFT, graphics.ALIGN_TOP)
			graphics.color(Color.fromHex(0x9696A7))
			graphics.print(midString, mx + mOffset + fontOffset + (0.5 * scale), my + mOffset + fontOffset + topHeight, textsize, graphics.ALIGN_LEFT, graphics.ALIGN_TOP)
			graphics.color(Color.fromHex(0xFFE6C9))
			graphics.print(lowString, mx + mOffset + fontOffset + (0.5 * scale), my + mOffset + fontOffset + topHeight + midHeight, textsize, graphics.ALIGN_LEFT, graphics.ALIGN_TOP)
			graphics.color(Color.fromHex(0xFFC9C9))
			graphics.print(stackString, mx + mOffset + fontOffset + (0.5 * scale), my + mOffset + fontOffset + topHeight + midHeight + lowHeight, textsize, graphics.ALIGN_LEFT, graphics.ALIGN_TOP)
		end
	end
	
	if input.checkKeyboard(keyBind) == input.RELEASED or altInput == input.HELD or yOffset >= 50 then
		if not cc then
			misc.hud:set("show_gold", 1)
			misc.hud:set("show_boss", 1)
			misc.hud:set("show_skills", 1)
			misc.hud:set("show_time", 1)
			if not itemsHidden then
				misc.hud:set("show_items", 1)
			end
		end
		cc = true
	else
		cc = false
	end
end)
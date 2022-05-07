-- Credits

local blackAlpha = 0
local yoff = 0
local creditCreatureSprites = {}
if not global.rormlflag.ss_disable_enemies then
	callback.register("postLoad", function()
		local monsterList = {
			{object = obj.Suicider, name = "Exploder"},
			{object = obj.SquallElver, name = "Squall Elver"},
			{object = obj.Scrounger, name = "Scrounger"},
			{object = obj.Admonitor, name = "Clay Admonitor"},
			{object = obj.Mimic, name = "Mimic"},
			{object = obj.Gatekeeper, name = "Gatekeeper"},
			{object = obj.ArcherBugHive, name = "Archer Bug Hive"},
			{object = obj.SandCrabKing, name = "Sand Crab King"},
			{object = obj.Post, name = "Wayfarer"},
			{object = obj.Eye, name = "Overseer"},
			{object = obj.TotemController, name = "Mechanical Totem"},
			{object = obj.Wyvern, name = "Scaleless Wyvern"},
		}
		for _, obj in ipairs(monsterList) do
			local sprite
			local size = 32
			
			local preSprite = obj.object.sprite
			
			local currentSprite = nil
			
			local imageSurface = Surface.new(size, size)
			
			graphics.setTarget(imageSurface)
			imageSurface:clear()
			
			local x, y = preSprite.xorigin, preSprite.yorigin
			
			local yy
			if preSprite.height > 140 then
				yy = 100
			elseif preSprite.height > 30 and obj.name ~= "Wayfarer" then
				yy = preSprite.height - 20
			end
			
			graphics.drawImage{
				image = preSprite,
				x = 16 or preSprite.xorigin,
				y = yy or preSprite.yorigin,
				subimage = 1
			}

			graphics.resetTarget()
			
			currentSprite = imageSurface:createSprite(16, 16)
			imageSurface:free()
			
			sprite = currentSprite:finalise(preSprite:getName().."_cropped")
			
			table.insert(creditCreatureSprites, {sprite = sprite, name = obj.name})
		end
	end)
end
local function drawCredits()
	local w, h = graphics.getGameResolution()
	local xx = w * 0.94
	local yy = (yoff)
	
	graphics.alpha(1 - blackAlpha)
	graphics.color(Color.fromHex(0xEFD27B))
	graphics.print("Starstorm", xx, yy + 0.5, 2, 2)
	graphics.color(Color.WHITE)
	graphics.print("by Nk", xx, yy + 21.5, 1, 2)
	
	local yyy = 52 - 14
	
	local xoff = 150
	if w < 700 then
		xoff = 110
	end	
	
	for i, monster in ipairs(creditCreatureSprites) do
		local yyyy = yy + yyy + i * (32 + 16)
		graphics.print(monster.name, xx, yyyy, 1, 2)
		graphics.drawImage{
			image = monster.sprite,
			x = xx - xoff,
			y = yyyy,
			alpha = 1 - blackAlpha
		}
	end
	
	yyy = 1500.5
	if w < 800 then
		yyy = 2200.5
	end
	
	graphics.print("---Mod Credits----", xx, yy + yyy, 1, 2)
	graphics.print(
[[Modloader by Saturnyoshi


= Content =

General Ideas - Riskka
Nemesis Executioner's
design - Bruh
Scaleless Wyvern - DeegerDill
Slate Mines - 4cqker
Sand Crab King - Vahnkiljoy
& Daimera
Torrid Outlands'
background - Wooph
Overseer & Squall Elver
Monsterlog Sprites -
Subwit
Boaroness' select
animation - jesuspxp
Cyclone Icon - Jingo
Commission Variants - Fate
Whistling Basin Music - 
Altzeus
G-Hook & Gem-Breacher
Logs - QandQuestion
Copy editing - Polly Edaline

= Testing =

HostAnon
Bang
XYZ
D4rkD3vil
Wilscwil
..and everyone over at 4chan!

= Supporters =

Jingo
Fate
BethJerry
adrian.
Mr_Stonks
AnAwesomeDudette
Swuff
Stoutheart
EarthZebra
funkyIsaac
Little Wasp
fancyhat
Kevin

= Wiki Contributors =

Altzeus
AnAwesomeDudette
Axolord
BirbExMachina
Jingo
Neptunia
ZeaTheMays
Polly Edaline

= Special Thanks =

Saturnyoshi
Cluicide
FrictionlessPortals
Scoot
Pears
Assa
Josh
Chloeeee
Panda
Sivelos
KKHTA
Zarah
Ruxbieno
]]
	, xx, yy + yyy + 21, 1, 2)
end
callback.register("globalRoomStart", function(room)
	if room == rm.Credits then
		creditScroll = 0
		graphics.bindDepth(-9999999, drawCredits) -- e
	end
end)
callback.register("globalStep", function(room)
	if room == rm.Credits then
		--[[local scroll = 0.4
		local gamepad = input.getPlayerGamepad()
		if gamepad and gamepad > 0 then
			for button, _ in pairs(allGamepadControls) do
				if input.checkGamepad(button, gamepad) == input.PRESSED then
					scroll = 2.4
					break
				end
			end
		else
			if input.checkKeyboard("anykey") == input.PRESSED or input.checkKeyboard("anykey") == input.HELD then
				scroll = 2.4
			end
			if input.checkKeyboard("escape") == input.PRESSED or input.checkKeyboard("escape") == input.RELEASED then
			end
		end
		
		creditScroll = creditScroll + scroll]]
		
		if Sound.getMusic() == sfx.musicStage6 then
			if specialEndingMusic then
				Sound.setMusic(specialEndingMusic)
			end
		end
		local credits = obj.Credits:find(1)
		if credits and credits:isValid() then
			blackAlpha = credits:get("black_alpha")
			yoff = credits:get("yoff")
		end
	end
end)
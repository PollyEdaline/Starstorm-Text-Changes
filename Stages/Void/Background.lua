local sprVoidBackground = Sprite.load("VoidBackground", "Stages/Void/voidBkg.png", 1, 0, 0)
local sprVoidBackground2 = Sprite.load("VoidBackground2", "Stages/Void/voidBkg2.png", 1, 0, 0)
local bkgVoid = Object.new("DrawVoid")
bkgVoid.depth = 400
bkgVoid:addCallback("draw", function(self)
	local width = sprVoidBackground.width
	local height = sprVoidBackground.height
	
	local currentStage = Stage.getCurrentStage()
	local stageData = bkgStages[currentStage]
	
	local currentRoom = Room.getCurrentRoom()
	local roomWidth, roomHeight = Stage.getDimensions()
	
	local stageColor = Color.fromHex(0x86768E)
	if stageData and stageData.color then
		stageColor = stageData.color
	end
	stageColor = Color.mix(stageColor, Color.fromHex(0xC6DAC2), 0.5)
	
	local yOffset = 1000
	if currentStage ~= stg.Void then
		yOffset = roomHeight 
	end
	
	local layers = 5
	if stageData and stageData.layers then layers = stageData.layers end
	
	if layers >= 4 then
		local xParallax = 0.85
		for i = 0, math.floor((roomWidth * xParallax) / width) do
			graphics.drawImage{
				image = sprVoidBackground,
				x = misc.camera.x * xParallax + i * width,
				y = (misc.camera.y * xParallax) + (roomHeight * 0.15),
				color = stageColor,
				xscale = -1
			}
		end
		graphics.color(Color.fromHex(0x1C1522))
		graphics.alpha(1)
		graphics.rectangle(0, (misc.camera.y * xParallax) + (roomHeight * 0.15) + height, roomWidth, roomHeight, false)
	end
	
	if layers >= 3 then
		local xParallax = 0.75
		for i = 0, math.floor((roomWidth * xParallax) / width) do
			graphics.drawImage{
				image = sprVoidBackground2,
				x = misc.camera.x * xParallax + i * width,
				y = (misc.camera.y * xParallax) + (roomHeight * 0.22),
				color = Color.mix(stageColor, Color.WHITE, 0.5),
				xscale = -1
			}
		end
	end
	if layers >= 2 then
		local xParallax = 0.65
		for i = 0, math.floor((roomWidth * xParallax) / width) do
			graphics.drawImage{
				image = sprVoidBackground,
				x = misc.camera.x * xParallax + i * width,
				y = (misc.camera.y * xParallax) + (roomHeight * 0.3),
			}
		end
		graphics.color(Color.fromHex(0x39253D))
		graphics.alpha(1)
		graphics.rectangle(0, (misc.camera.y * xParallax) + (roomHeight * 0.3) + height, roomWidth, roomHeight, false)
	end
	
	if layers >= 1 then
		local xParallax = 0.6
		for i = 0, math.floor((roomWidth * xParallax) / width) do
			graphics.drawImage{
				image = sprVoidBackground2,
				x = misc.camera.x * xParallax + i * width,
				y = (misc.camera.y * xParallax) + (roomHeight * 0.32),
			}
		end
	end
end)
local bkgVoid2 = Object.new("DrawVoid2")
bkgVoid2.depth = 400
bkgVoid2:addCallback("draw", function(self)
	local width = sprVoidBackground.width
	local height = sprVoidBackground.height
	
	local currentRoom = Room.getCurrentRoom()
	local roomWidth, roomHeight = Stage.getDimensions()
	
	local steps = 10
	local ii = 1 / steps
	
	graphics.setBlendMode("max")
	for i = 1, steps do
		local xParallax = (ii * i)
		local yParallax = (ii * i)
		
		local sine = math.sin((global.timer + i * 2.5) * 0.02)
		
		graphics.color(Color.mix(Color.LIGHT_BLUE, Color.PURPLE, sine))
		graphics.alpha(0.8 * ((steps - i) / steps))
		graphics.circle(
		self.x * (1 - xParallax) + (misc.camera.x * xParallax) + misc.camera.width * 0.5 * xParallax,
		self.y * (1 - yParallax) + (misc.camera.y * yParallax) + misc.camera.height * 0.5 * yParallax,
		80 * ((steps - i) / steps) + sine * 5, true)
	end
	graphics.setBlendMode("normal")
end)

return bkgVoid, bkgVoid2
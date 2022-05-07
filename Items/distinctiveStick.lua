local path = "Items/Resources/"

it.DistinctiveStick = Item.new("Distinctive Stick")
it.DistinctiveStick.pickupText = "Heal near the teleporter." 
it.DistinctiveStick.sprite = Sprite.load("DistinctiveStick", path.."Distinctive Stick.png", 1, 14, 13)
it.DistinctiveStick:setTier("common")
it.DistinctiveStick:setLog{
	group = "common_locked",
	description = "Grows a tree nearby Teleporters, &g&healing nearby players&!&.",
	story = "Darling, I have something special for you..\nThe other day on my mission, I came across this. It caught my eye because it's unlike any of the branches I've seen in my life! This branch excudes a peculiar energy. It made me feel connected to nature in a way I thought was only possible in stories! In honor of our anniversary, I'm giving it to you.\nI'll arrive home soon with an even greater present. Please, don't lose faith.",
	destination = "Dreq Mineli,\nTesaft,\nEarth",
	date = "01/15/2056"
}
local objDistinctiveStick = Object.new("HealTree")
objDistinctiveStick.sprite = Sprite.load("DistinctiveStickTree", path.."distinctiveStickDisplay.png", 1, 12, 34)
objDistinctiveStick:addCallback("create", function(self)
	local selfData = self:getData()
	selfData.treeCounter = 0
	selfData.timer = 30
	selfData.treeCounter = 0
	if selfData.radius == nil then
		selfData.radius = 100
	end
	local n = 0
	while n < 100 and not self:collidesMap(self.x, self.y + n + 1) do
		n = n + 1
	end
	if n == 100 then n = 0 end
	self.y = self.y + n
end)
objDistinctiveStick:addCallback("step", function(self)
	local selfData = self:getData()
	if selfData.timer == 0 then
		for p, player in pairs(obj.P:findAllEllipse(self.x - selfData.radius, self.y - selfData.radius, self.x + selfData.radius, self.y + selfData.radius)) do
			heal = obj.EfHeal2:create(self.x, self.y)
			heal:set("value", player:get("maxhp") * 0.023)
		end
		selfData.timer = 145
	else
		selfData.timer = selfData.timer - 1
	end
end)
objDistinctiveStick:addCallback("draw", function(self)
	local selfData = self:getData()
	if selfData.treeCounter >= math.pi * 2 then
		selfData.treeCounter = 0
	else
		selfData.treeCounter = math.min(selfData.treeCounter + 0.05, math.pi * 2)
	end
	graphics.color(Color.DAMAGE_HEAL)
	graphics.alpha( 0.25 * (math.cos(selfData.treeCounter)))
	graphics.circle(self.x, self.y, selfData.radius, true)
end)

local onPlayerStepCall = function(player)
	local playerData = player:getData()
	
	local distinctiveStick = player:countItem(it.DistinctiveStick)
	if distinctiveStick > 0 then
		if not playerData.treeSpawned then
			local teleporters = obj.Teleporter:findAll()
			for t, teleporter in pairs(teleporters) do
				tree = objDistinctiveStick:create(teleporter.x + math.random(-40, 40), teleporter.y)
				tree:getData().radius = 70 + (40 * distinctiveStick)
				tree:getData().parent = player
			end
			playerData.treeSpawned = 1
		end
	end
	for _, tree in pairs(objDistinctiveStick:findAll()) do
		if tree:getData().parent == player then
			local rangeVal = 75 + (25 * distinctiveStick)
			if rangeVal > tree:getData().radius then
				tree:getData().radius = rangeVal
			end
		end
	end
end

table.insert(call.onStageEntry, function()
	for p, player in pairs(misc.players) do
		player:getData().treeSpawned = nil
	end
end)

it.DistinctiveStick:addCallback("pickup", function(player)
	tcallback.register("onPlayerStep", onPlayerStepCall)
end)
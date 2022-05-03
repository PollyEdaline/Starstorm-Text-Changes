-- DEATH MESSAGES

local deathMessages = {
"Oh no...",
"Oopsie.",
"Should have seen that coming.",
"Destiny sealed.",
"That was depressing.",
"Anticlimatic.",
"Yeet.",
"That wasn't cool.",
"Dying, again.",
"Could have been worse.",
"At least you tried.",
"Heartbroken.",
"Not OP.",
"Should have gotten Dio's Friend.",
"What?",
"Yeah... nice.",
"Are you okay?",
"Let's try again sometime soon.",
"Rude, didn't even say goodbye.",
"Another one bites the dust.",
"Stinky.",
"Get some rest.",
"I don't get it.",
":(",
"To be honest, I expected that.",
"You are no more.",
"You died painfully.",
"Let's pretend that didn't happen.",
"Bye bye.",
"You cried before losing consciousness.",
"You will be remembered.",
"You didn't stand a chance.",
"Very, very dead.",
"Sorry mom.",
"Mom says it's my turn now.",
"What's the point?",
"Relatable.",
"Try harder.",
"Boom.",
"ouchies owo",
"F.",
"This is the part where you quit.",
"You weren't strong enough.",
"Continue?",
"You have perished.",
"The planet has claimed your life",
"You fought valiantly... But to no avail.",
"You didn't know how to live.",
"The end.",
"FIN.",
"Was that it?",
"Give up?",
"The end?",
"Nooooooooooo!",
"Good enough.",
"Fair game.",
"Need a tutorial?",
"Help is not coming.",
"Medic!",
"C-c-c-combo breaker!",
"It was fun while it lasted.",
"An attempt was made.",
"You had one job.",
"Good job!",
"Need a hug?",
"Hnng.",
"Life comes and goes.",
"It's just a game.",
"You'll win! ...Someday.",
"You could do it.",
"dead.exe",
"Imagine living",
"What?!",
"What was that?",
"Don't skip leg day.",
"Wow! Okay...",
"Whew.",
"Yes, you just died.",
"Free ticket to hell.",
"Free ticket to heaven.",
"The void welcomes you.",
"Weee wooo weee wooo."
-- cringe
}

local toSync = {}

local syncDeathMessage = net.Packet.new("SSDeathMessage", function(player, text, x, y)
	table.insert(toSync, {text = text, x = x, y = y})
end)


local onStepCall = function()
	for _, corpse in ipairs(obj.EfPlayerDead:findAll()) do
		if not corpse:getData().edited then
			corpse:getData().edited = true
			if math.chance(55) then
				local text = table.irandom(deathMessages)
				corpse:set("death_message", text)
			end
			if net.online then
				syncDeathMessage:sendAsHost(net.ALL, nil, corpse:get("death_message"), corpse.x, corpse.y)
			end
		end
	end
	for i, check in ipairs(toSync) do
		local x, y, r = check.x, check.y, 100
		local instance = obj.EfPlayerDead:findEllipse(x - r, y - r, x + r, y + r)
		if instance and instance:isValid() then
			instance:set("death_message", check.text)
			table.remove(toSync, i)
		end
	end
end
callback.register("onPlayerDeath", onStepCall)
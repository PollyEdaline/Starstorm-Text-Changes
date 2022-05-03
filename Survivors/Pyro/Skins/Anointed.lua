-- ANOINTED

local path = "Survivors/Pyro/Skins/Anointed/"

local survivor = Survivor.find("Pyro", "Starstorm")
local sprSelect = Sprite.load("APyroSelect", path.."Select", 14, 2, 0)
local APyro = SurvivorVariant.new(survivor, "Anointed Pyro", sprSelect, {
	idle = Sprite.load("APyroIdle", path.."idle", 5, 4, 6),
	walk = Sprite.load("APyroWalk", path.."walk", 8, 8, 6),
	walkShoot = Sprite.load("APyroWalkShoot", path.."walkShoot", 8, 8, 7),
	jump = Sprite.load("APyroJump", path.."jump", 5, 4, 6),
	climb = Sprite.load("APyroClimb", path.."climb", 2, 4, 7),
	death = Sprite.load("APyroDeath", path.."death", 9, 10, 14),
	decoy = Sprite.load("APyroDecoy", path.."decoy", 1, 9, 11),
	
	shoot1 = Sprite.load("APyroShoot1", path.."shoot1", 3, 7, 6),
	shoot3 = Sprite.load("APyroShoot3", path.."shoot3", 5, 11, 6),
	shoot4 = Sprite.load("APyroShoot4", path.."shoot4", 6, 10, 13),
	
	fire1 = Sprite.load("APyroFire1", path.."fire1", 6, 7, 10),
	fire2 = Sprite.load("APyroFire2", path.."fire2", 6, 7, 20),
	
	heatBar = Sprite.load("APyroBar", path.."heatBar", 2, 14, 10),
}, Color.fromHex(0xB5F7FF))
SurvivorVariant.setInfoStats(APyro, {{"Strength", 4}, {"Vitality", 4}, {"Toughness", 3}, {"Agility", 4}, {"Difficulty", 5}, {"Chill", 10}})
SurvivorVariant.setDescription(APyro, "The pest exterminator is enlightened, earning a new title in the eyes of the universe.")

spr.EfFireyAnointed = Sprite.load("EfFireyAnointed", path.."EfFireyAnointed", 7, 2, 5)
spr.EfFireyAnointed2 = Sprite.load("EfFireyAnointed2", path.."EfFireyAnointed2", 7, 2, 5)

par.PyroJumpA = ParticleType.new("PyroJumpA")
par.PyroJumpA:sprite(spr.EfFireyAnointed, true, true, false)
par.PyroJumpA:color(Color.WHITE, Color.WHITE, Color.BLACK)
par.PyroJumpA:alpha(1, 1)
par.PyroJumpA:size(0.55, 1, -0.002, 0.1)
par.PyroJumpA:speed(0.1, 0.2, -0.01, 0.1)
par.PyroJumpA:angle(0, 360, 0, 4, true)
par.PyroJumpA:direction(75, 105, 0, 2)
par.PyroJumpA:gravity(0.01, 90)
par.PyroJumpA:life(40, 70)

par.PyroBullet2A = ParticleType.new("PyroBullet2A")
par.PyroBullet2A:sprite(spr.EfFireyAnointed2, true, true, false)
par.PyroBullet2A:color(Color.WHITE, Color.WHITE, Color.BLACK)
par.PyroBullet2A:alpha(1, 1)
par.PyroBullet2A:size(0.25, 0.6, -0.002, 0.1)
par.PyroBullet2A:speed(0.05, 0.1, -0.01, 0.1)
par.PyroBullet2A:angle(0, 360, 0, 4, true)
par.PyroBullet2A:direction(75, 105, 0, 2)
par.PyroBullet2A:gravity(0.01, 90)
par.PyroBullet2A:life(40, 70)

par.PyroBulletA = ParticleType.new("PyroBulletA")
par.PyroBulletA:sprite(spr.EfFireyAnointed, true, true, false)
par.PyroBulletA:color(Color.WHITE, Color.WHITE, Color.BLACK)
par.PyroBulletA:alpha(1, 1)
par.PyroBulletA:size(0.25, 0.6, -0.002, 0.1)
par.PyroBulletA:speed(0.05, 0.1, -0.01, 0.1)
par.PyroBulletA:angle(0, 360, 0, 4, true)
par.PyroBulletA:direction(75, 105, 0, 2)
par.PyroBulletA:gravity(0.01, 90)
par.PyroBulletA:life(40, 70)

callback.register("onSkinInit", function(player, skin)
	if skin == APyro then
		local playerData = player:getData()
		
		playerData.particleBig = par.PyroJumpA
		playerData.particleSmall = par.PyroBulletA
		playerData.particleSmall2 = par.PyroBullet2A -- thanks, anon
	end
end)
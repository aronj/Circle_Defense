return {
	tlldmc1 = {
		bmcode = 0,
		buildangle = 8192,
		buildcostenergy = 132000,
		buildcostmetal = 11467,
		builder = false,
		buildinggrounddecaldecayspeed = 30,
		buildinggrounddecalsizex = 4,
		buildinggrounddecalsizey = 4,
		buildinggrounddecaltype = "tlldmc_aoplane.dds",
		buildpic = "tlldmc.png",
		buildtime = 75000,
		canattack = true,
		canstop = 1,
		category = "ALL NOTHOVERNOTVTOL NOTMOBILE NOTSUB NOTSUBNOTSHIP NOTVTOL WEAPON",
		corpse = "dead",
		defaultmissiontype = "GUARD_NOMOVE",
		description = "Small-Dark Matter Cannon",
		designation = "ARM-ERC",
		energymake = 0,
		energystorage = 0,
		energyuse = 0,
		explodeas = "MEDIUM_BUILDINGEX",
		firestandorders = 1,
		footprintx = 3,
		footprintz = 3,
		icontype = "building",
		idleautoheal = 7,
		idletime = 1800,
		losemitheight = 49.5,
		mass = 22000,
		maxdamage = 30000,
		maxslope = 10,
		maxwaterdepth = 0,
		metalstorage = 0,
		name = "Small DMC",
		noautofire = false,
		objectname = "tlldmc1",
		radardistance = 0,
		radaremitheight = 49.5,
		selfdestructas = "MEDIUM_BUILDING",
		shootme = 1,
		sightdistance = 1000,
		standingfireorder = 0,
		script = "tlldmc.cob",
		unitname = "tlldmc2",
		unitnumber = 200000,
		usebuildinggrounddecal = true,
		workertime = 0,
		yardmap = "oooo oooo oooo oooo",
		customparams = {
			buildpic = "tlldmc.png",
			canareaattack = 1,
		},
		featuredefs = {
			dead = {
				blocking = false,
				category = "corpses",
				damage = 24000,
				description = "Small DMC Wreckage",
				energy = 0,
				featuredead = "heap",
				featurereclamate = "SMUDGE01",
				footprintx = 3,
				footprintz = 3,
				height = 40,
				hitdensity = 100,
				metal = 7600,
				object = "TLLDMC1_DEAD",
				reclaimable = false,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
			heap = {
				blocking = false,
				category = "heaps",
				damage = 14800.00195,
				description = "Small DMC Heap",
				energy = 0,
				featurereclamate = "SMUDGE01",
				footprintx = 3,
				footprintz = 3,
				height = 4,
				hitdensity = 100,
				metal = 4080,
				object = "3X3E",
				reclaimable = false,
				seqnamereclamate = "TREE1RECLAMATE",
				world = "All Worlds",
			},
		},
		sfxtypes = {
			explosiongenerators = {
				[1] = "custom:tlldmc_flare",
			},
		},
		sounds = {
			canceldestruct = "cancel2",
			underattack = "warning1",
			cant = {
				[1] = "cantdo4",
			},
			count = {
				[1] = "count6",
				[2] = "count5",
				[3] = "count4",
				[4] = "count3",
				[5] = "count2",
				[6] = "count1",
			},
			ok = {
				[1] = "servlrg3",
			},
			select = {
				[1] = "servlrg3",
			},
		},
		weapondefs = {
			tlldmc = {
				areaofeffect = 200,
				cegtag = "Trail_dmc_cannon",
				collidefriendly = false,
				craterboost = 0,
				cratermult = 0,
				duration = 0.025,
				energypershot = 70000,
				explosiongenerator = "custom:Tlldmc_Explosion",
				firestarter = 90,
				id = 254,
				impactonly = 1,
				impulseboost = 0,
				impulsefactor = 0,
				intensity = 0.75,
				name = "Dark Matter Cannon",
				nogap = 1,
				noselfdamage = true,
				range = 1520,
				reloadtime = 10,
				rgbcolor = "1 0.15 0.15",
				size = 2,
				sizedecay = -0.25,
				soundhitdry = "xplolrg1",
				soundstart = "Energy",
				stages = 20,
				turret = true,
				weapontype = "Cannon",
				weaponvelocity = 320,
				damage = {
					commanders = 1900,
					default = 16000,
					experimental_land = 35000,
					experimental_ships = 35000,
					subs = 5,
				},
			},
			tlldmc_rapid = {
				areaofeffect = 90,
				cegtag = "Trail_dmc_cannon",
				collidefriendly = false,
				craterboost = 0,
				cratermult = 0,
				duration = 0.025,
				energypershot = 35000,
				explosiongenerator = "custom:Tlldmc_Explosion",
				firestarter = 90,
				impactonly = 1,
				impulseboost = 0,
				impulsefactor = 0,
				intensity = 0.75,
				name = "Dark Matter Cannon",
				nogap = 1,
				noselfdamage = true,
				range = 1520,
				reloadtime = 5,
				rgbcolor = "1 0.15 0.15",
				size = 2,
				sizedecay = -0.25,
				soundhitdry = "xplolrg1",
				soundstart = "Energy",
				stages = 20,
				turret = true,
				weapontype = "Cannon",
				weaponvelocity = 320,
				damage = {
					commanders = 1600,
					default = 7500,
					experimental_land = 17500,
					experimental_ships = 17500,
					subs = 5,
				},
			},
		},
		weapons = {
			[1] = {
				badtargetcategory = "MEDIUM SMALL TINY",
				def = "tlldmc",
				onlytargetcategory = "NOTVTOL",
			},
			[2] = {
				badtargetcategory = "MEDIUM SMALL TINY",
				def = "tlldmc_rapid",
				onlytargetcategory = "NOTVTOL",
			},
		},
	},
}
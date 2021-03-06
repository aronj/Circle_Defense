return {
	corboucher2 = {
		bmcode = 0,
		buildangle = 8192,
		buildcostenergy = 248725,
		buildcostmetal = 44123,
		builder = false,
		buildinggrounddecaldecayspeed = 30,
		buildinggrounddecalsizex = 7,
		buildinggrounddecalsizey = 7,
		buildinggrounddecaltype = "corboucher_aoplane.dds",
		buildpic = "corboucher.png",
		buildtime = 461000,
		canattack = true,
		canstop = 1,
		category = "ALL NOTHOVERNOTVTOL NOTMOBILE NOTSUB NOTSUBNOTSHIP NOTVTOL WEAPON",
		corpse = "dead",
		defaultmissiontype = "GUARD_NOMOVE",
		description = "Super-Anti Experimental Cannon",
		designation = "BOUCHER-GUARD",
		energystorage = 0,
		energyuse = 0,
		explodeas = "MEDIUM_BUILDINGEX",
		firestandorders = 1,
		footprintx = 6,
		footprintz = 6,
		icontype = "building",
		idleautoheal = 7,
		idletime = 1800,
		losemitheight = 71.55766,
		mass = 20740,
		maxdamage = 180000,
		maxslope = 10,
		maxwaterdepth = 0,
		metalstorage = 0,
		name = "Super Bucher",
		noautofire = false,
		nochasecategory = "ALL",
		objectname = "corboucher2",
		radardistance = 0,
		radaremitheight = 71.55766,
		selfdestructas = "MEDIUM_BUILDING",
		shootme = 1,
		side = "CORE",
		sightdistance = 2550,
		standingfireorder = 2,
		script = "corboucher.cob",
		unitname = "corboucher2",
		unitnumber = 731989,
		usebuildinggrounddecal = true,
		workertime = 0,
		yardmap = "ooooooo ooooooo ooooooo ooooooo ooooooo ooooooo",
        customparams = {
			buildpic = "corboucher.png",
		},

		featuredefs = {
			dead = {
				blocking = true,
				category = "core_corpses",
				damage = 96000,
				description = "Super Boucher Wreckage",
				featuredead = "heap",
				featurereclamate = "smudge01",
				footprintx = 6,
				footprintz = 6,
				height = 20,
				hitdensity = 100,
				metal = 32592,
				object = "corboucher2_dead",
				reclaimable = true,
				seqnamereclamate = "tree1reclamate",
				world = "All Worlds",
			},
			heap = {
				blocking = false,
				category = "heaps",
				damage = 54800.00195,
				description = "Super Boucher Heap",
				featurereclamate = "smudge01",
				footprintx = 5,
				footprintz = 5,
				height = 4,
				hitdensity = 100,
				metal = 23273.59961,
				object = "3x3d",
				reclaimable = true,
				seqnamereclamate = "tree1reclamate",
				world = "All Worlds",
			},
		},
		sounds = {
			canceldestruct = "cancel2",
			cloak = "kloak1",
			uncloak = "kloak1un",
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
				[1] = "twrturn3",
			},
			select = {
				[1] = "twrturn3",
			},
		},
		weapondefs = {
			core_boucher = {
				areaofeffect = 30,
				collidefriendly = false,
				craterboost = 0,
				cratermult = 0,
				duration = 0.025,
				energypershot = 150000,
				firestarter = 90,
				id = 254,
				impactonly = 1,
				impulseboost = 0,
				impulsefactor = 0,
				intensity = 0.75,
				name = "Cartouche Aluminium",
				noselfdamage = true,
				range = 3600,
				reloadtime = 5,
				rgbcolor = "0.9 0.6 1",
				soundhitdry = "xplolrg1",
				soundstart = "Energy",
				thickness = 5,
				turret = true,
				weapontype = "LaserCannon",
				weaponvelocity = 2000,
				damage = {
					commanders = 10000,
					default = 50000,
					experimental_land = 150000,
					experimental_ships = 150000,
					subs = 5,
				},
			},
		},
		weapons = {
			[1] = {
				badtargetcategory = "LARGE MEDIUM SMALL TINY",
				def = "CORE_BOUCHER",
				onlytargetcategory = "NOTVTOL",
			},
		},
	},
}

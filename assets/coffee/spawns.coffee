spawns = Game.spawns
_spawns =
	available: []
	all: spawns

for key of spawns
	spawn = spawns[key]
	if spawn.energy > 0
		_spawns.available.push spawn

modules.export = _spawns
units = require './units'
spawns = require 'spawns'
creeps = require 'creeps'

allLength = creeps.all.length
onePercent = allLength / 100
percents =
	scout: 30
	worker: 70

for type of creeps
	if type is 'all'
		continue

	_creeps = creeps[type]
	length = _creeps.length
	percent = onePercent * length
	if percent < percents[type]
		spawn = spawns.available[0]
		creep = new units[type] spawn
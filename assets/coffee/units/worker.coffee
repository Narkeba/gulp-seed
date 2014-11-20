class Worker
	constructor: (@spawn) ->
		body = ['attack', 'move']
		@name = @spawn.createCreep body
		Memory.creeps[@name] = role: 'worker'

	work: ->
		if @energy < @energyCapacity
			target = @pos.findNearest Game.SOURCES_ACTIVE
			@moveTo target
			@harvest target
		else
			@moveTo Game.spawns.Spawn1
			@transferEnergy Game.spawns.Spawn1

module.exports = Worker
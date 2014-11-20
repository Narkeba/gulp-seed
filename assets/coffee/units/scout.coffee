class Scout
	constructor: (@spawn) ->
		body = ['attack', 'move']
		@name = @spawn.createCreep body
		Memory.creeps[@name] = role: 'scout'

module.exports = Scout
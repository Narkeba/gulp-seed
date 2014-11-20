creeps = Game.creeps
_creeps =
	all: creeps

for creep in creeps
	role = creep.memory.role

	if role not in _creeps
		_creeps[role] = []

	_creeps[role].push creep
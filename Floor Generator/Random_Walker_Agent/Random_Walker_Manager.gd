extends Resource
class_name WalkerManager

var agents: Array[WalkerAgent] = []

func _init() -> void:
	pass
	
func generate_paths(initial_agents: int = 3, agent_data: Dictionary[String, Variant] = {}) -> Dictionary[WalkerAgent, Array]:	
	for i in range(initial_agents):
		var new_agent: WalkerAgent = WalkerAgent.new()
		if not agent_data.is_empty():
			new_agent = WalkerAgent.new(
				{} if not agent_data.has("weights") else agent_data["weights"],
				new_agent.child_spawn_chance if not agent_data.has("child_spawn_chance") else agent_data["child_spawn_chance"],
				new_agent.child_recurrsion_factor if not agent_data.has("child_recurrsion_factor") else agent_data["child_recurrsion_factor"],
				new_agent.end_weight_increase if not agent_data.has("end_weight_increase") else agent_data["end_weight_increase"],
			)
			
		add_new_agent(new_agent)
	
	var agent_paths: Dictionary[WalkerAgent, Array] = {}
	
	while not agents.is_empty():
		for walker: WalkerAgent in agents:
			var last_position: Vector2 = walker.start_position
			var new_position: Vector2 = walker.generate_next_action()
			
			var agent_path: Array = agent_paths.get_or_add(walker, [last_position])
			last_position = agent_path[agent_path.size()-1]
			
			if new_position != last_position:
				var path: Array = agent_paths.get(walker)
				path.append(new_position)
			else:
				agents.erase(walker)
			
	agents = []	
	return agent_paths
	
func get_map_data(paths: Dictionary[WalkerAgent, Array]) -> Dictionary[String, Variant]:
	var generation_data: Dictionary[String, Variant] = {
	"dimensions": [Vector2.ZERO, Vector2.ZERO],
	"total_agents": 0,
	"total_rooms": 0,
	}
	
	generation_data.total_agents = paths.size()
	
	var min_vector: Vector2 = Vector2.ZERO
	var max_vector: Vector2 = Vector2.ZERO
	
	var unique_positions: Array[Vector2] = []
	
	for agent in paths:
		for position in paths[agent]:
			if position.x > max_vector.x: max_vector.x = position.x
			if position.y > max_vector.y: max_vector.y = position.y
			if position.x < min_vector.x: min_vector.x = position.x
			if position.y < min_vector.y: min_vector.y = position.y
			
			if not unique_positions.has(position): unique_positions.append(position)
		
	generation_data.dimensions = abs(min_vector - max_vector)
	generation_data.total_rooms = unique_positions.size()
	
	#print("Dimensions: ", generation_data.dimensions)
	#print("Agents: ", generation_data.total_agents)
	#print("Rooms: ", generation_data.total_rooms)
	#print("")
	
	return generation_data
	
func add_new_agent(agent: WalkerAgent) -> void:
	self.agents.append(agent)
	agent.child_created.connect(add_new_agent)

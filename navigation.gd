extends Navigation2D

# Member variables
const SPEED = 200.0

var begin = Vector2()
var end = Vector2()
var path = []
export(NodePath) var targetPath

func _process(delta):
	var ant = get_node(targetPath)
	
	if path.size() > 1:
		var to_walk = delta * SPEED
		while to_walk > 0 and path.size() >= 2:
			# Get from and to points
			var pfrom = path[path.size() - 1]
			var pto = path[path.size() - 2]
			
			# Turn the ant to look where it is going
			ant.look_at(pto)
			
			# Get distance to next point
			var distance = pfrom.distance_to(pto)
			
			if distance <= to_walk:
				path.remove(path.size() - 1)
				to_walk -= distance
			else:
				path[path.size() - 1] = pfrom.linear_interpolate(pto, to_walk / distance)
				to_walk = 0
		
		var atpos = path[path.size() - 1]
		
		ant.position = atpos
		
		if path.size() < 2:
			path = []
			set_process(false)
	else:
		set_process(false)


func _update_path():
	var simple_path = get_simple_path(begin, end, true)
	path = Array(simple_path) # PoolVector2Array too complex to use, convert to regular array
	path.invert()
	
	set_process(true)


func _input(event):
	# Mouse in viewport coordinates
	if event is InputEventMouseButton:
       print("Mouse Click/Unclick at: ", event.position)
	
	if event is InputEventMouseButton and event.pressed and event.button_index == 1:
		begin = $ant.position
		# Mouse to local navigation coordinates
		end = event.position - position
		_update_path()

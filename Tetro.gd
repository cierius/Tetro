extends Camera2D


var shape # The currently held object

var is_holding = false # Used when the player is actively holding a shape

class Tetro:
	var pos: Vector2


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	var m_pos = get_global_mouse_position() # Basically just shorter to type out
	
	if(Input.is_action_just_pressed("touch")):
		touch(m_pos)
	elif(Input.is_action_just_released("touch") && shape):
		is_holding = false
		shape.position = snap_to_nearest_cell(m_pos)
		shape = null
	
	# Lock the position of the shape to the mouse position
	if(is_holding && shape):
		shape.position = Vector2(m_pos.x, m_pos.y)


func snap_to_nearest_cell(pos):
	var vec = Vector2(0, 0) # this is what we'll use to be the new position for the shape
	
	var space_state = get_world_2d().direct_space_state
	
	# Raycast a point and return an array of everything hit
	var result = space_state.intersect_point(pos)
	
	if(len(result) > 1 && result[1].collider.is_in_group("open")):
		print(result)
		# Result is an array so we have to loop over it when we move shapes on the
		# grid itself otherwise it doesn't detect properly
		for coll in result:
			if(!coll.collider.is_in_group("draggable")):
				if(coll.collider.is_in_group("open")):
					# I am unsure why we have to subtract this large vector, but it works
					vec = coll.collider.get_parent().position - Vector2(256, -128)
					
	elif(len(result) == 2 && result[1].collider.is_in_group("filled")):
		vec = Vector2(0, 350)
		
	else:
		# If we don't leave the shape on the grid it's left where released
		vec = pos
	
	return vec


# When the player clicks / touches on a shape it picks it up and allows them to move it while held down
func touch(pos):
	var space_state = get_world_2d().direct_space_state
	
	# Raycast our mouse pos and see if we hit a draggable shape
	var result = space_state.intersect_ray(pos, pos)
	
	if(result):
		if(result.collider.is_in_group("draggable")):
			shape = result.collider.get_parent()
			is_holding = true
		

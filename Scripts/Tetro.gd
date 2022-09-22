extends Camera2D


var shape # The currently held object
var shape_container = [] # an array that will fill with the shapes we grab

var is_holding = false # Used when the player is actively holding a shape

# The main interactble object for the player
class Tetro:
	var game_object # this is the collider associated with the object
	var origin: Vector2 # starting position
	var value: int 


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
	var vec = Vector2(0, 0) # new position for the shape
	
	# Grab the physics state of the world
	var space_state = get_world_2d().direct_space_state 
	
	# Raycast a point and return an array of everything hit
	var result = space_state.intersect_point(pos)
	
	if(len(result) > 1 && result[1].collider.is_in_group("open")):
		# Result is an array so we have to loop over it when we move shapes on the
		# grid itself otherwise it doesn't detect properly
		for coll in result:
			if(!coll.collider.is_in_group("draggable")):
				if(coll.collider.is_in_group("open")):
					# I am unsure why we have to subtract this large vector, but it works
					vec = coll.collider.get_parent().position - Vector2(256, -128)
	
	# When the block is let go of above a filled square, return to it's origin
	elif(len(result) == 2 && result[1].collider.is_in_group("filled")):
		# Loop through our array to find the class instance and then return it's starting pos
		for s in shape_container:
			if(s.game_object == result[0].collider):
				return s.origin
	
	# If we don't leave the shape on the grid it's left where released
	else:
		vec = pos
	
	return vec


# When the player clicks / touches on a shape it picks it up and allows them to move it while held down
func touch(pos):
	var space_state = get_world_2d().direct_space_state
	
	# Raycast our mouse pos and see if we hit a draggable shape
	# Index 0 will be our piece and not the board
	var result = space_state.intersect_point(pos)
	
	if(result):
		if(result[0].collider.is_in_group("draggable")):
			# First we check to see if we have a class instance of collision
			# if not we create one and assign the Tetro's starting variables
			
			if(len(shape_container) > 0):
				var result_index: int = 0
				
				# Count the number of times we find the shape in our array
				# If it's 0 then we create a new Tetro instance
				for s in range(len(shape_container)):
					if(shape_container[s].game_object == result[0].collider):
						result_index += 1
				
				if(result_index == 0):
					create_tetro(result[0])
			
			else:
				create_tetro(result[0])
			
			
			shape = result[0].collider.get_parent()
			is_holding = true


func create_tetro(result):
	# Instance the class, assign it's variables of the clicked shape
	# then add it to the array so we can trace it
	var tetro_inst = Tetro.new()
	tetro_inst.origin = result.collider.get_parent().position
	tetro_inst.game_object = result.collider
	shape_container.append(tetro_inst)
	
	print("New Tetro: ", tetro_inst.origin, " ", tetro_inst.game_object.get_parent().name)



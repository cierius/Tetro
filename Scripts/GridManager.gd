extends Node


class Grid:
	var grid = []
	var r: Array = [Block,Block,Block,Block,Block,Block,Block,Block,Block]
	var rows = [r, r, r, r, r, r, r, r, r]
	var columns = [r, r, r, r, r, r, r, r, r]
	var sub_grids = [[],[],[],[],[],[],[],[],[]]

class Block:
	var value: int
	var gameObject

onready var g = Grid.new()

export var grid_open: PackedScene
export var grid_filled: PackedScene

func _ready():
	var x_index = 0
	var y_index = 0
	
	for x in range(9):
		x_index += 1
		for y in range(9):
			var block_inst = Block.new()
			var inst
			
			if(round(rand_range(0, 1)) == 0):
				inst = grid_open.instance()  
			else:
				inst = grid_filled.instance() 
				var rand_num = rand_range(0, 9)
				inst.get_node("./Label").text = str(round(rand_num)) 
				block_inst.value = round(rand_num)
			
			block_inst.gameObject = inst
			g.grid.append(inst)
			
			call_deferred("add_child", inst)
			
			inst.position = Vector2(x*64, -y*64)
			y_index += 1
	
	#organize_grid()


func organize_grid():
	for i in g.grid:
		print(i.position.x/64)
		
		g.columns[i.position.x/64].insert(int(i.position.y/64), i)
		g.rows[i.position.y/64].insert(int(i.position.x/64), i)
		
		for y in range(3):
			for x in range(3):
				for spot_y in range(3):
					for spot_x in range(3):
						var grid_spot
						
						grid_spot = g.rows[(y-1)*(x-1)][(spot_y-1)*(spot_x-1)]
						#print(grid_spot)
						g.sub_grids[y*x].insert(spot_y*spot_x, grid_spot)
		
	print(len(g.rows[0]))

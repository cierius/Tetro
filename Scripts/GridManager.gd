extends Node


class Grid:
	var grid = []
	var rows = [[],[],[],[],[],[],[],[],[]]
	var columns = [[],[],[],[],[],[],[],[],[]]
	var sub_grids = [[],[],[],[],[],[],[],[],[]]


class Block:
	var value: int
	var pos: Vector2
	var gameObject

onready var g = Grid.new()

export var grid_open: PackedScene
export var grid_filled: PackedScene

func _ready():
	generate_blank()
	organize_grid()
	


func generate_blank():
	for x in range(9):
		for y in range(9):
			var block_inst = Block.new()
			var inst = grid_open.instance()
			
			block_inst.gameObject = inst
			g.grid.append(block_inst)
			
			call_deferred("add_child", inst)
			
			block_inst.pos = Vector2(x*64, y*64)
			inst.position = Vector2(x*64, -y*64)


func organize_grid():
	for i in g.grid:
		
		g.columns[i.pos.x/64].insert(int(abs(i.pos.y/64)), i)
		g.rows[abs(i.pos.y/64)].insert(int(i.pos.x/64), i)
		
		#Sub Grid X - 0
		if(i.pos.x/64 >= 0 and i.pos.x/64 <= 2):
			if(i.pos.y/64 >= 0 and i.pos.y/64 <= 2):
				g.sub_grids[0].append(i)
			elif(i.pos.y/64 >= 3 and i.pos.y/64 <= 5):
				g.sub_grids[3].append(i)
			elif(i.pos.y/64 >= 6 and i.pos.y/64 <= 8):
				g.sub_grids[6].append(i)
		
		#Sub Grid X - 1
		elif(i.pos.x/64 >= 3 and i.pos.x/64 <= 5):
			if(i.pos.y/64 >= 0 and i.pos.y/64 <= 2):
				g.sub_grids[1].append(i)
			elif(i.pos.y/64 >= 3 and i.pos.y/64 <= 5):
				g.sub_grids[4].append(i)
			elif(i.pos.y/64 >= 6 and i.pos.y/64 <= 8):
				g.sub_grids[7].append(i)
		
		#Sub Grid X - 3
		elif(i.pos.x/64 >= 6 and i.pos.x/64 <= 8):
			if(i.pos.y/64 >= 0 and i.pos.y/64 <= 2):
				g.sub_grids[2].append(i)
			elif(i.pos.y/64 >= 3 and i.pos.y/64 <= 5):
				g.sub_grids[5].append(i)
			elif(i.pos.y/64 >= 6 and i.pos.y/64 <= 8):
				g.sub_grids[8].append(i)


func randomize_grid():
	pass

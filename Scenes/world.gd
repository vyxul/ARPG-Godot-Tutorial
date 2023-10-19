extends Node2D

@onready var map: Node = $TileMap
@onready var player: Node = $Player
@onready var heartsContainer = $CanvasLayer/HeartsContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	# Set camera boundaries
	# Get temp variables
	var mapSize = map.get_used_rect()
	var tileSize = map.cell_quadrant_size
	
	# Get bounds of tilemap
	var limit_left = mapSize.position.x * tileSize
	var limit_right = limit_left + (mapSize.size.x * tileSize)
	var limit_top = mapSize.position.y * tileSize
	var limit_bottom = limit_top + (mapSize.size.y * tileSize)
	
	# Use the setter method in player to set the boundaries
	player.setCameraBounds(limit_left, limit_right, limit_top, limit_bottom)
	
	# Set up the Hearts Container
	heartsContainer.setMaxHearts(player.maxHealth)
	heartsContainer.updateHearts(player.currentHealth)
	player.currentHealthChanged.connect(heartsContainer.updateHearts.bind())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_canvas_layer_closed():
	get_tree().paused = false


func _on_canvas_layer_opened():
	get_tree().paused = true

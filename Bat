extends Area2D
class_name Bat

signal Die

@export var speed: float = 100.0
@export var health: int = 10

var duke = null
var should_follow = false

func _ready():
	$Sprite.play("default")
	duke = get_tree().get_root().find_child("Duke", true, false)
	$MoveTimer.start()

	# Connect signals from DetectionArea
	$DetectionArea.body_entered.connect(_on_detection_area_body_entered)
	$DetectionArea.body_exited.connect(_on_detection_area_body_exited)

func _process(delta):
	if should_follow and duke:
		var direction = (duke.global_position - global_position).normalized()
		global_position += direction * speed * delta
		rotation = direction.angle()

func _on_detection_area_body_entered(body: Node) -> void:
	if body.name == "Duke":
		should_follow = true

func _on_detection_area_body_exited(body: Node) -> void:
	if body.name == "Duke":
		should_follow = false

func _on_body_entered(body):
	if body.is_in_group("Bullet"):
		take_damage(1)

func take_damage(amount: int):
	health -= amount
	print("Bat took damage! Health now: ", health)
	if health <= 0:
		get_tree().change_scene_to_file("res://Bosslevelone.tscn")

func die():
	print("Bat has died.")
	queue_free()

func _on_area_entered(area: Area2D) -> void:
	var parent = area.get_parent()
	if parent and parent.name == "Duke" and area.name == "HitBox":
		if parent.has_method("take_damage"):
			parent.take_damage(1)
	if area.is_in_group("Bullet"):
		take_damage(1)

func StartMoving() -> void:
	$Sprite.play("move")

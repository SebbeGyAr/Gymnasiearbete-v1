extends Area2D

var speed = 750

func _physics_process(delta):
	position += transform.x * speed * delta
	await get_tree().create_timer(1).timeout
	queue_free()
	

func _on_bullet_body_entered(body):
	if body.is_in_group("Non Character Entities"):
		body.queue_free()
	queue_free()


func _on_area_entered(area: Area2D) -> void:
	queue_free()

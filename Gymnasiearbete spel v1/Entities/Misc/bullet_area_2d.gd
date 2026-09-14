extends Area2D

# HASTIGHET PÅ KULAN
var speed = 750

func _physics_process(delta):
	# FLYTTAR KULAN
	position += transform.x * speed * delta
	
	# SPELAR LITET LJUD I 0.25 SEKUNDER
	await get_tree().create_timer(0.25).timeout
	$AudioStreamPlayer.volume_db = -100
	
	# VÄNTAR TILLS EN SEKUND TOTALT PASSERAT, SEDAN RADERAR SIG SJÄLV
	await get_tree().create_timer(0.75).timeout
	queue_free()
	

func _on_bullet_body_entered(body):
	# SKA GÖRA SÅ ATT ENTITYN TAR SKADA OM KULAN TRÄFFAR EN ENTITY
	if body.is_in_group("Non Character Entities"):
#		body.got_hit()
		pass

	# SEDAN FÖRSVINNER KULAN
	queue_free()


func _on_area_entered(_area: Area2D) -> void:
	# RADERAR SIG SJÄLV OM DEN KOLLIDERAR MED EN AREA2D
	queue_free()

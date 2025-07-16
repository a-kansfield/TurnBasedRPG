extends Control


const MOVE_SPD = .2
const VANISH_SPD = 8

var modAlpha = false
enum CHILDREN {
	LABEL = 0,
	VANISH_TIMER = 1,
	DESTROY_SELF = 2
}

func _init():
	pass
func _process(delta):
	self.position.y -= MOVE_SPD
	if modAlpha:
		self.modulate.a8 -= VANISH_SPD
	
	
	


func _on_timer_timeout():
	modAlpha = true


func _on_destroy_self_timeout():
	queue_free()

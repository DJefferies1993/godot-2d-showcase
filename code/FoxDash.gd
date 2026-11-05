extends Node2D
## Committed horizontal attack; all movement uses the fox's existing solid collider.
const WINDUP:=.18
const TRAVEL:=.32
const RECOVERY:=.24
const COOLDOWN:=5.0
const SPEED:=1000.0
var fox:CharacterBody2D
var cooldown:=1.0
var age:=0.0
var active:=false
var direction:=1.0
var hit:Dictionary={}
var body:Sprite2D
var trail:Sprite2D
func _ready() -> void:
	fox=get_parent()
	body=Sprite2D.new()
	body.texture=load("res://skills/UmbraFox/dash-fox.png")
	body.hframes=4
	body.vframes=4
	body.scale=Vector2.ONE*.19
	body.position=Vector2(0,-12)
	add_child(body)
	trail=Sprite2D.new()
	trail.texture=load("res://skills/UmbraFox/dash-trail.png")
	trail.hframes=4
	trail.vframes=4
	trail.scale=Vector2.ONE*.30
	trail.z_index=-1
	add_child(trail)
	hide()
func tick(delta:float) -> bool:
	cooldown=maxf(0,cooldown-delta)
	if not active:return false
	if fox.dead:finish();return false
	var before:=age
	age+=delta
	fox.velocity.x=0
	var start:=fox.global_position
	if age>=WINDUP and before<WINDUP+TRAVEL:
		fox.floor_check.force_raycast_update()
		var safe_floor:bool=fox.floor_check.is_colliding()
		if not safe_floor:age=WINDUP+TRAVEL
		var portion:=maxf(0,minf(age,WINDUP+TRAVEL)-maxf(before,WINDUP))
		if not safe_floor:portion=0
		fox.velocity.x=direction*SPEED*portion/maxf(delta,.00001)
	fox.move_and_slide()
	if age>=WINDUP and before<WINDUP+TRAVEL:
		hit_segment(start,fox.global_position)
		if fox.is_on_wall():age=maxf(age,WINDUP+TRAVEL)
	body.frame=clampi(int(age/(WINDUP+TRAVEL+RECOVERY)*16),0,15)
	trail.frame=clampi(int(maxf(0,age-WINDUP)/TRAVEL*16),0,15)
	trail.visible=age>=WINDUP and age<WINDUP+TRAVEL+.12
	trail.modulate.a=1-smoothstep(WINDUP+TRAVEL,WINDUP+TRAVEL+.12,age)
	if age>=WINDUP+TRAVEL+RECOVERY:finish()
	return true
func try_start(difference:Vector2) -> bool:
	if active or cooldown>0 or fox.dead or fox.attacking or fox.casting_fireball:return false
	if not fox.is_on_floor() or absf(difference.y)>65 or absf(difference.x)<155 or absf(difference.x)>420:return false
	direction=signf(difference.x)
	fox.face_direction(direction)
	fox.wall_check.force_raycast_update()
	fox.floor_check.force_raycast_update()
	if fox.wall_check.is_colliding() or not fox.floor_check.is_colliding():return false
	active=true
	fox.velocity.x=0
	age=0
	cooldown=COOLDOWN
	hit.clear()
	body.flip_h=direction<0
	# The supplied trail faces left, while the fox sheet faces right.
	trail.flip_h=direction>0
	trail.position=Vector2(-direction*45,16)
	body.frame=0
	trail.hide()
	fox.sprite.hide()
	show()
	return true
func hit_segment(start:Vector2,end:Vector2) -> void:
	var query:=PhysicsShapeQueryParameters2D.new()
	var shape:=RectangleShape2D.new()
	shape.size=Vector2(absf(end.x-start.x)+85,70)
	query.shape=shape
	query.transform=Transform2D(0,(start+end)*.5+Vector2(0,3))
	query.collision_mask=4|8
	query.exclude=[fox.get_rid()]
	for result in fox.get_world_2d().direct_space_state.intersect_shape(query,64):
		var enemy:Node=result.collider
		if not enemy.is_in_group("Enemy") or hit.has(enemy.get_instance_id()):continue
		if enemy.has_method("is_dead") and enemy.is_dead():continue
		var ray:=PhysicsRayQueryParameters2D.create(end+Vector2(0,3),enemy.global_position,1,[fox.get_rid()])
		if not fox.get_world_2d().direct_space_state.intersect_ray(ray).is_empty():continue
		hit[enemy.get_instance_id()]=true
		CombatManager.damage_target(fox,enemy,fox.get_attack_damage()*1.5,&"companion",1)
func finish() -> void:
	active=false
	fox.velocity.x=0
	fox.sprite.show()
	fox.play_animation(&"idle",true)
	hide()

extends Node


var enemies: Dictionary = {}


# ==================================================
# REGISTRATION
# ==================================================

func register_enemy(enemy: Node2D) -> void:
	if enemy == null:
		return

	if not is_instance_valid(enemy):
		return

	enemies[enemy.get_instance_id()] = enemy
	WorldExpansion.watch_enemy(enemy)


func unregister_enemy(enemy: Node2D) -> void:
	if enemy == null:
		return

	if enemy.has_method("is_dead") and enemy.is_dead():
		WorldExpansion.enemy_defeated(enemy)
	enemies.erase(
		enemy.get_instance_id()
	)


# ==================================================
# CLEAN INVALID REFERENCES
# ==================================================

func clean_registry() -> void:
	var ids_to_remove: Array[int] = []

	for enemy_id in enemies.keys():
		var enemy: Variant = enemies[enemy_id]

		if enemy == null:
			ids_to_remove.append(enemy_id)
			continue

		if not is_instance_valid(enemy):
			ids_to_remove.append(enemy_id)

	for enemy_id in ids_to_remove:
		enemies.erase(enemy_id)


# ==================================================
# GET ALL ACTIVE ENEMIES
# ==================================================

func get_all_enemies() -> Array[Node2D]:
	clean_registry()

	var result: Array[Node2D] = []

	for enemy_value in enemies.values():
		if enemy_value is Node2D:
			result.append(
				enemy_value as Node2D
			)

	return result


# ==================================================
# NEAREST ENEMY
# ==================================================

func get_nearest_enemy(
	world_position: Vector2,
	max_range: float
) -> Node2D:

	clean_registry()

	var nearest_enemy: Node2D = null
	var nearest_distance: float = max_range

	for enemy_value in enemies.values():

		if not enemy_value is Node2D:
			continue

		var enemy: Node2D = enemy_value as Node2D

		if not is_instance_valid(enemy):
			continue

		if enemy.has_method("is_combat_target"):

			if not enemy.is_combat_target():
				continue

		var distance: float = (
			world_position.distance_to(
				enemy.global_position
			)
		)

		if distance < nearest_distance:
			nearest_distance = distance
			nearest_enemy = enemy

	return nearest_enemy


# ==================================================
# ENEMIES INSIDE RADIUS
# ==================================================

func get_enemies_in_radius(
	world_position: Vector2,
	radius: float
) -> Array[Node2D]:

	clean_registry()

	var result: Array[Node2D] = []

	var radius_squared: float = (
		radius * radius
	)

	for enemy_value in enemies.values():

		if not enemy_value is Node2D:
			continue

		var enemy: Node2D = enemy_value as Node2D

		if not is_instance_valid(enemy):
			continue

		if enemy.has_method("is_combat_target"):

			if not enemy.is_combat_target():
				continue

		var distance_squared: float = (
			world_position.distance_squared_to(
				enemy.global_position
			)
		)

		if distance_squared <= radius_squared:
			result.append(enemy)

	return result


# ==================================================
# RECTANGLE QUERY
# ==================================================

func get_enemies_in_rect(
	world_rect: Rect2
) -> Array[Node2D]:

	clean_registry()

	var result: Array[Node2D] = []

	for enemy_value in enemies.values():

		if not enemy_value is Node2D:
			continue

		var enemy: Node2D = enemy_value as Node2D

		if not is_instance_valid(enemy):
			continue

		if world_rect.has_point(
			enemy.global_position
		):
			result.append(enemy)

	return result


# ==================================================
# COUNT
# ==================================================

func get_enemy_count() -> int:
	clean_registry()
	return enemies.size()

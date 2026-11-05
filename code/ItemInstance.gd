class_name SpiritItemInstance
extends RefCounted
## Persistent identity survives every transfer. V1 uses one instance per slot.
var uid: String = ""
var definition_id: String = ""
var upgrade_level: int = 0
var appearance_id: String = ""
var attributes: Dictionary = {}

func to_dict() -> Dictionary:
	return {"uid": uid, "definition_id": definition_id, "upgrade_level": upgrade_level,
		"appearance_id": appearance_id, "attributes": attributes.duplicate(true)}

static func from_dict(data: Dictionary) -> SpiritItemInstance:
	var item := SpiritItemInstance.new()
	item.uid = str(data.get("uid", ""))
	item.definition_id = str(data.get("definition_id", ""))
	item.upgrade_level = maxi(0, int(data.get("upgrade_level", 0)))
	item.appearance_id = str(data.get("appearance_id", ""))
	item.attributes = data.get("attributes", {}).duplicate(true)
	return item

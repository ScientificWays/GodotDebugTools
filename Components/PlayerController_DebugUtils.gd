@tool
extends Node
class_name PlayerController_DebugUtils

@export_category("Owner")
@export var owner_player_controller: PlayerController

func _ready() -> void:
	
	if Engine.is_editor_hint():
		if not owner_player_controller:
			owner_player_controller = find_parent("*layer*")
	else:
		assert(owner_player_controller)
		
		if OS.has_feature("debug"):
			GDConsole.create_command(kill)
			GDConsole.create_command(teleport)
			GDConsole.create_command(self_damage)
			GDConsole.create_command(fade)
		else:
			queue_free()

func _unhandled_input(in_event: InputEvent) -> void:
	
	if in_event.is_action_pressed(&"debug_action"):
		#DebugSpawnCreature()
		#DebugSpawnExplosion()
		teleport()
		#DebugSpawnItem()
		#DebugApplyStatusEffect()
		#self_damage()
		#DebugUnlock()
		#DebugToggleVisibility()
		#fade()
		get_viewport().set_input_as_handled()
		
	elif in_event.is_action_pressed(&"debug_scroll_up"):
		owner_player_controller._camera.PendingZoom *= 1.25
		print("Set camera zoom to ", owner_player_controller._camera.PendingZoom)
		get_viewport().set_input_as_handled()
		
	elif in_event.is_action_pressed(&"debug_scroll_down"):
		owner_player_controller._camera.PendingZoom *= 0.8
		print("Set camera zoom to ", owner_player_controller._camera.PendingZoom)
		get_viewport().set_input_as_handled()
		

func kill() -> void:
	if owner_player_controller.controlled_pawn:
		owner_player_controller.controlled_pawn.kill()

func teleport() -> void:
	
	if not is_instance_valid(owner_player_controller.controlled_pawn):
		return
	
	var TeleportPosition := owner_player_controller.controlled_pawn.get_global_mouse_position()
	owner_player_controller.controlled_pawn.teleport_to(TeleportPosition)

func self_damage() -> void:
	
	var damage_receiver := DamageReceiver.try_get_from(owner_player_controller.controlled_pawn)
	damage_receiver.try_receive_damage(self, owner_player_controller, 10.0, DamageReceiver.DamageType_MeleeHit, true)

func fade() -> void:
	await owner_player_controller.trigger_fade_in(1.0)
	owner_player_controller.trigger_fade_out(1.0)

extends Node

var transition_scene: PackedScene = preload("res://scene_transition.tscn")
var current_scene: Node = null

func change_scene_with_transition(previous_scene: Node, next_scene: PackedScene):
	# Load the transition UI
	current_scene = previous_scene
	var transition = transition_scene.instantiate()
	get_tree().get_root().add_child(transition)
	#transition.z_index = 999  # Ensure it's on top

	# Wait for fade out
	var anim = transition.get_node("AnimationPlayer")
	anim.play("Fade")

	# Wait for half the animation to load the scene
	await anim.animation_finished

	# Change scene
	if current_scene:
		current_scene.queue_free()
	var new_scene = next_scene.instantiate()
	get_tree().get_root().add_child(new_scene)
	current_scene = new_scene

	# Wait for fade-in to finish, then clean up
	await anim.animation_finished
	transition.queue_free()

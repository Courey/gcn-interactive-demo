class_name Telescope extends Resource

enum physical_location {
	GROUND,
	SPACE
}

enum observation_band {
	RADIO,
	MICROWAVE,
	INFRARED,
	NIR,
	OPTICAL,
	UV,
	XRAY,
	GAMMA_RAY
}

# Basic Properties (Non-gameplay affecting)
@export var telescope_name: String
@export var position: physical_location

# Telescope Stats (Gameplay affecting)
## Degrees squared
@export var field_of_view: float # Corresponds to players' respective target areas
@export var sensitivity: int
## Degrees per second
@export var slew_speed: float
@export var observation_delay: int
## Start and end of observable range in nanometers
@export var band: Array[observation_band]
@export var image: Texture2D
@export var type: String

func get_location_string():
	return physical_location.find_key(position)

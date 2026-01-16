extends Node

enum SafezoneState { NO_SAFEZONE_FOUND, FIRST_SAFEZONE_FOUND, BOTH_SAFEZONES_FOUND }

var safezone_state: SafezoneState
var first_safezone_pos: Vector2i

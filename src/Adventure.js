"use strict";

exports.ffi_get_player = function(player_name) {
	return function() {
		return get_player(player_name);
	};
}

exports.ffi_attack = function(target) {
	return attack(target);
}

exports.ffi_get_nearest_monster = function(args) {
	return function() {
		return get_nearest_monster(args);
	};
}
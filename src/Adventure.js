"use strict";

exports.ffi_character = function() {
	return character;
};

exports.ffi_get_player = function(player_name) {
	return function() {
		return get_player(player_name);
	};
}

exports.ffi_attack = function(target) {
	return function() {
		return attack(target);
	};
}

exports.ffi_can_attack = function(target) {
	return function() {
		return can_attack(target);
	};
}

exports.ffi_get_nearest_monster = function(args) {
	return function() {
		return get_nearest_monster(args);
	};
}


exports.ffi_move = function(x) {
	return function(y) {
		return function() {
			move(x, y);
		}
	}
}

// NOTE: This function will eventually be removed
// in favour of our own movement system.
exports.ffi_smart_move = function(destination) {
	return function() {
		// return new Promise((resolve, reject) => {
		safe_log("Calling smart move with " + JSON.stringify(destination), "white");
		smart_move(destination.x, destination.y);
		// });
	}
}

exports.ffi_loot = function(commander) {
	return function() {
		loot(commander);
	}
}

exports.ffi_use = function(name) {
	return function(target) {
		return function() {
			use(name, target);
		};
	};
}
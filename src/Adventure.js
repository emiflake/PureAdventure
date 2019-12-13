"use strict";

exports.ffi_character = function() {
	let itemList = [];
	for (const item of character.items ) {
		if (item && item.name && item.q)
			itemList.push({ name : item.name, quantity : item.q });
	}
	return Object.assign({}, character, { itemList });
};

exports.ffi_get_player = function(player_name) {
	return function() {
		return get_player(player_name);
	};
};

exports.ffi_attack = function(target) {
	return function() {
		return attack(target);
	};
};

exports.ffi_can_attack = function(target) {
	return function() {
		return can_attack(target);
	};
};

exports.ffi_get_nearest_monster = function(args) {
	return function() {
		return get_nearest_monster(args);
	};
};


exports.ffi_move = function(x) {
	return function(y) {
		return function() {
			move(x, y);
		};
	};
};

exports.ffi_xmove = function(destination) {
	return function() {
		xmove(destination.x, destination.y);
	};
};

exports.ffi_smart_move = function(destination) {
	return function() {
		smart_move(destination.x, destination.y);
	};
};

exports.ffi_loot = function(commander) {
	return function() {
		loot(commander);
	};
};

exports.ffi_use = function(name) {
	return function(target) {
		return function() {
			use(name, target);
		};
	};
};

exports.ffi_find_npc = function (Just) {
	return function(Nothing) {
		return function(npc_name) {
			return function() {
				const npc = find_npc(npc_name);
				if (npc) {
					return Just(npc);
				} else {
					return Nothing;
				}
			};
		};
	};
};

exports.ffi_buy = function(name) {
	return function(quantity) {
		return function() {
			return buy(name, quantity);
		};
	};
};

exports.ffi_can_move_ft = function(from) {
	return function(to) {
		return function() {
			return can_move({
				map: character.map,
				x: from.x,
				y: from.y,
				going_x: to.x,
				going_y: to.y
			});
		}
	};
};
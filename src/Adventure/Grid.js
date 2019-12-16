"use strict";

exports.ffi_x_lines = function(world) {
	return function() {
		return G.geometry[world].x_lines.map(line => ({pos: line[0], min: line[1], max: line[2]}));
	};
};

exports.ffi_y_lines = function(world) {
	return function() {
		return G.geometry[world].y_lines.map(line => ({pos: line[0], min: line[1], max: line[2]}));
	};
};

exports.ffi_map_size = function(world) {
	return function() {
		const geom = G.geometry[world];
		return {
			minX: geom.min_x,
			minY: geom.min_y,
			maxX: geom.max_x,
			maxY: geom.max_y,
		};
	};
};
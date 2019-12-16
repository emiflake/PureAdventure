"use strict";

exports.ffi_draw_line = function(a) {
	return function(b) {
		return function(size) {
			return function(color) {
				return function() {
					draw_line(a.x, a.y, b.x, b.y, size, color);
				};
			};
		};
	};
};

exports.ffi_clear_drawings = function() {
	clear_drawings();
}
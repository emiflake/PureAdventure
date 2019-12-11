"use strict";

exports.ffi_set_message = function(msg) {
	return function() {
		set_message(msg);
	}
}

exports.ffi_safe_log = function(msg) {
	return function(color) {
		return function() {
			safe_log(msg, color);
		}
	}
}
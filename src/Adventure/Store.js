"use strict";



exports.ffi_set = function(key) {
	return function(value) {
		return function() {
			localStorage.setItem(key, value);
		};
	};
};

exports.ffi_get = function(key) {
	return function() {
		const ret = localStorage.getItem(key);
		if (ret) {
			return ret;
		} else {
			return "";
		}
	};
}
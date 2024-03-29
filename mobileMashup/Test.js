
(function () {
	var STK = (function () {
		var spec = {dependCacheList:{}, importCacheStore:{}, importCacheList:[], jobsCacheList:[]};
		var that = {};
		var lastPoint = 1;
		var baseURL = "";
		var errorInfo = [];
		var register = function (ns, maker) {
			var path = ns.split(".");
			var curr = that;
			for (var i = 0, len = path.length; i < len; i += 1) {
				if (i == len - 1) {
					if (curr[path[i]] !== undefined) {
						throw ns + "has been register!!!";
					}
					curr[path[i]] = maker(that);
					return true;
				}
				if (curr[path[i]] === undefined) {
					curr[path[i]] = {};
				}
				curr = curr[path[i]];
			}
		};
		var checkPath = function (ns) {
			var list = ns.split(".");
			var curr = that;
			for (var i = 0, len = list.length; i < len; i += 1) {
				if (curr[list[i]] === undefined) {
					return false;
				}
				curr = curr[list[i]];
			}
			return true;
		};
		var checkDepend = function () {
			for (var k in spec.dependCacheList) {
				var loaded = true;
				for (var i = 0, len = spec.dependCacheList[k]["depend"].length; i < len; i += 1) {
					if (!checkPath(spec.dependCacheList[k]["depend"][i])) {
						loaded = false;
						break;
					}
				}
				if (loaded) {
					register.apply(that, spec.dependCacheList[k]["args"]);
					delete spec.dependCacheList[k];
					setTimeout(function () {
						checkDepend();
					}, 25);
				}
			}
		};
		var E = function (id) {
			if (typeof id === "string") {
				return document.getElementById(id);
			} else {
				return id;
			}
		};
		var addEvent = function (sNode, sEventType, oFunc) {
			var oElement = E(sNode);
			if (oElement == null) {
				return;
			}
			sEventType = sEventType || "click";
			if ((typeof oFunc).toLowerCase() != "function") {
				return;
			}
			if (oElement.attachEvent) {
				oElement.attachEvent("on" + sEventType, oFunc);
			} else {
				if (oElement.addEventListener) {
					oElement.addEventListener(sEventType, oFunc, false);
				} else {
					oElement["on" + sEventType] = oFunc;
				}
			}
		};
		that.inc = function (ns, undepended) {
			if (!spec.importCacheList) {
				spec.importCacheList = [];
			}
			for (var i = 0, len = spec.importCacheList.length; i < len; i += 1) {
				if (spec.importCacheList[i] === ns) {
					if (!undepended) {
						spec.importCacheList.push(ns);
					}
					return false;
				}
			}
			if (!undepended) {
				spec.importCacheList.push(ns);
			}
			spec.importCacheStore[ns] = false;
			var js = document.createElement("SCRIPT");
			js.setAttribute("type", "text/javascript");
			js.setAttribute("src", baseURL + ns.replace(/\./ig, "/") + ".js");
			js.setAttribute("charset", "utf-8");
			js[that.IE ? "onreadystatechange" : "onload"] = function () {
				if (!that.IE || this.readyState.toLowerCase() == "complete" || this.readyState.toLowerCase() == "loaded") {
					lastPoint = spec.importCacheList.length;
					spec.importCacheStore[ns] = true;
					checkDepend();
				}
			};
			document.getElementsByTagName("HEAD")[0].appendChild(js);
		};
		that.register = function (ns, maker, shortName) {
			spec.dependCacheList[ns] = {args:arguments, depend:spec.importCacheList.slice(lastPoint, spec.importCacheList.length), "short":shortName};
			lastPoint = spec.importCacheList.length;
			checkDepend();
		};
		that.regShort = function (sname, sfun) {
			if (that[sname] !== undefined) {
				throw sname + ":show has been register";
			}
			that[sname] = sfun;
		};
		that.setBaseURL = function (url) {
			baseURL = url;
		};
		that.getErrorInfo = function () {
			return errorInfo;
		};
		that.IE = /msie/i.test(navigator.userAgent);
		that.E = E;
		that.C = function (tagName) {
			var dom;
			tagName = tagName.toUpperCase();
			if (tagName == "TEXT") {
				dom = document.createTextNode("");
			} else {
				if (tagName == "BUFFER") {
					dom = document.createDocumentFragment();
				} else {
					dom = document.createElement(tagName);
				}
			}
			return dom;
		};
		that.Ready = (function () {
			var funcList = [];
			var inited = false;
			var exec_func_list = function () {
				if (inited == true) {
					return;
				}
				inited = true;
				for (var i = 0, len = funcList.length; i < len; i++) {
					if ((typeof funcList[i]).toLowerCase() == "function") {
						funcList[i].call();
					}
				}
				funcList = [];
			};
			if (document.attachEvent && window == window.top) {
				(function () {
					try {
						document.documentElement.doScroll("left");
					}
					catch (e) {
						setTimeout(arguments.callee, 0);
						return;
					}
					exec_func_list();
				})();
			} else {
				if (document.addEventListener) {
					addEvent(document, "DOMContentLoaded", exec_func_list);
				} else {
					if (/WebKit/i.test(navigator.userAgent)) {
						(function () {
							if (/loaded|complete/.test(document.readyState.toLowerCase())) {
								exec_func_list();
								return;
							}
							setTimeout(arguments.callee, 25);
						})();
					}
				}
			}
			addEvent(window, "load", exec_func_list);
			return function (oFunc) {
				if (inited == true || (/loaded|complete/).test(document.readyState.toLowerCase())) {
					if ((typeof oFunc).toLowerCase() == "function") {
						oFunc.call();
					}
				} else {
					funcList.push(oFunc);
				}
			};
		})();
		return that;
	})();
	$Import = STK.inc;
	STK.register("core.func.getType", function ($) {
		return function (oObject) {
			var _t;
			return ((_t = typeof (oObject)) == "object" ? oObject == null && "null" || Object.prototype.toString.call(oObject).slice(8, -1) : _t).toLowerCase();
		};
	});
	STK.register("core.obj.parseParam", function ($) {
		return function (oSource, oParams, isown) {
			var key;
			if (typeof oParams != "undefined") {
				for (key in oSource) {
					if (oParams[key] != null) {
						if (isown) {
							if (oSource.hasOwnProperty[key]) {
								oSource[key] = oParams[key];
							}
						} else {
							oSource[key] = oParams[key];
						}
					}
				}
			}
			return oSource;
		};
	});
	STK.register("core.func.methodBefore", function ($) {
		return function () {
			var started = false;
			var methodList = [];
			var that = {};
			that.add = function (oFunc, oOpts) {
				var opts = {args:[], pointer:window, top:false};
				$.core.obj.parseParam(opts, oOpts);
				if (opts.top == true) {
					methodList.unshift([oFunc, opts.args, opts.pointer]);
				} else {
					methodList.push([oFunc, opts.args, opts.pointer]);
				}
				return !started;
			};
			that.start = function () {
				var i, len, method, args, pointer;
				if (started == true) {
					return;
				}
				started = true;
				for (i = 0, len = methodList.length; i < len; i++) {
					method = methodList[i][0];
					args = methodList[i][1];
					pointer = methodList[i][2];
					method.apply(pointer, args);
				}
			};
			that.reset = function () {
				methodList = [];
				started = false;
			};
			that.getList = function () {
				return methodList;
			};
			return that;
		};
	});
	STK.register("core.str.parseURL", function ($) {
		return function (url) {
			var parse_url = /^(?:([A-Za-z]+):)?(\/{0,3})([0-9.\-A-Za-z]+\.[0-9A-Za-z]+)?(?::(\d+))?(?:\/([^?#]*))?(?:\?([^#]*))?(?:#(.*))?$/;
			var names = ["url", "scheme", "slash", "host", "port", "path", "query", "hash"];
			var results = parse_url.exec(url);
			var that = {};
			for (var i = 0, len = names.length; i < len; i += 1) {
				that[names[i]] = results[i] || "";
			}
			return that;
		};
	});
	STK.register("core.arr.isArray", function ($) {
		return function (o) {
			return Object.prototype.toString.call(o) === "[object Array]";
		};
	});
	STK.register("core.str.trim", function ($) {
		return function (str) {
			if (typeof str !== "string") {
				throw "trim need a string as parameter";
			}
			if (typeof str.trim === "function") {
				return str.trim();
			} else {
				return str.replace(/^(\u3000|\s|\t|\u00A0)*|(\u3000|\s|\t|\u00A0)*$/g, "");
			}
		};
	});
	STK.register("core.json.queryToJson", function ($) {
		return function (QS, isDecode) {
			var _Qlist = $.core.str.trim(QS).split("&");
			var _json = {};
			var _fData = function (data) {
				if (isDecode) {
					return decodeURIComponent(data);
				} else {
					return data;
				}
			};
			for (var i = 0, len = _Qlist.length; i < len; i++) {
				if (_Qlist[i]) {
					_hsh = _Qlist[i].split("=");
					_key = _hsh[0];
					_value = _hsh[1];
					if (_hsh.length < 2) {
						_value = _key;
						_key = "$nullName";
					}
					if (!_json[_key]) {
						_json[_key] = _fData(_value);
					} else {
						if ($.core.arr.isArray(_json[_key]) != true) {
							_json[_key] = [_json[_key]];
						}
						_json[_key].push(_fData(_value));
					}
				}
			}
			return _json;
		};
	});
	STK.register("core.json.jsonToQuery", function ($) {
		var _fdata = function (data, isEncode) {
			data = data == null ? "" : data;
			data = $.core.str.trim(data.toString());
			if (isEncode) {
				return encodeURIComponent(data);
			} else {
				return data;
			}
		};
		return function (JSON, isEncode) {
			var _Qstring = [];
			if (typeof JSON == "object") {
				for (var k in JSON) {
					if (JSON[k] instanceof Array) {
						for (var i = 0, len = JSON[k].length; i < len; i++) {
							_Qstring.push(k + "=" + _fdata(JSON[k][i], isEncode));
						}
					} else {
						if (typeof JSON[k] != "function") {
							_Qstring.push(k + "=" + _fdata(JSON[k], isEncode));
						}
					}
				}
			}
			if (_Qstring.length) {
				return _Qstring.join("&");
			} else {
				return "";
			}
		};
	});
	STK.register("core.util.URL", function ($) {
		return function (sURL) {
			var that = {};
			var url_json = $.core.str.parseURL(sURL);
			var query_json = $.core.json.queryToJson(url_json.query);
			var hash_json = $.core.json.queryToJson(url_json.hash);
			that.setParam = function (sKey, sValue) {
				query_json[sKey] = sValue;
				return this;
			};
			that.getParam = function (sKey) {
				return query_json[sKey];
			};
			that.setParams = function (oJson) {
				for (var key in oJson) {
					that.setParam(key, oJson[key]);
				}
				return this;
			};
			that.setHash = function (sKey, sValue) {
				hash_json[sKey] = sValue;
				return this;
			};
			that.getHash = function (sKey) {
				return hash_json[sKey];
			};
			that.valueOf = that.toString = function () {
				var url = [];
				var query = $.core.json.jsonToQuery(query_json);
				var hash = $.core.json.jsonToQuery(hash_json);
				if (url_json.scheme != "") {
					url.push(url_json.scheme + ":");
					url.push(url_json.slash);
				}
				if (url_json.host != "") {
					url.push(url_json.host);
					url.push(url_json.port);
				}
				url.push("/");
				url.push(url_json.path);
				if (query != "") {
					url.push("?" + query);
				}
				if (hash != "") {
					url.push("#" + hash);
				}
				return url.join("");
			};
			return that;
		};
	});
	STK.register("core.evt.addEvent", function ($) {
		return function (sNode, sEventType, oFunc) {
			var oElement = $.E(sNode);
			if (oElement == null) {
				return false;
			}
			sEventType = sEventType || "click";
			if ((typeof oFunc).toLowerCase() != "function") {
				return;
			}
			if (oElement.attachEvent) {
				oElement.attachEvent("on" + sEventType, oFunc);
			} else {
				if (oElement.addEventListener) {
					oElement.addEventListener(sEventType, oFunc, false);
				} else {
					oElement["on" + sEventType] = oFunc;
				}
			}
			return true;
		};
	});
	STK.register("core.json.clone", function ($) {
		function clone(jsonObj) {
			var buf;
			if (jsonObj instanceof Array) {
				buf = [];
				var i = jsonObj.length;
				while (i--) {
					buf[i] = clone(jsonObj[i]);
				}
				return buf;
			} else {
				if (jsonObj instanceof Object) {
					buf = {};
					for (var k in jsonObj) {
						buf[k] = clone(jsonObj[k]);
					}
					return buf;
				} else {
					return jsonObj;
				}
			}
		}
		return clone;
	});
	STK.register("core.util.templet", function ($) {
		return function (template, data) {
			return template.replace(/#\{(.+?)\}/ig, function () {
				var key = arguments[1].replace(/\s/ig, "");
				var ret = arguments[0];
				var list = key.split("||");
				for (var i = 0, len = list.length; i < len; i += 1) {
					if (/^default:.*$/.test(list[i])) {
						ret = list[i].replace(/^default:/, "");
						break;
					} else {
						if (data[list[i]] !== undefined) {
							ret = data[list[i]];
							break;
						}
					}
				}
				return ret;
			});
		};
	});
	STK.register("core.obj.clear", function ($) {
		return function (oHash) {
			var key, newHash = {};
			for (key in oHash) {
				if (oHash[key] != null) {
					newHash[key] = oHash[key];
				}
			}
			return newHash;
		};
	});
	STK.register("core.json.jsonToStr", function ($) {
		function f(n) {
			return n < 10 ? "0" + n : n;
		}
		if (typeof Date.prototype.toJSON !== "function") {
			Date.prototype.toJSON = function (key) {
				return isFinite(this.valueOf()) ? this.getUTCFullYear() + "-" + f(this.getUTCMonth() + 1) + "-" + f(this.getUTCDate()) + "T" + f(this.getUTCHours()) + ":" + f(this.getUTCMinutes()) + ":" + f(this.getUTCSeconds()) + "Z" : null;
			};
			String.prototype.toJSON = Number.prototype.toJSON = Boolean.prototype.toJSON = function (key) {
				return this.valueOf();
			};
		}
		var cx = /[\u0000\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g, escapable = /[\\\"\x00-\x1f\x7f-\x9f\u00ad\u0600-\u0604\u070f\u17b4\u17b5\u200c-\u200f\u2028-\u202f\u2060-\u206f\ufeff\ufff0-\uffff]/g, gap, indent, meta = {"\b":"\\b", "\t":"\\t", "\n":"\\n", "\f":"\\f", "\r":"\\r", "\"":"\\\"", "\\":"\\\\"}, rep;
		function quote(string) {
			escapable.lastIndex = 0;
			return escapable.test(string) ? "\"" + string.replace(escapable, function (a) {
				var c = meta[a];
				return typeof c === "string" ? c : "\\u" + ("0000" + a.charCodeAt(0).toString(16)).slice(-4);
			}) + "\"" : "\"" + string + "\"";
		}
		function str(key, holder) {
			var i, k, v, length, mind = gap, partial, value = holder[key];
			if (value && typeof value === "object" && typeof value.toJSON === "function") {
				value = value.toJSON(key);
			}
			if (typeof rep === "function") {
				value = rep.call(holder, key, value);
			}
			switch (typeof value) {
			  case "string":
				return quote(value);
			  case "number":
				return isFinite(value) ? String(value) : "null";
			  case "boolean":
			  case "null":
				return String(value);
			  case "object":
				if (!value) {
					return "null";
				}
				gap += indent;
				partial = [];
				if (Object.prototype.toString.apply(value) === "[object Array]") {
					length = value.length;
					for (i = 0; i < length; i += 1) {
						partial[i] = str(i, value) || "null";
					}
					v = partial.length === 0 ? "[]" : gap ? "[\n" + gap + partial.join(",\n" + gap) + "\n" + mind + "]" : "[" + partial.join(",") + "]";
					gap = mind;
					return v;
				}
				if (rep && typeof rep === "object") {
					length = rep.length;
					for (i = 0; i < length; i += 1) {
						k = rep[i];
						if (typeof k === "string") {
							v = str(k, value);
							if (v) {
								partial.push(quote(k) + (gap ? ": " : ":") + v);
							}
						}
					}
				} else {
					for (k in value) {
						if (Object.hasOwnProperty.call(value, k)) {
							v = str(k, value);
							if (v) {
								partial.push(quote(k) + (gap ? ": " : ":") + v);
							}
						}
					}
				}
				v = partial.length === 0 ? "{}" : gap ? "{\n" + gap + partial.join(",\n" + gap) + "\n" + mind + "}" : "{" + partial.join(",") + "}";
				gap = mind;
				return v;
			}
		}
		return function (value, replacer, space) {
			var i;
			gap = "";
			indent = "";
			if (typeof space === "number") {
				for (i = 0; i < space; i += 1) {
					indent += " ";
				}
			} else {
				if (typeof space === "string") {
					indent = space;
				}
			}
			rep = replacer;
			if (replacer && typeof replacer !== "function" && (typeof replacer !== "object" || typeof replacer.length !== "number")) {
				throw new Error("JSON.stringify");
			}
			return str("", {"":value});
		};
	});
	STK.register("core.json.strToJson", function ($) {
		var at, ch, escapee = {"\"":"\"", "\\":"\\", "/":"/", b:"\b", f:"\f", n:"\n", r:"\r", t:"\t"}, text, error = function (m) {
			throw {name:"SyntaxError", message:m, at:at, text:text};
		}, next = function (c) {
			if (c && c !== ch) {
				error("Expected '" + c + "' instead of '" + ch + "'");
			}
			ch = text.charAt(at);
			at += 1;
			return ch;
		}, number = function () {
			var number, string = "";
			if (ch === "-") {
				string = "-";
				next("-");
			}
			while (ch >= "0" && ch <= "9") {
				string += ch;
				next();
			}
			if (ch === ".") {
				string += ".";
				while (next() && ch >= "0" && ch <= "9") {
					string += ch;
				}
			}
			if (ch === "e" || ch === "E") {
				string += ch;
				next();
				if (ch === "-" || ch === "+") {
					string += ch;
					next();
				}
				while (ch >= "0" && ch <= "9") {
					string += ch;
					next();
				}
			}
			number = +string;
			if (isNaN(number)) {
				error("Bad number");
			} else {
				return number;
			}
		}, string = function () {
			var hex, i, string = "", uffff;
			if (ch === "\"") {
				while (next()) {
					if (ch === "\"") {
						next();
						return string;
					} else {
						if (ch === "\\") {
							next();
							if (ch === "u") {
								uffff = 0;
								for (i = 0; i < 4; i += 1) {
									hex = parseInt(next(), 16);
									if (!isFinite(hex)) {
										break;
									}
									uffff = uffff * 16 + hex;
								}
								string += String.fromCharCode(uffff);
							} else {
								if (typeof escapee[ch] === "string") {
									string += escapee[ch];
								} else {
									break;
								}
							}
						} else {
							string += ch;
						}
					}
				}
			}
			error("Bad string");
		}, white = function () {
			while (ch && ch <= " ") {
				next();
			}
		}, word = function () {
			switch (ch) {
			  case "t":
				next("t");
				next("r");
				next("u");
				next("e");
				return true;
			  case "f":
				next("f");
				next("a");
				next("l");
				next("s");
				next("e");
				return false;
			  case "n":
				next("n");
				next("u");
				next("l");
				next("l");
				return null;
			}
			error("Unexpected '" + ch + "'");
		}, value, array = function () {
			var array = [];
			if (ch === "[") {
				next("[");
				white();
				if (ch === "]") {
					next("]");
					return array;
				}
				while (ch) {
					array.push(value());
					white();
					if (ch === "]") {
						next("]");
						return array;
					}
					next(",");
					white();
				}
			}
			error("Bad array");
		}, object = function () {
			var key, object = {};
			if (ch === "{") {
				next("{");
				white();
				if (ch === "}") {
					next("}");
					return object;
				}
				while (ch) {
					key = string();
					white();
					next(":");
					if (Object.hasOwnProperty.call(object, key)) {
						error("Duplicate key \"" + key + "\"");
					}
					object[key] = value();
					white();
					if (ch === "}") {
						next("}");
						return object;
					}
					next(",");
					white();
				}
			}
			error("Bad object");
		};
		value = function () {
			white();
			switch (ch) {
			  case "{":
				return object();
			  case "[":
				return array();
			  case "\"":
				return string();
			  case "-":
				return number();
			  default:
				return ch >= "0" && ch <= "9" ? number() : word();
			}
		};
		return function (source, reviver) {
			var result;
			text = source;
			at = 0;
			ch = " ";
			result = value();
			white();
			if (ch) {
				error("Syntax error");
			}
			return typeof reviver === "function" ? (function walk(holder, key) {
				var k, v, value = holder[key];
				if (value && typeof value === "object") {
					for (k in value) {
						if (Object.hasOwnProperty.call(value, k)) {
							v = walk(value, k);
							if (v !== undefined) {
								value[k] = v;
							} else {
								delete value[k];
							}
						}
					}
				}
				return reviver.call(holder, key, value);
			}({"":result}, "")) : result;
		};
	});
	STK.register("core.io.getXHR", function ($) {
		return function () {
			var _XHR = false;
			try {
				_XHR = new XMLHttpRequest();
			}
			catch (try_MS) {
				try {
					_XHR = new ActiveXObject("Msxml2.XMLHTTP");
				}
				catch (other_MS) {
					try {
						_XHR = new ActiveXObject("Microsoft.XMLHTTP");
					}
					catch (failed) {
						_XHR = false;
					}
				}
			}
			return _XHR;
		};
	});
	STK.register("core.io.ajax", function ($) {
		return function (oOpts) {
			var opts = {url:"", charset:"UTF-8", timeout:30 * 1000, args:{}, onComplete:null, onTimeout:null, uniqueID:null, onFail:null, method:"get", asynchronous:true, contentType:"application/x-www-form-urlencoded", responseType:"json"};
			$.core.obj.parseParam(opts, oOpts);
			if (opts.url == "") {
				throw "ajax need url in parameters object";
			}
			var trans = $.core.io.getXHR();
			var cback = function () {
				if (trans.readyState == 4) {
					var data = "";
					if (opts.responseType === "xml") {
						data = trans.responseXML;
					} else {
						if (opts.responseType === "text") {
							data = trans.responseText;
						} else {
							try {
								data = eval("(" + trans.responseText + ")");
							}
							catch (exp) {
								throw opts.url + "return error : syntax error";
							}
						}
					}
					if (trans.status == 200) {
						if (opts.onComplete != null) {
							opts.onComplete(data);
						}
					} else {
						if (opts.onFail != null) {
							opts.onFail(data, trans);
						}
					}
				} else {
					if (opts.onTraning != null) {
						opts.onTraning(trans);
					}
				}
			};
			trans.onreadystatechange = cback;
			if (opts.method.toLocaleLowerCase() == "get") {
				var url = $.core.util.URL(opts.url);
				url.setParams(opts.args);
				url.setParam("__rnd", new Date().valueOf());
				trans.open(opts.method, url, opts.asynchronous);
				trans.send("");
			} else {
				trans.open(opts.method, opts.url, opts.asynchronous);
				trans.setRequestHeader("Content-Type", opts.contentType);
				trans.send($.core.json.jsonToQuery(opts.args));
			}
		};
	});
	STK.register("core.dom.removeNode", function ($) {
		return function (node) {
			node = $.E(node) || node;
			try {
				node.parentNode.removeChild(node);
			}
			catch (e) {
			}
		};
	});
	STK.register("core.util.cookie", function ($) {
		var that = {set:function (sKey, sValue, oOpts) {
			var arr = [];
			var d, t;
			var cfg = {expire:null, path:null, domain:null, secure:null, encode:true};
			$.core.obj.parseParam(cfg, oOpts);
			if (cfg.encode == true) {
				sValue = escape(sValue);
			}
			arr.push(sKey + "=" + sValue);
			if (cfg.path != null) {
				arr.push("path=" + cfg.path);
			}
			if (cfg.domain != null) {
				arr.push("domain=" + cfg.domain);
			}
			if (cfg.secure != null) {
				arr.push(cfg.secure);
			}
			if (cfg.expire != null) {
				d = new Date();
				t = d.getTime() + cfg.expire * 3600000;
				d.setTime(t);
				arr.push("expires=" + d.toGMTString());
			}
			document.cookie = arr.join(";");
		}, get:function (sKey) {
			sKey = sKey.replace(/([\.\[\]\$])/g, "\\$1");
			var rep = new RegExp(sKey + "=([^;]*)?;", "i");
			var co = document.cookie + ";";
			var res = co.match(rep);
			if (res) {
				return res[1] || "";
			} else {
				return "";
			}
		}, remove:function (sKey, oOpts) {
			oOpts = oOpts || {};
			oOpts.expire = -10;
			that.set(sKey, "", oOpts);
		}};
		return that;
	});
	if (WB == null) {
		return;
	}
	var CONN_CACHE = {};
	var CONN_INDEX = 0;
	var CONN_TYPE;
	var CONN_READY = false;
	var CONN_HTML5_IFM;
	var API_CACHE = {};
	var MB = STK.core.func.methodBefore();
	var CFG = {key:null, xdpath:null, xddomain:null};
	var API_STATIC_PROXY_URL = "http://api.t.sina.com.cn/oauth/xd";
	var API_DOMAIN = "http://api.t.sina.com.cn";
	var API_PROXY_URL = "http://api.t.sina.com.cn/oauth/proxy";
	function parseCMD(sMethod, oCallBack, oArgs, oOpts) {
		var cfg = {method:"post", type:"json", cache_time:0};
		STK.core.obj.parseParam(cfg, oOpts);
		oArgs = oArgs || {};
		oOpts = oOpts || {};
		oArgs.source = CFG.key;
		oArgs._method = cfg.method;
		oArgs._cache_time = cfg.cache_time;
		oArgs._anywhereToken = STK.core.util.cookie.get("anywhereToken");
		sMethod = STK.core.util.templet(sMethod, oArgs);
		sendCMDToServer(sMethod, oArgs, oCallBack);
	}
	function sendCMDToServer(sMethod, oArgs, oCallBack) {
		if (MB.add(sendCMDToServer, {args:arguments})) {
			return;
		}
		var callback_index = "conn_" + CONN_INDEX;
		var cache = CONN_CACHE[callback_index] = {};
		cache.callback = oCallBack;
		CONN_INDEX++;
		oArgs = STK.core.obj.clear(oArgs);
		var args = STK.core.json.jsonToStr(oArgs);
		args = escape(args);
		switch (CONN_TYPE) {
		  case "html5":
			var oData = {origin:"client", cmd:sMethod, args:args, callback_index:callback_index, xdpath:CFG.xdpath, xddomain:CFG.xddomain};
			CONN_HTML5_IFM.contentWindow.postMessage(STK.core.json.jsonToQuery(oData), API_DOMAIN);
			break;
		  case "flash":
			break;
		  case "iframe":
			cache.ifm = createServerIFM(sMethod, args, callback_index);
			break;
		}
	}
	function createServerIFM(sCMD, sArgs, sCallBackIndex) {
		var url = STK.core.util.URL(API_STATIC_PROXY_URL);
		url.setParam("xdpath", CFG.xdpath);
		url.setParam("source", CFG.key);
		url.setParam("connect_type", CONN_TYPE);
		url.setParam("cmd", sCMD);
		if (sArgs != null) {
			url.setParam("args", sArgs);
		}
		if (sCallBackIndex != null) {
			url.setParam("callback_index", sCallBackIndex);
		}
		url.setParam("xddomain", CFG.xddomain);
		url.setParam("origin", "client");
		var ifm = STK.C("iframe");
		ifm.style.width = "500px";
		ifm.style.height = "300px";
		ifm.style.display = "none";
		ifm.src = url;
		document.body.appendChild(ifm);
		return ifm;
	}
	function initServerProxy() {
		var location_split = window.location.toString().split("?");
		if (location_split.length < 2) {
			return;
		}
		var cfg = STK.core.json.queryToJson(location_split[1]);
		switch (cfg.connect_type) {
		  case "html5":
			STK.core.evt.addEvent(window, "message", function (evt) {
				var data = evt.data;
				parseData(data);
			});
			var data = STK.core.json.clone(cfg);
			data.origin = "server";
			data.cmd = "ready";
			data = STK.core.json.jsonToQuery(data);
			parent.postMessage(data, cfg.xddomain);
			break;
		  case "flash":
			break;
		  case "iframe":
			OAuthAJAX(cfg.cmd, unescape(cfg.args), function (sResult, bStatus) {
				var url = STK.core.util.URL(cfg.xdpath);
				url.setParam("xdpath", cfg.xdpath);
				url.setParam("connect_type", cfg.connect_type);
				url.setParam("callback_index", cfg.callback_index);
				url.setParam("cmd", cfg.cmd);
				url.setParam("args", cfg.args);
				url.setParam("origin", "client");
				url.setParam("status", bStatus);
				var ifm = STK.C("iframe");
				ifm.style.width = "500px";
				ifm.style.height = "300px";
				document.body.appendChild(ifm);
				ifm.contentWindow.name = sResult;
				ifm.contentWindow.location = url;
			});
			break;
		}
	}
	function initClientProxy() {
		var location_split = window.location.toString().split("?");
		if (location_split.length < 2) {
			return;
		}
		var cfg = STK.core.json.queryToJson(location_split[1]);
		cfg.data = escape(window.name);
		cfg.origin = "server";
		var data = STK.core.json.jsonToQuery(cfg);
		try {
			parent.parent.WB.client.parseData(data);
		}
		catch (e) {
		}
	}
	function OAuthAJAX(sCMD, sArgs, oCallBack) {
		var oArgs = STK.core.json.strToJson(sArgs);
		oArgs._uri = sCMD;
		var sHash = [];
		for (var key in oArgs) {
			if (key != "_cache_time") {
				sHash.push(oArgs[key]);
			}
		}
		sHash = sHash.join("_");
		var dataExpired = true;
		if (API_CACHE[sHash]) {
			dataExpired = (new Date().valueOf() - API_CACHE[sHash].time) > oArgs._cache_time * 1000;
		}
		if (dataExpired) {
			STK.core.io.ajax({url:API_PROXY_URL, method:oArgs._method, responseType:"text", args:oArgs, onComplete:function (sResult) {
				API_CACHE[sHash] = {data:sResult, time:new Date().valueOf()};
				oCallBack(sResult, true);
			}, onFail:function (sResult) {
				oCallBack(sResult, false);
			}});
		} else {
			oCallBack(API_CACHE[sHash].data, true);
		}
	}
	function parseData(sData) {
		var oJson = STK.core.json.queryToJson(sData);
		var sCMD = oJson.cmd;
		var sOrigin = oJson.origin;
		var sArgs = oJson.args;
		var sMethodIndex = oJson.callback_index;
		var oData = oJson.data;
		var sConnectType = oJson.connect_type;
		var bStatus = oJson.status;
		if (sOrigin == "server") {
			if (sCMD == "ready") {
				CONN_READY = true;
				MB.start();
			} else {
				var data_cache = CONN_CACHE[sMethodIndex];
				if (data_cache && data_cache.callback) {
					var data = unescape(oData);
					try {
						data = STK.core.json.strToJson(data);
					}
					catch (e) {
					}
					data_cache.callback(data, (bStatus == "true" || bStatus == true));
				}
				if (sConnectType == "iframe") {
					if (data_cache && data_cache.ifm) {
						STK.core.dom.removeNode(data_cache.ifm);
					}
				}
			}
		} else {
			if (sOrigin == "client") {
				OAuthAJAX(sCMD, unescape(sArgs), function (sResult, bStatus) {
					var data = STK.core.json.clone(oJson);
					data.data = escape(sResult);
					data.args = escape(data.args);
					data.origin = "server";
					data.status = bStatus;
					data = STK.core.json.jsonToQuery(data);
					try {
						parent.postMessage(data, oJson.xddomain);
					}
					catch (e) {
					}
				});
			}
		}
	}
	function init(oOpts) {
		STK.core.obj.parseParam(CFG, oOpts);
		if (CFG.key == null) {
			throw "WB.client.init -> key is null";
		}
		if (CFG.xdpath == null) {
			throw "WB.client.init -> xdpath is null";
		}
		var parseURL = STK.core.str.parseURL(CFG.xdpath);
		CFG.xddomain = parseURL.scheme + ":" + parseURL.slash + parseURL.host;
		CONN_TYPE = window.postMessage ? "html5" : "iframe";
		switch (CONN_TYPE) {
		  case "html5":
			CONN_HTML5_IFM = createServerIFM("conn");
			STK.core.evt.addEvent(window, "message", function (evt) {
				var data = evt.data;
				parseData(data);
			});
			break;
		  case "flash":
			break;
		  case "iframe":
			parseData("origin=server&cmd=ready");
			break;
		}
	}
	var that = {};
	that.parseCMD = parseCMD;
	that.initServerProxy = initServerProxy;
	that.initClientProxy = initClientProxy;
	that.parseData = parseData;
	that.init = init;
	WB.regist("client", that);
})();


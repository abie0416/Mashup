/**
* Make a map like java.
* You can use this map like this :
* var myMap = new Map();
* myMap.put("key","value");
* var key = myMap.get("key");
*/
function Map() {

  this.elements = new Array();

  this.size = function() {
      return this.elements.length;
  }

  this.isEmpty = function() {
      return (this.elements.length < 1);
  }

  this.clear = function() {
      this.elements = new Array();
  }

  this.put = function(_key, _value) {
      if (!this.containsKey(_key)) {
        this.elements.push({key:_key, value:_value});
      } else {
        this.remove(_key);
        this.elements.push({key:_key, value:_value});
      }
  }

  this.remove = function(_key) {
      var bln = false;

      try {
          for (var i = 0; i < this.elements.length; i++) {
              if (this.elements[i].key == _key) {
                  this.elements.splice(i, 1);
                  return true;
              }
          }
      } catch(e) {
          bln = false;
      }
      return bln;
  }

  this.get = function(_key) {
      try{
          for (var i = 0; i < this.elements.length; i++) {
              if (this.elements[i].key == _key) {
                  return this.elements[i].value;
              }
          }
      }catch(e) {
          return null;
      }
  }

  this.element = function(_index) {
      if (_index < 0 || _index >= this.elements.length) {
          return null;
      }
      return this.elements[_index];
  }

  this.containsKey = function(_key) {
      var bln = false;
      try {
          for (var i = 0; i < this.elements.length; i++) {
              if (this.elements[i].key == _key) {
                  bln = true;
              }
          }
      }catch(e) {
          bln = false;
      }
      return bln;
  }

  this.containsValue = function(_value) {
      var bln = false;
      try {
          for (var i = 0; i < this.elements.length; i++) {
              if (this.elements[i].value == _value){
                  bln = true;
              }
          }
      } catch(e) {
          bln = false;
      }
      return bln;
  }

  this.values = function() {
      var arr = new Array();
      for (var i = 0; i < this.elements.length; i++) {
          arr.push(this.elements[i].value);
      }
      return arr;
  }

  this.keys = function() {
      var arr = new Array();
      for (var i = 0; i < this.elements.length; i++) {
          arr.push(this.elements[i].key);
      }
      return arr;
  }

  this.getKeysFromValue = function(_value) {
      var arr = new Array();
      for (var i = 0; i < this.elements.length; i++) {
          if (this.elements[i].value == _value) {
              arr.push(this.elements[i].key);
          }
      }
      return arr;
  }
}

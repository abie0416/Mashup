function MobileGps_getLocation(invokeId){
    this.url = "http://localhost:8080/webapi/compare";
    this.run = function(args){
        var a = args[0], b = args[1];
        var paras = "?a=" + a + "&b=" + b;
        (new util()).sendHttpRequest(this.url + paras, this);
    };
    this.waiting = function(){
        engine.pause();
    };
    this.handle = function(data){
        var results = new Array();
        results.push(new String(data));
        engine.insertResult(results);
        engine.resume();
    };
}

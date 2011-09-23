/*
author: Zhipeng Peng(pengzhipeng.zju@gmail.com)
create data: 2010/12/30

Functions without '_' are public functions, the others are private functions.

Interfaces:
1. Given username and password, update his status.
*/

Qt.include("Base64.js")
Qt.include("environment.js")

function SinaMicroBlogClass()
{
    this.serviceId = "SinaMicroBlog_updateStatus";
    this.apiKey = "2641644181";
    this.basicUrl = "http://api.t.sina.com.cn/";
    this.username="pzp@zju.edu.cn";
    this.pwd="123456";
}

SinaMicroBlogClass.prototype._make_base_auth = function(username, password) {
  var tok = username + ':' + password;
  var hash = Base64.encode(tok);
  return "Basic " + hash;
}

SinaMicroBlogClass.prototype.updateStatus = function(args)
{
  console.log("+++++SinaMicroBlogClass.updateStatus+++++");

  this.serviceId = args[0];
  var status = args[1];
    console.log("status:"+status);
    var url = this.basicUrl+"statuses/update.xml?source="+this.apiKey;

    var data = "status="+status;

    var auth = this._make_base_auth(this.username,this.pwd);

    var headers = [
        {Key: "Authorization", Value: auth},
        {Key: "CONTENT-TYPE", Value: "application/x-www-form-urlencoded"},
        {Key: "Content-Length", Value: data.length}
    ];

    //    console.log(url);
    environment.getRequest(this, url, headers, data);
}

/*
 * TODO...
 */
SinaMicroBlogClass.prototype.uploadStatus = function(status) // update a status with a picture.
{
    var url = this.basicUrl + "statuses/upload.xml?source=" + this.apiKey;

    var auth = this._make_base_auth(this.username,this.pwd);

    var data = "status="+status
                +"pic="+"@http://www.baidu.com/img/baidu_logo_jr_1228_yd_f4d31d40acb1b6f8b406e5ec161637e0.gif";

    var headers = [
        {Key: "Authorization", Value: auth},
        {Key: "CONTENT-TYPE", Value: "multipart/form-data"},
        {Key: "Content-Length", Value: data.length}
    ];

    environment.getRequest(url, null, headers, data);
}

SinaMicroBlogClass.prototype._handler = function()
{
    console.log("+++++SinaMicroBlogClass._handler+++++");
    engine.handler(this.serviceId, null);
}

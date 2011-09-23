Qt.include("environment.js")
// This block uses developer keys.  For security reasons it cannot be ripped and used in a mashup.

function FlickrClass() {
    this.DEFAULT_MAX_PHOTOS = 30;
    this.result = null; // For getGeotaggedPhotos, the result is photos.
    this.serviceId = "";
}

FlickrClass.prototype.getGeotaggedPhotos = function(args) {
    this.serviceId = args[0];
    var text = args[1];
    if(text == "") {
        text = "Zhejiang University";
    }
    var number = args[2];
    if(number == "") {
        number = 5;
    }
    console.log("search_text:"+text);
    console.log("number:"+number);
    var apikey = "ca4b0ae508ecf7e47f19adc2f2e9dbb3";
    var params = "&sort=" +  "interestingness-desc" + "&text=" + text;
    this._getFlickrPhotos("flickr.photos.search", number, params, apikey);
};

FlickrClass.prototype._getFlickrPhotos = function(method, number, extraParams, apikey)
{
    if(!number || isNaN(number))
        number = this.DEFAULT_MAX_PHOTOS;
    var params = "&extras=owner_name,geo,date_taken,original_format&per_page="+ number;
    this._getFlickrXml( method, params + extraParams, apikey);
};

FlickrClass.prototype._getFlickrXml = function(method, params, apikey)
{
    var url = "http://www.flickr.com/services/rest/?method=flickr.photos.search" + params +"&api_key=ca4b0ae508ecf7e47f19adc2f2e9dbb3";
    environment.getRequest(this, url);
};

/*
 * Notes: XMLHttpRequest in QML doesn't support synchronous,
 * so we have to use another function to handle result until we get result.
 */
FlickrClass.prototype._handler = function(xmlHttp)
{
    console.log("+++++Flickr._handler+++++");
    var root = xmlHttp.responseXML.documentElement;

    var rsp = root;

    var result = rsp.attributes["stat"].value;
    if(result != "ok")
    {
        var errMsg = "flickr returned an unknown error";
        var errNodes = rsp.getElementsByTagName("err");
        if(errNodes)
        {
            errMsg = errNodes[0].attributes["msg"].value;
            // ignore file not found errors
            if(errNodes[0].attributes["code"].value!="1")
                throw errMsg;
        }
    }

    this.result = this._getPhotoArrayFromXml(root);
//    engine.handler(this.serviceId, this.result); // used when it's not testing.

    /* for test.*/
    if(executingItemIndex == 0) {
        engine.handler(this.serviceId, this.result);
    } else {
        handleFlickr();
    }
};


FlickrClass.prototype._getPhotoArrayFromXml = function(root)
{
    var photoArray = new Array();

    var photos = root.childNodes[1].childNodes;
    var count = (root.childNodes[1].childNodes.length-1)/2;
//    console.log(count);
    for(var i = 0; i < count; i++)
    {
        var photo = photos[2*i+1];
//        console.log(photo.nodeName);
//        console.log(photo.attributes.length);
        var id = photo.attributes["id"].value;
        var ownerName = photo.attributes["ownername"].value;
        var owner = photo.attributes["owner"].value;
        var title = photo.attributes["title"].value;
        var farm = photo.attributes["farm"].value;
        var server = photo.attributes["server"].value;
        var secret = photo.attributes["secret"].value;
//        var originalSecret = photo.attributes["original_secret"].value;
//        var originalFormat = photo.attributes["original_format"].value;
        var lat = photo.attributes["latitude"].value;
        var lon = photo.attributes["longitude"].value;
        if(photo.attributes["accuracy"].value == 0 && lat == 0 && lon == 0)
        {
            // return null for photos with no geodata so they get skipped by mapping blocks
            lat = null;
            lon = null;
        }
        var url = "http://farm" + farm + ".static.flickr.com/" + server + "/" + id + "_" + secret +"_s.jpg";
       // var url = String.format("http://farm{0}.static.flickr.com/{1}/{2}_{3}_s.jpg", farm, server, id, secret);
        var mediumUrl = "http://farm" + farm + ".static.flickr.com/" + server + "/" + id + "_" + secret +".jpg";
       // var mediumUrl = String.format("http://farm{0}.static.flickr.com/{1}/{2}_{3}.jpg", farm, server, id, secret);
        var originalUrl;
//        if(originalSecret && originalFormat)
//                originalUrl = "http://farm" + farm + ".static.flickr.com/" + server + "/" + id + "_" + originalSecret +"." + originalFormat;
//           // originalUrl = String.format("http://farm{0}.static.flickr.com/{1}/{2}_{3}.{4}", farm, server, id, originalSecret, originalFormat);
//        else
//            originalUrl = mediumUrl;
        var linkUrl = "http://www.flickr.com/photos/" + (owner || ownerName) + "/" + id;
      //  var linkUrl = String.format("http://www.flickr.com/photos/{0}/{1}", owner || ownerName, id);
        var dateTaken = photo.attributes["datetaken"].value;
        photoArray.push(new FlickrClass.Photo(id, ownerName, title, url, mediumUrl, originalUrl, linkUrl, lon, lat, dateTaken));
    }

    return photoArray;
};

FlickrClass.Photo = function(id, ownerName, title, url, mediumUrl, originalUrl, linkUrl, lon, lat, dateTaken)
{
    this.id = id;
    this.owner = ownerName;
    this.title = title;
    this.url = mediumUrl;
    this.thumbnailUrl = url;
    this.originalUrl = originalUrl;
    this.linkUrl = linkUrl;
    this.longitude = lon;
    this.latitude = lat;
    this.dateTaken = dateTaken;

    this.toString = function()
    {
        return "<a href='" + environment.escapeQuotes( this.linkUrl ) + "' target='_blank'><img style='width:75px;height:75px' src='" +
            environment.escapeQuotes( this.thumbnailUrl ) + "' title='" +
            environment.escapeQuotes( this.title ) + ", ID: " + environment.escapeQuotes( this.id ) + "'/></a>";
    };
};

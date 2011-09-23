// created on 2011.05.09 by Aaron Peng(phang.aaron@gmail.com).
// all result will be formatted into example of "results[i]: Object(lat, lon)".
Qt.include("environment.js")
Qt.include("Base64.js")

/**
 * All services:
 * 1. MobileGps_getLocation
 * 2. MobileNetwork_getCellId
 * 3. MobileMusic_playMusic
 * 4. GoogleStaticMap_addMarkers
 * 5. Flickr_getPhotos
 * 6. Google_getGeoLocation
 * 7. Dianping_getShopInfo
 * 8. LyricWiki_getLyric
 * 9. Lastfm_getArtistInfo
 * 10.SinaMicroBlog_updateStatus
 * 11.SinaMicroBlog_uploadStatus(Unfinished...)
 * 12.Lastfm_getEvents
 * 13.LyricNokia_getLyric
 * 14.Bandsintown_getLocationEvents
 * 15.Bandsintown_getArtistEvents
 */

/***********Mobile APIs***************/
//
// Objects from C++: myNetworkInfo(cellId), camera(camera).
//

function MobileGps_getLocation(invokeId) {
    this.url = null;
    this.run = function(args) {
        myConsole.log += "MobileGps_getLocation"+"\n";
        this.handle(null);
    };
    this.handle = function(xmlHttp) {
        var results = new Array();
        var location = new Object();
//        location.Latitude = gps.lat;
//        location.Longitude = gps.lon;
        location.Latitude = 39.917;
        location.Longitude = 116.392;
        console.log(location.Latitude);
        results.push(location);
        engine.insertResult(results);
        engine.resume();
    }
}

function MobileNetwork_getCellId(invokeId) {
    this.run = function(args) {
        myConsole.log += "Mobile_getCellId"+"\n";
        this.handle(null);
    };
    this.handle = function(xmlHttp) {
        var results = new Array();
        var location = new Object();
        location.cellId = myNetworkInfo.getCellId();
        myConsole.log += "cellId="+location.cellId+"\n";
        results.push(location);
        engine.insertResult(results);
        engine.resume();
    }
}

function MobileMusic_playMusic(invokeId) {
    this.run = function(args) {
        myConsole.log += "MobileMusic_playMusic"+"\n";
        mainWindow.showPlayerSignal(); // emit signals to show music player.
    };
    this.handle = function(xmlHttp) {

    }
}
/************************************/

/*
 * service: GoogleStaticMap_addMarkers with a array of pushpin data{lat, lon}.
 * example of url: http://maps.google.com/maps/api/staticmap?size=512x512&maptype=roadmap
 * &markers=color:blue|40.702147,-74.015794|40.711614,-74.012318&sensor=false
 */
function GoogleStaticMap_addMarkers(invokeId) {
    this.url = "http://maps.google.com/maps/api/staticmap?size=360x480&maptype=roadmap&sensor=false";

    this.run = function(args) {
        var markers = "&markers=color:blue";
//        for(var i=0; i<args.length; i++) {
            var markerData = args;
            var lat = markerData.lat;
            var lon = markerData.lon;
            markers += "|"+lat+","+lon;
//        }
        var paras = markers;
        console.log(paras);
        this.url += paras;
        this.handle(null);
    };

    this.handle = function(xmlHttp) {
        var results = new Array();
        var map = new Object();
        map.url = this.url;
        results.push(map);
        engine.insertResult(results);
        engine.resume();
    };
}

/*
 * service: Flickr.getPhotos
 * example of url: http://www.flickr.com/services/rest/?method=flickr.photos.search
 * &api_key=ca4b0ae508ecf7e47f19adc2f2e9dbb3&sort=interestingness-desc&text=flower
 * &per_page=5&lat=39.917&lon=116.392&radius=20
 */
function Flickr_getPhotos(invokeId) {
    this.url = "http://www.flickr.com/services/rest/?method=flickr.photos.search"+
         "&api_key=ca4b0ae508ecf7e47f19adc2f2e9dbb3"+
         "&sort=interestingness-desc";

    this.run = function(args) {
        var text = args.search_text, per_page = args.number, lat=args.lat, lon=args.lon, radius=args.radius;
        var paras = "&text=" + text + "&per_page=" + per_page + "&lat=" + lat + "&lon=" + lon + "&radius=" + radius;
        console.log(paras);
        environment.getRequest(this, this.url+paras);
    };

    this.handle = function(xmlHttp) {
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
                if(errNodes[0].attributes["code"].value!="1")
                    throw errMsg;
            }
        }
        var results = this._getPhotoArrayFromXml(root);
        engine.insertResult(results);
        engine.resume();
    };

    this._getPhotoArrayFromXml = function(root) {
        var photoArray = new Array();
        var photos = root.childNodes[1].childNodes;
        var count = (root.childNodes[1].childNodes.length-1)/2;
        for(var i = 0; i < count; i++)
        {
            var photo = photos[2*i+1];
            var id = photo.attributes["id"].value;
            var owner = photo.attributes["owner"].value;
            var title = photo.attributes["title"].value;
            var farm = photo.attributes["farm"].value;
            var server = photo.attributes["server"].value;
            var secret = photo.attributes["secret"].value;
            var url = "http://farm" + farm + ".static.flickr.com/" + server + "/" + id + "_" + secret +"_s.jpg";
            var mediumUrl = "http://farm" + farm + ".static.flickr.com/" + server + "/" + id + "_" + secret +".jpg";
            photoArray.push(new _photo(id, title, url, mediumUrl));
        }

        return photoArray;
    };

    function _photo(id, title, url, mediumUrl)
    {
        this.id = id;
        this.title = title;
        this.url = mediumUrl;
        this.thumbnailUrl = url;
    };
}

/*
 * service: Google_getGeoLocation with cellid.
 * example of url: http://114.255.191.5/ServiceProxy/NokiaGeocoder.php?mcc=460&mnc=0&lac=4391&cid=20914
 */
function Google_getGeoLocation(invokeId) {
    this.url = "http://114.255.191.5/ServiceProxy/NokiaGeocoder.php?mcc=460&mnc=0&lac=4391";

    this.run = function(args) {
        var cid = args.cid;
        var paras = "&cid=" + cid;
        myConsole.log = "paras="+paras;
        console.log(paras);
        environment.getRequest(this, this.url+paras);
    };

    this.handle = function(xmlHttp) {
        var root = xmlHttp.responseXML.documentElement;
        var results = this._getLocation(root);
        engine.insertResult(results);
        engine.resume();
    };

    this._getLocation = function(locationXML) {
        var locationArray = new Array();
        var lat = locationXML.childNodes[0].childNodes[0].nodeValue;
        var lon = locationXML.childNodes[1].childNodes[0].nodeValue;
        var radius = locationXML.childNodes[2].childNodes[0].nodeValue;
        myConsole.log += ":::"+lat+":"+lon+":"+radius;
        console.log(":::"+lat+":"+lon+":"+radius);
        locationArray.push(new _loc(lat, lon, radius));

        return locationArray;
    };

    function _loc(lat, lon, radius)
    {
        this.latitude = lat;
        this.longitude = lon;
        this.radius = radius;
    };
}

/*
 * service: Dianping_getShopInfo with latitude & longitude & range.
 * example of url: http://114.255.191.5/ServiceProxy/dianping.php?lat=39.794527&lng=116.515578&rang=500
 */
function Dianping_getShopInfo(invokeId) {
    this.url = "http://114.255.191.5/ServiceProxy/dianping.php?";
    this.lat = null;
    this.lng = null;
    this.rang = null;

    this.run = function(args) {
        this.lat = args.lat;
        this.lng = args.lon;
        this.rang = args.rang;
        var paras = "lat="+this.lat+"&lng="+this.lng+"&rang="+this.rang;
        console.log(paras);
        environment.getRequest(this, this.url+paras);
    };

    this.handle = function(xmlHttp) {
        var root = xmlHttp.responseXML.documentElement;
        var results = this._getShopInfo(root);
        engine.insertResult(results);
        engine.resume();
    };

    this._getShopInfo = function(root) {
        var shopInfoArray = new Array();
        for(var i=0; i<root.childNodes.length; i++) {
            var name = root.childNodes[i].childNodes[0].childNodes[0].nodeValue;
            var price = root.childNodes[i].childNodes[1].childNodes[0].nodeValue;
            var tag = root.childNodes[i].childNodes[2].childNodes[0].nodeValue;
            console.log(name+":"+price+":"+tag);
            shopInfoArray.push(new _shopInfo(this.lat, this.lng, this.rang, name, price, tag));
        }

        return shopInfoArray;
    };

    function _shopInfo(lat, lon, radius, name, price, tag)
    {
        this.latitude = lat;
        this.longitude = lon;
        this.radius = radius;
        this.name = name;
        this.price = price;
        this.tag = tag;
    };
}

/*
 * service: LyricWiki_getLyric with args of artist & song.
 * example of url: http://lyricwiki.org/api.php?func=getSong&artist=Tool&song=Schism&fmt=xml
 */
function LyricWiki_getLyric(invokeId) {
    this.url = "http://lyricwiki.org/api.php?func=getSong&fmt=xml";

    this.run = function(args) {
        var artist = args.artist;
        var song = args.song;
        var paras = "&artist="+artist+"&song="+song;
        console.log(paras);
        environment.getRequest(this, this.url+paras);
    };

    this.handle = function(xmlHttp) {
        var root = xmlHttp.responseXML.documentElement;
        var results = this._getLyricInfo(root);
        engine.insertResult(results);
        engine.resume();
    };

    this._getLyricInfo = function(root) {
        var lyricInfoArray = new Array();
        var artist = root.childNodes[1].childNodes[0].nodeValue;
        var song = root.childNodes[3].childNodes[0].nodeValue;
        var lyrics = root.childNodes[5].childNodes[0].nodeValue;
        var url = root.childNodes[7].childNodes[0].nodeValue;
        console.log(artist+":"+song+":"+lyrics+":"+url);
        lyricInfoArray.push(new _lyricInfo(artist, song, lyrics, url));

        return lyricInfoArray;
    };

    function _lyricInfo(artist, song, lyrics, url)
    {
        this.artistO = artist;
        this.songO = song;
        this.lyrics = lyrics;
        this.url = url;
    };
}

/*
 * service: LyricNokia_getLyric with args of artist & song.
 * example of url: http://114.255.191.5/ServiceProxy/musixmatch.php?artist=Brad%20Paisley&track=Mud%20on%20the%20tires
 */
function LyricNokia_getLyric(invokeId) {
    this.url = "http://114.255.191.5/ServiceProxy/musixmatch.php?";

    this.run = function(args) {
        var artist = args.artist;
        var track = args.track;
        var paras = "artist="+artist+"&track="+track;
        console.log(paras);
        environment.getRequest(this, this.url+paras);
    };

    this.handle = function(xmlHttp) {
        var root = xmlHttp.responseXML.documentElement;
        var results = this._getLyricInfo(root);
        engine.insertResult(results);
        engine.resume();
    };

    this._getLyricInfo = function(root) {
        var lyricInfoArray = new Array();
        var artistO, album, trackO, lyrics;
        for(var i=0; i<root.childNodes.length; i++) {
            var child = root.childNodes[i];
            switch(child.nodeName) {
            case "artist":
                artistO = child.firstChild.nodeValue;
                break;
            case "album":
                album = child.firstChild.nodeValue;
                break;
            case "track":
                trackO = child.firstChild.nodeValue;
                break;
            case "lyrics_body":
                lyrics = child.firstChild.nodeValue;
                break;
            }
        }
        console.log(artistO+":"+album+":"+lyrics+":"+trackO);
        lyricInfoArray.push(new _lyricInfo(artistO, album, lyrics, trackO));

        return lyricInfoArray;
    };

    function _lyricInfo(artistO, album, lyrics, trackO)
    {
        this.artistO = artistO;
        this.album = album;
        this.lyrics = lyrics;
        this.trackO = trackO;
    };
}

/*
 * service: Bandsintown_getLocationEvents with args of location & radius.
 * example of url: http://api.bandsintown.com/events/search?location=hangzhou&radius=100&format=xml&app_id=YOUR_APP_ID
 */
function Bandsintown_getLocationEvents(invokeId) {
    this.url = "http://api.bandsintown.com/events/search?format=xml&app_id=YOUR_APP_ID";

    this.run = function(args) {
        var location = args.location;
        var radius = args.radius;
        var paras = "&location="+location+"&radius="+radius;
        console.log(paras);
        environment.getRequest(this, this.url+paras);
    };

    this.handle = function(xmlHttp) {
        var root = xmlHttp.responseXML.documentElement;
        var results = this._getEventsInfo(root);
        engine.insertResult(results);
        engine.resume();
    };

    this._getEventsInfo = function(root) {
        var eventInfoArray = new Array();
        for(var i=0; i<root.childNodes.length; i++) {
            if(root.childNodes[i].nodeName == "event") {
                var eventXml = root.childNodes[i];
                var url="", dateTime="", ticketUrl="", artists="", venue="", latitude="", longitude="", city="";
                for(var j=0; j<eventXml.childNodes.length; j++) {
                    var eventAttr = eventXml.childNodes[j];
                    switch(eventAttr.nodeName) {
                    case "url":
                        url = eventAttr.firstChild.nodeValue;
                        break;
                    case "datetime":
                        dateTime = eventAttr.firstChild.nodeValue;
                        break;
                    case "ticket_url":
                        ticketUrl = eventAttr.firstChild.nodeValue;
                        break;
                    case "artists":
                        for(var k=0; k<eventAttr.childNodes.length; k++) {
                            if(eventAttr.childNodes[k].nodeName == "artist") {
                                var artistXml = eventAttr.childNodes[k];
                                for(var l=0; l<artistXml.childNodes.length; l++) {
                                    if(artistXml.childNodes[l].nodeName == "name") {
                                        artists += artistXml.childNodes[l].firstChild.nodeValue+";";
                                    }
                                }
                            }
                        }
                        break;
                    case "venue":
                        for(var k=0; k<eventAttr.childNodes.length; k++) {
                            var venueAttr = eventAttr.childNodes[k];
                            switch(venueAttr.nodeName) {
                            case "name":
                                venue = venueAttr.firstChild.nodeValue;
                                break;
                            case "city":
                                city = venueAttr.firstChild.nodeValue;
                                break;
                            case "latitude":
                                latitude = venueAttr.firstChild.nodeValue;
                                break;
                            case "longitude":
                                longitude = venueAttr.firstChild.nodeValue;
                                break;
                            }
                        }
                    }
                }
                eventInfoArray.push(new _eventInfo(url, dateTime, ticketUrl, artists, venue, city, latitude, longitude));
            }
        }
        console.log(url+":"+ dateTime+":"+ ticketUrl+":"+ artists+":"+ venue+":"+ city+":"+ latitude+":"+ longitude);

        return eventInfoArray;
    };

    function _eventInfo(url, dateTime, ticketUrl, artists, venue, city, latitude, longitude)
    {
        this.url = url;
        this.dateTime = dateTime;
        this.ticketUrl = ticketUrl;
        this.artists = artists;
        this.venue = venue;
        this.city = city;
        this.latitude = latitude;
        this.longitude = longitude;
    };
}

/*
 * service: Bandsintown_getArtistEvents with args of location & radius.
 * example of url: http://api.bandsintown.com/artists/Syrano/events?format=xml&app_id=YOUR_APP_ID
 */
function Bandsintown_getArtistEvents(invokeId) {
    this.urlPrefix = "http://api.bandsintown.com/artists/";
    this.urlPostfix = "/events?format=xml&app_id=YOUR_APP_ID";

    this.run = function(args) {
        var artist = args.artist;
        console.log(artist);
        environment.getRequest(this, this.urlPrefix+artist+this.urlPostfix);
    };

    this.handle = function(xmlHttp) {
        var root = xmlHttp.responseXML.documentElement;
        var results = this._getEventsInfo(root);
        engine.insertResult(results);
        engine.resume();
    };

    this._getEventsInfo = function(root) {
        var eventInfoArray = new Array();
        for(var i=0; i<root.childNodes.length; i++) {
            if(root.childNodes[i].nodeName == "event") {
                var eventXml = root.childNodes[i];
                var url="", dateTime="", ticketUrl="", venue="", latitude="", longitude="", city="";
                for(var j=0; j<eventXml.childNodes.length; j++) {
                    var eventAttr = eventXml.childNodes[j];
                    switch(eventAttr.nodeName) {
                    case "url":
                        url = eventAttr.firstChild.nodeValue;
                        break;
                    case "datetime":
                        dateTime = eventAttr.firstChild.nodeValue;
                        break;
                    case "ticket_url":
                        ticketUrl = eventAttr.firstChild.nodeValue;
                        break;
                    case "venue":
                        for(var k=0; k<eventAttr.childNodes.length; k++) {
                            var venueAttr = eventAttr.childNodes[k];
                            switch(venueAttr.nodeName) {
                            case "name":
                                venue = venueAttr.firstChild.nodeValue;
                                break;
                            case "city":
                                city = venueAttr.firstChild.nodeValue;
                                break;
                            case "latitude":
                                latitude = venueAttr.firstChild.nodeValue;
                                break;
                            case "longitude":
                                longitude = venueAttr.firstChild.nodeValue;
                                break;
                            }
                        }
                    }
                }
                eventInfoArray.push(new _eventInfo(url, dateTime, ticketUrl, venue, city, latitude, longitude));
            }
        }
        console.log(url+":"+ dateTime+":"+ ticketUrl+":"+ venue+":"+ city+":"+ latitude+":"+ longitude);

        return eventInfoArray;
    };

    function _eventInfo(url, dateTime, ticketUrl, venue, city, latitude, longitude)
    {
        this.url = url;
        this.dateTime = dateTime;
        this.ticketUrl = ticketUrl;
        this.venue = venue;
        this.city = city;
        this.latitude = latitude;
        this.longitude = longitude;
    };
}

/*
 * service: Lastfm_getArtistInfo with args of artist.
 * example of url: http://ws.audioscrobbler.com/2.0/?method=artist.getinfo&artist=Cher&api_key=b25b959554ed76058ac220b7b2e0a026
 */
function Lastfm_getArtistInfo(invokeId) {
    this.url = "http://ws.audioscrobbler.com/2.0/?method=artist.getinfo&api_key=b25b959554ed76058ac220b7b2e0a026";

    this.run = function(args) {
        var artist = args.artist;
        var paras = "&artist="+artist;
        environment.getRequest(this, this.url+paras);
    };

    this.handle = function(xmlHttp) {
        var root = xmlHttp.responseXML.documentElement;
        console.log(root.childNodes[1].tagName);
        var results = this._getArtistInfo(root.childNodes[1]);
        engine.insertResult(results);
        engine.resume();
    };

    this._getArtistInfo = function(artistXml) {
        var artistInfoArray = new Array();
        var name = artistXml.childNodes[1].childNodes[0].nodeValue;
        var url = artistXml.childNodes[5].childNodes[0].nodeValue;
        var smallImage = artistXml.childNodes[7].childNodes[0].nodeValue;
        var largeImage = artistXml.childNodes[11].childNodes[0].nodeValue;
        var megaImage = artistXml.childNodes[15].childNodes[0].nodeValue;
        console.log(name+":"+url+":"+smallImage+":"+largeImage+":"+megaImage);
        artistInfoArray.push(new _artistInfo(name, url, smallImage, largeImage, megaImage));

        return artistInfoArray;
    };

    function _artistInfo(name, url, smallImage, largeImage, megaImage)
    {
        this.name = name;
        this.url = url;
        this.smallImage = smallImage;
        this.largeImage = largeImage;
        this.megaImage = megaImage;
    };
}

/*
 * service: Lastfm_getEvents with args of artist.
 * output parameters: city, latitude, longitude, startDate, url
 * example of url: http://ws.audioscrobbler.com/2.0/?method=artist.getevents&artist=Jay&api_key=b25b959554ed76058ac220b7b2e0a026
 */
function Lastfm_getEvents(invokeId) {
    this.url = "http://ws.audioscrobbler.com/2.0/?method=artist.getevents&api_key=b25b959554ed76058ac220b7b2e0a026";

    this.run = function(args) {
        var artist = args.artist;
        var paras = "&artist="+artist;
        environment.getRequest(this, this.url+paras);
    };

    this.handle = function(xmlHttp) {
        var root = xmlHttp.responseXML.documentElement;
        console.log(root.childNodes[1].tagName);
        var results = this._getArtistEvents(root.childNodes[1]);
        engine.insertResult(results);
        engine.resume();
    };

    this._getArtistEvents = function(eventsXml) {
        var eventsArray = new Array();
        for(var i=0; i<eventsXml.childNodes.length; i++) {
            if(eventsXml.childNodes[i].nodeName == "event") {
                var eventXml = eventsXml.childNodes[i]; // get "event" node.
                var city;
                var latitude = 0;
                var longitude = 0;
                var startDate;
                var url;
                for(var j=0; j<eventXml.childNodes.length; j++) {
                    var node = eventXml.childNodes[j];
                    switch(node.nodeName) {
                    case "venue":
                        var locationXml = node.childNodes[5]; // tag "location"
                        city = locationXml.childNodes[1].firstChild.nodeValue;
                        if(locationXml.childNodes[9].childNodes[1].childNodes.length >0) {
                            latitude = locationXml.childNodes[9].childNodes[1].firstChild.nodeValue;
                        }
                        if(locationXml.childNodes[9].childNodes[3].childNodes.length >0) {
                            longitude = locationXml.childNodes[9].childNodes[3].firstChild.nodeValue;
                        }
                        break;
                    case "startDate":
                        startDate = node.firstChild.nodeValue;
                        break;
                    case "url":
                        url = node.firstChild.nodeValue;
                        break;
                    }
                }
                console.log(city+";"+latitude+";"+longitude+";"+startDate+";"+url);
                eventsArray.push(new _eventInfo(city, latitude, longitude, startDate, url));
            }
        }

        return eventsArray;
    };

    function _eventInfo(city, latitude, longitude, startDate, url)
    {
        this.latitude = latitude;
        this.url = url;
        this.longitude = longitude;
        this.city = city;
        this.startDate = startDate;
    };
}

/*
 * service: SinaWeibo.updateStatus
 */
function SinaMicroBlog_updateStatus(invokeId) {
    this.url = "http://api.t.sina.com.cn/statuses/update.xml?source=2641644181";
    this.username="pzp@zju.edu.cn";
    this.pwd="123456";
    this.run = function(args){
        var status = args.Status;
        var data = "status="+status;
        var auth = this._make_base_auth(this.username,this.pwd);
        var headers = [
          {Key: "Authorization", Value: auth},
          {Key: "CONTENT-TYPE", Value: "application/x-www-form-urlencoded"},
          {Key: "Content-Length", Value: data.length}
        ];
        environment.getRequest(this, this.url, headers, data);
    };
    this.handle = function(xmlHttp) {
        var results = new Array();
        engine.insertResult(results);
        engine.resume();
    };
    this._make_base_auth = function(username, password) {
        var tok = username + ':' + password;
        var hash = Base64.encode(tok);
        return "Basic " + hash;
    };
}

/*
 * service: SinaWeibo.uploadStatus
 * upload a picture to SinaWeibo
 * TODO:unfinished.
 */
function SinaMicroBlog_uploadStatus(invokeId) {
    this.url = "http://api.t.sina.com.cn/statuses/upload.xml?source=2641644181";
    this.username="pzp@zju.edu.cn";
    this.pwd="123456";
    this.run = function(){
        var status = "hello";
        var data = "status="+status;
        var auth = this._make_base_auth(this.username,this.pwd);
        var headers = [
          {Key: "Authorization", Value: auth},
          {Key: "CONTENT-TYPE", Value: "application/x-www-form-urlencoded"},
          {Key: "Content-Length", Value: data.length}
        ];
        console.log(data);
        //environment.getRequest(this, this.url, headers, data);
    };
    this.handle = function(xmlHttp) {
        var results = new Array();
        engine.insertResult(results);
        engine.resume();
    };
    this._make_base_auth = function(username, password) {
        var tok = username + ':' + password;
        var hash = Base64.encode(tok);
        return "Basic " + hash;
    };
}

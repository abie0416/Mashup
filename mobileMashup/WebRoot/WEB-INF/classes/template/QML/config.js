Qt.include("model.js")

//description of home screen.
var config_items = [
    {
        name: "Flickr-SinaMicroBlog",
        shortDesc: "Micro blog with images",
        longDesc: "Search images from flickr and send the result to Sina Micro-blog.",
        userinputCtrls:[
            {
                text: "search text",
                type: "LABEL"
            },
            {
                text: "",
                type: "TEXTAREA",
            },
           {
                text: "number",
                type: "LABEL"
            },
            {
                text: "",
                type: "TEXTAREA",
            }
        ]
    },
    {
        name: "Location",
       shortDesc: "Publish Location",
        longDesc: "Get GPS location and publish it to Sina Weibo",
        userinputCtrls:[

        ]
   },
    {
        name: "Flickr",
        shortDesc: "Flickr picture",
        longDesc: "Get pictures from flickr.",
        userinputCtrls:[
            {
                text: "search text",
               type: "LABEL"
            },
            {
                text: "",
               type: "TEXTAREA",
            },
            {
               text: "number",
                type: "LABEL"
            },
            {
                text: "",
                type: "TEXTAREA",
            }
        ]
    },
    {
        name: "Sina Micro-Blog",
        shortDesc: "Update microblog status.",
        longDesc: "Update a status to Sina Microblog.",
        userinputCtrls:[
            {
                text: "Please input status:",
                type: "LABEL"
            },
            {
                text: "",
                type: "TEXTAREA",
            }
        ]
    }
];
var mashup = {
	id: 'mashup',
	context : null,
	process: null,
	push: addActivity,
	init: function() {
	this.context = {
		_temp: {type: null, value: null}
	};		var Invoke1 = new Invoke('invoke2', 'MobileGps', 'getLocation', [], [], ['string','string'], ['Longitude','Latitude']);
		mashup.push(Invoke1);

		var GetTerminalInput2 = new GetTerminalInput('keywords', 'keywords', 'string', 'text', 'sky');
		mashup.push(GetTerminalInput2);

		var GetTerminalInput3 = new GetTerminalInput('radius', 'radius', 'int', 'text', '20');
		mashup.push(GetTerminalInput3);

		var GetTerminalInput4 = new GetTerminalInput('number', 'number', 'int', 'text', '3');
		mashup.push(GetTerminalInput4);

		var Invoke5 = new Invoke('invoke3', 'Flickr', 'getPhotos', ['string','string','string','string','string'], [['radius','${radius}'],['search_text','${keywords}'],['number','${number}'],['lat','${invoke2.Latitude}'],['lon','${invoke2.Longitude}']], ['string','string','string','string'], ['longitude','title','thumbnailUrl','latitude']);
		mashup.push(Invoke5);

		var Invoke6 = new Invoke('invoke4', 'SinaMicroBlog', 'updateStatus', ['string'], [['Status','${invoke3.thumbnailUrl}']], [], []);
		mashup.push(Invoke6);

	}
};
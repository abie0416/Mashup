Qt.include("model.js")

// description of home screen.
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

// description of a mashup item.
var mashup = {
        id: 'mashup',
        context : null,
        process: null,
        push: addActivity,
        init: function() {
                this.context = {
                     _temp: {type: null, value: null},
                     continue1 : {type:'boolean', value: true}
                };
                var While1 = new While('While1', '${continue1}==true');
                mashup.push(While1);

                var Invoke2 = new Invoke('invoke1', 'MobileGps', 'getLocation', [], [], ['string','string'], ['Latitude','Longitude']);
                While1.push(Invoke2);

                var GetTerminalInput3 = new GetTerminalInput('radius', 'Radius', 'real', 'text', '5');
                While1.push(GetTerminalInput3);

                var GetTerminalInput4 = new GetTerminalInput('search_text', 'Keywords', 'string', 'text', 'flower');
                While1.push(GetTerminalInput4);

                var GetTerminalInput5 = new GetTerminalInput('number', 'Number', 'real', 'text', '5');
                While1.push(GetTerminalInput5);

                var Invoke6 = new Invoke('invoke2', 'Flickr', 'getPhotos', ['string','real','real','real','real'], ['${search_text}','${number}','${invoke1.Latitude}','${invoke1.Longitude}','${radius}'], ['string','string','string','string'], ['thumbnailUrl','title','longitude','latitude']);
                While1.push(Invoke6);

                var GetTerminalInput7 = new GetTerminalInput('status', 'status', 'string', 'text', 'Smile~');
                While1.push(GetTerminalInput7);

                var GetTerminalInput8 = new GetTerminalInput('selectedSinaWeibo', 'SinaWeibo', 'boolean', 'checkbox', 'true');
                While1.push(GetTerminalInput8);

                var IfBlock9 = new IfBlock('IfBlock9');
                While1.push(IfBlock9);

                var If10 = new If('If10', '${selectedSinaWeibo}==true');
                IfBlock9.push(If10);

                var Invoke11 = new Invoke('invoke3', 'SinaMicroBlog', 'updateStatus', ['string'], ['${invoke2.thumbnailUrl}'], [], []);
                If10.push(Invoke11);

                var GetTerminalInput12 = new GetTerminalInput('continueOrNot', 'continue?', 'boolean', 'checkbox', 'true');
                While1.push(GetTerminalInput12);

                var Assign13 = new Assign('continue1', '${continueOrNot}');
                While1.push(Assign13);

        }
};

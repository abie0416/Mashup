
var environment = {

    getRequest : function(src, url, headers, data)
    {
        console.log("+++++environment.getRequest+++++");
        var xmlHttp = new XMLHttpRequest();
        xmlHttp.onreadystatechange = function() {
            myConsole.log += "xmlHttp.readyState:"+xmlHttp.readyState+"\n\n";
            if (xmlHttp.readyState == XMLHttpRequest.DONE) {
                myConsole.log += "xmlHttp.status:"+xmlHttp.status+"\n\n";
                if(xmlHttp.status == "200") {
                    console.log(xmlHttp.responseText);
                    console.log("     -----Result returned.");
                    myConsole.log += "-----Result returned:\n"+xmlHttp.responseText+"\n\n"; // show log on console screen.
                    src.handle(xmlHttp);
                }
                else {
                    throw "Unable to get data from '" + url + "': Error code " + xmlHttp.status;
                }
            }
        }

        if(data && data.length > 0)
        {
            xmlHttp.open('POST', url);
        }
        else
        {
            xmlHttp.open('GET', url);
        }

        if(headers && headers.length > 0)
        {
            for(var i = 0; i < headers.length; i++)
            {
                if(headers[i] && headers[i].Key && headers[i].Value)
                {
                    xmlHttp.setRequestHeader(headers[i].Key, headers[i].Value);
                }
            }
        }

        if(data && data.length > 0)
        {
            xmlHttp.send(data);
        }
        else
        {
            xmlHttp.send(null);
        }
    },
    escapeQuotes : function(str)
    {
            if(str == null || str == "" || str == "undefined")
                    return str;
            var s = '\"';
            return str.replace(/"/g, s);
    }
}

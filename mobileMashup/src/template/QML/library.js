Qt.include("js/generateCtrls.js")
Qt.include("js/events.js")
Qt.include("Flickr.js")
Qt.include("SinaMicroBlog.js")
Qt.include("resultPageConfig.js")

var executingItemIndex = 0; // indicate which mashup is executing.
var itemCount = 0;
var itemsArray = new Array();
var userinputArray = new Array(); // store userinput controllers.
var userinputDataArray = new Array(); // store userinput controls which have data.
var userinputValues = new Array();
var _resultItemsArray = new Array();

/*
 * : public
 * generate mashup items with data offered.
 */
function generateItems(items)
{
    for(var itemIndex in items){
        var newItem = Qt.createComponent("Myitem.qml");
        console.log(itemIndex);
        console.log(items[itemIndex].name);
        if(newItem.status == Component.Ready)
            _createItem(newItem, items[itemIndex]);
        else
            newItem.statusChanged.conncet(_createItem);
    }
}

/*
 * : public
 * generate userinput controls.
 */
function generateUserinputCtrls(selectedItem)
{
    console.log("+++++library.generateUserinputCtrls+++++");

    clearUserinputArray();

    var userinputCtrls = selectedItem.userinputCtrls;
    for(var ctrlIndex in userinputCtrls) {
        var ctrl = userinputCtrls[ctrlIndex];
        switch(ctrl.type){
        case "TEXTAREA":
                userinputArray.push(generateTextArea(ctrl.text, ctrls));
            break;
        case "CHECKBOX":
                userinputArray.push(generateCheckbox(ctrl.text, ctrls));
            break;
        case "BUTTON":
                userinputArray.push(generateButton(ctrl.text, ctrls));
            break;
        case "LABEL":
                userinputArray.push( generateLabel(ctrl.text, ctrls));
            break;
        }
    }
    var eb = generateMashupExectionButton(ctrls);
//    eb.clicked.connect(runEngine); // used when it's not testing.

    /* for test.*/
    if(executingItemIndex == 0) {
        eb.clicked.connect(runEngine);
    }
    else {
        eb.clicked.connect(executeMashup);
    }

    userinputArray.push(eb);
}

/*
 * : public
 * show the result in mashup result screen.
 */
function showMashupScreen()
{
     mainWindow.state = "State2";
}

/*
 * delete the previous controls on userinput control screen.
 */
function clearUserinputArray()
{
    for(var i in userinputArray) {
        userinputArray[i].destroy();
    }
    while(userinputArray.length != 0) {
        userinputArray.pop(userinputArray[0]);
    }
    while(userinputDataArray.length != 0) {
        userinputDataArray.pop(userinputDataArray[0]);
    }
}

function _clearMashupScreen()
{
    for(var i in _resultItemsArray) {
        _resultItemsArray[i].destroy();
    }
    while(_resultItemsArray.length >0) {
        _resultItemsArray.pop(_resultItemsArray[0]);
    }
}

/*
 * create a mashup item on homescreen.
 */
function _createItem(newItem, data) {
    console.log("+++++library._createItem+++++");
    if (newItem.status == Component.Ready) {
        console.log("create item ready");
        var sprite = newItem.createObject(items);
        if (sprite == null) {
            console.log("create item error");
        } else {
            sprite.itemIndex = itemCount;
            sprite.state= "baseState";
            sprite.title = data.name;
            sprite.shortDesc = data.shortDesc;
            sprite.longDesc = data.longDesc;
            sprite.userinputCtrls = data.userinputCtrls;
            console.log(sprite.itemClicked);
            sprite.itemClicked.connect(itemclicked);
            sprite.itemExecuted.connect(itemexecuted);
            itemsArray.push(sprite);
            itemCount++;
        }
    } else if (newItem.status == Component.Error) {
        console.log("Error loading component:", newItem.errorString());
    }
}

/****************************************************************************/
/***************************** result page operations. **********************/
/****************************************************************************/
var resultCtrlArray = new Array();

/*
 * configure the result page with result
 * page configuration information from the GUI.
 */
function configResultPage()
{
    _clearResultPage();
    console.log("config");
    for(var itemIndex in resultConfigItems) {
        console.log(itemIndex+"haha1234");
        var item = resultConfigItems[itemIndex];
        switch(item.type) {
        case "TEXTAREA":
            resultCtrlArray.push(_generateTextAreaResultCtrl(item));
            break;
        case "IMAGE":
            resultCtrlArray.push(_generateImageResultCtrl(item));
            break;
        }
    }
}

/*
 * generate a textarea result control to show a result information.
 */
function _generateTextAreaResultCtrl(item)
{
    var screenWidth = resultView.width;
    var screenHeight = resultView.height;
    var input = Qt.createComponent("TextArea.qml");
    if(input.status == Component.Ready)
    {
        var inputCtrl = input.createObject(resultView);
        if(inputCtrl == null) {
            console.log("generate TextArea error!");
        } else {
            inputCtrl.text = _getServiceOutputValue(item.target); // TODO...
            inputCtrl.enabled = false;
            inputCtrl.width = item.width*screenWidth;
            inputCtrl.height = item.height*screenHeight;

            inputCtrl.anchors.left = resultView.left;
            inputCtrl.anchors.top = resultView.top;
            inputCtrl.anchors.leftMargin = item.left*screenWidth;
            inputCtrl.anchors.topMargin = item.top*screenHeight;
        }
    }
    else {
        console.log("generate TextArea error!");
    }

    return inputCtrl;
}

/*
 * get value of service outputs and show it in the result control.
 * example of output: "invoke1.Latitude".
 */
function _getServiceOutputValue(output)
{
    var vars = output.split(".");
    var invoke = vars[0];
    var outputName = vars[1];
    console.log(invoke);
    console.log(outputName);
    return mashup.context[invoke][0][outputName].value;
}

/*
 * generate a image result control to show a result information.
 */
function _generateImageResultCtrl(item)
{
    var screenWidth = resultView.width;
    var screenHeight = resultView.height;
    var newImage = Qt.createQmlObject("import Qt 4.7; Image {}", resultView, "");
    newImage.source = _getServiceOutputValue(item.target);
    newImage.enabled = false;
    newImage.width = item.width*screenWidth;
    newImage.height = item.height*screenHeight;
    newImage.anchors.left = resultView.left;
    newImage.anchors.top = resultView.top;
    newImage.anchors.leftMargin = item.left*screenWidth;
    newImage.anchors.topMargin = item.top*screenHeight;

    return newImage;
}

/*
 * clear the result page.
 */
function _clearResultPage()
{
    console.log(resultCtrlArray.length);
    for(var i in resultCtrlArray) {
        console.log(i);
        resultCtrlArray[i].destroy();
    }
    while(resultCtrlArray.length != 0) {
        console.log("+++++++++++++"+resultCtrlArray.length);
        resultCtrlArray.pop(resultCtrlArray[0]);
    }
}
/****************************************************************************/
/*************************************End************************************/
/****************************************************************************/

/*
 * for test.
 */
function executeMashup()
{
    _clearMashupScreen();
    userinputValues.splice(0);
    for(var index in userinputArray) {
        var userinput = userinputArray[index];
        userinputValues.push(userinput.value);
    }
    if(executingItemIndex == 2) {
        _testFlickr(userinputArray[1].value, userinputArray[3].value);
    }
    else if(executingItemIndex == 3) {
        _testSinaMicroBlog(userinputArray[1].value);
    }
    else if(executingItemIndex == 1) {
        _testLocationSinaWeibo();
    }

    /* show the result in mashup result screen.*/
    showMashupScreen();
}

var flickr = new FlickrClass();

/*
 * for test.
 */
function handleFlickr()
{
    console.log("+++++library.handleFlickr+++++");
    var result = flickr.result;
    for(var i in result) {
        var photo = result[i];
        console.log(photo.thumbnailUrl);
        var newImage = Qt.createQmlObject("import Qt 4.7; Image {}", resultListItems, "");
        newImage.source = photo.thumbnailUrl;
        _resultItemsArray.push(newImage);
    }
}

/*
 * for test.
 */
function _testLocationSinaWeibo()
{
    var sina = new SinaMicroBlogClass();
    var args = new Array();
    var status = "lat:"+gps.lat+";lon:"+gps.lon;
    args.push("SinaMicroBlog_updateStatus");
    args.push(status)
    sina.updateStatus(args);
}

/*
 * for test.
 */
function _testFlickr(search_text, number)
{
    console.log("+++++library.testFlickr+++++");
    var args = new Array();
    args.push("flickr...");
    args.push(search_text);
    args.push(number);
    flickr.getGeotaggedPhotos(args);
}

/*
 * for test.
 */
function _testSinaMicroBlog(status)
{
    var sina = new SinaMicroBlogClass();
    var args = new Array();
    args.push("SinaMicroBlog_updateStatus");
    args.push(status)
    sina.updateStatus(args);
}


/*
 * when some mashup item is clicked, change all items' state.
 */
function itemclicked(itemIndex)
{
    var count=0;
    console.log("+++++events.itemclicked+++++");
    console.log("itemIndex: "+itemIndex);
    for(var item in itemsArray){
        var tempItem = itemsArray[item];
        if(tempItem.itemIndex == itemIndex)
        {
            if(tempItem.state=="baseState")
                tempItem.state = "State1";
            else
                tempItem.state = "baseState";
        }
        else
        {
            tempItem.state = "baseState";
        }
    }
    executingItemIndex = itemIndex;
}

/*
 * when the user wants to execute a mashup,
 * go to userinput configuration screen.
 */
function itemexecuted(itemIndex)
{
    console.log("+++++events.itemexecuted+++++");
    console.log("itemIndex: "+itemIndex);
    mainWindow.state = "executeState";
//    engine.init(itemIndex); // used when it's not testing.

    /*
     * for test.
     * there is only one mashup item needing engine to execute.
     */
    if(itemIndex == 0) {
        engine.init();
        engine.run();
    }
    else {
        generateUserinputCtrls(itemsArray[itemIndex]);
    }
}


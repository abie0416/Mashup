/*
 * genereate userinput controls, including label, textarea, button, checkbox.
 */

/*
 * : public
 * generate a control with a control object.
 * ctrlObj: label, control(type), value(default)
 */
function generateCtrl(ctrlObj, parent, userinputArray, userinputDataArray)
{
    console.log("generateCtrl");
    if(ctrlObj.control == "text") {
        _generateTextArea(ctrlObj, parent, userinputArray, userinputDataArray);
    }
    else if(ctrlObj.control == "checkbox") {
        _generateCheckbox(ctrlObj, parent, userinputArray, userinputDataArray);
    }
}

// generate a label control.
function _generateLabel(text, parent, userinputArray)
{
    var newLabel = Qt.createQmlObject('import Qt 4.7; Text {text: "label"}', parent, "");
    newLabel.text = text;

    userinputArray.push(newLabel);
}

// generate a textarea control.
function _generateTextArea(ctrlObj, parent, userinputArray, userinputDataArray)
{
    _generateLabel(ctrlObj.label, parent, userinputArray);
    var input = Qt.createComponent("TextArea.qml");
    if(input.status == Component.Ready)
    {
        var inputCtrl = input.createObject(parent);
        if(inputCtrl == null) {
            console.log("generate TextArea error!");
        } else {
            inputCtrl.text = ctrlObj.value;
        }
    }
    else {
        console.log("generate TextArea error!");
    }

    userinputArray.push(inputCtrl);
    userinputDataArray.push(inputCtrl);
}


// generate a button control.
function _generateButton(ctrlObj, parent, userinputArray)
{
    var buttonComponent = Qt.createComponent("Button.qml");
    if(buttonComponent.status == Component.Ready)
    {
        var butCtrl = buttonComponent.createObject(parent);
        if(butCtrl == null) {
            console.log("generate button error!");
        } else {
            butCtrl.text = ctrlObj.label;
        }
    }
    else {
        console.log("generate button error!");
    }

    userinputArray.push(butCtrl);
}

// generate a checkbox control.
function _generateCheckbox(ctrlObj, parent, userinputArray, userinputDataArray)
{
    var checkboxComponent = Qt.createComponent("Checkbox.qml");
    if(checkboxComponent.status == Component.Ready)
    {
        var checkboxCtrl = checkboxComponent.createObject(parent);
        if(checkboxCtrl == null) {
            console.log("generate checkbox error!");
        } else {
            checkboxCtrl.text = ctrlObj.label;
        }
    }
    else {
        console.log("generate checkbox error! not ready!");
    }

    userinputArray.push(checkboxCtrl);
    userinputDataArray.push(checkboxCtrl);
}

// generate the button of next.
function generateNextButton(parent, userinputArray)
{
    var buttonComponent = Qt.createComponent("Button.qml");
    if(buttonComponent.status == Component.Ready)
    {
        var butCtrl = buttonComponent.createObject(parent);
        if(butCtrl == null) {
            console.log("generate next-button error!");
        } else {
            butCtrl.text = "next";
        }
    }
    else {
        console.log("generate next-button error!");
    }

    userinputArray.push(butCtrl);

    return butCtrl;
}

// generate the button of executing mashup.
function generateMashupExectionButton(parent, userinputArray)
{
    var buttonComponent = Qt.createComponent("Button.qml");
    if(buttonComponent.status == Component.Ready)
    {
        var butCtrl = buttonComponent.createObject(parent);
        if(butCtrl == null) {
            // Error Handling
        } else {
            butCtrl.text = "Execute!";
        }
    }
    else {
        //Error Handling.
    }

    userinputArray.push(butCtrl);
}

Qt.include("environment.js")
Qt.include("js/map.js")
Qt.include("config.js")
Qt.include("library.js")
Qt.include("js/stack.js")
Qt.include("services.js")
Qt.include("model.js")

var engine = {
    _waiting: false,
    currentActivity: null,

    // initialize the home screen with all mashup items.
    initAppHome : function() {
        mainWindow.state="baseState";
        generateItems(config_items);
    },

    init: function(){
        mashup.init();
        this.currentActivity = mashup.process;
    },
    run: function(){
        this._waiting = false;
        this.execute();
    },
    pause: function(){
        this._waiting = true;
    },
    finish: function(){
        this._waiting = true;
        mainWindow.state = "State2";
        configResultPage();
    },
    resume: function(){
        console.log("resume()");
        this._waiting = false;
        if(this.currentActivity instanceof Invoke) {
            console.log("resume(); Invoke");
            var lastActivity = this.currentActivity;
            mashup.context[this.currentActivity.id] = new Object();
            for (var i=0; i<mashup.context._temp.value.length; i++) {
                mashup.context[this.currentActivity.id][i] = new Object();
                for (var j = 0; j < this.currentActivity.outputNames.length; j++) {
                    mashup.context[this.currentActivity.id][i][this.currentActivity.outputNames[j]] = new Variable(this.currentActivity.outputTypes[j], null);
                    console.log("i="+i+"j="+j);
                    var assign = new Assign(this.currentActivity.outputNames[j], "${_temp[" + i + "]."+this.currentActivity.outputNames[j]+"}");
                    assign.forInvoke = true;
                    assign.invokerId = this.currentActivity.id;
                    assign.resultIndex = i;
                    assign.next = lastActivity.next;
                    assign.parent = lastActivity.parent;
                    lastActivity.next = assign;
                    lastActivity = assign;
                }
            }
        }
        engine.forward();
        this.execute();
    },
    insertResult: function(result){
        mashup.context["_temp"].value = result;
    },
    getResult: function(){
        return mashup.context["_temp"].value ;
    },
    forward: function(){
        if (this.currentActivity instanceof While) { // special care for "while"
            console.log("while");
            getContext(this.currentActivity);
            if (evaluateExpression(this.currentActivity.condition, this.currentActivity.parent, -1)) {
                if (this.currentActivity.process != null) {
                    engine.currentActivity = this.currentActivity.process;
                }
            } else {
                if (this.currentActivity.next != null) {
                    this.currentActivity = this.currentActivity.next;
                } else {
                    if (this.currentActivity.parent.id != "mashup") {
                        this.currentActivity = this.currentActivity.parent;
                    } else {
                        this.finish(); // actually the whole mashup is finished
                    }
                }
            }
        } else {
            if (this.currentActivity.next != null) {
                if (!(this.currentActivity instanceof If)) {
                    this.currentActivity = this.currentActivity.next;
                    if (this.currentActivity instanceof IfBlock) {
                        getContext(this.currentActivity);
                        engine.currentActivity = this.currentActivity.process;
                        engine.forward();
                    } else if ((this.currentActivity instanceof Elseif) || this.currentActivity instanceof Else) {
                        getContext(this.currentActivity);
                        if (evaluateExpression(this.currentActivity.condition, this.currentActivity.parent)) {
                            if (this.currentActivity.process != null) {
                                engine.currentActivity = this.currentActivity.process;
                            }
                        } else {
                            engine.forward();
                        }
                    }
                } else {
                    getContext(this.currentActivity);
                    if (evaluateExpression(this.currentActivity.condition, this.currentActivity.parent)) {
                        if (this.currentActivity.process != null) {
                            engine.currentActivity = this.currentActivity.process;
                        }
                    } else { // "if" condition is not satisfied.
                        // And "if" next must be "elseif" or "else".
                        this.currentActivity = this.currentActivity.next;
                        getContext(this.currentActivity);
                        if (evaluateExpression(this.currentActivity.condition, this.currentActivity.parent)) {
                            if (this.currentActivity.process != null) {
                                engine.currentActivity = this.currentActivity.process;
                            }
                        } else {
                            engine.forward();
                        }
                    }
                }
            } else {
                // if the execution of  sub process is finished, jump out to its parent
                if (this.currentActivity.parent.id == "mashup") {
                    this.finish(); // actually the whole mashup is finished
                } else if (this.currentActivity.parent instanceof While) {
                    delete getContext(this.currentActivity.parent.parent)[this.currentActivity.parent.id];
                    if (evaluateExpression(this.currentActivity.parent.condition, this.currentActivity.parent.parent)) {
                        getContext(this.currentActivity.parent);
                        this.currentActivity = this.currentActivity.parent.process;
                    } else {
                        this.currentActivity = this.currentActivity.parent;
                        engine.forward();
                    }
                } else if (this.currentActivity.parent instanceof IfBlock) {
                    if (!(this.currentActivity instanceof If)) { // "elseif" or "else", go to "IfBlock".
                        this.currentActivity = this.currentActivity.parent;
                        engine.forward();
                    } else {
                        getContext(this.currentActivity);
                        if (evaluateExpression(this.currentActivity.condition, this.currentActivity.parent)) {
                            if (this.currentActivity.process != null) {
                                engine.currentActivity = this.currentActivity.process;
                            }
                        } else { // "if" condition is not satisfied, go to "IfBlock".
                            this.currentActivity = this.currentActivity.parent;
                            engine.forward();
                        }
                    }
                } else if ((this.currentActivity.parent instanceof If) ||
                           (this.currentActivity.parent instanceof Elseif) ||
                           (this.currentActivity.parent instanceof Else)) {
                    delete getContext(this.currentActivity.parent.parent.parent)[this.currentActivity.parent.parent.id];
                    this.currentActivity = this.currentActivity.parent.parent;
                    engine.forward();
                } else {
                    this.pause();
                    console.log("Error");
                }
            }
        }

    },
    execute: function(){
        while (!this._waiting) {
            console.log("engine.execute()");
            if (this.currentActivity instanceof Assign) {
                console.log("execute:assign");
                executeAssign(this.currentActivity);
                engine.forward();
            } else if (this.currentActivity instanceof GetTerminalInput) {
                console.log("execute:GetTerminalInput");
                executeTerminalInput(this.currentActivity);
            } else if (this.currentActivity instanceof Invoke) {
                console.log("execute:Invoke");
                executeInvoke(this.currentActivity);
            } else {
                engine.forward();
            }
        }
    }
};

function executeAssign(assign){
    console.log("executeAssign");
    if (!assign.forInvoke) {
        var context = getContext(assign);
        var varName = assign.name;
        var path = varName.split(".");
        for (var i = 0; i < path.length - 1; i++) {
            context = context[path[i]];
        }
        if(context[path[path.length - 1]] == undefined) { // explicit assign operation, assign a value to a global variable.
            mashup.context[assign.name].value = evaluateExpression(assign.value, assign.parent);
            console.log(assign.name);
            console.log(mashup.context[assign.name].value);
        }
        else { // implicit assign operation.
            context[path[path.length - 1]].value = evaluateExpression2(assign.value, assign.parent);
        }
    } else {
        console.log(assign.invokerId+";"+assign.resultIndex+";"+assign.name);
        mashup.context[assign.invokerId][assign.resultIndex][assign.name].value = evaluateExpression1(assign.value, assign.parent);
    }
}

// executeTerminalInput: before UI actions
function executeTerminalInput(getTerminalInput){
    console.log("executeTerminalInput");
    var context = getContext(getTerminalInput);
    /*
    * first assign this variable a default value in order to transform the getTerminalInput
     * into Assign
     */
    context[getTerminalInput.name] = new Variable(getTerminalInput.type, getTerminalInput.value);
    engine.pause();
    var assign = new Assign(getTerminalInput.name, "${_temp}");
    assign.next = getTerminalInput.next;
    assign.parent = getTerminalInput.parent;
    getTerminalInput.next = assign;

    // generate input control.
    clearUserinputArray();
    generateCtrl(getTerminalInput, ctrls, userinputArray, userinputDataArray);
    var nextBtn = generateNextButton(ctrls, userinputArray);
    nextBtn.clicked.connect(_nextOpers);
}

function _nextOpers()
{
    console.log("_nextOpers");
    engine.insertResult(userinputDataArray[0].value); // in fact, we have only one item in userinputArray temporarily.
    engine.resume();
}

function executeInvoke(invoke){
    console.log("executeInvoke");
    var invokee = eval("new " + invoke.portType + "_" + invoke.operation + "(invoke.id)");

    var input = new Array();
    for (var j = 0; j < invoke.inputValues.length; j++) {
        console.log("input."+invoke.inputValues[j][0]+"="+evaluateExpression3(invoke.inputValues[j][1], invoke.parent));
        eval("input."+invoke.inputValues[j][0]+"=\""+evaluateExpression3(invoke.inputValues[j][1], invoke.parent)+"\"");
    }
    engine.pause();

    invokee.run(input);
}

function getContext(activity){
    console.log("getContext");
    if (activity.id == "mashup") {
        return mashup.context;
    }
    var path = new Array();
    var parent = activity.parent;
    var context = mashup.context;
    while (parent.id != "mashup") {
        path.push(parent.id);
        parent = parent.parent;
    }
    for (var i = path.length - 1; i >= 0; i--) {
        context = context[path[i]];
    }
    if ((activity instanceof Assign) || (activity instanceof GetTerminalInput)) {
        return context;
    } else {
        if (context[activity.id] == undefined) {
            context[activity.id] = new Object();
        }
        return context[activity.id];
    }
}

/*
 * store the results of services into context of mashup by assign operations of type invoke.
 * example of exp: ${_temp[0].Latitude}.
 */
function evaluateExpression1(exp, parent){
    console.log("evaluateExpression1");
    var vars = exp.match(/\$\{\w+(\.\w+)?(\[\d+\])?(\.\w+)?\}/g);
    if (vars != undefined) {
        // elimilate ${} from ${expression}
        vars[0] = vars[0].substring(2, vars[0].length - 1);

        // store values of each expression
        var values = new Array();

        var attr = null;
        var path = new Array();
        var value, index = null;

        attr = vars[0].substring(vars[0].lastIndexOf(".")+1);
        index = parseInt(vars[0].substring(vars[0].indexOf("[") + 1, vars[0].indexOf("]")));
        vars[0] = vars[0].substring(0, vars[0].indexOf("["));

        // retrive the value from top to bottom, renew it when encounter a lower leverl variable with the same name
        var contextMap = mashup.context;
        if (contextMap[vars[0]] != undefined) {
            value = contextMap[vars[0]].value;
        }
    }
    return eval("value["+index+"]."+attr);
}

/*
 * store the result of userinput into context of mashup by assign operations.
 * example of exp: ${_temp}.
 */
function evaluateExpression2(exp, parent){
    console.log("evaluateExpression2");
    var vars = exp.match(/\$\{\w+(\.\w+)?(\[\d+\])?\}/g);
    if (vars != undefined) {
        // elimilate ${} from ${expression}
        vars[0] = vars[0].substring(2, vars[0].length - 1);

        // store values of each expression
        var values = new Array();

        var value, index = null;

        // retrive the value from top to bottom, renew it when encounter a lower leverl variable with the same name
        var contextMap = mashup.context;
        if (contextMap[vars[0]] != undefined) {
            value = contextMap[vars[0]].value;
        }
    }
    return value;
}

/*
 * evaluate values for inputs of services to be invoked.
 * example of exp: ${search_text} or ${invoke1.Latitude}
 * TODO: deal with multiple results of invoke1.
 */
function evaluateExpression3(exp, parent){
    console.log("evaluateExpression3");
    console.log(exp);
    var vars = exp.match(/\$\{\w+(\.\w+)?(\[\d+\])?(\.\w+)?\}/g);
    if (vars != undefined) {
        // elimilate ${} from ${expression}
        vars[0] = vars[0].substring(2, vars[0].length - 1);

        // store values of each expression
        var values = new Array();
        var path = new Array();
        var value, index = null;

        // retrive the path in the context
        if (vars[0].indexOf(".") != -1) {
            path = vars[0].split(".").reverse();
            vars[0] = path[0];
            path.shift();
            var contextMap = mashup.context;
            value = contextMap[path[0]][0][vars[0]].value;
        } else {
            while (parent.id != "mashup") {
                path.push(parent.id);
                parent = parent.parent;
            }
            // retrive the value from top to bottom, renew it when encounter a lower leverl variable with the same name
            var contextMap = mashup.context;
            if (contextMap[vars[0]] != undefined) {
                value = contextMap[vars[0]].value;
            }
            if (path[0] != undefined) {
                for (var j = path.length - 1; j >= 0; j--) {
                    contextMap = contextMap[path[j]];
                    if (contextMap[vars[0]] != undefined) {
                        value = contextMap[vars[0]].value;
                    }
                }
            }
        }
    }
    return value;
}

/*
 * evaluate conditions of while or if-else operations;
 * evaluate value for explicit assign operations.
 * example of exp: ${continue}==true || ${invoke1.Latitude}>30
 */
function evaluateExpression(exp, parent){
    console.log("evaluateExpression");
    console.log(exp);
    var vars = exp.match(/\$\{\w+(\.\w+)?(\[\d+\])?(\.\w+)?\}/g);
    if (vars != undefined) {
        // elimilate ${} from ${expression}
        for (var i = 0; i < vars.length; i++) {
            vars[i] = vars[i].substring(2, vars[i].length - 1);
        }

        // store values of each expression
        var values = new Array();

        for (var i = 0; i < vars.length; i++) {
            var attr = null;
            var path = new Array();
            var value, index = null;
            var originalVar = vars[i];

            if (vars[i].indexOf("[") != -1) {
                index = parseInt(vars[i].substring(vars[i].indexOf("[") + 1, vars[i].indexOf("]")));
                vars[i] = vars[i].substring(0, vars[i].indexOf("["));
            }

            console.log(vars);
            // retrive the path in the context
            if (vars[i].indexOf(".") != -1) {
                path = vars[i].split(".").reverse();
                vars[i] = path[0];
                path.shift();
            } else {
                while (parent.id != "mashup") {
                    path.push(parent.id);
                    parent = parent.parent;
                }
            }

            // retrive the value from top to bottom, renew it when encounter a lower leverl variable with the same name
            var contextMap = mashup.context;
            if (contextMap[vars[i]] != undefined) {
                value = contextMap[vars[i]].value;
            }
            if (path[0] != undefined) {
                for (var j = path.length - 1; j >= 0; j--) {
                    contextMap = contextMap[path[j]];
                    if (contextMap[vars[i]] != undefined) {
                        value = contextMap[vars[i]].value;
                    }
                }
            }

            // handle values for array
            if (value instanceof Array) {
                attr = originalVar.substring(originalVar.lastIndexOf(".")+1);
                value = value[index];
            }
            values.push(value);
        }

        // replace the expressions with its values
        for (var i = 0; i < vars.length; i++) {
            if (typeof(values[i]) == "string" || values[i] instanceof String) {
                values[i] = "\"" + values[i] + "\""
            }
            exp = exp.replace(/\$\{\w+(\.\w+)?(\[\d+\])?(\.\w+)?\}/, values[i]);
        }
    }
    return eval(exp);
}

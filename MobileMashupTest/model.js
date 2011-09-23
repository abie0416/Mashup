function Variable(type, value) {
    this.type = type;
    this.value = value;
}

function Assign(name, value){
    this.name = name;
    this.value = value;

    this.parent = null;
    this.next = null;

    /*
     * As outputs of invoking a service may refered by other activities,
     * they will be kept as globe variables under the name of its invocation id.
     * The "forInvoke" field is the singal.
     */
    this.forInvoke = false;
    this.invokerId = null;
    this.resultIndex = null; // the result may be an array of results.
}

function GetTerminalInput(name, label, type, control, value){
    this.name = name;
    this.label = label;
    this.type = type;
    this.control = control;
    this.value = value;

    this.parent = null;
    this.next = null;
}

function Invoke(id, portType, operation, inputTypes, inputValues, outputTypes, outputNames){
    this.id = id;
    this.portType = portType;
    this.operation = operation;
    this.inputTypes = inputTypes;
    this.inputValues = inputValues;
    this.outputTypes = outputTypes;
    this.outputNames = outputNames;
    this.outputValues = new Array();

    this.parent = null;
    this.next = null;
}

function While(id, condition){
    this.id = id;
    this.condition = condition;
    this.process = null;

    this.parent = null;
    this.next = null;

    this.push = addActivity;
}

function IfBlock(id){
    this.id = id;
    this.process = null;
    this.executed = false;

    this.parent = null;
    this.next = null;

    this.push = addActivity;
}

function If(id, condition){
    this.id = id;
    this.condition = condition;
    this.process = null;

    this.parent = null;
    this.next = null;

    this.push = addActivity;
}

function Elseif(id, condition){
    this.id = id;
    this.condition = condition;
    this.process = null;

    this.parent = null;
    this.next = null;

    this.push = addActivity;
}

function Else(id, condition){
    this.id = id;
    this.condition = condition;
    this.process = null;

    this.parent = null;
    this.next = null;

    this.push = addActivity;
}

function addActivity(activity){
    activity.parent = this;
    var activityNode = this.process;
    if (activityNode == null) {
        this.process = activity;
    } else {
        while (activityNode.next != null) {
            activityNode = activityNode.next;
        }
        activityNode.next = activity;
    }
}

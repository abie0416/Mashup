function Stack()
{
    this.elements = new Array();

    this.push = function(item) {
        return this.elements.push(item);
    };

    this.pop = function() {
        return this.elements.pop();
    };

    this.isEmpty = function() {
        return this.elements.length == 0;
    };
}

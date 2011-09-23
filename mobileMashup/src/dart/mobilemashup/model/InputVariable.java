package dart.mobilemashup.model;

import dart.mobilemashup.visitor.MashupNodeVisitor;

public class InputVariable extends Node {

	private String type;
	private String value;
	private String name;

	public InputVariable(String type, String value, String name) {
		super();
		this.type = type;
		this.value = value;
		this.name = name;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}
	
	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}

	@Override
	public void accept(MashupNodeVisitor mashupNodeVisitor) {
		mashupNodeVisitor.visitInputVariable(this);
	}
}

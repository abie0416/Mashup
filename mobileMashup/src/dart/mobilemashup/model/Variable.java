package dart.mobilemashup.model;

import dart.mobilemashup.visitor.MashupNodeVisitor;

public class Variable extends Node {

	public static final String REAL = "real";
	public static final String BOOLEAN = "boolean";
	public static final String STRING = "string";
	
	private String name;
	private String type;
	private String value;

	public Variable(String name, String type, String value) {
		super();
		this.name = name;
		this.type = type;
		this.value = value;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}

	@Override
	public void accept(MashupNodeVisitor mashupNodeVisitor) {
		mashupNodeVisitor.visitVariable(this);
	}

}

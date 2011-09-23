package dart.mobilemashup.model;

import dart.mobilemashup.visitor.MashupNodeVisitor;

public class OutputVariable extends Node {

	private String name;
	private String type;

	public OutputVariable(String name, String type) {
		super();
		this.name = name;
		this.type = type;
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

	@Override
	public void accept(MashupNodeVisitor mashupNodeVisitor) {
		mashupNodeVisitor.visitOutputVariable(this);
	}

}

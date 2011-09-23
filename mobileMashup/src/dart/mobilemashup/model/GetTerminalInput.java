package dart.mobilemashup.model;

import dart.mobilemashup.visitor.MashupNodeVisitor;

public class GetTerminalInput extends Activity {
	private String name;
	private String label;
	private String type;
	private String control;
	private String value;

	public GetTerminalInput(String name, String label, String type,
			String control, String value) {
		super();
		this.name = name;
		this.label = label;
		this.type = type;
		this.control = control;
		this.value = value;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getLabel() {
		return label;
	}

	public void setLabel(String label) {
		this.label = label;
	}

	public String getType() {
		return type;
	}

	public void setType(String type) {
		this.type = type;
	}

	public String getControl() {
		return control;
	}

	public void setControl(String control) {
		this.control = control;
	}

	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}

	@Override
	public void accept(MashupNodeVisitor mashupNodeVisitor) {
		mashupNodeVisitor.visitGetTerminalInput(this);
	}

}

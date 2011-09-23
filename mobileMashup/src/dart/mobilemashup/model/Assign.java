package dart.mobilemashup.model;

import dart.mobilemashup.visitor.MashupNodeVisitor;

public class Assign extends Activity {

	private String var;
	private String value;

	public Assign(String var, String value) {
		super();
		this.var = var;
		this.value = value;
	}

	public String getVar() {
		return var;
	}

	public void setVar(String var) {
		this.var = var;
	}

	public String getValue() {
		return value;
	}

	public void setValue(String value) {
		this.value = value;
	}

	@Override
	public void accept(MashupNodeVisitor mashupNodeVisitor) {
		mashupNodeVisitor.visitAssign(this);
	}

}

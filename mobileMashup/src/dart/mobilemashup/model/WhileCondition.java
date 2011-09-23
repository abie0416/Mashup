package dart.mobilemashup.model;

public class WhileCondition extends MashupNode {

	private String condition;

	public WhileCondition(String condition) {
		this.condition = condition;
	}

	public String getCondition() {
		return condition;
	}

	public void setCondition(String condition) {
		this.condition = condition;
	}
	
}

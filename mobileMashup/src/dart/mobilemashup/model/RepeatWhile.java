package dart.mobilemashup.model;

public class RepeatWhile extends FlowControlNode {

	private WhileCondition whileCondition;
	private WhileProcess whileBody;

	public RepeatWhile() {
		super();
	}

	public RepeatWhile(WhileCondition whileCondition, WhileProcess whileBody) {
		this.whileCondition = whileCondition;
		this.whileBody = whileBody;
	}

	public WhileCondition getWhileCondition() {
		return whileCondition;
	}

	public void setWhileCondition(WhileCondition whileCondition) {
		this.whileCondition = whileCondition;
	}

	public WhileProcess getWhileBody() {
		return whileBody;
	}

	public void setWhileBody(WhileProcess whileBody) {
		this.whileBody = whileBody;
	}

}

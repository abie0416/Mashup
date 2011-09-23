package dart.mobilemashup.model;

public class IfThenElse extends FlowControlNode {

	private IfCondition ifCondition;
	private Then thenBody;

	public IfThenElse() {
	}

	public IfThenElse(IfCondition ifCondition, Then thenBody) {
		this.ifCondition = ifCondition;
		this.thenBody = thenBody;
	}

	public IfCondition getIfCondition() {
		return ifCondition;
	}

	public void setIfCondition(IfCondition ifCondition) {
		this.ifCondition = ifCondition;
	}

	public Then getThenBody() {
		return thenBody;
	}

	public void setThenBody(Then thenBody) {
		this.thenBody = thenBody;
	}

}

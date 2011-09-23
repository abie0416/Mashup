package dart.mobilemashup.model;

public class WhileProcess extends MashupNode {

	private MashupNode whileBody;

	public WhileProcess(MashupNode whileBody) {
		this.whileBody = whileBody;
	}

	public MashupNode getWhileBody() {
		return whileBody;
	}

	public void setWhileBody(MashupNode whileBody) {
		this.whileBody = whileBody;
	}
	
}

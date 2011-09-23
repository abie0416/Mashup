package dart.mobilemashup.model;

public class Then extends MashupNode {

	private MashupNode thenBody;

	public Then(MashupNode thenBody) {
		this.thenBody = thenBody;
	}

	public MashupNode getThenBody() {
		return thenBody;
	}

	public void setThenBody(MashupNode thenBody) {
		this.thenBody = thenBody;
	}
	
}

package dart.mobilemashup.model;

public class ServiceEffect extends MashupNode {

	private String expression;

	public ServiceEffect(String expression) {
		this.expression = expression;
	}

	public String getExpression() {
		return expression;
	}

	public void setExpression(String expression) {
		this.expression = expression;
	}

}

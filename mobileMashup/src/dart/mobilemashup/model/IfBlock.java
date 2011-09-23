package dart.mobilemashup.model;

import java.util.List;

import dart.mobilemashup.visitor.MashupNodeVisitor;

public class IfBlock extends Activity implements ActivityContainer {

	private String id;
	private List<Activity> body;

	public IfBlock(String id) {
		super();
		this.id = id;
	}

	public List<Activity> getBody() {
		return body;
	}

	public void setBody(List<Activity> body) {
		this.body = body;
	}

	@Override
	public void accept(MashupNodeVisitor mashupNodeVisitor) {
		mashupNodeVisitor.visitIfBlock(this);
	}

	public List<Activity> getActivities() {
		return getBody();
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}
}

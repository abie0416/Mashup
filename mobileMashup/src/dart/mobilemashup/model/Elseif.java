package dart.mobilemashup.model;

import java.util.List;

import dart.mobilemashup.visitor.MashupNodeVisitor;

public class Elseif extends Activity implements ActivityContainer {

	private String id;
	private String condition;
	private List<Activity> body;

	public Elseif(String id) {
		super();
		this.id = id;
	}
	
	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}
	
	public String getCondition() {
		return condition;
	}

	public void setCondition(String condition) {
		this.condition = condition;
	}

	public List<Activity> getBody() {
		return body;
	}

	public void setBody(List<Activity> body) {
		this.body = body;
	}

	@Override
	public void accept(MashupNodeVisitor mashupNodeVisitor) {
		mashupNodeVisitor.visitElseif(this);
	}

	public List<Activity> getActivities() {
		return getBody();
	}

}

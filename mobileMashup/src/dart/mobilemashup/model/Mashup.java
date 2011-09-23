package dart.mobilemashup.model;

import java.util.List;

import dart.mobilemashup.visitor.MashupNodeVisitor;

public class Mashup extends Node implements ActivityContainer {

	private static final String ID = "mashup";
	
	private List<Variable> variables;
	private List<Activity> process;

	public Mashup() {
		super();
	}

	public List<Variable> getVariables() {
		return variables;
	}

	public void setVariables(List<Variable> variables) {
		this.variables = variables;
	}

	public List<Activity> getProcess() {
		return process;
	}

	public void setProcess(List<Activity> process) {
		this.process = process;
	}

	@Override
	public void accept(MashupNodeVisitor mashupNodeVisitor) {
		mashupNodeVisitor.visitMashup(this);
	}

	public List<Activity> getActivities() {
		return getProcess();
	}

	public String getId() {
		return ID;
	}

	public void setId(String id) {
		if (!id.equals(ID)) {
			throw new IllegalArgumentException();
		}
	}
}

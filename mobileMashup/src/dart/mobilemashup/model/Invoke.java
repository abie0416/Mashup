package dart.mobilemashup.model;

import java.util.List;

import dart.mobilemashup.visitor.MashupNodeVisitor;

public class Invoke extends Activity {

	private String id;
	private String portType;
	private String operation;
	private List<InputVariable> inputVariables;
	private List<OutputVariable> outputVariable;

	public Invoke(String id, String portType, String operation) {
		super();
		this.id = id;
		this.portType = portType;
		this.operation = operation;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getPortType() {
		return portType;
	}

	public void setPortType(String portType) {
		this.portType = portType;
	}

	public String getOperation() {
		return operation;
	}

	public void setOperation(String operation) {
		this.operation = operation;
	}

	public List<InputVariable> getInputVariables() {
		return inputVariables;
	}

	public void setInputVariables(List<InputVariable> inputVariables) {
		this.inputVariables = inputVariables;
	}

	public List<OutputVariable> getOutputVariable() {
		return outputVariable;
	}

	public void setOutputVariable(List<OutputVariable> outputVariable) {
		this.outputVariable = outputVariable;
	}

	@Override
	public void accept(MashupNodeVisitor mashupNodeVisitor) {
		mashupNodeVisitor.visitInvoke(this);
	}

}

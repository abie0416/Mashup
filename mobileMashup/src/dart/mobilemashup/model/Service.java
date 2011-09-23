package dart.mobilemashup.model;

public class Service extends MashupNode {

	private String id;

	private String name;

	private String apiName;

	private ServiceInput inputs;

	private ServiceOutput outputs;

	private ServiceEffect effect;

	public Service(String id, String name, String apiName) {
		this.id = id;
		this.name = name;
		this.apiName = apiName;
	}

	public Service(String id, String name, String apiName, ServiceInput inputs,
			ServiceOutput outputs, ServiceEffect effect) {
		this.id = id;
		this.name = name;
		this.apiName = apiName;
		this.inputs = inputs;
		this.outputs = outputs;
		this.effect = effect;
	}

	public String getId() {
		return id;
	}

	public void setId(String id) {
		this.id = id;
	}

	public String getName() {
		return name;
	}

	public void setName(String name) {
		this.name = name;
	}

	public String getApiName() {
		return apiName;
	}

	public void setApiName(String apiName) {
		this.apiName = apiName;
	}

	public ServiceInput getInputs() {
		return inputs;
	}

	public void setInputs(ServiceInput inputs) {
		this.inputs = inputs;
	}

	public ServiceOutput getOutputs() {
		return outputs;
	}

	public void setOutputs(ServiceOutput outputs) {
		this.outputs = outputs;
	}

	public ServiceEffect getEffect() {
		return effect;
	}

	public void setEffect(ServiceEffect effect) {
		this.effect = effect;
	}

}

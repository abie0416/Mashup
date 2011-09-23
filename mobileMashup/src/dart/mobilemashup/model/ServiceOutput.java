package dart.mobilemashup.model;

import java.util.HashMap;

public class ServiceOutput extends MashupNode {

	private HashMap<String, Parameter> paras;

	public ServiceOutput(HashMap<String, Parameter> paras) {
		super();
		this.paras = paras;
	}

	public HashMap<String, Parameter> getParas() {
		return paras;
	}

	public void setParas(HashMap<String, Parameter> paras) {
		this.paras = paras;
	}

}

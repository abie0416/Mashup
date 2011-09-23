package dart.mobilemashup.model;

import java.util.List;

public class ServiceInput extends MashupNode {

	private List<Parameter> paras;

	public ServiceInput(List<Parameter> paras) {
		super();
		this.paras = paras;
	}

	public List<Parameter> getParas() {
		return paras;
	}

	public void setParas(List<Parameter> paras) {
		this.paras = paras;
	}

}

package dart.mobilemashup.bean;

// this class should encapsulate all the input of mobile mashup
public class SourceBean {

	private String source;

	public SourceBean(String source) {
		this.source = source;
	}

	@Override
	public String toString() {
		return this.source;
	}

}

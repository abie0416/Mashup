package dart.mobilemashup.model;

public class MashupProcess extends MashupNode {

	private MashupNode mashupContent;

	public MashupProcess() {
		super();
	}

	public MashupProcess(MashupNode mashupContent) {
		this.mashupContent = mashupContent;
	}

	public MashupNode getMashupContent() {
		return mashupContent;
	}

	public void setMashupContent(MashupNode mashupContent) {
		this.mashupContent = mashupContent;
	}
	
}

package dart.mobilemashup.model;

public class SequenceBlock extends MashupNode {

	private MashupNode block;

	public SequenceBlock(MashupNode block) {
		this.block = block;
	}

	public MashupNode getBlock() {
		return block;
	}

	public void setBlock(MashupNode block) {
		this.block = block;
	}

}

package dart.mobilemashup.model;

import java.util.List;

public class Sequence extends FlowControlNode {

	private List<SequenceBlock> sequenceBlocks;

	public Sequence(List<SequenceBlock> sequenceBlocks) {
		this.sequenceBlocks = sequenceBlocks;
	}

	public List<SequenceBlock> getSequenceBlocks() {
		return sequenceBlocks;
	}

	public void setSequenceBlocks(List<SequenceBlock> sequenceBlocks) {
		this.sequenceBlocks = sequenceBlocks;
	}
	
}

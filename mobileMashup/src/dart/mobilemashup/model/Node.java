package dart.mobilemashup.model;

import dart.mobilemashup.visitor.MashupNodeVisitor;

public abstract class Node {

	public abstract void accept(MashupNodeVisitor mashupNodeVisitor);
}

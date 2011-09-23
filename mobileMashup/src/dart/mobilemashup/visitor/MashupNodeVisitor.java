package dart.mobilemashup.visitor;

import dart.mobilemashup.model.Assign;
import dart.mobilemashup.model.Else;
import dart.mobilemashup.model.Elseif;
import dart.mobilemashup.model.GetTerminalInput;
import dart.mobilemashup.model.If;
import dart.mobilemashup.model.IfBlock;
import dart.mobilemashup.model.InputVariable;
import dart.mobilemashup.model.Invoke;
import dart.mobilemashup.model.Mashup;
import dart.mobilemashup.model.OutputVariable;
import dart.mobilemashup.model.Variable;
import dart.mobilemashup.model.While;

public abstract class MashupNodeVisitor {

	public abstract void visitVariable(Variable variable);
	
	public abstract void visitGetTerminalInput(GetTerminalInput getTerminalInput);
	
	public abstract void visitAssign(Assign assign);

	public abstract void visitInvoke(Invoke invoke);

	public abstract void visitInputVariable(InputVariable inputVariable);

	public abstract void visitOutputVariable(OutputVariable outputVariable);

	public abstract void visitWhile(While _while);
	
	public abstract void visitIfBlock(IfBlock ifBlock);

	public abstract void visitIf(If _if);
	
	public abstract void visitElseif(Elseif elseif);
	
	public abstract void visitElse(Else _else);
	
	public abstract void visitMashup(Mashup mashup);
}

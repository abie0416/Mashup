package dart.mobilemashup;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;
import java.io.PrintWriter;
import java.util.Iterator;
import java.util.List;

import org.apache.log4j.Logger;

import dart.mobilemashup.exception.BadMashupException;
import dart.mobilemashup.model.Activity;
import dart.mobilemashup.model.ActivityContainer;
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

public class CodeGenerator {

	private static final Logger logger = Logger.getLogger(CodeGenerator.class);

	private static final String NEW_LINE = "\r\n";
	private static final char TAB = '\t';
	private Mashup mashup;
	private int index;
	public static String resultPageString = null;

	public CodeGenerator(Mashup mashup) {
		super();
		this.mashup = mashup;
		index = 0;
	}

	private synchronized String getRandomName(String type) {
		return type + (++index);
	}

	private StringBuffer genenrateVariable(StringBuffer sb) {
		sb.append(TAB).append("context : null,");
		Iterator<Variable> it = mashup.getVariables().iterator();
		while (it.hasNext()) {
			Variable v = it.next();
			sb.append(",").append(NEW_LINE).append(TAB).append(TAB).append(
					v.getName()).append(" : ").append("{type:'").append(
					v.getType()).append("', value: ").append(
					v.getType().equals(Variable.STRING) ? "'" + v.getValue()
							+ "'" : v.getValue()).append("}");
		}
		return sb;
	}

	private StringBuffer generateProcess(StringBuffer sb,
			ActivityContainer parent) {
		Iterator<Activity> it = parent.getActivities().iterator();
		while (it.hasNext()) {
			Activity activity = it.next();
			if (activity instanceof Assign) {
				generateAssign(sb, (Assign) activity, parent);
			} else if (activity instanceof GetTerminalInput) {
				generateGetTerminalInput(sb, (GetTerminalInput) activity,
						parent);
			} else if (activity instanceof Invoke) {
				generateInvoke(sb, (Invoke) activity, parent);
			} else if (activity instanceof While) {
				generateWhile(sb, (While) activity, parent);
			} else if (activity instanceof IfBlock) {
				generateIfBlock(sb, (IfBlock) activity, parent);
			} else if (activity instanceof If) {
				generateIf(sb, (If) activity, parent);
			} else if (activity instanceof Elseif) {
				generateElseif(sb, (Elseif) activity, parent);
			} else if (activity instanceof Else) {
				generateElse(sb, (Else) activity, parent);
			} else {
				logger.error("Bad Mashup!");
				throw new BadMashupException("Bad Mashup!");
			}
		}
		return sb;
	}

	private StringBuffer generateAssign(StringBuffer sb, Assign activity,
			ActivityContainer parent) {
		String var = getRandomName("Assign");
		sb.append(TAB).append(TAB).append("var ").append(var).append(
				" = new Assign('").append(activity.getVar()).append("', '")
				.append(activity.getValue()).append("');").append(NEW_LINE);
		sb.append(TAB).append(TAB).append(parent.getId()).append(".push(")
				.append(var).append(");").append(NEW_LINE).append(NEW_LINE);
		return sb;
	}

	private StringBuffer generateGetTerminalInput(StringBuffer sb,
			GetTerminalInput activity, ActivityContainer parent) {
		String var = getRandomName("GetTerminalInput");
		sb.append(TAB).append(TAB).append("var ").append(var).append(
				" = new GetTerminalInput('").append(activity.getName()).append(
				"', '").append(activity.getLabel()).append("', '").append(
				activity.getType()).append("', '")
				.append(activity.getControl()).append("', '").append(
						activity.getValue()).append("');").append(NEW_LINE);
		sb.append(TAB).append(TAB).append(parent.getId()).append(".push(")
				.append(var).append(");").append(NEW_LINE).append(NEW_LINE);
		return sb;
	}

	private String generateInputVariableTypes(List<InputVariable> inputVariables) {
		StringBuffer sb = new StringBuffer();
		sb.append("[");
		Iterator<InputVariable> it = inputVariables.iterator();
		while (it.hasNext()) {
			InputVariable inputVariable = it.next();
			sb.append("'").append(inputVariable.getType()).append("',");
		}
		if (sb.charAt(sb.length() - 1) == ',') {
			sb.deleteCharAt(sb.length() - 1);
		}
		sb.append("]");
		return sb.toString();
	}

	private String generateInputVariableValues(
			List<InputVariable> inputVariables) {
		StringBuffer sb = new StringBuffer();
		sb.append("[");
		Iterator<InputVariable> it = inputVariables.iterator();
		while (it.hasNext()) {
			InputVariable inputVariable = it.next();
			sb.append("[");
			sb.append("'").append(inputVariable.getName()).append("',");
			sb.append("'").append(inputVariable.getValue()).append("'");
			sb.append("],");
		}
		if (sb.charAt(sb.length() - 1) == ',') {
			sb.deleteCharAt(sb.length() - 1);
		}
		sb.append("]");
		return sb.toString();
	}

	private String generateOutputVariableTypes(
			List<OutputVariable> outputVariables) {
		StringBuffer sb = new StringBuffer();
		sb.append("[");
		Iterator<OutputVariable> it = outputVariables.iterator();
		while (it.hasNext()) {
			OutputVariable outputVariable = it.next();
			sb.append("'").append(outputVariable.getType()).append("',");
		}
		if (sb.charAt(sb.length() - 1) == ',') {
			sb.deleteCharAt(sb.length() - 1);
		}
		sb.append("]");
		return sb.toString();
	}

	private String generateOutputVariableNames(
			List<OutputVariable> outputVariables) {
		StringBuffer sb = new StringBuffer();
		sb.append("[");
		Iterator<OutputVariable> it = outputVariables.iterator();
		while (it.hasNext()) {
			OutputVariable outputVariable = it.next();
			sb.append("'").append(outputVariable.getName()).append("',");
		}
		if (sb.charAt(sb.length() - 1) == ',') {
			sb.deleteCharAt(sb.length() - 1);
		}
		sb.append("]");
		return sb.toString();
	}

	private StringBuffer generateInvoke(StringBuffer sb, Invoke activity,
			ActivityContainer parent) {
		String var = getRandomName("Invoke");
		sb
				.append(TAB)
				.append(TAB)
				.append("var ")
				.append(var)
				.append(" = new Invoke('")
				.append(activity.getId())
				.append("', '")
				.append(activity.getPortType())
				.append("', '")
				.append(activity.getOperation())
				.append("', ")
				.append(
						generateInputVariableTypes(activity.getInputVariables()))
				.append(", ").append(
						generateInputVariableValues(activity
								.getInputVariables())).append(", ").append(
						generateOutputVariableTypes(activity
								.getOutputVariable())).append(", ").append(
						generateOutputVariableNames(activity
								.getOutputVariable())).append(");").append(
						NEW_LINE);
		sb.append(TAB).append(TAB).append(parent.getId()).append(".push(")
				.append(var).append(");").append(NEW_LINE).append(NEW_LINE);
		return sb;
	}

	private StringBuffer generateWhile(StringBuffer sb, While activity,
			ActivityContainer parent) {
		String var = getRandomName("While");
		activity.setId(var);
		sb.append(TAB).append(TAB).append("var ").append(var).append(
				" = new While('").append(activity.getId()).append("', '")
				.append(activity.getCondition()).append("');").append(NEW_LINE);
		sb.append(TAB).append(TAB).append(parent.getId()).append(".push(")
				.append(var).append(");").append(NEW_LINE).append(NEW_LINE);
		generateProcess(sb, activity);
		return sb;
	}

	private StringBuffer generateIfBlock(StringBuffer sb, IfBlock activity,
			ActivityContainer parent) {
		String var = getRandomName("IfBlock");
		activity.setId(var);
		sb.append(TAB).append(TAB).append("var ").append(var).append(
				" = new IfBlock('" + activity.getId() + "');").append(NEW_LINE);
		sb.append(TAB).append(TAB).append(parent.getId()).append(".push(")
				.append(var).append(");").append(NEW_LINE).append(NEW_LINE);
		generateProcess(sb, activity);
		return sb;
	}

	private StringBuffer generateIf(StringBuffer sb, If activity,
			ActivityContainer parent) {
		String var = getRandomName("If");
		activity.setId(var);
		sb.append(TAB).append(TAB).append("var ").append(var).append(
				" = new If('").append(activity.getId()).append("', '").append(
				activity.getCondition()).append("');").append(NEW_LINE);
		sb.append(TAB).append(TAB).append(parent.getId()).append(".push(")
				.append(var).append(");").append(NEW_LINE).append(NEW_LINE);
		generateProcess(sb, activity);
		return sb;
	}

	private StringBuffer generateElseif(StringBuffer sb, Elseif activity,
			ActivityContainer parent) {
		String var = getRandomName("Elseif");
		activity.setId(var);
		sb.append(TAB).append(TAB).append("var ").append(var).append(
				" = new Elseif('").append(activity.getId()).append("', '")
				.append(activity.getCondition()).append("');").append(NEW_LINE);
		sb.append(TAB).append(TAB).append(parent.getId()).append(".push(")
				.append(var).append(");").append(NEW_LINE).append(NEW_LINE);
		generateProcess(sb, activity);
		return sb;
	}

	private StringBuffer generateElse(StringBuffer sb, Else activity,
			ActivityContainer parent) {
		String var = getRandomName("Else");
		activity.setId(var);
		sb.append(TAB).append(TAB).append("var ").append(var).append(
				" = new Else('").append(activity.getId()).append("');").append(
				NEW_LINE);
		sb.append(TAB).append(TAB).append(parent.getId()).append(".push(")
				.append(var).append(");").append(NEW_LINE).append(NEW_LINE);
		generateProcess(sb, activity);
		return sb;
	}

	private void writeFile(File file, String content) throws IOException {
		PrintWriter out = new PrintWriter(new FileWriter(file), true);
		out.write(content);
		out.close();
	}

	public void generateCode(File config_js) throws IOException {
		StringBuffer sb = new StringBuffer();
		sb.append("Qt.include(\"model.js\")").append(NEW_LINE).append(NEW_LINE);
		sb.append("//description of home screen.\r\n"
				+"var config_items = [\r\n"
				+"    {\r\n"
				+"        name: \"Flickr-SinaMicroBlog\",\r\n"
				+"        shortDesc: \"Micro blog with images\",\r\n"
				+"        longDesc: \"Search images from flickr and send the result to Sina Micro-blog.\",\r\n"
				+"        userinputCtrls:[\r\n"
				+"            {\r\n"
				+"                text: \"search text\",\r\n"
				+"                type: \"LABEL\"\r\n"
				+"            },\r\n"
				+"            {\r\n"
				+"                text: \"\",\r\n"
				+"                type: \"TEXTAREA\",\r\n"
				+"            },\r\n"
				+"           {\r\n"
				+"                text: \"number\",\r\n"
				+"                type: \"LABEL\"\r\n"
				+"            },\r\n"
				+"            {\r\n"
				+"                text: \"\",\r\n"
				+"                type: \"TEXTAREA\",\r\n"
				+"            }\r\n"
				+"        ]\r\n"
				+"    },\r\n"
				+"    {\r\n"
				+"        name: \"Location\",\r\n"
				+"       shortDesc: \"Publish Location\",\r\n"
				+"        longDesc: \"Get GPS location and publish it to Sina Weibo\",\r\n"
				+"        userinputCtrls:[\r\n"
				+"\r\n"
				+"        ]\r\n"
				+"   },\r\n"
				+"    {\r\n"
				+"        name: \"Flickr\",\r\n"
				+"        shortDesc: \"Flickr picture\",\r\n"
				+"        longDesc: \"Get pictures from flickr.\",\r\n"
				+"        userinputCtrls:[\r\n"
				+"            {\r\n"
				+"                text: \"search text\",\r\n"
				+"               type: \"LABEL\"\r\n"
				+"            },\r\n"
				+"            {\r\n"
				+"                text: \"\",\r\n"
				+"               type: \"TEXTAREA\",\r\n"
				+"            },\r\n"
				+"            {\r\n"
				+"               text: \"number\",\r\n"
				+"                type: \"LABEL\"\r\n"
				+"            },\r\n"
				+"            {\r\n"
				+"                text: \"\",\r\n"
				+"                type: \"TEXTAREA\",\r\n"
				+"            }\r\n"
				+"        ]\r\n"
				+"    },\r\n"
				+"    {\r\n"
				+"        name: \"Sina Micro-Blog\",\r\n"
				+"        shortDesc: \"Update microblog status.\",\r\n"
				+"        longDesc: \"Update a status to Sina Microblog.\",\r\n"
				+"        userinputCtrls:[\r\n"
				+"            {\r\n"
				+"                text: \"Please input status:\",\r\n"
				+"                type: \"LABEL\"\r\n"
				+"            },\r\n"
				+"            {\r\n"
				+"                text: \"\",\r\n"
				+"                type: \"TEXTAREA\",\r\n"
				+"            }\r\n"
				+"        ]\r\n"
				+"    }\r\n"
				+"];\r\n");
		sb.append("var mashup = {").append(NEW_LINE);
		sb.append(TAB).append("id: 'mashup',").append(NEW_LINE);
		sb.append(TAB).append("context : null,").append(NEW_LINE);
//		genenrateVariable(sb).append(",").append(NEW_LINE);
		sb.append(TAB).append("process: null,").append(NEW_LINE);
		sb.append(TAB).append("push: addActivity,").append(NEW_LINE);
		sb.append(TAB).append("init: function() {").append(NEW_LINE);
		sb.append(TAB).append("this.context = {").append(NEW_LINE).append(TAB)
		.append(TAB).append("_temp: {type: null, value: null}").append(NEW_LINE).append(TAB).append("};");
		generateProcess(sb, mashup);
		sb.append(TAB).append("}").append(NEW_LINE).append("};");
		writeFile(config_js, sb.toString());
	}
	
	public void generateCode2(File resultPageFile) throws IOException {
		if(resultPageString != null)
			writeFile(resultPageFile, resultPageString);
	}
}

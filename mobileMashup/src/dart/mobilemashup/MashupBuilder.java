package dart.mobilemashup;

import java.io.ByteArrayInputStream;
import java.io.File;
import java.io.IOException;
import java.net.URL;
import java.util.LinkedList;
import java.util.List;

import javax.xml.XMLConstants;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.transform.stream.StreamSource;
import javax.xml.validation.Schema;
import javax.xml.validation.SchemaFactory;

import org.apache.log4j.Logger;
import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.w3c.dom.Text;
import org.xml.sax.SAXException;

import dart.mobilemashup.bean.XmlSourceBean;
import dart.mobilemashup.exception.BadMashupException;
import dart.mobilemashup.model.Activity;
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

public class MashupBuilder {

	private static final Logger logger = Logger.getLogger(MashupBuilder.class);
	private static final String LANGUAGE_DEFINITION = "mobile_mashup_language_definition.xsd";

	public MashupBuilder() {
		super();
	}

	public Mashup build(XmlSourceBean xmlSource) throws IOException {
		try {
			SchemaFactory factory = SchemaFactory
					.newInstance(XMLConstants.W3C_XML_SCHEMA_NS_URI);
			Schema schema = factory.newSchema(new File(new URL(this.getClass()
					.getResource("/"), LANGUAGE_DEFINITION).getFile()));
			schema.newValidator().validate(
					new StreamSource(new ByteArrayInputStream(xmlSource
							.toString().getBytes())));

			Document doc = DocumentBuilderFactory.newInstance()
					.newDocumentBuilder().parse(
							new ByteArrayInputStream(xmlSource.toString()
									.getBytes()));
			return build(doc);
		} catch (SAXException e) {
			logger.error("Error with XML files!", e);
		} catch (ParserConfigurationException e) {
			logger.error("Mashup source file is invalid!", e);
		}
		return null;
	}

	private Mashup build(Document doc) {
		Mashup mashup = new Mashup();
		Element root = doc.getDocumentElement();
		NodeList children = root.getChildNodes();
		for (int i = 0; i < children.getLength(); i++) {
			Node child = children.item(i);
			if (child instanceof Element) {
				Element childElement = (Element) child;
				if (childElement.getTagName().equals("variables")) {
					mashup.setVariables(bulidVariables(childElement));
				} else if (childElement.getTagName().equals("process")) {
					mashup.setProcess(bulidProcess(childElement));
				}
			}
		}
		return mashup;
	}

	private List<Variable> bulidVariables(Element node) {
		List<Variable> variables = new LinkedList<Variable>();
		NodeList variableNodes = node.getChildNodes();
		for (int i = 0; i < variableNodes.getLength(); i++) {
			Node variableNode = variableNodes.item(i);
			if (variableNode instanceof Element) {
				variables.add(buildVariable((Element) variableNode));
			}
		}
		return variables;
	}

	private List<Activity> bulidProcess(Element node) {
		List<Activity> process = new LinkedList<Activity>();
		NodeList activityNodes = node.getChildNodes();
		for (int i = 0; i < activityNodes.getLength(); i++) {
			Node activityNode = activityNodes.item(i);
			if (activityNode instanceof Element) {
				process.add(buildActivity((Element) activityNode));
			}
		}
		return process;
	}

	private Variable buildVariable(Element node) {
		return new Variable(node.getAttribute("name"), node
				.getAttribute("type"), node.getAttribute("value"));
	}

	private Activity buildActivity(Element node) {
		String tagName = node.getTagName();
		if (tagName.equals("getTerminalInput")) {
			return buildGetTerminalInput(node);
		} else if (tagName.equals("assign")) {
			return buildAssign(node);
		} else if (tagName.equals("invoke")) {
			return buildInvoke(node);
		} else if (tagName.equals("while")) {
			return buildWhile(node);
		} else if (tagName.equals("ifBlock")) {
			return buildIfBlock(node);
		} else if (tagName.equals("if")) {
			return buildIf(node);
		} else if (tagName.equals("elseif")) {
			return buildElseif(node);
		} else if (tagName.equals("else")) {
			return buildElse(node);
		} else {
			logger.error("Unknown tag: <" + tagName + ">");
			throw new BadMashupException("Unknown tag: <" + tagName + ">");
		}
	}

	private GetTerminalInput buildGetTerminalInput(Element node) {
		return new GetTerminalInput(node.getAttribute("name"), node
				.getAttribute("label"), node.getAttribute("type"), node
				.getAttribute("control"), node.getAttribute("value"));
	}

	private Assign buildAssign(Element node) {
		return new Assign(node.getAttribute("var"), node.getAttribute("value"));
	}

	private Invoke buildInvoke(Element node) {
		Invoke invoke = new Invoke(node.getAttribute("id"), node
				.getAttribute("portType"), node.getAttribute("operation"));
		NodeList children = node.getChildNodes();
		for (int i = 0; i < children.getLength(); i++) {
			Node child = children.item(i);
			if (child instanceof Element) {
				Element childElement = (Element) child;
				if (childElement.getTagName().equals("inputVariables")) {
					invoke.setInputVariables(buildInputVariables(childElement));
				} else if (childElement.getTagName().equals("outputVariables")) {
					invoke
							.setOutputVariable(buildOutputVariables(childElement));
				}
			}
		}
		return invoke;
	}

	private InputVariable buildInputVariable(Element node) {
		return new InputVariable(node.getAttribute("type"), node
				.getAttribute("value"), node.getAttribute("name"));
	}

	private List<InputVariable> buildInputVariables(Element node) {
		List<InputVariable> inputVariables = new LinkedList<InputVariable>();
		NodeList inputVariableNodes = node.getChildNodes();
		for (int i = 0; i < inputVariableNodes.getLength(); i++) {
			Node inputVariableNode = inputVariableNodes.item(i);
			if (inputVariableNode instanceof Element) {
				inputVariables
						.add(buildInputVariable((Element) inputVariableNode));
			}
		}
		return inputVariables;
	}

	private OutputVariable buildOutputVariable(Element node) {
		return new OutputVariable(node.getAttribute("name"), node
				.getAttribute("type"));
	}

	private List<OutputVariable> buildOutputVariables(Element node) {
		List<OutputVariable> outputVariables = new LinkedList<OutputVariable>();
		NodeList outputVariableNodes = node.getChildNodes();
		for (int i = 0; i < outputVariableNodes.getLength(); i++) {
			Node outputVariableNode = outputVariableNodes.item(i);
			if (outputVariableNode instanceof Element) {
				outputVariables
						.add(buildOutputVariable((Element) outputVariableNode));
			}
		}
		return outputVariables;
	}

	private While buildWhile(Element node) {
		While _while = new While(node.getAttribute("id"));
		NodeList children = node.getChildNodes();

		// set condition and remove the condition node from while node
		Node conditionNode = children.item(1);
		if (conditionNode instanceof Element) {
			Element conditionElement = (Element) conditionNode;
			if (conditionElement.getTagName().equals("condition")) {
				_while.setCondition(getCondition(conditionElement));
				node.removeChild(conditionElement);
			}
		}

		_while.setBody(bulidProcess(node));
		return _while;
	}

	private IfBlock buildIfBlock(Element node) {
		IfBlock ifBlock = new IfBlock(node.getAttribute("id"));
		NodeList activityNodes = node.getChildNodes();
		if (activityNodes.getLength() < 1) {
			logger.error("<ifBlock> ifBlock: no sub elements");
			throw new BadMashupException("<ifBlock> ifBlock: no sub elements");
		}
		ifBlock.setBody(bulidProcess(node));
		return ifBlock;
	}

	private If buildIf(Element node) {
		If _if = new If(node.getAttribute("id"));
		NodeList children = node.getChildNodes();

		// set condition and remove the condition node from if node
		Node conditionNode = children.item(1);
		if (conditionNode instanceof Element) {
			Element conditionElement = (Element) conditionNode;
			if (conditionElement.getTagName().equals("condition")) {
				_if.setCondition(getCondition(conditionElement));
				node.removeChild(conditionElement);
			}
		}

		_if.setBody(bulidProcess(node));
		return _if;
	}

	private Elseif buildElseif(Element node) {
		Elseif elseif = new Elseif(node.getAttribute("id"));
		NodeList children = node.getChildNodes();

		// set condition and remove the condition node from elseif node
		Node conditionNode = children.item(1);
		if (conditionNode instanceof Element) {
			Element conditionElement = (Element) conditionNode;
			if (conditionElement.getTagName().equals("condition")) {
				elseif.setCondition(getCondition(conditionElement));
				node.removeChild(conditionElement);
			}
		}

		elseif.setBody(bulidProcess(node));
		return elseif;
	}

	private Else buildElse(Element node) {
		Else _else = new Else(node.getAttribute("id"));
		_else.setBody(bulidProcess(node));
		return _else;
	}

	private String getCondition(Element node) {
		return ((Text) node.getFirstChild()).getData().trim();
	}

}

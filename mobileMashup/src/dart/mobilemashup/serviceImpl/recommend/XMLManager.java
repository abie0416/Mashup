package dart.mobilemashup.serviceImpl.recommend;

import java.io.IOException;
import java.util.ArrayList;

import org.dom4j.Document;
import org.dom4j.DocumentHelper;
import org.dom4j.Element;

public class XMLManager {

	private static String RESULTTAG = "result";
	private static String MATCHTAG = "matches";
	private static String OUTPUTTAG = "outputs";
	private static String OUTPUTPARATAG = "para3";
	
	// given two services, return matched parameter result.
	public String writeMatchParaXML(ArrayList<ArrayList<String>> outMatches, ArrayList<String> outputParas2)
	{
		Document doc = DocumentHelper.createDocument();
		Element root = doc.addElement(RESULTTAG);
		Element matches = root.addElement("service");
		Element outMatchesEle = matches.addElement(MATCHTAG);
		writeMatches(outMatches, outMatchesEle, 1);
		
		Element outputParasEle = matches.addElement(OUTPUTTAG);
		writeOutputs(outputParas2, outputParasEle);
		
		return doc.asXML();
	}

	private void writeOutputs(ArrayList<String> outputParas, Element outputParasEle)
	{
		for(String outputPara: outputParas)
		{
			Element outputParaEle = outputParasEle.addElement(OUTPUTPARATAG);
			outputParaEle.addAttribute("name", outputPara);
		}
	}
	
	private void writeMatches(ArrayList<ArrayList<String>> inMatches,
			Element inMatchesEle, int index) {
		for(ArrayList<String> inMatch:inMatches)
		{
			String paraTag1 = "";
			String paraTag2 = "";
			if(index == 0)
			{
				paraTag1 += "para1";
				paraTag2 += "para2";
			}
			else if(index == 1)
			{
				paraTag1 += "para2";
				paraTag2 += "para1";
			}
			Element para1Ele = inMatchesEle.addElement(paraTag1);
			para1Ele.addAttribute("name", inMatch.get(0));
			para1Ele.addAttribute("type", "text");// to do...
			Element defaultVEle = para1Ele.addElement("defaultValue");
			defaultVEle.addText(inMatch.get(1));
			for(int i=2; i<inMatch.size(); i++)
			{
				Element para2Ele = para1Ele.addElement(paraTag2);
				para2Ele.addAttribute("name", inMatch.get(i));
				i++;
				para2Ele.addAttribute("semantic", inMatch.get(i));
			}
		}
	}
	
	public String writeServiceXML(ServiceTree mst, int index) throws IOException {
		String targetServiceName = null;
		return writeServiceXML(mst, index, targetServiceName);
	}
	
	public String writeServiceXML(ServiceTree mst, int index, String targetServiceName) throws IOException {

		Document doc = DocumentHelper.createDocument();
		Element root = null; // doc.addElement("result");
		TreeNode rootNode = mst.root;
		if(index == 0) // get all services.
		{
			root = doc.addElement("concept");
			rootNode = rootNode.children.get(0);
			root.addAttribute("name", rootNode.name);
		}
		else if(index == 1) // get matched services.
		{
			Element root0 = doc.addElement("concept");
			root0.addAttribute("name", targetServiceName);
			if(rootNode == null) // no matched services.
			{
				return doc.asXML();
			}
			root = root0.addElement("concept");
			rootNode = rootNode.children.get(0);
			root.addAttribute("name", rootNode.name);
		}
		constructXML(root, rootNode);
		return doc.asXML();
	}

	private void constructXML(Element root, TreeNode rootNode) {
		for (TreeNode childNode : rootNode.children) {
			String tag = "";
			if (childNode.children.size() == 0)
				tag = "instance";
			else
				tag = "concept";
			Element newConcept = root.addElement(tag);
			newConcept.addAttribute("name", childNode.name);
			if (childNode.children.size() != 0)
				constructXML(newConcept, childNode);
		}
	}
}

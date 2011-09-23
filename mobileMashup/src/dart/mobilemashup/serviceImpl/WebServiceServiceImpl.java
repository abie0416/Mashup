package dart.mobilemashup.serviceImpl;

import java.util.ArrayList;
import java.util.Iterator;
import java.util.Set;

import org.apache.log4j.Logger;
import org.semanticweb.owlapi.model.IRI;
import org.semanticweb.owlapi.model.OWLClass;
import org.semanticweb.owlapi.model.OWLDataFactory;
import org.semanticweb.owlapi.model.OWLDataProperty;
import org.semanticweb.owlapi.model.OWLLiteral;
import org.semanticweb.owlapi.model.OWLNamedIndividual;
import org.semanticweb.owlapi.model.OWLObjectProperty;
import org.semanticweb.owlapi.model.PrefixManager;
import org.semanticweb.owlapi.reasoner.NodeSet;
import org.semanticweb.owlapi.reasoner.OWLReasoner;
import org.semanticweb.owlapi.util.DefaultPrefixManager;

import com.clarkparsia.pellet.owlapiv3.PelletReasoner;

import dart.mobilemashup.service.ParameterService;
import dart.mobilemashup.service.WebServiceService;
import dart.mobilemashup.serviceImpl.recommend.RecommendManager;
import dart.mobilemashup.serviceImpl.recommend.SEMANTICRELATION;
import dart.mobilemashup.serviceImpl.recommend.ServiceTree;
import dart.mobilemashup.serviceImpl.recommend.XMLManager;

public class WebServiceServiceImpl implements WebServiceService {

	private static final String ONTOLOGYPREFIX = "http://www.dart.zju.edu.cn/ontologies/webservices/";
	private static final String OWLSPREFIX = "http://www.daml.org/services/owl-s/1.2/";

	private static final Logger logger = Logger
			.getLogger(AllServicesServiceImpl.class);

	private RecommendManager recommendManager;

	public WebServiceServiceImpl(RecommendManager rs) {
		super();
		recommendManager = rs;
	}

	// For service recommendation.
	public String getMatchedServices(String apiName, String serviceName,
			String realPath, String targetServiceName) {
		String result = "";
		try {
			logger.info("function: getMatchedServices" + "?apiName=" + apiName
					+ "&serviceName=" + serviceName + "&targetServiceName="
					+ targetServiceName);
			ArrayList<String> outputParas1 = new ArrayList<String>();
			ArrayList<String> inputParas1 = new ArrayList<String>();

			// OWLOntologyManager manager = recommendManager.manager;
			OWLDataFactory factory = recommendManager.factory;
			PrefixManager pm = new DefaultPrefixManager(OWLSPREFIX);

			// configure reasoner.
			PelletReasoner reasoner = recommendManager.reasoner;

			// get parameters of target service.
			IRI targetServiceIRI = IRI.create(ONTOLOGYPREFIX + apiName
					+ ".owl#" + serviceName);
			OWLNamedIndividual service1 = factory
					.getOWLNamedIndividual(targetServiceIRI); // UserInputService
			// individual.
			getParaTypes(service1, outputParas1, inputParas1, factory, pm,
					reasoner);
			logger.info("Parameters of target service retrieved!");

			// get all service instances.
			IRI serviceClassIRI = IRI
					.create(OWLSPREFIX + "Service.owl#Service");
			OWLClass Service = factory.getOWLClass(serviceClassIRI);
			NodeSet<OWLNamedIndividual> serviceInstances = reasoner
					.getInstances(Service, false);
			logger.info("Service instances number:"
					+ serviceInstances.getNodes().size());

			Iterator<OWLNamedIndividual> sit = serviceInstances.getFlattened()
					.iterator();
			ArrayList<ArrayList<String>> serviceSupers = new ArrayList<ArrayList<String>>();
			while (sit.hasNext()) {
				OWLNamedIndividual service2 = sit.next();
				ArrayList<String> outputParas2 = new ArrayList<String>();
				ArrayList<String> inputParas2 = new ArrayList<String>();
				getParaTypes(service2, outputParas2, inputParas2, factory, pm,
						reasoner);
				int matchIndex = 0; // 0: no match; 1: out match; 2: in match;
				// 3: both match
				logger.info("Now the service is :" + service2.getIRI());
				matchIndex = judgeMatch(outputParas1, inputParas1,
						outputParas2, inputParas2, matchIndex);
				logger.info("matchIndex:" + matchIndex);
				switch (matchIndex) {
				case 3:
				case 2:
				case 1:
					recommendManager.getSupers(reasoner, service2,
							serviceSupers);
					System.out.println(service2.getIRI().getFragment());
					System.out.println(service2.getIRI().getScheme());
					System.out.println(service2.getIRI().getStart());
					break;
				case 0:
					break;
				}

			}

			ServiceTree mst = new ServiceTree();
			mst.constructTree(serviceSupers);
			XMLManager xm = new XMLManager();
			result = xm.writeServiceXML(mst, 1, targetServiceName);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	// For parameter configuration which the from-node is the USERINPUT node.
	public String getUserinputMatchedParas(String api2Name, String service2Name) {
		String result = null;
		try {
			OWLDataFactory factory = recommendManager.factory;
			PrefixManager pm = new DefaultPrefixManager(OWLSPREFIX);

			// configure reasoner.
			PelletReasoner reasoner = recommendManager.reasoner;

			// get parameters of to-node service.
			ArrayList<String> outputParas2 = new ArrayList<String>();
			ArrayList<String> inputParas2 = new ArrayList<String>();
			ArrayList<String> inputParaValues2 = new ArrayList<String>();
			IRI service2IRI = IRI.create(ONTOLOGYPREFIX + api2Name + ".owl#"
					+ service2Name);
			OWLNamedIndividual service2 = factory
					.getOWLNamedIndividual(service2IRI);
			getParas(service2, outputParas2, inputParas2, factory, pm, reasoner);
			getParaValues(service2, inputParaValues2, factory, pm, reasoner);
			logger.info("Parameters of to-node service retrieved!");

			ArrayList<ArrayList<String>> outMatches = new ArrayList<ArrayList<String>>();
			// get outMatches: service1.outputs->service2.inputs
			getUserinputMatch(inputParas2,
					inputParaValues2, outMatches);

			XMLManager xm = new XMLManager();
			result = xm.writeMatchParaXML(outMatches, outputParas2);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	private void getUserinputMatch(ArrayList<String> inputParas2, ArrayList<String> inputParaValues2,
			ArrayList<ArrayList<String>> outMatches) {
		for (int i = 0; i < inputParas2.size(); i++) {
			ArrayList<String> outMatch = new ArrayList<String>();
			outMatch.add(inputParas2.get(i));
			outMatch.add(inputParaValues2.get(i));
			outMatch.add(inputParas2.get(i));
			outMatch.add(SEMANTICRELATION.SYNONYMY);
			outMatches.add(outMatch);
		}
	}

	// For parameter configuration.
	public String getMatchedParas(String api1Name, String service1Name,
			String api2Name, String service2Name) {
		String result = null;
		try {
			OWLDataFactory factory = recommendManager.factory;
			PrefixManager pm = new DefaultPrefixManager(OWLSPREFIX);

			// configure reasoner.
			PelletReasoner reasoner = recommendManager.reasoner;

			// get parameters of from-node service.
			ArrayList<String> outputParas1 = new ArrayList<String>();
			ArrayList<String> inputParas1 = new ArrayList<String>();
			ArrayList<String> inputParaValues1 = new ArrayList<String>();
			ArrayList<String> outputParaTypes1 = new ArrayList<String>();
			ArrayList<String> inputParaTypes1 = new ArrayList<String>();
			IRI service1IRI = IRI.create(ONTOLOGYPREFIX + api1Name + ".owl#"
					+ service1Name);
			OWLNamedIndividual service1 = factory
					.getOWLNamedIndividual(service1IRI);
			getParas(service1, outputParas1, inputParas1, factory, pm, reasoner);
			getParaValues(service1, inputParaValues1, factory, pm, reasoner);
			getParaTypes(service1, outputParaTypes1, inputParaTypes1, factory,
					pm, reasoner);
			logger.info("Parameters of from-node service retrieved!");

			// get parameters of to-node service.
			ArrayList<String> outputParas2 = new ArrayList<String>();
			ArrayList<String> inputParas2 = new ArrayList<String>();
			ArrayList<String> inputParaValues2 = new ArrayList<String>();
			ArrayList<String> outputParaTypes2 = new ArrayList<String>();
			ArrayList<String> inputParaTypes2 = new ArrayList<String>();
			IRI service2IRI = IRI.create(ONTOLOGYPREFIX + api2Name + ".owl#"
					+ service2Name);
			OWLNamedIndividual service2 = factory
					.getOWLNamedIndividual(service2IRI);
			getParas(service2, outputParas2, inputParas2, factory, pm, reasoner);
			getParaValues(service2, inputParaValues2, factory, pm, reasoner);
			getParaTypes(service2, outputParaTypes2, inputParaTypes2, factory,
					pm, reasoner);
			logger.info("Parameters of to-node service retrieved!");

			ArrayList<ArrayList<String>> outMatches = new ArrayList<ArrayList<String>>();
			// get outMatches: service1.outputs->service2.inputs
			getMatch(inputParaTypes2, outputParaTypes1, inputParas2,
					outputParas1, inputParaValues2, outMatches);

			XMLManager xm = new XMLManager();
			result = xm.writeMatchParaXML(outMatches, outputParas2);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;
	}

	// get fragment of parameter's URI
	private void getParas(OWLNamedIndividual serviceIndividual,
			ArrayList<String> outputParas, ArrayList<String> inputParas,
			OWLDataFactory factory, PrefixManager pm, OWLReasoner reasoner) {
		OWLNamedIndividual processIndividual = getProcIndividual(factory, pm,
				reasoner, serviceIndividual);
		Set<OWLNamedIndividual> outputIndividuals = getOutputIndividuals(
				factory, pm, reasoner, processIndividual);
		Set<OWLNamedIndividual> inputIndividuals = getInputIndividuals(factory,
				pm, reasoner, processIndividual);
		for (OWLNamedIndividual output : outputIndividuals) {
			outputParas.add(output.getIRI().getFragment());
		}
		for (OWLNamedIndividual input : inputIndividuals) {
			inputParas.add(input.getIRI().getFragment());
		}

	}

	// get default value of parameter.
	private void getParaValues(OWLNamedIndividual serviceIndividual,
			ArrayList<String> inputParaValues, OWLDataFactory factory,
			PrefixManager pm, OWLReasoner reasoner) {
		OWLNamedIndividual processIndividual = getProcIndividual(factory, pm,
				reasoner, serviceIndividual);
		Set<OWLNamedIndividual> inputIndividuals = getInputIndividuals(factory,
				pm, reasoner, processIndividual);
		OWLDataProperty parameterValueDataProperty = factory
				.getOWLDataProperty(IRI.create(OWLSPREFIX
						+ "Process.owl#parameterValue"));

		if (inputParaValues != null) {
			getParaValues(reasoner, processIndividual,
					parameterValueDataProperty, inputParaValues,
					inputIndividuals);
		}
	}

	private void getParaValues(OWLReasoner reasoner,
			OWLNamedIndividual processIndividual,
			OWLDataProperty parameterValueDataProperty,
			ArrayList<String> paraValues,
			Set<OWLNamedIndividual> paraIndividuals) {
		Iterator<OWLNamedIndividual> it = paraIndividuals.iterator();
		while (it.hasNext()) {
			OWLNamedIndividual individual = it.next();
			Set<OWLLiteral> inputValues = reasoner.getDataPropertyValues(
					individual, parameterValueDataProperty);
			if (inputValues.size() > 0) {
				OWLLiteral inputValue = (OWLLiteral) reasoner
						.getDataPropertyValues(individual,
								parameterValueDataProperty).toArray()[0];
				paraValues.add(inputValue.getLiteral());
			} else {
				paraValues.add("not set");
			}
		}
	}

	private Set<OWLNamedIndividual> getInputIndividuals(OWLDataFactory factory,
			PrefixManager pm, OWLReasoner reasoner,
			OWLNamedIndividual processIndividual) {
		OWLObjectProperty hasInputProperty = factory.getOWLObjectProperty(
				":Process.owl#hasInput", pm);
		Set<OWLNamedIndividual> inputIndividuals = reasoner
				.getObjectPropertyValues(processIndividual, hasInputProperty)
				.getFlattened();
		return inputIndividuals;
	}

	private Set<OWLNamedIndividual> getOutputIndividuals(
			OWLDataFactory factory, PrefixManager pm, OWLReasoner reasoner,
			OWLNamedIndividual processIndividual) {
		OWLObjectProperty hasOutputProperty = factory.getOWLObjectProperty(
				":Process.owl#hasOutput", pm);
		Set<OWLNamedIndividual> outputIndividuals = reasoner
				.getObjectPropertyValues(processIndividual, hasOutputProperty)
				.getFlattened();
		return outputIndividuals;
	}

	private void getMatch(ArrayList<String> inputParaTypes1,
			ArrayList<String> outputParaTypes2, ArrayList<String> inputParas1,
			ArrayList<String> outputParas2, ArrayList<String> inputParaValues1,
			ArrayList<ArrayList<String>> inMatches) {
		ParameterService ps = new ParameterServiceImpl();
		for (int i = 0; i < inputParas1.size(); i++) {
			String paraType1 = inputParaTypes1.get(i);
			ArrayList<String> inMatch = new ArrayList<String>();
			inMatch.add(inputParas1.get(i));
			inMatch.add(inputParaValues1.get(i));
			for (int j = 0; j < outputParas2.size(); j++) {
				String para2 = outputParas2.get(j);
				String paraType2 = outputParaTypes2.get(j);
				String matchResult = ps.getSemanticRelation(paraType1,
						paraType2, recommendManager);
				if (!matchResult.equals(SEMANTICRELATION.NONE)) {
					inMatch.add(para2);
					inMatch.add(matchResult);
				}
			}
			inMatches.add(inMatch);
		}
	}

	private int judgeMatch(ArrayList<String> outputParas1,
			ArrayList<String> inputParas1, ArrayList<String> outputParas2,
			ArrayList<String> inputParas2, int matchIndex) {
		Iterator<String> it2 = outputParas2.iterator();
		Iterator<String> it1 = null;
		ParameterService ps = new ParameterServiceImpl();
		while (it2.hasNext()) {
			String output2 = it2.next();
			it1 = inputParas1.iterator();
			while (it1.hasNext()) {
				String input1 = it1.next();
				if (!ps.getSemanticRelation(input1, output2, recommendManager)
						.equals(SEMANTICRELATION.NONE)) {
					matchIndex = 2;
					break;
				}
			}
		}
		it1 = outputParas1.iterator();
		while (it1.hasNext()) {

			String output1 = it1.next();
			it2 = inputParas2.iterator();
			while (it2.hasNext()) {
				String input2 = it2.next();
				// System.out.println(input2 + "#" + output1);
				if (!ps.getSemanticRelation(input2, output1, recommendManager)
						.equals(SEMANTICRELATION.NONE)) {
					if (matchIndex == 2)
						matchIndex = 3;
					else
						matchIndex = 1;
					System.out.println("some paras matched");
					break;
				}
			}
		}
		return matchIndex;
	}

	/**
	 * @param apiName
	 * @param serviceName
	 * @param outputParas :
	 *            outputParas can be null.
	 * @param inputParas :
	 *            inputParas can be null.
	 * @param factory
	 * @param pm
	 * @param reasoner
	 */
	private void getParaTypes(OWLNamedIndividual serviceIndividual,
			ArrayList<String> outputParaTypes,
			ArrayList<String> inputParaTypes, OWLDataFactory factory,
			PrefixManager pm, OWLReasoner reasoner) {
		// get parameterTypes of inputs and outputs given API name and service
		// name.

		OWLNamedIndividual processIndividual = getProcIndividual(factory, pm,
				reasoner, serviceIndividual);
		Set<OWLNamedIndividual> outputIndividuals = getOutputIndividuals(
				factory, pm, reasoner, processIndividual);
		Set<OWLNamedIndividual> inputIndividuals = getInputIndividuals(factory,
				pm, reasoner, processIndividual);
		OWLDataProperty parameterTypeDataProperty = factory
				.getOWLDataProperty(IRI.create(OWLSPREFIX
						+ "Process.owl#parameterType"));

		if (outputParaTypes != null) {
			getParaTypes(reasoner, processIndividual,
					parameterTypeDataProperty, outputParaTypes,
					outputIndividuals);
		}

		if (inputParaTypes != null) {
			getParaTypes(reasoner, processIndividual,
					parameterTypeDataProperty, inputParaTypes, inputIndividuals);
		}

	}

	/**
	 * @param reasoner
	 * @param processIndividual
	 * @param parameterTypeDataProperty
	 * @param outputParas
	 * @param hasOutputProperty
	 */
	private void getParaTypes(OWLReasoner reasoner,
			OWLNamedIndividual processIndividual,
			OWLDataProperty parameterTypeDataProperty,
			ArrayList<String> paraTypes, Set<OWLNamedIndividual> paraIndividuals) {
		Iterator<OWLNamedIndividual> it = paraIndividuals.iterator();
		while (it.hasNext()) {
			OWLNamedIndividual individual = it.next();
			OWLLiteral outputClassname = (OWLLiteral) reasoner
					.getDataPropertyValues(individual,
							parameterTypeDataProperty).toArray()[0];
			paraTypes.add(outputClassname.getLiteral());
			// System.out.println(outputClassname.getLiteral());
		}
	}

	/**
	 * @param factory
	 * @param pm
	 * @param reasoner
	 * @param serviceIndividual
	 * @return
	 */
	private OWLNamedIndividual getProcIndividual(OWLDataFactory factory,
			PrefixManager pm, OWLReasoner reasoner,
			OWLNamedIndividual serviceIndividual) {
		// get process Individual.
		OWLObjectProperty describedByProperty = factory.getOWLObjectProperty(
				":Service.owl#describedBy", pm);
		NodeSet<OWLNamedIndividual> tempSet = reasoner.getObjectPropertyValues(
				serviceIndividual, describedByProperty);
		// System.out.println(tempSet.getFlattened().size());
		OWLNamedIndividual processIndividual = null;
		if (tempSet.getFlattened().size() > 0)
			processIndividual = (OWLNamedIndividual) tempSet.getFlattened()
					.toArray()[0];
		return processIndividual;
	}
}

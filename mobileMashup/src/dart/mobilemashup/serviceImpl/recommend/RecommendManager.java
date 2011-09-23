package dart.mobilemashup.serviceImpl.recommend;

import java.io.File;
import java.util.ArrayList;
import java.util.Iterator;

import org.apache.log4j.Logger;
import org.semanticweb.owlapi.apibinding.OWLManager;
import org.semanticweb.owlapi.model.IRI;
import org.semanticweb.owlapi.model.OWLClass;
import org.semanticweb.owlapi.model.OWLDataFactory;
import org.semanticweb.owlapi.model.OWLNamedIndividual;
import org.semanticweb.owlapi.model.OWLOntology;
import org.semanticweb.owlapi.model.OWLOntologyCreationException;
import org.semanticweb.owlapi.model.OWLOntologyManager;
import org.semanticweb.owlapi.model.PrefixManager;
import org.semanticweb.owlapi.reasoner.NodeSet;
import org.semanticweb.owlapi.util.DefaultPrefixManager;

import com.clarkparsia.pellet.owlapiv3.PelletReasoner;
import com.clarkparsia.pellet.owlapiv3.PelletReasonerFactory;

import dart.mobilemashup.serviceImpl.AllServicesServiceImpl;

public class RecommendManager {
	private static final Logger logger = Logger
	.getLogger(AllServicesServiceImpl.class);
	public OWLOntology allServicesOntology;
	public PelletReasoner reasoner;
	public OWLOntologyManager manager;
	public OWLDataFactory factory;
	public PrefixManager pm;
	private static String APISTARTINDEX = "/";
	private static String APIENDINDEX = ".owl";
	private static String SERVICEINDEX = "Service";
	
	private static final String OWLSPREFIX = "http://www.daml.org/services/owl-s/1.2/";
	
	public RecommendManager(String realPath) throws OWLOntologyCreationException {
		manager = OWLManager.createOWLOntologyManager();
		factory = manager.getOWLDataFactory();
		pm = new DefaultPrefixManager(OWLSPREFIX);
		// load AllServices.owl.
		File allServicesFile = new File(realPath
				+ "\\ontologies\\AllServices.owl");
		IRI iri = IRI.create(allServicesFile);
		allServicesOntology = manager
				.loadOntologyFromOntologyDocument(iri);
		logger.info("Loading ontology " + allServicesOntology
				+ " succeeded!\n");

		// configure reasoner.
		reasoner = PelletReasonerFactory.getInstance()
				.createReasoner(allServicesOntology);
		reasoner.prepareReasoner();
		reasoner.getKB().printClassTree();
		boolean consistent = reasoner.isConsistent();
		logger.info("Reasoner consistent: " + consistent + "\n");
	}
	
	public void getSuperClass(PelletReasoner reasoner,
			ArrayList<String> supers, OWLClass oc) {
		NodeSet<OWLClass> superClasses = reasoner.getSuperClasses(oc, true);
		if (superClasses.getFlattened().size() > 0) {
			OWLClass superClass = (OWLClass) superClasses.getFlattened()
					.toArray()[0];
			supers.add(superClass.getIRI().getFragment());
			System.out.print("-" + superClass.getIRI().getFragment());
			getSuperClass(reasoner, supers, superClass);
		}
	}
	
	public void getSupers(PelletReasoner reasoner,
			OWLNamedIndividual service2,
			ArrayList<ArrayList<String>> serviceSupers) {
		logger.info("Now the service is :" + service2.getIRI() + "\n");

		ArrayList<String> supers = new ArrayList<String>();
		String serviceName = service2.getIRI().getFragment();
		String serviceNameShort = serviceName.substring(0, serviceName.lastIndexOf(SERVICEINDEX));
		String start = service2.getIRI().getStart();
		String apiName = start.substring(start.lastIndexOf(APISTARTINDEX)+1, start.indexOf(APIENDINDEX));
		String apiNameShort = apiName.substring(0, apiName.lastIndexOf(SERVICEINDEX));
		supers.add(apiNameShort+"."+serviceNameShort);
		serviceSupers.add(supers);
		NodeSet<OWLClass> serviceTypes = reasoner.getTypes(service2,
				true);
		for (OWLClass oc : serviceTypes.getFlattened()) {
			String className = oc.getIRI().getFragment();
			if (!className.equals("Service")) // get api class
			// types.
			{
				supers.add(className);
				System.out.print("Class chain:" + className);
				getSuperClass(reasoner, supers, oc);
				System.out.println();
			}
		}
	}

}

package dart.mobilemashup.serviceImpl;

import java.util.ArrayList;
import java.util.Iterator;

import org.apache.log4j.Logger;
import org.semanticweb.owlapi.model.IRI;
import org.semanticweb.owlapi.model.OWLClass;
import org.semanticweb.owlapi.model.OWLDataFactory;
import org.semanticweb.owlapi.model.OWLNamedIndividual;
import org.semanticweb.owlapi.reasoner.NodeSet;

import com.clarkparsia.pellet.owlapiv3.PelletReasoner;

import dart.mobilemashup.service.AllServicesService;
import dart.mobilemashup.serviceImpl.recommend.RecommendManager;
import dart.mobilemashup.serviceImpl.recommend.ServiceTree;
import dart.mobilemashup.serviceImpl.recommend.XMLManager;

public class AllServicesServiceImpl implements AllServicesService {

	private static final String ONTOLOGYPREFIX = "http://www.dart.zju.edu.cn/ontologies/webservices/";
	private static final String OWLSPREFIX = "http://www.daml.org/services/owl-s/1.2/";

	private static final Logger logger = Logger
			.getLogger(AllServicesServiceImpl.class);

	private RecommendManager recommendManager;
	
	public AllServicesServiceImpl(RecommendManager rs) {
		super();
		recommendManager = rs;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see dart.mobilemashup.serviceImpl.AllServicesService#getAllServices(java.lang.String)
	 */
	public String getAllServices(String realPath) {
		String result = "";
		try {
//			OWLOntologyManager manager = recommendSession.manager;
			OWLDataFactory factory = recommendManager.factory;

			// configure reasoner.
			PelletReasoner reasoner = recommendManager.reasoner;

			// get all service instances.
			IRI serviceClassIRI = IRI
					.create(OWLSPREFIX + "Service.owl#Service");
			OWLClass Service = factory.getOWLClass(serviceClassIRI);
			NodeSet<OWLNamedIndividual> serviceInstances = reasoner
					.getInstances(Service, false);
			logger.info("Service instances number:"
					+ serviceInstances.getNodes().size() + "\n");

			Iterator<OWLNamedIndividual> sit = serviceInstances.getFlattened()
					.iterator();
			ArrayList<ArrayList<String>> serviceSupers = new ArrayList<ArrayList<String>>();
			while (sit.hasNext()) {
				OWLNamedIndividual service2 = sit.next();
				recommendManager.getSupers(reasoner, service2, serviceSupers);
			}

			ServiceTree mst = new ServiceTree();
			mst.constructTree(serviceSupers);
			XMLManager xm = new XMLManager();
			result = xm.writeServiceXML(mst, 0);

		} catch (Exception e) {
			e.printStackTrace();
		}
		return result;

	}




}

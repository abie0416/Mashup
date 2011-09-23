package dart.mobilemashup.serviceImpl;

import java.io.File;
import java.util.Set;

import org.semanticweb.owlapi.apibinding.OWLManager;
import org.semanticweb.owlapi.model.IRI;
import org.semanticweb.owlapi.model.OWLClass;
import org.semanticweb.owlapi.model.OWLClassExpression;
import org.semanticweb.owlapi.model.OWLDataFactory;
import org.semanticweb.owlapi.model.OWLOntology;
import org.semanticweb.owlapi.model.OWLOntologyCreationException;
import org.semanticweb.owlapi.model.OWLOntologyManager;
import org.semanticweb.owlapi.model.PrefixManager;
import org.semanticweb.owlapi.reasoner.Node;
import org.semanticweb.owlapi.util.DefaultPrefixManager;

import com.clarkparsia.pellet.owlapiv3.PelletReasoner;

import dart.mobilemashup.service.ParameterService;
import dart.mobilemashup.serviceImpl.recommend.RecommendManager;
import dart.mobilemashup.serviceImpl.recommend.SEMANTICRELATION;

public class ParameterServiceImpl implements ParameterService {

	private static final String ONTOLOGYPREFIX = "http://www.dart.zju.edu.cn/ontologies/webservices/";
	private static final String OWLSPREFIX = "http://www.daml.org/services/owl-s/1.2/";



	/*
	 * (non-Javadoc)
	 * 
	 * @see dart.mobilemashup.serviceImpl.ParameterService#getSemanticRelation(java.lang.String,
	 *      java.lang.String)
	 */
	public String getSemanticRelation(String para1IRI, String para2IRI, RecommendManager rm) {
		String result = SEMANTICRELATION.NONE;

		if(judgeSemanticEqual(para1IRI, para2IRI, rm))
		{
			result = SEMANTICRELATION.SYNONYMY;
		}
		else if(judgeSemanticSuper(para1IRI, para2IRI, rm))
		{
			result = SEMANTICRELATION.HYPONYMY;
		}
		else if(judgeSemanticSuper(para2IRI, para1IRI, rm))
		{
			result = SEMANTICRELATION.HYPERNYMY;
		}
		try {
			OWLOntologyManager manager = rm.manager;
			OWLDataFactory factory = rm.factory;
			PelletReasoner reasoner = rm.reasoner;
			PrefixManager pm = rm.pm;
			
//			OWLClass para1Class = factory.getOWLClass(IRI.create(para1));
//			Node<OWLClass> para1Equal = reasoner.getEquivalentClasses(para1Class);
//			Set<OWLClass> set = s.getEntities();
//			// load AllServices.owl.
//			String realPath = System.getProperty("user.dir");
//			System.out.println(realPath);
//			File conceptsFile = new File(realPath
//					+ "\\ontologies\\Conpects.owl");
//			IRI iri = IRI.create(conceptsFile);
//			OWLOntology conceptsOntology = manager
//					.loadOntologyFromOntologyDocument(iri);
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}

		return result;
	}
	
	private boolean judgeSemanticSuper(String para1IRI, String para2IRI, RecommendManager rm)
	{
		OWLDataFactory factory = rm.factory;
		PelletReasoner reasoner = rm.reasoner;
		
		OWLClass para1Class = factory.getOWLClass(IRI.create(para1IRI));
		Set<OWLClass> para1SuperClasses = reasoner.getSuperClasses(para1Class, false).getFlattened();
		for(OWLClass c:para1SuperClasses)
		{
			String iri = c.getIRI().toString();
			if(iri.equals(para2IRI))
			{
				return true;
			}
		}
		return false;
	}
	
	private boolean judgeSemanticEqual(String para1IRI, String para2IRI, RecommendManager rm)
	{
		try {
//			OWLOntologyManager manager = rm.manager;
			OWLDataFactory factory = rm.factory;
			PelletReasoner reasoner = rm.reasoner;
			
			OWLClass para1Class = factory.getOWLClass(IRI.create(para1IRI));
			Node<OWLClass> para1EqualNode = reasoner.getEquivalentClasses(para1Class);
			Set<OWLClass> para1EqualClasses = para1EqualNode.getEntities();
			for(OWLClass c:para1EqualClasses)
			{
				String iri = c.getIRI().toString();
				if(iri.equals(para2IRI))
				{
					return true;
				}
			}
		} catch (Exception e) {
			// TODO Auto-generated catch block
			e.printStackTrace();
		}
		return false;
	}

}

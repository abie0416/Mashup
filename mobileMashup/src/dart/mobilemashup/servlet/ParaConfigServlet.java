package dart.mobilemashup.servlet;

// Example: http://localhost:8080/mobileMashup/paraConfig?
// 		service1Name=Flickr.GetGeotaggedImage&service2Name=SinaMicroBlog.UpdateStatus

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.semanticweb.owlapi.model.OWLOntologyCreationException;

import dart.mobilemashup.service.WebServiceService;
import dart.mobilemashup.serviceImpl.WebServiceServiceImpl;
import dart.mobilemashup.serviceImpl.recommend.RecommendManager;

public class ParaConfigServlet extends HttpServlet {

	private static String RECOMMENDCONTEXT = "RECOMMENDCONTEXT";
	private static String SEPARATOR1 = ".";
	private static String SEPARATOR2 = "_";
	private static String INPUT1PARA = "service1Name";
	private static String INPUT2PARA = "service2Name";
	private static String POSTFIX = "Service";
	private static String USERINPUT = "USERINPUTService";
	
	/**
	 * The doGet method of the servlet. <br>
	 *
	 * This method is called when a form has its tag value method equals to get.
	 * 
	 * @param request the request send by the client to the server
	 * @param response the response send by the server to the client
	 * @throws ServletException if an error occurred
	 * @throws IOException if an error occurred
	 */
	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		doPost(request, response);
	}

	/**
	 * The doPost method of the servlet. <br>
	 *
	 * This method is called when a form has its tag value method equals to post.
	 * 
	 * @param request the request send by the client to the server
	 * @param response the response send by the server to the client
	 * @throws ServletException if an error occurred
	 * @throws IOException if an error occurred
	 */
	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

//		String service1Name = "MyServiceService";
//		String api1Name = "UserInputService";
//		String service2Name = "UpdateStatusService";
//		String api2Name = "TwitterService";
		String service1NameLong = request.getParameter(INPUT1PARA); // Sample:"UserInput.MyService_123"
		System.out.println("service1Name="+service1NameLong);
		String api1Name = service1NameLong.substring(0, service1NameLong.indexOf(SEPARATOR1))+POSTFIX;
		String service1Name = null;
		if(service1NameLong.contains(SEPARATOR2))
			service1Name = service1NameLong.substring(service1NameLong.indexOf(SEPARATOR1)+1, service1NameLong.indexOf(SEPARATOR2))+POSTFIX;
		else
			service1Name = service1NameLong.substring(service1NameLong.indexOf(SEPARATOR1)+1)+POSTFIX;
		String service2NameLong = request.getParameter(INPUT2PARA); // Sample:"UserInput.MyService_123"
		System.out.println("service2Name="+service2NameLong);
		String api2Name = service2NameLong.substring(0, service2NameLong.indexOf(SEPARATOR1))+POSTFIX;
		String service2Name = null;
		if(service2NameLong.contains(SEPARATOR2))
			service2Name = service2NameLong.substring(service2NameLong.indexOf(SEPARATOR1)+1, service2NameLong.indexOf(SEPARATOR2))+POSTFIX;
		else
			service2Name = service2NameLong.substring(service2NameLong.indexOf(SEPARATOR1)+1)+POSTFIX;
		String realPath = request.getSession().getServletContext().getRealPath("\\");
		
		RecommendManager rm = null;
		
		if(this.getServletContext().getAttribute(RECOMMENDCONTEXT)==null)
		{
			try {
				rm = new RecommendManager(realPath);
			} catch (OWLOntologyCreationException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			this.getServletContext().setAttribute(RECOMMENDCONTEXT, rm);
		}
		else
		{
			rm = (RecommendManager)this.getServletContext().getAttribute(RECOMMENDCONTEXT);
		}
//		/*** test ***/
//		ParameterService ps = new ParameterServiceImpl();
////		String s = ps.getSemanticRelation("http://www.dart.zju.edu.cn/ontologies/webservices/Concepts.owl#Image", "http://www.dart.zju.edu.cn/ontologies/webservices/Concepts.owl#Picture", rm);
//		String s = ps.getSemanticRelation("http://www.dart.zju.edu.cn/ontologies/webservices/UserProfile.owl#Status", "http://www.dart.zju.edu.cn/ontologies/webservices/Concepts.owl#Image", rm);
//		/*** test ***/
		WebServiceService wss = new WebServiceServiceImpl(rm);
		String result = null;
		if(api1Name.equals(USERINPUT))
		{
			result = wss.getUserinputMatchedParas(api2Name, service2Name);
		}
		else {
			result = wss.getMatchedParas(api1Name, service1Name, api2Name, service2Name);
		}
		response.getWriter().write(result);
	}

}

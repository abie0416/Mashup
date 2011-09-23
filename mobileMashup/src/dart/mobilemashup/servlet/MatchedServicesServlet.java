package dart.mobilemashup.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.semanticweb.owlapi.model.OWLOntologyCreationException;

import dart.mobilemashup.service.WebServiceService;
import dart.mobilemashup.serviceImpl.WebServiceServiceImpl;
import dart.mobilemashup.serviceImpl.recommend.RecommendManager;

public class MatchedServicesServlet extends HttpServlet {

	private static String RECOMMENDCONTEXT = "RECOMMENDCONTEXT";
	private static String SEPARATOR1 = ".";
	private static String SEPARATOR2 = "_";
	private static String INPUTPARA = "serviceName";
	private static String POSTFIX = "Service";
	
	/**
	 * 
	 */
	private static final long serialVersionUID = 1L;

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

		doService(request, response);
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

		doService(request, response);
	}
	
	public synchronized void doService(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
		// get service and API to be matched.
		String serviceNameLong = request.getParameter(INPUTPARA); // Sample:"UserInput.MyService_123"
		String apiName = serviceNameLong.substring(0, serviceNameLong.indexOf(SEPARATOR1))+POSTFIX;
		String serviceName = null;
		if(serviceNameLong.contains(SEPARATOR2))
			serviceName = serviceNameLong.substring(serviceNameLong.indexOf(SEPARATOR1)+1, serviceNameLong.indexOf(SEPARATOR2))+POSTFIX;
		else
			serviceName = serviceNameLong.substring(serviceNameLong.indexOf(SEPARATOR1)+1)+POSTFIX;
//		String apiName = "UserInputService";
//		String serviceName = "MyServiceService";
		System.out.println(request.getContextPath());
		System.out.println();

		// preparation.
		String realPath = request.getSession().getServletContext().getRealPath("\\");
//		System.out.println(realPath);
		
		RecommendManager rs = null;
		
		if(this.getServletContext().getAttribute(RECOMMENDCONTEXT)==null)
		{
			try {
				rs = new RecommendManager(realPath);
			} catch (OWLOntologyCreationException e) {
				// TODO Auto-generated catch block
				e.printStackTrace();
			}
			this.getServletContext().setAttribute(RECOMMENDCONTEXT, rs);
		}
		else
		{
			rs = (RecommendManager)this.getServletContext().getAttribute(RECOMMENDCONTEXT);
		}
		
		WebServiceService gms = new WebServiceServiceImpl(rs);
		String result = gms.getMatchedServices(apiName, serviceName, realPath, serviceNameLong);
		response.getWriter().write(result);
	}

}

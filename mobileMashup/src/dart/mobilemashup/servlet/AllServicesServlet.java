package dart.mobilemashup.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.semanticweb.owlapi.model.OWLOntologyCreationException;

import dart.mobilemashup.service.AllServicesService;
import dart.mobilemashup.serviceImpl.AllServicesServiceImpl;
import dart.mobilemashup.serviceImpl.recommend.RecommendManager;

public class AllServicesServlet extends HttpServlet {

	private static String RECOMMENDCONTEXT = "RECOMMENDCONTEXT";
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

		doPost(request,response);
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
		String realPath = request.getSession().getServletContext().getRealPath("\\");
		
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
		
		AllServicesService ass = new AllServicesServiceImpl(rs);
		response.getWriter().write(ass.getAllServices(realPath));

	}

}

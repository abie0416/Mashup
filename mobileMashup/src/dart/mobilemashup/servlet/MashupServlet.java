package dart.mobilemashup.servlet;

import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dart.mobilemashup.CodeGenerator;
import dart.mobilemashup.bean.XmlSourceBean;

public class MashupServlet extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doPost(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
//		request.setAttribute("MobileParas", request.getSession().getAttribute("MobileParas"));
		request.setAttribute("source", new XmlSourceBean(request.getParameter("mashupString")));
		CodeGenerator.resultPageString = request.getParameter("resultPageConfig");
		
		request.getRequestDispatcher("/complier").forward(request, response);
	}

}

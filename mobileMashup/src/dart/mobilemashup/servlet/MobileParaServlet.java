package dart.mobilemashup.servlet;

import java.io.IOException;
import java.util.Enumeration;
import java.util.HashMap;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

public class MobileParaServlet extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doPost(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		HashMap<String, Object> mobileParameters = new HashMap<String, Object>();
		Enumeration parameters = request.getParameterNames();
		HttpSession session = request.getSession();
		while(parameters.hasMoreElements())
		{
			String parameterName = (String)parameters.nextElement();
			mobileParameters.put(parameterName, request.getParameter(parameterName));
			System.out.println(parameterName+":"+request.getParameter(parameterName));
		}
		session.setAttribute("MobileParameters", mobileParameters);
		response.sendRedirect("simulate/mashup.jsp");
	}

}

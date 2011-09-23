package dart.mobilemashup.servlet;

import java.io.BufferedInputStream;
import java.io.BufferedOutputStream;
import java.io.File;
import java.io.FileInputStream;
import java.io.IOException;

import javax.servlet.ServletException;
import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import dart.mobilemashup.bean.XmlSourceBean;
import dart.mobilemashup.service.CompilerService;
import dart.mobilemashup.serviceImpl.CompilerServiceImpl;

public class ComplierServlet extends HttpServlet {

	public void doGet(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		doPost(request, response);
	}

	public void doPost(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {
		CompilerService cs = new CompilerServiceImpl();
		File projectFile = null;
		try {
			XmlSourceBean xsb = (XmlSourceBean)request.getAttribute("source");
			String sessionId = request.getSession().getId();
			projectFile = cs.compile(xsb, sessionId);
		} catch (Exception e) {
			e.printStackTrace();
		}
		if (projectFile != null && projectFile.exists()) {
			response.setContentType("application/zip");
			ServletOutputStream sos = response.getOutputStream();
			response.setHeader("Content-disposition", "attachment;filename="
					+ projectFile.getName());
			BufferedInputStream bis = new BufferedInputStream(
					new FileInputStream(projectFile));
			BufferedOutputStream bos = new BufferedOutputStream(sos);
			byte[] buf = new byte[1024];
			int bytesRead;
			while ((bytesRead = bis.read(buf, 0, buf.length)) != -1) {
				bos.write(buf, 0, bytesRead);
			}
			if (bis != null) {
				bis.close();
			}
			if (bos != null) {
				bos.close();
			}
		}
	}

}

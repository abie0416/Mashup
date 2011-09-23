package dart.mobilemashup.util;

import java.io.BufferedReader;
import java.io.FileReader;
import java.io.IOException;
import java.io.InputStreamReader;

import org.apache.log4j.Logger;

import dart.mobilemashup.bean.XmlSourceBean;
import dart.mobilemashup.service.CompilerService;
import dart.mobilemashup.serviceImpl.CompilerServiceImpl;

public class CommandLine {
	private static final String BUILD_FILE = "build.bat";
	private static final Logger logger = Logger
			.getLogger(CommandLine.class);

	public static void main(String[] args) throws Exception {
		CommandLine.executeCommand("D:\\apache-tomcat-6.0.20\\webapps\\mobileMashup\\WEB-INF\\classes\\template\\QML"+ "\\" + BUILD_FILE);
	}
	
	public static void executeCommand(String command) throws Exception {
		boolean error = false;
		try {
			Process process = new ProcessBuilder(command.split(" ")).start();
			BufferedReader results = new BufferedReader(new InputStreamReader(
					process.getInputStream()));
			String out;
			while ((out = results.readLine()) != null) {
				logger.info(out);
			}
			BufferedReader errors = new BufferedReader(new InputStreamReader(process.getErrorStream()));
			while ((out = errors.readLine()) != null) {
				logger.error("Error: " + out);
				error = true;
			}
		} catch (IOException e) {
			e.printStackTrace();
			throw new RuntimeException();
		}
		
		if (error) {
			logger.error("Error when excuting commands : " + command);
			throw new Exception("Error when excuting commands : " + command);
		}
	}
}

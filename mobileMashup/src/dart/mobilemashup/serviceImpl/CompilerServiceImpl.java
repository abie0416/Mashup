package dart.mobilemashup.serviceImpl;

import static org.junit.Assert.fail;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.io.PrintWriter;
import java.net.MalformedURLException;

import org.apache.log4j.Logger;

import dart.mobilemashup.CodeGenerator;
import dart.mobilemashup.MashupBuilder;
import dart.mobilemashup.bean.XmlSourceBean;
import dart.mobilemashup.model.Mashup;
import dart.mobilemashup.service.CompilerService;
import dart.mobilemashup.util.CommandLine;
import dart.mobilemashup.util.FileUtil;
import dart.mobilemashup.util.WorkingDirectory;

public class CompilerServiceImpl implements CompilerService {

	private static final Logger logger = Logger
			.getLogger(CompilerServiceImpl.class);
	private static final String TEMPLATE_FOLDER = "template/QML";
	private static final String BUILD_FILE = "build.bat";
	private static final String BINARY_FILE = "MobileMashup.sisx";
	private static final String CONFIG_FILE_NAME = "config.js";
	private static final String RESULT_PAGE_CONFIG_FILE = "resultPageConfig.js";
	
	private MashupBuilder mb;
	private Mashup mashup;

	// test this compiler
	public static void main(String[] args) throws Exception {
		BufferedReader br = new BufferedReader(new FileReader(
				"D:\\test\\input\\mr.xml"));
		StringBuffer strBuf = new StringBuffer();
		String line;
		while ((line = br.readLine()) != null) {
			strBuf.append(line);
		}
		XmlSourceBean sb = new XmlSourceBean(strBuf.toString());
		CompilerService cs = new CompilerServiceImpl();
		try {
			cs.compile(sb, "D:\\test\\output");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public synchronized File compile(XmlSourceBean sb, String workingDirName)
			throws Exception {
		workingDirName = "QML";
		File workingDir = WorkingDirectory.getWorkingDirectory(workingDirName);
		String templatePath = (CompilerServiceImpl.class.getResource("/")
				.getPath() + TEMPLATE_FOLDER).substring(1).replaceAll("%20",
				" ");
		String binary = workingDir + File.separator + BINARY_FILE;
		//FileUtil.copyFiles(templatePath, workingDir.getAbsolutePath());
		generateFiles(sb, workingDirName);
		//cdOfBuildFile(workingDir.getAbsolutePath());
		try {
			CommandLine.executeCommand(workingDir.getAbsolutePath() + "\\" + BUILD_FILE);
		} catch (Exception e) {
			e.printStackTrace();
		}
		return new File(binary);
	}

	/**
	 * copy template files into the working directory and change the working
	 * directory of build file when running in command line mode
	 */
	public void cdOfBuildFile(String workingDir)
			throws IOException {
		BufferedReader br = new BufferedReader(new FileReader(workingDir + "/"
				+ BUILD_FILE));
		String newLine = "\r\n";
		StringBuffer sb = new StringBuffer();
		sb.append("d:").append(newLine);
		sb.append("cd \"").append(workingDir.replaceAll("/", "\\\\")).append("\"").append(
				newLine);
		String line;
		while ((line = br.readLine()) != null) {
			sb.append(line).append(newLine);
		}
		br.close();
		PrintWriter pw = new PrintWriter(workingDir + "/" + BUILD_FILE);
		pw.write(sb.toString());
		pw.flush();
		pw.close();
	}

	// generate config.js
	private void generateFiles(XmlSourceBean sb, String workingDirName)
			throws Exception {
		// build the mashup object from sb
		mb = new MashupBuilder();
		mashup = mb.build(sb);
		
		// generate config.js
		CodeGenerator cg = new CodeGenerator(mashup);
		try {
			File configFile = new File(WorkingDirectory
					.getWorkingDirectory(workingDirName), CONFIG_FILE_NAME);
			if (!configFile.exists()) {
				configFile.createNewFile();
			}
			cg.generateCode(configFile);
			
			File resultPageFile = new File(WorkingDirectory
					.getWorkingDirectory(workingDirName), RESULT_PAGE_CONFIG_FILE);
			if (!resultPageFile.exists()) {
				resultPageFile.createNewFile();
			}
			cg.generateCode2(resultPageFile);
		} catch (MalformedURLException e) {
			e.printStackTrace();
			fail("cannot find config.js!");
		} catch (IOException e) {
			e.printStackTrace();
			fail("fail to generate config.js");
		}
	}
}

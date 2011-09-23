package dart.mobilemashup.service;

import static org.junit.Assert.fail;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.net.MalformedURLException;
import java.net.URL;

import org.junit.Before;
import org.junit.Test;

import dart.mobilemashup.CodeGenerator;
import dart.mobilemashup.MashupBuilder;
import dart.mobilemashup.bean.XmlSourceBean;
import dart.mobilemashup.model.Mashup;

public class CodeGeneratorTest {

	private static final String XML_FILE_NAME = "sample.xml";
	private static final String CONFIG_FILE_NAME = "config.js";

	private MashupBuilder mmb;
	private XmlSourceBean xmlSource;
	private Mashup mashup;

	@Before
	public void setUp() throws Exception {
		xmlSource = new XmlSourceBean(readXmlFromFile(new File(XML_FILE_NAME)));
		mmb = new MashupBuilder();
		mashup = mmb.build(xmlSource);
	}

	@Test
	public void testGenerateCode() {
		CodeGenerator cg = new CodeGenerator(mashup);
		try {
			cg.generateCode(new File(
					new URL(this.getClass().getResource("."), CONFIG_FILE_NAME)
							.getFile()));
		} catch (MalformedURLException e) {
			e.printStackTrace();
			fail("cannot find config.js!");
		} catch (IOException e) {
			e.printStackTrace();
			fail("fail to generate config.js");
		}
	}

	private String readXmlFromFile(File file) throws FileNotFoundException,
			IOException {
		StringBuffer sb = new StringBuffer();
		BufferedReader in = new BufferedReader(new FileReader(new URL(this
				.getClass().getResource("."), XML_FILE_NAME).getFile()));
		String line;
		while ((line = in.readLine()) != null) {
			sb.append(line.trim());
		}
		return sb.toString();
	}
}

package dart.mobilemashup.service;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import java.net.URL;

import org.junit.Before;
import org.junit.Test;

import dart.mobilemashup.MashupBuilder;
import dart.mobilemashup.bean.XmlSourceBean;
import dart.mobilemashup.model.Mashup;

public class MashupBuilderTest {

	private MashupBuilder mmb;
	private static final String XML_FILE_NAME = "sample.xml";
	private XmlSourceBean xmlSource;

	@Before
	public void setUp() throws Exception {
		xmlSource = new XmlSourceBean(readXmlFromFile(new File(XML_FILE_NAME)));
		mmb = new MashupBuilder();
	}

	@Test
	public void testBuild() throws IOException {
		Mashup mashup = mmb.build(xmlSource);
		assert (mashup != null);
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

package dart.mobilemashup.service;

import java.io.File;

import dart.mobilemashup.bean.XmlSourceBean;

public interface CompilerService {

	public File compile(XmlSourceBean sb, String workingDirName) throws Exception;
}

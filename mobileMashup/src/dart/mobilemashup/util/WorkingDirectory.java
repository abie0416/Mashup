package dart.mobilemashup.util;

import java.io.File;

/**
 * Modification(20110517):
 * no temporary directory and no copy files. 
 * all operations will be in /template/QML.  
 * @author AaronPhang
 *
 */
public class WorkingDirectory {

	private static final String workingDir = "/template";

	private static void delete(File file) {
		if (file.isFile()) {
			file.delete();
		} else {
			for (File f : file.listFiles()) {
				delete(f);
			}
			file.delete();
		}
	}

	public static synchronized void createWorkingDirectory(String dirName) {
//		File folder = new File(WorkingDirectory.class.getResource(workingDir)
//				.getFile().replaceAll("%20", " "), dirName);
//		folder.mkdir();
	}

	public static synchronized void deleteWorkingDirectory(String dirName) {
		//delete(new File(WorkingDirectory.class.getResource(
				//workingDir + File.separator + dirName).getFile().replaceAll("%20", " ")));
	}

	public static synchronized void emptyWorkingDirectory(String dirName) {
		File folder = new File(WorkingDirectory.class.getResource(
				workingDir + File.separator + dirName).getFile().replaceAll("%20", " "));
		for (File f : folder.listFiles()) {
			//delete(f);
		}
	}
	
	public static synchronized void emptyAllWorkingDirectory() {
		File folder = new File(WorkingDirectory.class.getResource(
				workingDir).getFile().replaceAll("%20", " "));
		for (File f : folder.listFiles()) {
			//delete(f);
		}
	}
	
	public static File getWorkingDirectory(String dirName) {
		File dir = new File(WorkingDirectory.class.getResource(workingDir)
				.getFile().replaceAll("%20", " "), dirName);
		if (dir.exists() && dir.isDirectory()) {
			return dir;
		}
		return null;
	}
}

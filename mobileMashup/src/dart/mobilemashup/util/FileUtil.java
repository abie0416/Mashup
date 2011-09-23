package dart.mobilemashup.util;

import java.io.File;
import java.io.FileWriter;
import java.io.IOException;

public class FileUtil {

	public static void move(String from, String to) {
		File dir = new File(from);
		File[] files = dir.listFiles();
		if (files == null)
			return;
		File destinationDir = new File(to);
		destinationDir.deleteOnExit();
		destinationDir.mkdirs();
		for (File file : files) {
			if (file.isDirectory()) {
				move(file.getPath(), to + "/" + file.getName());
			}
			File destinationFile = new File(destinationDir.getPath() + "\\"
					+ file.getName());
			if (destinationFile.exists()) {
				destinationFile.delete();
			}
			file.renameTo(destinationFile);
		}
	}

	public static void moveFile(File file, File destinationDir) {
		File[] files = destinationDir.listFiles();
		for (File f : files) {
			if (f.getName().equalsIgnoreCase(file.getName())) {
				f.delete();
				break;
			}
		}
		File destinationFile = new File(destinationDir.getPath()
				+ File.separator + file.getName());
		file.renameTo(destinationFile);
	}

	public static void copyFiles(String from, String desFolder) {
		File file = new File("copy" + System.currentTimeMillis() + ".bat");
		try {
			file.createNewFile();
			FileWriter fw = new FileWriter(file);
			fw.write("xcopy " + from.replaceAll("/", "\\\\") + "\\* "
					+ desFolder.replaceAll("/", "\\\\") + " /E /H /Y\r\n");
			fw.close();
			CommandLine.executeCommand(file.getAbsolutePath());
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			file.deleteOnExit();
		}

	}

	public static void main(String[] args) {
		copyFiles("D:/folder", "D:/folderX");
	}
}

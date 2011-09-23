package dart.mobilemashup.util;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.util.zip.ZipEntry;
import java.util.zip.ZipOutputStream;

public class ZipCompressor {

	public static void zip(String zipFileName, String inputFile)
			throws Exception {
		ZipOutputStream out = new ZipOutputStream(new FileOutputStream(
				zipFileName));
		File file = new File(inputFile);
		zipFile(out, file, "");
		out.close();
	}

	private static void zipFile(ZipOutputStream out, File file, String base)
			throws Exception {
		if (file.isDirectory()) {
			File[] fl = file.listFiles();
			out.putNextEntry(new ZipEntry(base + "/"));
			base = base.length() == 0 ? "" : base + "/";
			for (int i = 0; i < fl.length; i++) {
				zipFile(out, fl[i], base + fl[i].getName());
			}
		} else {
			out.putNextEntry(new ZipEntry(base));
			FileInputStream in = new FileInputStream(file);
			int b;
			while ((b = in.read()) != -1)
				out.write(b);
			in.close();
		}
	}

	public static void main(String[] args) {
		try {
			ZipCompressor.zip("D:/test/output/mashup.zip", "D:/test/input/QML");
		} catch (Exception e) {
			e.printStackTrace();
		}
	}
}
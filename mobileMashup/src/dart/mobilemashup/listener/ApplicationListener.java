package dart.mobilemashup.listener;

import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;

import dart.mobilemashup.util.WorkingDirectory;

public class ApplicationListener implements ServletContextListener {

	public void contextDestroyed(ServletContextEvent arg0) {
		WorkingDirectory.emptyAllWorkingDirectory();
	}

	public void contextInitialized(ServletContextEvent arg0) {
		WorkingDirectory.emptyAllWorkingDirectory();
	}

}

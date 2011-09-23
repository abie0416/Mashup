package dart.mobilemashup.listener;

import javax.servlet.http.HttpSessionEvent;
import javax.servlet.http.HttpSessionListener;

import org.apache.log4j.Logger;

import dart.mobilemashup.util.WorkingDirectory;

public class SessionListener implements HttpSessionListener {

	private static final Logger logger = Logger.getLogger(SessionListener.class);
	
	public void sessionCreated(HttpSessionEvent event) {
		WorkingDirectory.createWorkingDirectory(event.getSession().getId());
		logger.info("create folder : " + event.getSession().getId() + " for current user");
	}

	public void sessionDestroyed(HttpSessionEvent event) {
		WorkingDirectory.deleteWorkingDirectory(event.getSession().getId());
		logger.info("delete folder : " + event.getSession().getId());
	}

}

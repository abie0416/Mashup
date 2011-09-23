package dart.mobilemashup.service;

public interface WebServiceService {

	public abstract String getMatchedServices(String apiName,
			String serviceName, String realPath, String targetServiceName);

	public abstract String getMatchedParas(String api1Name,
			String service1Name, String api2Name, String service2Name);
	
	public abstract String getUserinputMatchedParas(String api2Name, String service2Name);

}
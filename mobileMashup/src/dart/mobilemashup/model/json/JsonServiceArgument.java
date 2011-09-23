package dart.mobilemashup.model.json;

import org.json.JSONException;

public class JsonServiceArgument extends JsonObj {

	public JsonServiceArgument(String serviceId, String outputName) throws JSONException {
		super();
		jsonObj.accumulate("serviceId", "'" + serviceId + "'");
		jsonObj.accumulate("outputName", "'" + outputName + "'");
	}

}

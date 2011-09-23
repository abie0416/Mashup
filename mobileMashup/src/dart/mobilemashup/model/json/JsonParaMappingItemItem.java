package dart.mobilemashup.model.json;

import org.json.JSONException;

public class JsonParaMappingItemItem extends JsonObj {

	public JsonParaMappingItemItem(String serviceId, String outputName) throws JSONException {
		super();
		jsonObj.accumulate("serviceId", "'" + serviceId + "'");
		jsonObj.accumulate("outputName", "'" + outputName + "'");
	}
	
}

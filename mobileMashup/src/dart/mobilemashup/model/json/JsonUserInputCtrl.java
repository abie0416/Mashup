package dart.mobilemashup.model.json;

import org.json.JSONException;

public class JsonUserInputCtrl extends JsonObj {
	
	public JsonUserInputCtrl(String text, String type) throws JSONException {
		super();
		jsonObj.accumulate("text",  "'" + text + "'");
		jsonObj.accumulate("type",  "'" + type + "'");
	}
	
}

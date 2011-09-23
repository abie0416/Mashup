package dart.mobilemashup.model.json;

import org.json.JSONObject;

public abstract class JsonObj {

	protected JSONObject jsonObj;

	protected JsonObj() {
		jsonObj = new JSONObject();
	}

	public JSONObject getJsonObj() {
		return jsonObj;
	}

	@Override
	public String toString() {
		return jsonObj.toString();
	}

}

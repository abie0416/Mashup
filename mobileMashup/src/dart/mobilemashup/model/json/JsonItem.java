package dart.mobilemashup.model.json;

import org.json.JSONArray;
import org.json.JSONException;

public class JsonItem extends JsonObj {

	public JsonItem(String name, String shortDesc, String longDesc) throws JSONException {
		super();
		jsonObj.accumulate("name", "'" + name + "'");
		jsonObj.accumulate("shortDesc", "'" + shortDesc + "'");
		jsonObj.accumulate("longDesc", "'" + longDesc + "'");
		jsonObj.accumulate("userinputCtrls", new JSONArray());
	}
	
	public void addUserinputCtrl(JsonUserInputCtrl uic) throws JSONException {
		jsonObj.getJSONArray("userinputCtrls").put(uic);
	}
}

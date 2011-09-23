package dart.mobilemashup.model.json;

import org.json.JSONArray;
import org.json.JSONException;

public class JsonDependMap extends JsonObj {

	public void addDependItem(String itemName, JSONArray dependedIds) throws JSONException {
		jsonObj.accumulate(itemName, dependedIds);
	}
	
	public void addNoneDependItem(String itemName) throws JSONException {
		JSONArray arr = new JSONArray();
		arr.put(-1);
		jsonObj.accumulate(itemName, arr);
	}
}

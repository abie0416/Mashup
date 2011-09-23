package dart.mobilemashup.model.json;

import org.json.JSONArray;
import org.json.JSONException;

public class JsonParaMapping extends JsonObj {

	public void addParaMappingItem(String itemName, JSONArray paras)
			throws JSONException {
		jsonObj.accumulate(itemName, paras);
	}
}

package dart.mobilemashup.model.json;

import org.json.JSONException;

public class JsonService extends JsonObj {

	public JsonService(String id, String name) throws JSONException {
		super();
		jsonObj.accumulate("id", "'" + id + "'");
		jsonObj.accumulate("name", "'" + name + "'");
		jsonObj.accumulate("execute", "function(args) {"+ id+".execute(args);}");
	}
}

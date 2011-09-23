package dart.mobilemashup.model.json;

import org.json.JSONArray;

public abstract class JsonArr {
	
	protected JSONArray jsonArr;

	protected JsonArr() {
		jsonArr = new JSONArray();
	}

	@Override
	public String toString() {
		return jsonArr.toString();
	}

}

package dart.mobilemashup.service;

import dart.mobilemashup.serviceImpl.recommend.RecommendManager;

public interface ParameterService {

	public String getSemanticRelation(String para1,
			String para2, RecommendManager rm);
}
package dart.mobilemashup.serviceImpl.recommend;

import java.util.ArrayList;
import java.util.HashMap;

public class TreeNode {
	public ArrayList<TreeNode> children;
	public String name;
	public TreeNode parent;
	public HashMap<String, String> attributes;

	TreeNode() {
		parent = null;
		name = "";
		attributes = new HashMap<String,String>();
		children = new ArrayList<TreeNode>();
	}
}

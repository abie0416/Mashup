/**
 * 
 */
package dart.mobilemashup.serviceImpl.recommend;

import java.util.ArrayList;

/**
 * @author Administrator
 * 
 */
public class ServiceTree {

	public TreeNode root = null;

	public void constructTree(ArrayList<ArrayList<String>> data) {
		// construct a tree with single path.
		if(data.size() == 0) // no services.
			return;
		ArrayList<String> data1 = data.get(0);
		for (int i = 0; i < data1.size(); i++) {
			String nodeV = data1.get(i);
			TreeNode newNode = new TreeNode();
			newNode.name = nodeV;
			if (root != null) {
				newNode.children.add(root);
				root.parent = newNode;
			}
			root = newNode;
		}

		// continue construct the tree with more paths.
		for (int i = 1; i < data.size(); i++) {
			ArrayList<String> dataS = data.get(i);
			ArrayList<TreeNode> nodeIndex = root.children;
			TreeNode newRoot = null;
			boolean hasNode = true;
			for (int j = dataS.size() - 2; j >= 0; j--) // start from the most
			// super class.
			{
				String nodeV = dataS.get(j);
				if (hasNode == true) {
					for (TreeNode node : nodeIndex) {
						if (node.name.equals(nodeV)) {
							nodeIndex = node.children;
							hasNode = true;
							break;
						} else {
							hasNode = false;
						}
					}
				}
				if (!hasNode) // the node is not in the tree yet.
				{
					TreeNode newNode = new TreeNode();
					newNode.name = nodeV;
					if (newRoot == null) {
						newNode.parent = nodeIndex.get(0).parent;
						nodeIndex.get(0).parent.children.add(newNode);
					} else {
						newNode.parent = newRoot;
						newRoot.children.add(newNode);
					}
					newRoot = newNode;
				}
			}
		}

		printTree(root, 0);
	}

	public void printTree(TreeNode node, int depth) {
		if (node != null) {
			for (int i = 0; i < depth; i++)
				System.out.print(".....");
			System.out.println(node.name);
			for (TreeNode n : node.children) {
				printTree(n, depth + 1);
			}
		}
	}

}
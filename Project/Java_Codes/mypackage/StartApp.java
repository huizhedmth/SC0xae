/**
 * to start the app
 */
package mypackage;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;

/**
 * @author Cauchy
 *
 */
public class StartApp {
	public static ArrayList<String> allWords;
	public static HashMap<String, Paper> papers;
	public static ArrayList<String> paperList;

	/**
	 * @param args
	 * @throws IOException 
	 */
	public static void main(String[] args) throws IOException {
		allWords = new ArrayList<String>();
		papers = new HashMap<String, Paper>();
		paperList = new ArrayList<String>();
		XmlParse xml = new XmlParse();

		//process all xmls for papers
		for(int i=1001; i<1080; i++){
			String pid = "P00-" + i;
			paperList.add(pid);
			Paper paper = new Paper(pid, xml.parseXML(pid));
			papers.put(pid, paper);
		}
		
		for(int i=1001; i<1071; i++){
			String pid = "P01-" + i;
			paperList.add(pid);
			Paper paper = new Paper(pid, xml.parseXML(pid));
			papers.put(pid, paper);
		}
		
		for(int i=1001; i<1066; i++){
			String pid = "P02-" + i;
			paperList.add(pid);
			Paper paper = new Paper(pid, xml.parseXML(pid));
			papers.put(pid, paper);
		}
		
		for(int i=1001; i<1072; i++){
			String pid = "P03-" + i;
			paperList.add(pid);
			Paper paper = new Paper(pid, xml.parseXML(pid));
			papers.put(pid, paper);
		}
		
		for(int i=1001; i<1089; i++){
			String pid = "P04-" + i;
			paperList.add(pid);
			Paper paper = new Paper(pid, xml.parseXML(pid));
			papers.put(pid, paper);
		}
		
		for(int i=1001; i<1078; i++){
			String pid = "P05-" + i;
			paperList.add(pid);
			Paper paper = new Paper(pid, xml.parseXML(pid));
			papers.put(pid, paper);
		}
		
		for(int i=1001; i<1148; i++){
			String pid = "P06-" + i;
			paperList.add(pid);
			Paper paper = new Paper(pid, xml.parseXML(pid));
			papers.put(pid, paper);
		}
				
		
		allWords = xml.getAllWords();
		
		System.out.println(allWords.size());
		System.out.println(allWords.toString());
		
		//output the feature matrix of papers
		InputGenerator generator = new InputGenerator(allWords, papers, paperList);
		generator.generateInorder("src/input/matrixInorder.txt");
		
		//parse the users' data
		for(int i=1; i<16; i++){
			String uid = "y" + i;
			String outputFile = "src/input/" + uid + ".txt";
			User user = new User(uid, xml.parseUser(uid));
			//output the feature matrix of the user
			generator.userGenerate(outputFile, user);
		}		
		for(int i=1; i<14; i++){
			String uid = "m" + i;
			String outputFile = "src/input/" + uid + ".txt";
			User user = new User(uid, xml.parseUser(uid));
			//output the feature matrix of the user
			generator.userGenerate(outputFile, user);
		}
		
	}

}

/**
 * to generate the input matrix
 */
package mypackage;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Map.Entry;

/**
 * @author Cauchy
 *
 */
public class InputGenerator {
	private ArrayList<String> allWords;
	private HashMap<String, Paper> papers;
	private ArrayList<String> paperList;
	
	public InputGenerator(ArrayList<String> allWords, HashMap<String, Paper> papers, ArrayList<String> paperList){
		this.allWords = new ArrayList<String>();
		this.papers = new HashMap<String, Paper>();
		this.paperList = new ArrayList<String>();
		
		this.allWords = allWords;
		this.papers = papers;
		this.paperList = paperList;
	}
	
	//output the feature matrix of the user
	public void userGenerate(String filename, User user) throws IOException{
		PrintWriter out  = new PrintWriter(filename);
		
		for(int i=0; i<paperList.size(); i++){
			if(user.getFaverate().contains(paperList.get(i))){
				out.println("1");
			}else{ out.println("0"); }
		}
		
		System.out.println("User " + user.getId() + " finish output.");
		out.close();
//		user.writeData(out, paperList);
	}
	
	//output the feature matrix of the papers without order
	public void generate(String filename) throws IOException{
		PrintWriter out = new PrintWriter(filename);
		
		//go through the paper set
		Iterator<Entry<String, Paper>> iterPaperSet = this.papers.entrySet().iterator();
		while(iterPaperSet.hasNext()){
			Entry<String, Paper> entryPaperSet = iterPaperSet.next();
			String pid = entryPaperSet.getKey();
			Paper paper = entryPaperSet.getValue();
			
			paper.writeData(out, allWords);
			
			System.out.println("Paper " + pid + " finish output.");
		}	
		
		out.close();
	}
	
	//output the feature matrix of the papers in order of paper id
	public void generateInorder(String filename) throws IOException{
		PrintWriter out = new PrintWriter(filename);
		for(int i=1001; i<1080; i++){
			String pid = "P00-" + i;
			Paper paper = papers.get(pid);
			paper.writeData(out, allWords);
			System.out.println("Paper " + pid + " finish output.");
		}
		
		for(int i=1001; i<1071; i++){
			String pid = "P01-" + i;
			Paper paper = papers.get(pid);
			paper.writeData(out, allWords);
			System.out.println("Paper " + pid + " finish output.");
		}
		
		for(int i=1001; i<1066; i++){
			String pid = "P02-" + i;
			Paper paper = papers.get(pid);
			paper.writeData(out, allWords);
			System.out.println("Paper " + pid + " finish output.");
		}
		
		for(int i=1001; i<1072; i++){
			String pid = "P03-" + i;
			Paper paper = papers.get(pid);
			paper.writeData(out, allWords);
			System.out.println("Paper " + pid + " finish output.");
		}
		
		for(int i=1001; i<1089; i++){
			String pid = "P04-" + i;
			Paper paper = papers.get(pid);
			paper.writeData(out, allWords);
			System.out.println("Paper " + pid + " finish output.");
		}
		
		for(int i=1001; i<1078; i++){
			String pid = "P05-" + i;
			Paper paper = papers.get(pid);
			paper.writeData(out, allWords);
			System.out.println("Paper " + pid + " finish output.");
		}
		
		for(int i=1001; i<1148; i++){
			String pid = "P06-" + i;
			Paper paper = papers.get(pid);
			paper.writeData(out, allWords);
			System.out.println("Paper " + pid + " finish output.");
		}
		
		out.close();
	}
	
	public void setAllWords(ArrayList<String> allWords){
		this.allWords = allWords;
	}
	
	public void setPapers(HashMap<String, Paper> papers){
		this.papers = papers;
	}
}

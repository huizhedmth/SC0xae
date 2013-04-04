/**
 * a class design for papers
 */
package mypackage;

import java.io.PrintWriter;
import java.util.ArrayList;

/**
 * @author Cauchy
 *
 */
public class Paper {
	//paper id
	private String pid;
	//the list of words of a paper
	private ArrayList<String> words;
	
	public Paper(String pid,ArrayList<String> words){
		this.words = new ArrayList<String>();
		
		this.pid = pid;
		this.words = words;
	}
	
	public Paper(String pid){
		this.words = new ArrayList<String>();
		
		this.pid = pid;
	}
	
	//writes paper data to a print writer
	public void writeData(PrintWriter out, ArrayList<String> allWords){
		String output = "";
		
		for(int i=0; i<allWords.size(); i++){
			if(this.words.contains(allWords.get(i))){
				output = output + "1 ";
			}else{ output = output + "0 "; }
		}
		System.out.print(allWords.size() + " ");
		out.println(output);
	}
	
	public String getId(){
		return this.pid;
	}
	
	public ArrayList<String> getWords(){
		return this.words;
	}
	
	public void setWords(ArrayList<String> words){
		this.words = words;
	}
}

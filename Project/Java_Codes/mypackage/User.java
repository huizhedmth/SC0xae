/**
 * a class design for users
 */
package mypackage;

import java.io.PrintWriter;
import java.util.ArrayList;

/**
 * @author Cauchy
 *
 */
public class User {
	//user id
	private String uid;
	//the list of papers that user marked as interesting papers
	private ArrayList<String> faverate;
	
	public User(String uid,ArrayList<String> faverate){
		this.faverate = new ArrayList<String>();
		
		this.uid = uid;
		this.faverate = faverate;
	}
	
	//writes paper data to a print writer
	public void writeData(PrintWriter out, ArrayList<String> paperList){
		String output = "";
		for(int i=0; i<paperList.size(); i++){
			if(this.faverate.contains(paperList.get(i))){
				output = output + "1 ";
			}else{ output = output + "0 "; }
		}
		out.println(output);
		System.out.println("User " + this.uid + " finish output.");
	}
	
	public String getId(){
		return this.uid;
	}
	
	public ArrayList<String> getFaverate(){
		return this.faverate;
	}
	
	public void setFaverate(ArrayList<String> faverate){
		this.faverate = faverate;
	}

}

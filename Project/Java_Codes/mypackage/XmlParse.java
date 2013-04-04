/**
 * to parse the XML input
 */
package mypackage;

import java.io.BufferedReader;
import java.io.File;
import java.io.FileReader;
import java.io.IOException;
import java.util.ArrayList;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

import javax.annotation.processing.FilerException;
import javax.xml.parsers.DocumentBuilder;
import javax.xml.parsers.DocumentBuilderFactory;
import javax.xml.parsers.ParserConfigurationException;
import javax.xml.xpath.XPath;
import javax.xml.xpath.XPathConstants;
import javax.xml.xpath.XPathExpressionException;
import javax.xml.xpath.XPathFactory;

import org.w3c.dom.Document;
import org.w3c.dom.Element;
import org.w3c.dom.Node;
import org.w3c.dom.NodeList;
import org.xml.sax.SAXException;

/**
 * @author Cauchy
 *
 */
public class XmlParse {
	//all of the words that appear in any paper
	private ArrayList<String> allWords;
	
	public XmlParse(){
		this.allWords = new ArrayList<String>();
	}
	
	//parse all XML files of a specific user
	public ArrayList<String> parseUser(String uid){
		ArrayList<String> userData = new ArrayList<String>();
		BufferedReader userBuffer = null;
	
		try {
			String filename = "src/User/" + uid + ".txt"; 
			userBuffer =new BufferedReader(new FileReader(filename));
			String uData = userBuffer.readLine();
			while(uData != null){
				if(uData.length() != 0){
					userData.add(uData);
				}
				uData = userBuffer.readLine();
			}	
		}catch (FilerException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		}finally{
		     if(userBuffer != null)
				try {
					userBuffer.close();
				} catch (IOException e) {
					e.printStackTrace();
				}
		}
		return userData;

	}
	
	//parse all XML files of a specific paper
	public ArrayList<String> parseXML(String pid){
		ArrayList<String> words = new ArrayList<String>();
		
		//parse all possible files of a paper	
		for(int i=1; i<10; i++){
			String filename = "src/P/" + pid + "_000" + i + ".xml";
			File f = new File(filename);
			if(f.isFile()){
				ArrayList<String> partWords = new ArrayList<String>();
				partWords = this.parsePartXML(filename);
				for(int j=0; j<partWords.size(); j++){
					if(!words.contains(partWords.get(j))){
						words.add(partWords.get(j));
						//add all of the words that appear in any paper to allWrods.
						if(!this.allWords.contains(partWords.get(j))){
							this.allWords.add(partWords.get(j));
						}
					}
				}
			}else if(i==1){
				System.out.println("!!Paper " + filename + " does not exist.");
			}
		}		
		return words;
	}

	//parse a specific XML file
	public ArrayList<String> parsePartXML(String fileName) {
		 ArrayList<String> words = new ArrayList<String>();
		 
		 try {
			 DocumentBuilderFactory factory = DocumentBuilderFactory.newInstance();
			 DocumentBuilder builder = factory.newDocumentBuilder();
		
			 File f = new File(fileName);
			 Document doc = builder.parse(f);
			 
			 XPathFactory xpFactory = XPathFactory.newInstance();
			 XPath path = xpFactory.newXPath();
			 
			 NodeList nodesBody = (NodeList) path.evaluate("/document/page/body/section", doc, XPathConstants.NODESET);
			 
//			 System.out.println("length of body's children:" + nodesBody.getLength());
			 for(int i1=0; i1<nodesBody.getLength(); i1++){
				 Node section = nodesBody.item(i1);
				 
				 if(section instanceof Element){
				 NodeList nodesSec = section.getChildNodes();
				 
				 for(int i2=0; i2<nodesSec.getLength(); i2++){
					 Node col = nodesSec.item(i2);
					 
					 if(col instanceof Element){
					 NodeList nodesCol = col.getChildNodes();
					 for(int i3=0; i3<nodesCol.getLength(); i3++){
						 Node para = nodesCol.item(i3);
						 
						 if(para instanceof Element){
						 NodeList nodesPara = para.getChildNodes();
						 for(int i4=0; i4<nodesPara.getLength(); i4++){
							 Node ln = nodesPara.item(i4);
							 
							 if(ln instanceof Element){
							 NodeList nodesLn = ln.getChildNodes();
							 for(int i5=0; i5<nodesLn.getLength(); i5++){
								 Node wd = nodesLn.item(i5);
								 if(wd instanceof Element){
									 String text = wd.getTextContent().trim();
									 text = text.toLowerCase();
									 if(wd.getNodeName().equals("wd") && this.pattern(text) && (!words.contains(text))){						 
//										 System.out.println("3333 " + i1 + " " + i2 + " " + i3 + " " + i4 + " " + i5 + " " + ": " + text);
										 words.add(text);
									 }
								 }
							 }}
						 }}
					 }}
				 }}
			 }
			 
		} catch (SAXException e) {
			e.printStackTrace();
		} catch (IOException e) {
			e.printStackTrace();
		} catch (ParserConfigurationException e) {
			e.printStackTrace();
		} catch (XPathExpressionException e) {
			e.printStackTrace();
		}	 
		 return words;
	}
	
	//normalize input
	private boolean pattern(String word){
		boolean flag = true;
		
		if(word.length()<2 || word.length()>30){
			return false;
		}else if(word.endsWith("ly") || word.endsWith("ed") || word.endsWith("ing") || word.endsWith("s")){
			return false;
		}else{
		
			Pattern p = Pattern.compile("[a-z]+-*[a-z]+");
			Matcher m = p.matcher(word);
			flag = m.matches();
			return flag;
		}
	}
	
	public ArrayList<String> getAllWords(){
		return this.allWords;
	}
}

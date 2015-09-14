import java.io.*;
import java.util.*;

class ChapterInfo {
	String ChapterSeq;
	String ChapterName;
	int StartPageIdx;
	int EndPageIdx;
	public static void ShowSep(PrintStream output) {
		output.println("\n-----\n");
	}
	public void ShowHead(PrintStream output) {
		String IdName = Integer.toString(this.StartPageIdx) + "-" + Integer.toString(this.EndPageIdx);
		String ShowName = this.ChapterSeq + "\t" + this.ChapterName;
		String ExtraInfo = " - ╠╬убсп" + Integer.toString(this.EndPageIdx - this.StartPageIdx) + "рЁ";

		output.println("[" + ShowName + "](#" + IdName +")" + ExtraInfo);
	}
	public void ShowDetail(PrintStream output) {
		String IdName = Integer.toString(this.StartPageIdx) + "-" + Integer.toString(this.EndPageIdx);
		String ShowName = this.ChapterSeq + "\t" + this.ChapterName;
		String ExtraInfo = Integer.toString(this.EndPageIdx - this.StartPageIdx) + " P";

		output.println("<h3 id='" + IdName +"'>" + ShowName + " - " + ExtraInfo + "</h3>");
	}
}

public class GenList {
	static int MAX_CHAPTER_NUM = 100;
	static ChapterInfo[] Chapter = new ChapterInfo[MAX_CHAPTER_NUM];

	public static void main(String[] args) 
		throws FileNotFoundException {
		File f = new File(args[0]);
		Scanner input = new Scanner(f);

		int chapterNum = 0;
		while(input.hasNextLine()) {
			if(chapterNum >= MAX_CHAPTER_NUM) {
				System.out.println("Chapter Num is above than " + MAX_CHAPTER_NUM);
				break;
			}
			//String text = input.nextLine();
			//System.out.println(text.toUpperCase());
			//processLine(input.nextLine())
			String[] list = input.nextLine().split("\t");
			boolean isDigit = false;
			if(list.length == 3) {
				//process chapter number
				if(list[0].charAt(0) >= '0' && list[0].charAt(0) <= '9') {
					isDigit = true;
					int i = 1;
					for(; i < list[0].length(); i++) {
						boolean isLegal = (list[0].charAt(i) >= '0' && list[0].charAt(i) <= '9')
							|| (list[0].charAt(i) >= 'a' && list[0].charAt(i) <= 'z')
							|| (list[0].charAt(i) >= 'A' && list[0].charAt(i) <= 'Z');
						if(!isLegal) {
							isDigit = false;
							break;
						}
					}
				}

				if(isDigit) {
					list[0] = "╣з" + list[0] + "уб";
				}
				
				//System.out.println(list[0] + "\t" + list[1] + "\t" + list[2]);

				Chapter[chapterNum] = new ChapterInfo();
				Chapter[chapterNum].ChapterSeq = list[0];
				Chapter[chapterNum].ChapterName = list[1];
				Chapter[chapterNum].StartPageIdx = Integer.parseInt(list[2]);

				chapterNum ++;
			}
		}
		for(int i = 0; i < chapterNum - 1; i++) {
			Chapter[i].EndPageIdx = Chapter[i+1].StartPageIdx;
		}
		Chapter[chapterNum-1].EndPageIdx = Chapter[chapterNum-1].StartPageIdx;

		//Start Show
		for(int i = 0; i < chapterNum - 1; i++) {
			Chapter[i].ShowHead(System.out);
		}
		for(int i = 0; i < chapterNum - 1; i++) {
			ChapterInfo.ShowSep(System.out);
			Chapter[i].ShowDetail(System.out);
		}
	}
}

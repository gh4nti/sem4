// Design and implement a Java application that reads textual data from an existing text file using FileReader and writes the same content into another text file using FileWriter.

import java.io.FileReader;
import java.io.FileWriter;
import java.io.IOException;

public class Program5_2 {

    public static void main(String[] args) {
        FileReader fr = null;
        FileWriter fw = null;

        try {
            fr = new FileReader("txt/source.txt");
            fw = new FileWriter("txt/dest2.txt");

            int ch;

            while ((ch = fr.read()) != -1) {
                fw.write(ch);
            }

            System.out.println("File copied successfully.");
        } catch (IOException e) {
            System.out.println("Error while copying file: " + e.getMessage());
        } finally {
            try {
                if (fr != null) {
                    fr.close();
                }
                if (fw != null) {
                    fw.close();
                }
            } catch (IOException e) {
                System.out.println("Error closing file streams.");
            }
        }
    }
}

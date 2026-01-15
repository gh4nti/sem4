// Design and implement a Java application that copies the contents of one file to another using byte streams. The program must use FileInputStream to  read data from a source file and FileOutputStream to write the same data to a destination file.

import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;

public class Program5_1 {

    public static void main(String[] args) {
        FileInputStream fi = null;
        FileOutputStream fo = null;

        try {
            fi = new FileInputStream("txt/source.txt");
            fo = new FileOutputStream("txt/dest1.txt");

            int data;

            while ((data = fi.read()) != -1) {
                fo.write(data);
            }

            System.out.println("File copied successfully.");
        } catch (IOException e) {
            System.out.println("Error occurred while copying file: " + e.getMessage());
        } finally {
            try {
                if (fi != null) {
                    fi.close();
                }
                if (fo != null) {
                    fo.close();
                }
            } catch (IOException e) {
                System.out.println("Error closing file streams.");
            }
        }
    }
}

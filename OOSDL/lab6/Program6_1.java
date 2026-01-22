/*
Design and implement a Java application to manage hotel room bookings where room records are stored in a file and accessed using RandomAccessFile. Each room record should be of fixed length, enabling direct (random) access to any room’s booking information without reading the file sequentially. The system must support operations such as adding rooms, viewing room details, and updating booking status by directly navigating to the required record position in the file. 
i. Hotel room details in a file using RandomAccessFile.
ii. Each room record must contain:
iii. Room Number (int).
iv. Room Type (fixed-length String, e.g., 20 characters).
v. Price per Night (double)
vi. Booking Status (boolean)
vii. Provide an option to:
viii. Add new room records
ix. Display details of a specific room using its room number
x. Update booking status (book / vacate a room).
xi. Use the seek() method to jump directly to the position of a room record.
xii. Ensure data is read and written in the same sequence and format.
xiii. Close the file after each operation.
 */

import java.io.IOException;
import java.io.RandomAccessFile;
import java.util.Scanner;

public class Program6_1 {

    static final String FILE_NAME = "rooms.dat";
    static final int ROOM_TYPE_LENGTH = 20;
    static final int RECORD_SIZE = 4 + (ROOM_TYPE_LENGTH * 2) + 8 + 1;

    static Scanner sc = new Scanner(System.in);

    static void writeFixedString(RandomAccessFile raf, String str, int length) throws IOException {
        StringBuilder sb = new StringBuilder(str);
        sb.setLength(length);
        raf.writeChars(sb.toString());
    }

    static String readFixedString(RandomAccessFile raf, int length) throws IOException {
        char[] chars = new char[length];
        for (int i = 0; i < length; i++) {
            chars[i] = raf.readChar();
        }
        return new String(chars).trim();
    }

    static void addRoom() {
        try (RandomAccessFile raf = new RandomAccessFile(FILE_NAME, "rw")) {

            System.out.print("Enter room no.: ");
            int rno = sc.nextInt();
            sc.nextLine();

            System.out.print("Enter room type: ");
            String roomType = sc.nextLine();

            System.out.print("Enter price per night: ");
            double price = sc.nextDouble();

            System.out.print("Is Booked (True/False): ");
            boolean status = sc.nextBoolean();

            raf.seek(raf.length());

            raf.writeInt(rno);
            writeFixedString(raf, roomType, ROOM_TYPE_LENGTH);
            raf.writeDouble(price);
            raf.writeBoolean(status);

            System.out.println("Room added successfully.");

        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    static void displayRoom() {
        try (RandomAccessFile raf = new RandomAccessFile(FILE_NAME, "r")) {

            System.out.print("Enter room no.");
            int searchRoom = sc.nextInt();

            long totalRecords = raf.length() / RECORD_SIZE;
            boolean found = false;

            for (int i = 0; i < totalRecords; i++) {
                raf.seek(i * RECORD_SIZE);
                int rno = raf.readInt();

                if (rno == searchRoom) {
                    String type = readFixedString(raf, ROOM_TYPE_LENGTH);
                    double price = raf.readDouble();
                    boolean status = raf.readBoolean();

                    System.out.println("\nRoom no.: " + rno);
                    System.out.println("Room type: " + type);
                    System.out.println("Price per night: " + price);
                    System.out.println("Booked: " + status);
                    found = true;

                    break;
                }
            }

            if (!found) {
                System.out.println("Room not found.");
            }

        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    static void updateStatus() {
        try (RandomAccessFile raf = new RandomAccessFile(FILE_NAME, "rw")) {

            System.out.print("Enter room no.: ");
            int searchRoom = sc.nextInt();

            long totalRecords = raf.length() / RECORD_SIZE;
            boolean found = false;

            for (int i = 0; i < totalRecords; i++) {
                raf.seek(i * RECORD_SIZE);
                int rno = raf.readInt();

                if (rno == searchRoom) {
                    raf.skipBytes(ROOM_TYPE_LENGTH * 2 + 8);

                    System.out.print("Enter new booking status (true/false): ");
                    boolean newStatus = sc.nextBoolean();
                    raf.writeBoolean(newStatus);

                    System.out.println("Booking status updated.");
                    found = true;

                    break;
                }
            }

            if (!found) {
                System.out.println("Room not found.");
            }

        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        int choice;

        do {
            System.out.println("\nHotel Room Booking System\n");
            System.out.println("1. Add new room");
            System.out.println("2. Display room details");
            System.out.println("3. Update booking status");
            System.out.println("4. Exit");

            System.out.print("Enter choice: ");
            choice = sc.nextInt();

            switch (choice) {
                case 1 ->
                    addRoom();
                case 2 ->
                    displayRoom();
                case 3 ->
                    updateStatus();
                case 4 ->
                    System.out.println("Exiting...");
                default ->
                    System.out.println("Invalid choice.");
            }

        } while (choice != 4);

        sc.close();
    }
}

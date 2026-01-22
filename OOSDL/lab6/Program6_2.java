/*
Design and implement a Java application for managing hotel room bookings where room booking details are stored as serialized objects in a file. The application should use serialization to save hotel room booking objects permanently and deserialization to retrieve them when required. This approach should simulate real-world object persistence without using a database.
i. Create a Room class that implements Serializable.
ii. Each room object must store:
	a. Room Number
	b. Room Type
	c. Price per Night
	d. Booking Status
	e. Guest Name
iii. Serialize room booking objects and store them in a file.
iv. Deserialize objects from the file to:
	a. Display all room details
	b. Search for a room using room number
v. Allow updating booking status by:
	a. Deserializing the objects
	b. Modifying the required room object
	c. Re-serializing the updated objects back to the file
vi. Handle file and class-related exceptions properly.
 */

import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.ObjectInputStream;
import java.io.ObjectOutputStream;
import java.io.Serializable;
import java.util.ArrayList;
import java.util.Scanner;

class Room implements Serializable {

    private static final long serialVersionUID = 1L;

    int rno;
    String type;
    double price;
    boolean status;
    String name;

    public Room(int rno, String type, double price, boolean status, String name) {
        this.rno = rno;
        this.type = type;
        this.price = price;
        this.status = status;
        this.name = name;
    }

    public void display() {
        System.out.println("Room no.: " + rno);
        System.out.println("Room type: " + type);
        System.out.println("Price per night: " + price);
        System.out.println("Booked: " + status);
        System.out.println("Guest name: " + name);
        System.out.println();
    }
}

public class Program6_2 {

    static final String FILE_NAME = "rooms.ser";
    static Scanner sc = new Scanner(System.in);

    static ArrayList<Room> readRooms() {
        ArrayList<Room> rooms = new ArrayList<>();

        try (ObjectInputStream ois = new ObjectInputStream(new FileInputStream(FILE_NAME))) {
            rooms = (ArrayList<Room>) ois.readObject();
        } catch (FileNotFoundException e) {

        } catch (IOException | ClassNotFoundException e) {
            e.printStackTrace();
        }

        return rooms;
    }

    static void writeRooms(ArrayList<Room> rooms) {
        try (ObjectOutputStream oos = new ObjectOutputStream(new FileOutputStream(FILE_NAME))) {
            oos.writeObject(rooms);
        } catch (IOException e) {
            e.printStackTrace();
        }
    }

    static void addRoom() {
        ArrayList<Room> rooms = readRooms();

        System.out.print("Enter room no.: ");
        int rno = sc.nextInt();
        sc.nextLine();

        System.out.print("Enter room type: ");
        String type = sc.nextLine();

        System.out.print("Enter price per night: ");
        double price = sc.nextDouble();

        System.out.print("Is Booked (True/False): ");
        boolean status = sc.nextBoolean();
        sc.nextLine();

        System.out.println("Enter guest name: ");
        String name = sc.nextLine();

        rooms.add(new Room(rno, type, price, status, name));
        writeRooms(rooms);

        System.out.println("Room added successfully.");
    }

    static void displayAllRooms() {
        ArrayList<Room> rooms = readRooms();

        if (rooms.isEmpty()) {
            System.out.println("No rooms available.");
            return;
        }

        for (Room r : rooms) {
            r.display();
        }
    }

    static void searchRoom() {
        ArrayList<Room> rooms = readRooms();

        System.out.print("Enter room no. to search: ");
        int search = sc.nextInt();

        for (Room r : rooms) {
            if (r.rno == search) {
                r.display();
                return;
            }
        }
        System.out.println("Room not found.");
    }

    static void updateBookingStatus() {
        ArrayList<Room> rooms = readRooms();

        System.out.print("Enter room no.: ");
        int search = sc.nextInt();
        sc.nextLine();

        for (Room r : rooms) {
            if (r.rno == search) {
                System.out.print("Enter new booking status (true/false):");
                r.status = sc.nextBoolean();
                sc.nextLine();

                System.out.print("Enter guest name: ");
                r.name = sc.nextLine();

                writeRooms(rooms);
                System.out.println("Booking status updated.");
                return;
            }
        }
        System.out.println("Room not found.");
    }

    public static void main(String[] args) {
        int choice;

        do {
            System.out.println("\nHotel Room Booking System\n");
            System.out.println("1. Add room");
            System.out.println("2. Display all rooms");
            System.out.println("3. Search room");
            System.out.println("4. Update booking status");
            System.out.println("5. Exit");

            System.out.print("Enter choice: ");
            choice = sc.nextInt();

            switch (choice) {
                case 1 ->
                    addRoom();
                case 2 ->
                    displayAllRooms();
                case 3 ->
                    searchRoom();
                case 4 ->
                    updateBookingStatus();
                case 5 ->
                    System.out.println("Exiting...");
                default ->
                    System.out.println("Invalid choice.");
            }
        } while (choice != 5);

        sc.close();
    }
}

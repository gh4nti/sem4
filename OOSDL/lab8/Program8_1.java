/*
Design and implement a Hotel Management System in Java using the Collection Framework to manage hotel operations efficiently. The system should store, retrieve, update, and process hotel-related data dynamically using appropriate collection classes.

System Requirements

Room Management
Store room details such as:
Room Number
Room Type (Single, Double, Deluxe, Suite)
Room Price per Day
Availability Status
Allow adding new rooms and displaying all available rooms.

Customer Management
Maintain customer details including:
Customer ID
Name
Contact Number
Room Number Allocated
Support operations to add, view, and remove customer records.
Booking Management
Enable room booking and checkout functionality.
Update room availability automatically after booking or checkout.
Prevent booking of already occupied rooms.

Collections Usage
Use suitable collection classes such as:
ArrayList to store room and customer objects
HashMap to map room numbers to customer details
Iterator to traverse and manage records
Apply sorting (e.g., by room price or room number) using Collections.sort().

Menu-Driven Interface
Provide a console-based menu with options such as:
Add Room
Display Available Rooms
Add Customer
Book Room
Checkout Customer
Display All Customers
Exit

Constraints 
Do not use arrays for data storage.
All data must be handled using Java Collections.
Ensure proper validation and exception handling.
 */

import java.util.ArrayList;
import java.util.Collections;
import java.util.Comparator;
import java.util.HashMap;
import java.util.Iterator;
import java.util.Scanner;

class Room {

    int rno;
    String type;
    double price;
    boolean status;

    Room(int rno, String type, double price) {
        this.rno = rno;
        this.type = type;
        this.price = price;
        this.status = true;
    }

    @Override
    public String toString() {
        return "Room no.: " + rno
                + ", Type: " + type
                + ", Price: " + price
                + ", Availability: " + status;
    }
}

class Customer {

    int cID, rno;
    String name, contact;

    Customer(int cID, String name, String contact, int rno) {
        this.cID = cID;
        this.name = name;
        this.contact = contact;
        this.rno = rno;
    }

    @Override
    public String toString() {
        return "Customer ID: " + cID
                + ", Name: " + name
                + ", Contact: " + contact
                + ", Room no.: " + rno;
    }
}

public class Program8_1 {

    static ArrayList<Room> rooms = new ArrayList<>();
    static ArrayList<Customer> customers = new ArrayList<>();
    static HashMap<Integer, Customer> roomCustomerMap = new HashMap<>();
    static Scanner sc = new Scanner(System.in);

    public static void main(String[] args) {
        while (true) {
            System.out.println("\n--Hotel management system--");
            System.out.println("1. Add room");
            System.out.println("2. Display available rooms");
            System.out.println("3. Add customer");
            System.out.println("4. Book room");
            System.out.println("5. Checkout customer");
            System.out.println("6. Display all customers");
            System.out.println("7. Exit\n");

            System.out.println("Enter choice: ");

            try {
                int choice = sc.nextInt();
                sc.nextLine();

                switch (choice) {
                    case 1 ->
                        addRoom();
                    case 2 ->
                        displayAvailableRooms();
                    case 3 ->
                        addCustomer();
                    case 4 ->
                        bookRoom();
                    case 5 ->
                        checkoutCustomer();
                    case 6 ->
                        displayCustomer();
                    case 7 ->
                        System.exit(0);
                    default ->
                        System.out.println("Invalid choice.");
                }
            } catch (Exception e) {
                System.out.println("Invalid input.");
                sc.nextLine();
            }
        }
    }

    // add room
    static void addRoom() {
        try {
            System.out.print("Enter room no.: ");
            int rno = sc.nextInt();
            sc.nextLine();

            for (Room r : rooms) {
                if (r.rno == rno) {
                    System.out.println("Room already exists.");
                    return;
                }
            }

            System.out.print("Room type: ");
            String type = sc.nextLine();

            System.out.print("Price per day: ");
            double price = sc.nextDouble();

            rooms.add(new Room(rno, type, price));
            System.out.println("Room " + rno + " added.");
        } catch (Exception e) {
            System.out.println("Error printing room.");
            sc.nextLine();
        }
    }

    // display available rooms
    static void displayAvailableRooms() {
        Collections.sort(rooms, Comparator.comparingDouble(r -> r.price));

        System.out.println("\nAvailable rooms:");
        for (Room r : rooms) {
            if (r.status) {
                System.out.println(r);
            }
        }
    }

    // add customer
    static void addCustomer() {
        try {
            System.out.print("Customer ID: ");
            int cID = sc.nextInt();
            sc.nextLine();

            System.out.print("Name: ");
            String name = sc.nextLine();

            System.out.print("Contact: ");
            String contact = sc.nextLine();

            customers.add(new Customer(cID, name, contact, -1));
            System.out.println("Customer " + cID + " added.");
        } catch (Exception e) {
            System.out.println("Invalid customer data.");
            sc.nextLine();
        }
    }

    // book room
    static void bookRoom() {
        try {
            System.out.print("Customer ID: ");
            int cID = sc.nextInt();

            System.out.print("Room no.: ");
            int rno = sc.nextInt();

            Room selectedRoom = null;

            for (Room r : rooms) {
                if (r.rno == rno && r.status) {
                    selectedRoom = r;
                    break;
                }
            }

            if (selectedRoom == null) {
                System.out.println("Room not available.");
                return;
            }

            for (Customer c : customers) {
                if (c.cID == cID) {
                    c.rno = rno;
                    selectedRoom.status = false;
                    roomCustomerMap.put(rno, c);

                    System.out.println("Room booked successfully.");
                    return;
                }
            }

            System.out.println("Customer not found.");

        } catch (Exception e) {
            System.out.println("Booking failed.");
            sc.nextLine();
        }
    }

    // checkout customer
    static void checkoutCustomer() {
        try {
            System.out.print("Room no.: ");
            int rno = sc.nextInt();

            if (!roomCustomerMap.containsKey(rno)) {
                System.out.println("Room not occupied.");
                return;
            }

            Customer c = roomCustomerMap.remove(rno);
            c.rno = -1;

            for (Room r : rooms) {
                if (r.rno == rno) {
                    r.status = true;
                }
            }

            System.out.println("Checkout successful.");
        } catch (Exception e) {
            System.out.println("Checkout error.");
            sc.nextLine();
        }
    }

    // display customer
    static void displayCustomer() {
        Iterator<Customer> it = customers.iterator();
        while (it.hasNext()) {
            System.out.println(it.next());
        }
    }
}

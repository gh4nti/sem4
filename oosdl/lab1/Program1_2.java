/*
Create a base class named Room to represent general room details in a hotel. The class should contain data members such as room number, room type, and base price. Implement multiple constructors (constructor overloading) in the Room class to initialize room objects in different ways, such as:

i. Initializing only the room number and type

ii. Initializing room number, type, and base price

iii. Create a derived class named DeluxeRoom that inherits from the Room class using single inheritance. The derived class should include additional data members such as free Wi-Fi availability and complimentary breakfast. Implement appropriate constructors in the derived class that invoke the base class constructors using the super keyword.

iv. Create a main class to instantiate objects of both Room and DeluxeRoom using different constructors and display the room details. This application should clearly illustrate constructor overloading and inheritance.
 */

class Room {

    protected int no;
    protected String type;
    protected double basePrice;

    public Room(int no, String type) {
        this.no = no;
        this.type = type;
        this.basePrice = 0.0;
    }

    public Room(int no, String type, double basePrice) {
        this.no = no;
        this.type = type;
        this.basePrice = basePrice;
    }

    public void display() {
        System.out.println("Room number: " + no);
        System.out.println("Room type: " + type);
        System.out.println("Base price: " + basePrice);
    }
}

class DeluxeRoom extends Room {

    private final boolean freeWifi, complimentaryBreakfast;

    public DeluxeRoom(int no, String type, boolean freeWifi, boolean complimentaryBreakfast) {
        super(no, type);
        this.freeWifi = freeWifi;
        this.complimentaryBreakfast = complimentaryBreakfast;
    }

    public DeluxeRoom(int no, String type, double basePrice, boolean freeWifi, boolean complimentaryBreakfast) {
        super(no, type, basePrice);
        this.freeWifi = freeWifi;
        this.complimentaryBreakfast = complimentaryBreakfast;
    }

    @Override
    public void display() {
        super.display();
        System.out.println("Free WiFi: " + freeWifi);
        System.out.println("Complimentary breakfast: " + complimentaryBreakfast);
    }
}

public class Program1_2 {

    public static void main(String[] args) {
        Room r1 = new Room(101, "Standard");
        Room r2 = new Room(102, "Suite", 4500);

        DeluxeRoom d1 = new DeluxeRoom(201, "Deluxe", true, false);
        DeluxeRoom d2 = new DeluxeRoom(202, "Premium Deluxe", 6500, true, true);

        r1.display();
        System.out.println();

        r2.display();
        System.out.println();

        d1.display();
        System.out.println();

        d2.display();
        System.out.println();
    }
}

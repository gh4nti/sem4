/*
Create an abstract class named Room that represents a generic hotel room. The abstract class should contain common data members such as room number and base price, and include an abstract method calculateTariff() that must be implemented by all subclasses. It may also include concrete methods such as displayRoomDetails().

i. Create derived classes such as StandardRoom and LuxuryRoom that extend the abstract Room class and provide concrete implementations for the calculateTariff() method based on room-specific features.

ii. Create an interface named Amenities that declares methods such as provideWifi() and provideBreakfast(). The derived room classes should implement this interface to define the amenities offered for each room type.

iii. Create a main class to instantiate different room objects using a base class reference and invoke the implemented methods to demonstrate abstraction and interface-based design.
 */

interface Amenities {

    void provideWifi();

    void provideBreakfast();
}

abstract class Room {

    protected int no;
    protected double basePrice;

    public Room(int no, double basePrice) {
        this.no = no;
        this.basePrice = basePrice;
    }

    public abstract double calculateTariff();

    public void display() {
        System.out.println("Room number: " + no);
        System.out.println("Base price: " + basePrice);
    }
}

class StandardRoom extends Room implements Amenities {

    private final boolean AC;

    public StandardRoom(int no, double basePrice, boolean AC) {
        super(no, basePrice);
        this.AC = AC;
    }

    @Override
    public double calculateTariff() {
        if (AC) {
            return basePrice + 500;
        }
        return basePrice;
    }

    @Override
    public void display() {
        super.display();
        System.out.println("Standard Room");
        System.out.println("Air conditioning: " + AC);
    }

    @Override
    public void provideWifi() {
        System.out.println("Standard Room: WiFi available");
    }

    @Override
    public void provideBreakfast() {
        System.out.println("Standard Room: Breakfast not available");
    }
}

class LuxuryRoom extends Room implements Amenities {

    private final boolean premium;

    public LuxuryRoom(int no, double basePrice, boolean premium) {
        super(no, basePrice);
        this.premium = premium;
    }

    @Override
    public double calculateTariff() {
        if (premium) {
            return basePrice + 2000;
        }
        return basePrice;
    }

    @Override
    public void display() {
        super.display();
        System.out.println("Luxury Room");
        System.out.println("Premium services: " + premium);
    }

    @Override
    public void provideWifi() {
        System.out.println("Luxury Room: High-speed Wi-Fi available");
    }

    @Override
    public void provideBreakfast() {
        System.out.println("Luxury Room: Complimentary breakfast included");
    }
}

public class Program1_4 {

    public static void main(String[] args) {
        Room room;

        room = new StandardRoom(101, 3000, true);
        room.display();
        System.out.println("Tariff: " + room.calculateTariff());
        ((Amenities) room).provideWifi();
        ((Amenities) room).provideBreakfast();

        System.out.println();

        room = new LuxuryRoom(201, 5000, true);
        room.display();
        System.out.println("Tariff: " + room.calculateTariff());
        ((Amenities) room).provideWifi();
        ((Amenities) room).provideBreakfast();
    }
}

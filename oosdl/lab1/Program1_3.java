/*
Design and implement a Java application to simulate a Hotel Room Booking System that demonstrates the object-oriented concepts of inheritance and runtime polymorphism.

i. Create a base class named Room that represents a general hotel room. The class should contain data members such as room number and base tariff, and a method calculateTariff() to compute the room cost.

ii. Create derived classes such as StandardRoom and LuxuryRoom that inherit from the Room class. Each derived class should override the calculateTariff() method to compute the tariff based on room-specific features such as air conditioning, additional amenities, or premium services.

iii. In the main class, create a base class reference of type Room and assign it to objects of different derived classes (StandardRoom, LuxuryRoom). Invoke the calculateTariff() method using the base class reference to demonstrate runtime polymorphism, where the method call is resolved at runtime based on the actual object type.
 */

class Room {

    protected int no;
    protected double baseTariff;

    public Room(int no, double baseTariff) {
        this.no = no;
        this.baseTariff = baseTariff;
    }

    public double calculateTariff() {
        return baseTariff;
    }
}

class StandardRoom extends Room {

    private final boolean AC;

    public StandardRoom(int no, double baseTariff, boolean AC) {
        super(no, baseTariff);
        this.AC = AC;
    }

    @Override
    public double calculateTariff() {
        if (AC) {
            return baseTariff + 500;
        }
        return baseTariff;
    }
}

class LuxuryRoom extends Room {

    private final boolean premium;

    public LuxuryRoom(int no, double baseTariff, boolean premium) {
        super(no, baseTariff);
        this.premium = premium;
    }

    @Override
    public double calculateTariff() {
        if (premium) {
            return baseTariff + 2000;
        }
        return baseTariff;
    }
}

public class Program1_3 {

    public static void main(String[] args) {
        Room room;

        room = new StandardRoom(101, 3000, true);
        System.out.println("Standard room tariff: " + room.calculateTariff());

        room = new LuxuryRoom(102, 5000, true);
        System.out.println("Luxury room tariff: " + room.calculateTariff());
    }
}

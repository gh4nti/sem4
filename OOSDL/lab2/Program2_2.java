/*
Design and implement a Java application to manage room tariff details in a Hotel Management System using Java enumerations (enum). The application should demonstrate the use of enum constants, enum constructors, and enum methods. 

i. Define an enum named RoomType to represent different types of hotel rooms such as STANDARD, DELUXE, and SUITE. Each enum constant should be associated with a base tariff value using an enum constructor. The enum should also include methods to return the base tariff and to calculate the total room cost based on the number of days stayed. 

ii. Create a main class to select a room type, specify the number of days of stay, and compute the total room tariff by invoking the enum methods. The application should clearly illustrate how enum constructors are used to initialize constant-specific data and how enum methods operate on that data.
 */

enum RoomType {
    STANDARD(2000),
    DELUXE(3500),
    SUITE(6000);

    private final double tariff;

    RoomType(double tariff) {
        this.tariff = tariff;
    }

    public double getTariff() {
        return tariff;
    }

    public double calcTotal(int days) {
        return tariff * days;
    }
}

public class Program2_2 {

    public static void main(String[] args) {
        RoomType room = RoomType.DELUXE;
        int days = 4;

        double tariff = room.getTariff();
        double total = room.calcTotal(days);

        System.out.println("Selected Room Type: " + room);
        System.out.println("Base Tariff per Day: " + tariff);
        System.out.println("Number of Days Stayed: " + days);
        System.out.println("Total Room Cost: " + total);
    }
}

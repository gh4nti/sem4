/*
Create a Java program for a hotel room management system that uses a generic method to display room-related data of different types such as room numbers, room types, prices, and booking status. 
- Implement a generic method <T> void display(T data).
- Call the method with:
    1. Room number (Integer).
    2. Room type (String).
    3. Price per night (Double).
    4. Booking status (Boolean).
- Ensure type safety without explicit casting
 */

public class Program7_2 {

    public static <T> void display(T data) {
        System.out.println("Data: " + data);
    }

    public static void main(String[] args) {
        Integer rno = 101;
        String type = "Deluxe";
        Double price = 4500.00;
        Boolean status = true;

        System.out.println("Hotel room information:\n");

        display(rno);
        display(type);
        display(price);
        display(status);
    }
}

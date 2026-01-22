/*
Develop a Java application that uses a generic class with two type parameters to store hotel room information. The generic class should be capable of holding different data types for room identifiers and room attributes. 
- Create a generic class Room<T, U>.
- T represents Room Number or Room ID.
- U represents Room Type or Price.
- Demonstrate usage with different data types (e.g., Integer, String, Double).
- Display stored room details.
 */

class Room<T, U> {

    private final T ID;
    private final U attr;

    public Room(T ID, U attr) {
        this.ID = ID;
        this.attr = attr;
    }

    public T getID() {
        return ID;
    }

    public U getAttr() {
        return attr;
    }

    public void display() {
        System.out.println("Room ID: " + ID);
        System.out.println("Room attribute: " + attr);
        System.out.println();
    }
}

public class Program7_1 {

    public static void main(String[] args) {
        Room<Integer, String> room1 = new Room<>(101, "Deluxe");
        Room<String, Double> room2 = new Room<>("A202", 3500.00);
        Room<Integer, Double> room3 = new Room<>(303, 5000.00);

        System.out.println("Room details:\n");

        room1.display();
        room2.display();
        room3.display();
    }
}

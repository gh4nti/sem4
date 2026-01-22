/*
Design a Java program that uses generic methods to manage an array of hotel rooms. The program should be capable of storing and displaying arrays of different room attributes.
- Create a generic method to print arrays.
- Use it for:
	> Room numbers array 
	> Room types array 
	> Room prices array 
- Do not use collections framework.
 */

public class Program7_4 {

    public static <T> void printArray(T[] arr) {
        for (T i : arr) {
            System.out.println(i);
        }
        System.out.println();
    }

    public static void main(String[] args) {
        Integer[] roomNumbers = {101, 102, 103, 104};
        String[] roomTypes = {"Deluxe", "Standard", "Suite", "Economy"};
        Double[] roomPrices = {4500.0, 3000.0, 7000.0, 2000.0};

        System.out.println("Room numbers:");
        printArray(roomNumbers);

        System.out.println("Room types:");
        printArray(roomTypes);

        System.out.println("Room prices:");
        printArray(roomPrices);
    }
}

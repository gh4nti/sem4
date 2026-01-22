/*
Develop a hotel room booking module that uses a generic pair class to associate room numbers with guest details.
- Create a generic class Pair<T, U>.
- Store:
	> Room Number (Integer) 
	> Guest Name (String) 
- Display booking records.
- Ensure no type casting is required.
 */

class Pair<T, U> {

    private T first;
    private U second;

    public Pair(T first, U second) {
        this.first = first;
        this.second = second;
    }

    public T getFirst() {
        return first;
    }

    public U getSecond() {
        return second;
    }

    public void display() {
        System.out.println("Room no.: " + first);
        System.out.println("Guest name: " + second);
        System.out.println();
    }
}

public class Program7_5 {

    public static void main(String[] args) {
        Pair<Integer, String> room1 = new Pair<>(101, "abc");
        Pair<Integer, String> room2 = new Pair<>(202, "def");
        Pair<Integer, String> room3 = new Pair<>(303, "ghi");

        System.out.println("Room booking records:\n");

        room1.display();
        room2.display();
        room3.display();
    }
}

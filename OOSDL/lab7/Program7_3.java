/*
Develop a Java application that uses bounded type parameters to calculate room charges. The application should accept only numeric values for pricing and discount calculations.
- Create a generic class or method using <T extends Number>.
- Accept room price and discount as generic parameters.
- Perform calculations such as:
	> Total price
	> Discounted price
- Prevent non-numeric data types at compile time.
 */

class RoomCharges<T extends Number> {

    private final T price, discount;

    public RoomCharges(T price, T discount) {
        this.price = price;
        this.discount = discount;
    }

    public double calcTotalPrice() {
        return price.doubleValue();
    }

    public double calcDiscountedPrice() {
        double total = price.doubleValue();
        double disc = discount.doubleValue();
        return total - (total * disc / 100);
    }

    public void display() {
        System.out.println("Price: " + price);
        System.out.println("Discount (%): " + discount);
        System.out.println("Total Price: " + calcTotalPrice());
        System.out.println("Discounted Price: " + calcDiscountedPrice());
        System.out.println();
    }
}

public class Program7_3 {

    public static void main(String[] args) {
        RoomCharges<Double> room1 = new RoomCharges<>(5000.00, 10.00);
        RoomCharges<Integer> room2 = new RoomCharges<>(3000, 5);

        System.out.println("Hotel room charges:\n");

        room1.display();
        room2.display();
    }
}

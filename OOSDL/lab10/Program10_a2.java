// Develop a Java program to demonstrate encapsulation by creating a BankAccount class with private data members accountNumber and balance. Provide public methods to deposit, withdraw, and display the balance with proper validation.

class BankAccount {

    private final int accountNumber;
    private double balance;

    BankAccount(int accNo, double initialBalance) {
        accountNumber = accNo;

        if (initialBalance >= 0) {
            balance = initialBalance;
        } else {
            balance = 0;
            System.out.println("Invalid initial balance. Set to 0.");
        }
    }

    public void deposit(double amount) {
        if (amount > 0) {
            balance += amount;
            System.out.println("Deposited: " + amount);
        } else {
            System.out.println("Invalid deposit amount.");
        }
    }

    public void withdraw(double amount) {
        if (amount <= 0) {
            System.out.println("Invalid withdrawal amount.");
        } else if (amount > balance) {
            System.out.println("Insufficient balance.");
        } else {
            balance -= amount;
            System.out.println("Withdrawn: " + amount);
        }
    }

    public void display() {
        System.out.println("Account Number: " + accountNumber);
        System.out.println("Current Balance: " + balance + "\n");
    }
}

public class Program10_a2 {

    public static void main(String[] args) {
        BankAccount acc1 = new BankAccount(1001, 5000);

        acc1.display();

        acc1.deposit(2000);
        acc1.withdraw(1500);
        acc1.withdraw(7000);

        acc1.display();
    }
}

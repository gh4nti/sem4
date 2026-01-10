/*
The Hotel Billing system should calculate the total bill amount for hotel guests based on room charges and additional service charges. Store numeric values such as room tariff, number of days stayed, and service charges using wrapper class objects (Integer, Double) instead of primitive data types.
Demonstrate autoboxing by automatically converting primitive values to wrapper class objects when assigning values or storing them in collections. Demonstrate unboxing by automatically converting wrapper class objects back to primitive types while performing arithmetic operations for bill calculation. 

Create a main class to: 
i. Initialize room tariff and number of days using primitive data types and store them in wrapper objects. 

ii. Perform total bill calculation using unboxed primitive values. 

iii. Display the final hotel bill.
*/

class HotelBilling {
	private Double tariff;
	private Integer days;
	private Double serviceCharges;

	HotelBilling(Double tariff, Integer days, Double serviceCharges) {
		this.tariff = tariff;
		this.days = days;
		this.serviceCharges = serviceCharges;
	}

	public Double calculateTotalBill() {
		double totalCost = tariff * days;
		double totalBill = totalCost + serviceCharges;

		return totalBill;
	}
}

public class Program2_1 {
	public static void main(String[] args) {
		double tariff = 2500;
		int days = 3;
		double serviceCharges = 1200;

		Double tariffObj = tariff;
		Integer daysObj = days;
		Double serviceChargesObj = serviceCharges;

		HotelBilling bill = new HotelBilling(tariffObj, daysObj, serviceChargesObj);

		Double total = bill.calculateTotalBill();

		System.out.println("Room Tariff per Day: " + tariffObj);
		System.out.println("Number of Days Stayed: " + daysObj);
		System.out.println("Service Charges: " + serviceChargesObj);
		System.out.println("Total Hotel Bill: " + total);
	}
}
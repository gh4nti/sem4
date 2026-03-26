/*
Design and implement a Hotel Management System with a Graphical User  Interface (GUI) using JavaFX to automate and simplify basic hotel  operations. The application should provide an interactive, user-friendly interface for managing rooms, customers, and bookings.

Room Management:
- Display room details such as
	> Room Number
	> Room Type (Single, Double, Deluxe)
	> Price per Day
	> Availability Status

- Provide GUI options to:
	> Add new rooms 
	> View all rooms 
	> Show available rooms only 

Customer Management :
- Capture customer information through forms: 
	> Customer Name
	> Contact Number
	> Selected Room Number
Display customer booking details in the GUI. 

Booking and Checkout 
- Allow booking of rooms using a button click. 
- Prevent booking of already occupied rooms. 
- Provide a checkout option to release rooms and update availability. 

GUI Requirements 
- Use JavaFX controls such as: Label, TextField, Button, ComboBox, TableView
- Use suitable layouts:
	> GridPane for forms 
	> VBox / HBox for buttons and navigation 
- Implement event handling for all user actions. 

User Interaction 
- Display confirmation or error messages using labels or alerts. 
- Clear input fields after successful operations.
*/

import javafx.application.Application;
import javafx.collections.FXCollections;
import javafx.collections.ObservableList;
import javafx.scene.control.TableColumn;
import javafx.scene.control.TableView;
import javafx.scene.control.cell.PropertyValueFactory;
import javafx.stage.Stage;

public class Program9_1 extends Application {
	public static class Room {
		private int rno;
		private String type;
		private double price;
		private boolean status;

		public Room(int rno, String type, double price, boolean status) {
			this.rno = rno;
			this.type = type;
			this.price = price;
			this.status = status;
		}

		public int getRno() {
			return rno;
		}

		public String getType() {
			return type;
		}

		public double getPrice() {
			return price;
		}

		public boolean getStatus() {
			return status;
		}

		public void setStatus(boolean status) {
			this.status = status;
		}
	}

	public static class Customer {
		private String name, contact;
		private int rno;

		public Customer(String name, String contact, int rno) {
			this.name = name;
			this.contact = contact;
			this.rno = rno;
		}

		public String getName() {
			return name;
		}

		public String getContact() {
			return contact;
		}

		public int getRno() {
			return rno;
		}
	}

	ObservableList<Room> rooms = FXCollections.observableArrayList();
	ObservableList<Customer> customers = FXCollections.observableArrayList();

	TableView<Room> roomT = new TableView<>();
	TableView<Customer> custT = new TableView<>();

	@Override
	public void start(Stage stage) {
		// ROOM TABLE
		TableColumn<Room, Integer> colNum = new TableColumn<>("Room no");
		colNum.setCellValueFactory(new PropertyValueFactory<>("rno"));

		TableColumn<Room, String> colType = new TableColumn<>("Type");
		colType.setCellValueFactory(new PropertyValueFactory<>("type"));

		TableColumn<Room, Double> colPrice = new TableColumn<>("Price");
		colPrice.setCellValueFactory(new PropertyValueFactory<>("price"));

		TableColumn<Room, Boolean> colStatus = new TableColumn<>("Status");
		colStatus.setCellValueFactory(new PropertyValueFactory<>("status"));

		roomT.getColumns().addAll(colNum, colType, colPrice, colStatus);
		roomT.setItems(rooms);

	}
}
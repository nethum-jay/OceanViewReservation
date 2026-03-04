package com.oceanview.model;

public class Guest {

    // Represents the Primary Key in the database
    private int guestId;
    private String name;
    private String nic;
    private String email;
    private String address;
    private String contactNo;

    // Default constructor
    public Guest() {}

    // Constructor for creating a new Guest (without ID, mainly for database insertion)
    public Guest(String name, String nic, String email, String address, String contactNo) {
        this.name = name;
        this.nic = nic;
        this.email = email;
        this.address = address;
        this.contactNo = contactNo;
    }

    // Getters and Setters
    public int getGuestId() { return guestId; }
    public void setGuestId(int guestId) { this.guestId = guestId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getNic() { return nic; }
    public void setNic(String nic) { this.nic = nic; }

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }

    public String getContactNo() { return contactNo; }
    public void setContactNo(String contactNo) { this.contactNo = contactNo; }
}
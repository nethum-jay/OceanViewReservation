package com.oceanview.model;

public class Guest {
    private String name;
    private String nic;
    private String email;
    private String address;
    private String contactNo;

    public Guest() {}

    public Guest(String name, String nic, String email, String address, String contactNo) {
        this.name = name;
        this.nic = nic;
        this.email = email;
        this.address = address;
        this.contactNo = contactNo;
    }

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
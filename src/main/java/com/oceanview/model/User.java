package com.oceanview.model;

public class User {
    private int id;              //
    private String username;     //
    private String password;     //
    private String role;         //
    private String phone;        //
    private String fullName;     //
    private String nic;          //
    private String email;        //
    private String address;      //

    // Default Constructor
    public User() {}

    //For Login and Role

    public int getId() { return id; }
    public void setId(int id) { this.id = id; } //

    public String getUsername() { return username; }
    public void setUsername(String username) { this.username = username; }

    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }

    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; } //

    public String getPhone() { return phone; }
    public void setPhone(String phone) { this.phone = phone; }

    // For Profile Update and Admin Manage

    public String getFullName() { return fullName; }
    public void setFullName(String fullName) { this.fullName = fullName; } //

    public String getNic() { return nic; }
    public void setNic(String nic) { this.nic = nic; } //

    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; } //

    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; } //
}
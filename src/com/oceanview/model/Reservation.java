package com.oceanview.model;

import java.util.Date;

public class Reservation {
    private int resID;
    private int guestID;
    private String roomType;
    private String checkInDate;
    private String checkOutDate;

    // Default Constructor
    public Reservation() {}

    // Getters and Setters (Encapsulation)
    public int getGuestID() { return guestID; }
    public void setGuestID(int guestID) { this.guestID = guestID; }

    public String getRoomType() { return roomType; }
    public void setRoomType(String roomType) { this.roomType = roomType; }

    public String getCheckInDate() { return checkInDate; }
    public void setCheckInDate(String checkInDate) { this.checkInDate = checkInDate; }

    public String getCheckOutDate() { return checkOutDate; }
    public void setCheckOutDate(String checkOutDate) { this.checkOutDate = checkOutDate; }
}
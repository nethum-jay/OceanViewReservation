package com.oceanview.model;

public class Reservation {
    private int reservationID;
    private int guestID;
    private String roomType;
    private String checkInDate;
    private String checkOutDate;
    private int noOfPersons;

    // Getters and Setters
    public int getReservationID() { return reservationID; }
    public void setReservationID(int reservationID) { this.reservationID = reservationID; }

    public int getGuestID() { return guestID; }
    public void setGuestID(int guestID) { this.guestID = guestID; }

    public String getRoomType() { return roomType; }
    public void setRoomType(String roomType) { this.roomType = roomType; }

    public String getCheckInDate() { return checkInDate; }
    public void setCheckInDate(String checkInDate) { this.checkInDate = checkInDate; }

    public String getCheckOutDate() { return checkOutDate; }
    public void setCheckOutDate(String checkOutDate) { this.checkOutDate = checkOutDate; }

    public int getNoOfPersons() { return noOfPersons; }
    public void setNoOfPersons(int noOfPersons) { this.noOfPersons = noOfPersons; }
}
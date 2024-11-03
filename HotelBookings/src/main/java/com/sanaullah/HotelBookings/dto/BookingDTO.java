package com.sanaullah.HotelBookings.dto;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.sql.Date;

@Data
@AllArgsConstructor
public class BookingDTO {

    private Date checkindate;
    private Date checkoutdate;
    private float totalprice;
    private String roomType;
    private String hotelName;
    private String userName; // User's name
    private String userEmail;


}

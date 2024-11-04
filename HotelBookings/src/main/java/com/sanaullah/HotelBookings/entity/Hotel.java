package com.sanaullah.HotelBookings.entity;

import jakarta.persistence.*;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Entity
@NoArgsConstructor
@AllArgsConstructor
@Data
public class Hotel {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private  int id;
    private  String name;
    private  String address;
    private  String rating;
    private  double minPrice;
    private  double maxPrice;
    private  String image;


    @ManyToOne(fetch = FetchType.EAGER)
    @JoinColumn(name = "laoctionId")
    private  Location location;


}

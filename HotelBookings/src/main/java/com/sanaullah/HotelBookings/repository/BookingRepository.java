package com.sanaullah.HotelBookings.repository;

import com.sanaullah.HotelBookings.entity.Booking;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.sql.Date;
import java.util.List;

@Repository
public interface BookingRepository extends JpaRepository<Booking,Integer> {

//    @Query("SELECT b FROM Booking b WHERE  b.room.hotel.id = :hotelId   AND  b.room.id = :roomId AND " +
//            "(b.checkindate < :checkoutdate AND b.checkoutdate > :checkindate)")
//    List<Booking> findConflictingBookings(
//            @Param("hotelId") int hotelId,
//            @Param("roomId") int roomId,
//            @Param("checkindate") Date checkindate,
//            @Param("checkoutdate") Date checkoutdate
//    );



}
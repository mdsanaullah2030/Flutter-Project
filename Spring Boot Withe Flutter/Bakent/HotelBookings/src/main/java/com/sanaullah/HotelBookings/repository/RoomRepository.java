package com.sanaullah.HotelBookings.repository;

import com.sanaullah.HotelBookings.entity.Hotel;
import com.sanaullah.HotelBookings.entity.Room;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface RoomRepository extends JpaRepository<Room,Integer> {

    @Query("Select r from Room r Where r.hotel.name= :hotelName")
    public List<Room> findRoomByHotelName(@Param("hotelName") String hotelName);

    @Query("Select r from Room r Where r.hotel.id= :hotelid")
    public List<Room> findRoomByHotelId(@Param("hotelid") int hotelid);

    public List<Room> findAllByHotelId(int hotelId);

    public List<Room> deleteAllByHotelId(int hotelId);


    @Query("SELECT r.hotel FROM Room r WHERE r.id = :roomId")
    Hotel findHotelByRoomId(int roomId);

}
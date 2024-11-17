package com.sanaullah.HotelBookings.repository;

import com.sanaullah.HotelBookings.entity.Hotel;
import com.sanaullah.HotelBookings.entity.Location;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import java.util.List;

@Repository
public interface LocationRepository extends JpaRepository<Location, Integer> {

    @Query("SELECT l FROM Location l WHERE l.name = :locationName")
    List<Location> findLocationName(@Param("locationName") String locationName);


}
package com.sanaullah.HotelBookings.restController;

import com.sanaullah.HotelBookings.entity.Hotel;
import com.sanaullah.HotelBookings.entity.Location;
import com.sanaullah.HotelBookings.service.HotelService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
@RestController
@RequestMapping("/api/hotel")

public class HotelRestController {


    @Autowired
    private HotelService hotelService;


    @PostMapping("/save")
    @PreAuthorize("hasRole('ADMIN') or hasRole('HOTEL')")
    public ResponseEntity<String> saveHotel(
            @RequestPart(value = "hotel") Hotel hotel,
            @RequestParam(value = "image", required = true)MultipartFile file
    ) throws IOException {

        hotelService.saveHotel(hotel,file);

        return new ResponseEntity<>("Hotel added successfully with image.", HttpStatus.OK);

    }

    @GetMapping("/")
    public ResponseEntity<List<Hotel>> getAllHotel() {
        List<Hotel> hotels = hotelService.getAllHotel();
        return ResponseEntity.ok(hotels);
    }

    @GetMapping("/{id}")
    public ResponseEntity<Hotel> getHotelById(@PathVariable int id) {
        Hotel hotel = hotelService.getHotelById(id);
        return ResponseEntity.ok(hotel);
    }

    @GetMapping("/getHotelsByLocationId")
    public ResponseEntity<List<Hotel>> getHotelsByLocationId(@RequestParam int locationId) {
        List<Hotel> hotels = hotelService.findHotelsByLocationId(locationId);
        return ResponseEntity.ok(hotels);
    }

    @GetMapping("/h/searchhotel")
    public ResponseEntity<List<Hotel>> findHotelsByLocationName(@RequestParam(value = "locationName") String locationName) {
        List<Hotel> hotels = hotelService.findHotelsByLocationName(locationName);
        return ResponseEntity.ok(hotels);
    }

    @DeleteMapping("/delete/{id}")
    public ResponseEntity<String> deleteHotel(@PathVariable int id) {
        try {
            hotelService.deleteHotel(id);
            return new ResponseEntity<>("Hotel deleted successfully", HttpStatus.OK);
        } catch (RuntimeException e) {
            return new ResponseEntity<>("Hotel not found with this ID", HttpStatus.NOT_FOUND);
        }
    }
    @PutMapping("/updatehotel/{id}")
    public ResponseEntity<String> updateHotel(
            @PathVariable int id,
            @RequestPart("hotel") Hotel hotel,
            @RequestParam(value = "image", required = false) MultipartFile file
    ) throws IOException {
        try {
            hotelService.updateHotel(id, hotel, file);
            return ResponseEntity.ok("Hotel updated successfully");
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Hotel not found with this ID");
        }
    }

}






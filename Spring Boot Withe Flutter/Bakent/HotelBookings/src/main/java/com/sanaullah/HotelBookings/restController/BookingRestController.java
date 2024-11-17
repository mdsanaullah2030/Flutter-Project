package com.sanaullah.HotelBookings.restController;

import com.sanaullah.HotelBookings.entity.Booking;
import com.sanaullah.HotelBookings.dto.BookingDTO;
import com.sanaullah.HotelBookings.service.BookingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.io.IOException;
import java.util.List;

@RestController
@RequestMapping("/api/booking")
@CrossOrigin("*")
public class BookingRestController {

    @Autowired
    private BookingService bookingService;

    @PostMapping("/save")
    public ResponseEntity<Booking> saveBooking(
            @RequestBody Booking booking
    ) throws IOException {

        bookingService.saveBookings(booking);

        return new ResponseEntity<>(booking, HttpStatus.OK);
    }

    @GetMapping("/")
    public ResponseEntity<List<BookingDTO>> getAllBookings() {
        List<BookingDTO> bookings = bookingService.getAllBookings();
        return ResponseEntity.ok(bookings); // Return the bookings as JSON response
    }


    @PutMapping("/update/{id}")
    public ResponseEntity<String> updateBooking(@PathVariable int id, @RequestBody Booking updatedBooking) {
        try {
            bookingService.updateBooking(id, updatedBooking);
            return ResponseEntity.ok("Booking updated successfully.");
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(e.getMessage());
        }
    }



}
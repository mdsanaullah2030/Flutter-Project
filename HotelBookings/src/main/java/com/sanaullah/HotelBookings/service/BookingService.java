package com.sanaullah.HotelBookings.service;

import com.sanaullah.HotelBookings.dto.BookingDTO;
import com.sanaullah.HotelBookings.entity.*;
import com.sanaullah.HotelBookings.repository.*;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.io.IOException;
import java.util.List;
import java.util.concurrent.TimeUnit;
import java.util.stream.Collectors;

@Service
public class BookingService {

    @Autowired
    private BookingRepository bookingRepository;

    @Autowired
    private RoomRepository roomRepository;

    @Autowired
    private HotelRepository hotelRepository;
    @Autowired
    private UserRepository userRepository;
    @Autowired
    private LocationRepository locationRepository;

//    public List<Booking> getAllBookings() {
//        return bookingRepository.findAll();
//    }


    public List<BookingDTO> getAllBookings() {
        return bookingRepository.findAll().stream()
                .map(booking -> new BookingDTO(
                        booking.getCheckindate(),
                        booking.getCheckoutdate(),
                        booking.getTotalprice(),
                        booking.getRoom().getRoomType(),
                        booking.getRoom().getHotel().getName(),
                        booking.getUser().getName(), // Fetch user name
                        booking.getUser().getEmail() // Fetch user email
                ))
                .collect(Collectors.toList());
    }

    public Booking getBookingById(int id) {
        return bookingRepository.findById(id).orElse(new Booking());
    }

    public void saveBookings(Booking booking) throws IOException {
        Room room = roomRepository.findById(booking.getRoom().getId())
                .orElseThrow(() -> new RuntimeException("Room not found for ID " + booking.getRoom().getId()));

        Hotel hotel = roomRepository.findHotelByRoomId(room.getHotel().getId());


        //new//


        java.sql.Date checkindate = booking.getCheckindate();
        java.sql.Date checkoutdate = booking.getCheckoutdate();

    // Calculate the difference in milliseconds
        long diffInMillies = checkoutdate.getTime() - checkindate.getTime();

    // Convert milliseconds to days
        int dayCount = (int) TimeUnit.DAYS.convert(diffInMillies, TimeUnit.MILLISECONDS);
        float totalPrice=room.getPrice()*dayCount;

        booking.setTotalprice(totalPrice);

        User user=userRepository.findById(booking.getUser().getId())
                .orElseThrow(()-> new RuntimeException("User With this Id not Found"));



        booking.setRoom(room);
        booking.setHotel(hotel);
        booking.setUser(user);

        bookingRepository.save(booking);



    }



    public void updateBooking(int id, Booking updatedBooking) {
        // Fetch the existing booking
        Booking existingBooking = bookingRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Booking not found with this ID"));

        // Update booking fields
        existingBooking.setCheckindate(updatedBooking.getCheckindate());
        existingBooking.setCheckoutdate(updatedBooking.getCheckoutdate());

        // Recalculate the total price based on updated check-in and check-out dates
        long diffInMillies = updatedBooking.getCheckoutdate().getTime() - updatedBooking.getCheckindate().getTime();
        int dayCount = (int) TimeUnit.DAYS.convert(diffInMillies, TimeUnit.MILLISECONDS);
        float totalPrice = existingBooking.getRoom().getPrice() * dayCount;
        existingBooking.setTotalprice(totalPrice);

        // Find and set the room associated with the booking
        Room room = roomRepository.findById(updatedBooking.getRoom().getId())
                .orElseThrow(() -> new RuntimeException("Room with this ID not found"));
        existingBooking.setRoom(room);

        // Save the updated booking (not the room)
        bookingRepository.save(existingBooking);
    }

}
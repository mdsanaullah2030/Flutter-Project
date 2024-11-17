package com.sanaullah.HotelBookings.restController;

import com.sanaullah.HotelBookings.entity.Hotel;
import com.sanaullah.HotelBookings.entity.Location;
import com.sanaullah.HotelBookings.entity.Room;
import com.sanaullah.HotelBookings.service.RoomService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;
@RestController
@RequestMapping("/api/room")

public class RoomRestController {

    @Autowired
    private RoomService roomService;

    @PostMapping("/save")
    public ResponseEntity<String> saveRoom(
            @RequestPart(value = "room") Room room,
            @RequestParam(value = "image", required = true) MultipartFile file
    ) throws IOException {

        roomService.saveRoom(room,file);

        return new ResponseEntity<>("Room added successfully with image.", HttpStatus.OK);

    }


    @GetMapping("/")
    public ResponseEntity<List<Room>> getAllRoom() {
        List<Room> rooms = roomService.getALlRooms();
        return ResponseEntity.ok(rooms);
    }



    @GetMapping("/{id}")
    public ResponseEntity<Room> findRoomById(@PathVariable int id) {
        try {
            Room room = roomService.findById(id);
            return ResponseEntity.ok(room);
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body(null);
        }
    }


    @GetMapping("/r/searchroom")
    public ResponseEntity<List<Room>> findRoomByHotelName(@RequestParam("hotelName")String hotelName) {
        List<Room> rooms = roomService.findRoomByHotelName(hotelName);
        return ResponseEntity.ok(rooms);
    }
    @GetMapping("/r/searchroombyid")
    public ResponseEntity<List<Room>> findRoomByHotelId(@RequestParam("hotelid") int hotelid) {
        List<Room> rooms = roomService.findRoomByHotelId(hotelid);
        return ResponseEntity.ok(rooms);
    }




    @PutMapping("/updateroom/{id}")
    public ResponseEntity<String> updateRoom(
            @PathVariable int id,
            @RequestPart("room") Room room,
            @RequestParam(value = "image", required = false) MultipartFile file
    ) throws IOException {
        try {
            roomService.updateRoom(id, room, file);
            return ResponseEntity.ok("Room updated successfully");
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Room not found with this ID");
        }
    }
}

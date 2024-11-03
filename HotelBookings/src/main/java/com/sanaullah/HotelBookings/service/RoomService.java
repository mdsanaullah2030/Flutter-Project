
package com.sanaullah.HotelBookings.service;

import com.sanaullah.HotelBookings.entity.Hotel;
import com.sanaullah.HotelBookings.entity.Location;
import com.sanaullah.HotelBookings.entity.Room;
import com.sanaullah.HotelBookings.repository.HotelRepository;
import com.sanaullah.HotelBookings.repository.RoomRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.UUID;

@Service
public class RoomService {
    @Autowired
    private RoomRepository roomRepository;
    @Autowired
    private HotelRepository hotelRepository;

    @Value("src/main/resources/static/images")
    private String uploadDir;


    public List<Room> getALlRooms() {

        return roomRepository.findAll();

    }
    public Room getRoomById(int id){

        return roomRepository.findById(id).orElse(new Room());
    }



    @Transactional
    public void saveRoom(Room room, MultipartFile imageFile) throws IOException {

        Hotel hotel = hotelRepository.findById(room.getHotel().getId())
                .orElseThrow(() -> new RuntimeException("Hotel With this Id not Found"));



        if (imageFile != null && !imageFile.isEmpty()) {
            String imageFilename = saveImage(imageFile, room);
            room.setImage(imageFilename); // Set the image filename in the user entity
        }

        room.setHotel(hotel);


        roomRepository.save(room);

    }




    @Transactional
    public void updateRoom(int id, Room updatedRoom, MultipartFile imageFile) throws IOException {
        // Fetch the existing room
        Room existingRoom = roomRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Room not found with this ID"));

        // Update room details
        existingRoom.setRoomType(updatedRoom.getRoomType());

        existingRoom.setAdultNo(updatedRoom.getAdultNo());
        existingRoom.setChildNo(updatedRoom.getChildNo());
        existingRoom.setArea(updatedRoom.getArea());
        existingRoom.setPrice(updatedRoom.getPrice());
        existingRoom.setAvilability(updatedRoom.isAvilability());

        // Update the hotel association
        Hotel hotel = hotelRepository.findById(updatedRoom.getHotel().getId())
                .orElseThrow(() -> new RuntimeException("Hotel with this ID not found"));
        existingRoom.setHotel(hotel);

        // Update image if a new one is provided
        if (imageFile != null && !imageFile.isEmpty()) {
            String imageFilename = saveImage(imageFile, existingRoom);
            existingRoom.setImage(imageFilename);
        }

        // Save the updated room
        roomRepository.save(existingRoom);
    }

    public List<Room> findRoomByHotelName(String hotelName) {

        return roomRepository.findRoomByHotelName(hotelName);

    }



    private String saveImage(MultipartFile file, Room r) throws IOException {
        Path uploadPath = Paths.get(uploadDir + "/room");
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }


        // Generate a unique filename
        String filename = r.getRoomType() + "_" + UUID.randomUUID().toString();
        Path filePath = uploadPath.resolve(filename);

        // Save the file
        Files.copy(file.getInputStream(), filePath);

        return filename; // Return the filename for storing in the database
    }




    public void updateRoom(Room room) {
        roomRepository.save(room);
    }



    public  Room findById(int id){
        return   roomRepository.findById(id)
                .orElseThrow(()-> new RuntimeException("Location Not Found by this Id"));
    }


    public List<Room> findRoomByHotelId(int hotelid) {

        return roomRepository.findRoomByHotelId(hotelid);

    }



}

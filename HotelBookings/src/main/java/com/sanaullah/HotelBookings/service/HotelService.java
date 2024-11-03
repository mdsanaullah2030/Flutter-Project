
package com.sanaullah.HotelBookings.service;


import com.sanaullah.HotelBookings.entity.Hotel;
import com.sanaullah.HotelBookings.entity.Location;

import com.sanaullah.HotelBookings.repository.HotelRepository;
import com.sanaullah.HotelBookings.repository.LocationRepository;
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
public class HotelService {

    @Autowired
    private HotelRepository hotelRepository;
    @Autowired
    private LocationRepository locationRepository;

    @Value("src/main/resources/static/images")
    private  String uploadDir;


    public List<Hotel> getAllHotel(){

        return  hotelRepository.findAll();
    }

    public Hotel getHotelById(int id){

        return hotelRepository.findById(id).orElse(new Hotel());
    }


    @Transactional
    public void saveHotel(Hotel hotel, MultipartFile imageFile) throws IOException {

        Location location=locationRepository.findById(hotel.getLocation().getId())
                .orElseThrow(()-> new RuntimeException("Location With this Id not Found"));


        if (imageFile != null && !imageFile.isEmpty()) {
            String imageFilename = saveImage(imageFile, hotel);
            hotel.setImage(imageFilename); // Set the image filename in the user entity
        }



        hotel.setLocation(location);
        hotelRepository.save(hotel);

    }



    @Transactional
    public void updateHotel(int id, Hotel updatedHotel, MultipartFile imageFile) throws IOException {
        Hotel existingHotel = hotelRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Hotel not found with this ID"));

        // Update hotel details
        existingHotel.setName(updatedHotel.getName());
        existingHotel.setAddress(updatedHotel.getAddress());
        existingHotel.setRating(updatedHotel.getRating());
        existingHotel.setMinPrice(updatedHotel.getMinPrice());
        existingHotel.setMaxPrice(updatedHotel.getMaxPrice());

        // Update location
        Location location = locationRepository.findById(updatedHotel.getLocation().getId())
                .orElseThrow(() -> new RuntimeException("Location with this ID not found"));
        existingHotel.setLocation(location);

        // Update image if provided
        if (imageFile != null && !imageFile.isEmpty()) {
            String imageFilename = saveImage(imageFile, existingHotel);
            existingHotel.setImage(imageFilename);
        }

        hotelRepository.save(existingHotel);
    }



    //hotel to room serarch id Name//
    public List<Hotel> findHotelsByLocationName(String locationName){

        return hotelRepository.findHotelsByLocationName(locationName);
    }

    //hotel to room serarch id Use//
    public List<Hotel> findHotelsByLocationId(int locationid) {

        return hotelRepository.findHotelsByLocationId(locationid);

    }



    private String saveImage(MultipartFile file, Hotel h) throws IOException {
        Path uploadPath = Paths.get(uploadDir+"/hotel");
        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }


        String filename = h.getName()+"_"+UUID.randomUUID().toString() ;
        Path filePath = uploadPath.resolve(filename);


        Files.copy(file.getInputStream(), filePath);

        return filename;
    }

    @Transactional
    public void deleteHotel(int id) {
        hotelRepository.deleteById(id);
    }


}

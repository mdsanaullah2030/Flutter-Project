
package com.sanaullah.HotelBookings.service;

import com.sanaullah.HotelBookings.entity.Hotel;
import com.sanaullah.HotelBookings.entity.Location;
import com.sanaullah.HotelBookings.entity.Room;
import com.sanaullah.HotelBookings.repository.HotelRepository;
import com.sanaullah.HotelBookings.repository.LocationRepository;
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
public class LocetionService {
    @Autowired
    private LocationRepository locationRepository;

    @Value("src/main/resources/static/images")
    private String uploadDir;
    @Autowired
    private RoomRepository roomRepository;
    @Autowired
    private HotelRepository hotelRepository;

    public List<Location> getALlLocation(){

        return locationRepository.findAll();

    }

    public Location getLocationById(int id){

        return locationRepository.findById(id).orElse(new Location());
    }

    @Transactional
    public void saveLocation(Location location, MultipartFile imageFile) throws IOException {



        if (imageFile != null && !imageFile.isEmpty()) {
            String imageFileName = saveImage(imageFile, location);
            location.setImage(imageFileName);
        }

        locationRepository.save(location);
    }



    public String saveImage(MultipartFile file, Location l) throws IOException {
        Path uploadPath = Paths.get(uploadDir + "/location");

        if (!Files.exists(uploadPath)) {
            Files.createDirectories(uploadPath);
        }

        String filename = l.getName() + "_" + UUID.randomUUID().toString();
        Path filePath = uploadPath.resolve(filename);

        Files.copy(file.getInputStream(), filePath);


        return filename;
    }
    @Transactional
    public void updateLocation(int id, Location location, MultipartFile imageFile) throws IOException {
        Location existingLocation = locationRepository.findById(id)
                .orElseThrow(() -> new RuntimeException("Location not found with this ID"));

        // Update existing fields with new data
        existingLocation.setName(location.getName());

        // Handle image upload if provided
        if (imageFile != null && !imageFile.isEmpty()) {
            String imageFileName = saveImage(imageFile, existingLocation);
            existingLocation.setImage(imageFileName);
        }

        locationRepository.save(existingLocation);
    }




    public Location findByid(int id) {
        return locationRepository.findById(id).get();
    }




    public  Location findById(int id){
        return   locationRepository.findById(id)
                .orElseThrow(()-> new RuntimeException("Location Not Found by this Id"));
    }


    @Transactional
    public boolean deleteLocation(int id) {
        try {
            List<Hotel> hotels = hotelRepository.findAllByLocationId(id);
            for (Hotel hotel : hotels) {
                roomRepository.deleteAllByHotelId(hotel.getId());
            }
            hotelRepository.deleteAllByLocationId(id);
            locationRepository.deleteById(id);
            return true;
        } catch (Exception e) {
            return false;
        }
    }





    public List<Location> findLocationName(String locationName){
        return locationRepository.findLocationName(locationName);
    }
}

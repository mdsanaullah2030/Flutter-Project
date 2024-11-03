package com.sanaullah.HotelBookings.restController;

import com.sanaullah.HotelBookings.entity.Hotel;
import com.sanaullah.HotelBookings.entity.Location;
import com.sanaullah.HotelBookings.service.LocetionService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

@RestController
@RequestMapping("/api/location")

public class LocationRestController {
    @Autowired
    private LocetionService locetionService;

    @GetMapping("/")
    public ResponseEntity<List<Location>> getAllLocation() {
        List<Location> locations = locetionService.getALlLocation();
        return ResponseEntity.ok(locations);
    }

    @PostMapping("/save")
    public ResponseEntity<String> saveLocation(
            @RequestPart(value = "location") Location location,
            @RequestParam(value = "image", required = true) MultipartFile file
    ) throws IOException {
        locetionService.saveLocation(location, file);

        return new ResponseEntity<>("Location added succesfully with image", HttpStatus.OK);

    }
    @GetMapping("/{id}")
    public ResponseEntity<Location> getLocationById(@PathVariable int id) {
        Location location = locetionService.getLocationById(id);
        return ResponseEntity.ok(location);
    }

    @PutMapping("/location/{id}")
    public ResponseEntity<String> updateHotel(
            @PathVariable int id,
            @RequestPart("location") Location location,
            @RequestParam(value = "image", required = false) MultipartFile file
    ) throws IOException {
        try {
            locetionService.updateLocation(id, location, file);
            return ResponseEntity.ok("location updated successfully");
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Hotel not found with this ID");
        }
    }

    @DeleteMapping("/delete/{id}")
    public ResponseEntity<String> deleteLocation(@PathVariable int id) {
        try {
            locetionService.deleteLocation(id);
            return ResponseEntity.ok("Location deleted successfully");
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Location not found with this ID");
        }
    }


    @PutMapping("/update/{id}")
    public ResponseEntity<String> updateLocation(
            @PathVariable int id,
            @RequestPart("location") Location location,
            @RequestParam(value = "image", required = false) MultipartFile file
    ) throws IOException {
        try {
            locetionService.updateLocation(id, location, file);
            return ResponseEntity.ok("Location updated successfully");
        } catch (RuntimeException e) {
            return ResponseEntity.status(HttpStatus.NOT_FOUND).body("Location not found with this ID");
        }
    }

    @GetMapping("/findLocationName")
    public ResponseEntity<List<Location>> findLocationName(@RequestParam(value = "locationName") String locationName) {
        List<Location> location = locetionService.findLocationName(locationName);
        return ResponseEntity.ok(location);
    }



}

package com.sanaullah.HotelBookings.security;

import com.sanaullah.HotelBookings.jwt.JwtAuthenticationFilter;
import com.sanaullah.HotelBookings.service.UserService;
import lombok.RequiredArgsConstructor;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.config.Customizer;
import org.springframework.security.config.annotation.authentication.configuration.AuthenticationConfiguration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.List;

@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {

    private final UserService userService;
    private final JwtAuthenticationFilter jwtAuthenticationFilter;

    @Bean
    public SecurityFilterChain filterChain(HttpSecurity http) throws Exception {

        return
                http

                        .csrf(AbstractHttpConfigurer::disable)
                        .cors(Customizer.withDefaults())
                        .authorizeHttpRequests(
                                req ->
                                        req.requestMatchers("/login", "/register", "/register/admin",

                                                        "/api/location/findLocationName","/api/location/**",

                                                        "/api/hotel/getHotelsByLocationId","/api/hotel/","api/hotel/{id}",

                                                         "api/room/","api/room/{id}","/api/room/r/searchroombyid",
                                                        "/api/room/r/searchroom",
                                                         "/api/booking/",
                                                        "/api/booking/save","/activate/**",
                                                        "/images/**")
                                                .permitAll()
                                                .requestMatchers("/api/hotel/save",
                                                        "/api/room/save","/api/location/save",
                                                        "/api/hotel/updatehotel/{id}","/api/room/updateroom/{id}",
                                                        "/api/location/update/{id}")
                                                .hasAnyAuthority("ADMIN","HOTEL")
                                                .requestMatchers("api/hotel/{id}", "api/room/{id}","api/hotel/all/**","/api/hotel/save")
                                                .hasAnyAuthority("ADMIN", "HOTEL")
                                                .requestMatchers("api/user/**")
                                                .hasAuthority("USER")

                        )
                        .userDetailsService(userService)
                        .sessionManagement(
                                session ->
                                        session.sessionCreationPolicy(SessionCreationPolicy.STATELESS)
                        )
                        .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class)
                        .build();


    }



    @Bean
    public PasswordEncoder encoder() {
        return new BCryptPasswordEncoder();
    }


    @Bean
    public AuthenticationManager authenticationManager(AuthenticationConfiguration configuration) throws Exception {
        return configuration.getAuthenticationManager();
    }


    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        configuration.setAllowedOrigins(List.of("http://localhost:4200", "http://localhost:8181"));  // Add allowed origins
        configuration.setAllowedMethods(List.of("GET", "POST", "PUT", "DELETE", "OPTIONS"));
        configuration.setAllowedHeaders(List.of("Authorization", "Cache-Control", "Content-Type"));
        configuration.setAllowCredentials(true);

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);  // Apply CORS settings to all endpoints
        return source;
    }


}

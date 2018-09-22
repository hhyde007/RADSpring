/*
 *  Generated from GenSpringBootGen
 *  Copyright(c) 2019 by RADical Information Design Corporation
 *  Template: ServiceImplTemplate.java.txt
*/ 
package com.radinfodesign.radspringbootgen.fboace.service;

import static java.lang.System.out;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;
import java.util.Collection;
import java.util.HashSet;
import java.util.List;

import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.radinfodesign.radspringbootgen.fboace.dao.FlightRepository;
import com.radinfodesign.radspringbootgen.fboace.dao.FlightCrewMemberRepository;
import com.radinfodesign.radspringbootgen.fboace.dao.PilotRepository;
import com.radinfodesign.radspringbootgen.fboace.dao.AircraftRepository;
import com.radinfodesign.radspringbootgen.fboace.dao.AirportRepository;
import com.radinfodesign.radspringbootgen.fboace.model.Flight;
import com.radinfodesign.radspringbootgen.fboace.model.FlightCrewMember;
import com.radinfodesign.radspringbootgen.fboace.model.Pilot;

@Service
public class FlightServiceImpl implements FlightService{
  
  @Autowired
  FlightRepository flightRepository; 
  @Autowired
  FlightCrewMemberRepository flightCrewMemberRepository;
  @Autowired
  PilotRepository pilotRepository;
  @Autowired
  AircraftRepository aircraftRepository;
  @Autowired
  AirportRepository airportRepository;
  
  @Override
  public List<Flight> getAll() {
    return flightRepository.findAllInDefaultOrder();
  }
  
  @Override
  public Flight getEntity (Integer flightId) {
    return flightRepository.findOne(flightId);
  }
 
  @Override
  @Transactional
  public Flight putEntity 
       ( Integer flightId
       , String shortName
       , String longName
       , String departureDateTime
       , String arrivalDateTime
       , String notes
       , Integer aircraftId
       , Integer airportIdDeparture
       , Integer airportIdDestination
       , String[] flightCrewMemberNotess
       , Integer[] flightCrewMemberPilotIds
       ) throws Exception
  {
    out.println("FlightServiceClass.putEntity()");
    Flight flight;
    if (flightId==null || flightId==0) flight = new Flight();
    else flight = flightRepository.findOne(flightId);
    
    LocalDateTime departureDateTime_ = null;
    try {
       departureDateTime_ = LocalDateTime.parse(departureDateTime, DateTimeFormatter.ISO_LOCAL_DATE_TIME);
    } catch (DateTimeParseException e) {
      out.println("No good value for departureDateTime: " + e.getMessage());
    }
    flight.setDepartureDateTime(departureDateTime_);
    LocalDateTime arrivalDateTime_ = null;
    try {
       arrivalDateTime_ = LocalDateTime.parse(arrivalDateTime, DateTimeFormatter.ISO_LOCAL_DATE_TIME);
    } catch (DateTimeParseException e) {
      out.println("No good value for arrivalDateTime: " + e.getMessage());
    }
    flight.setArrivalDateTime(arrivalDateTime_);
    
    flight.setShortName(shortName);
    flight.setLongName(longName);
    flight.setNotes(notes);
    flight.setAircraft(aircraftRepository.findOne(aircraftId));
    flight.setAirportDeparture(airportRepository.findOne(airportIdDeparture));
    flight.setAirportDestination(airportRepository.findOne(airportIdDestination));
    
    flight = flightRepository.save(flight);
    System.out.println("FlightServiceImpl.putEntity: id = " + flight.getFlightId());

    Pilot pilot = null;
    
    FlightCrewMember flightCrewMember = null;
    if (flightCrewMemberPilotIds != null) {
      final int NEW_RECORD = flightCrewMemberPilotIds.length-1; // ASSUME LAST RECORD REPRESENTS NEW/BLANK TO BE INSERTED.
      for (int i=0; i<flightCrewMemberPilotIds.length; i++) {
        pilot = pilotRepository.findOne(flightCrewMemberPilotIds[i]);
        if (pilot == null | flight == null) continue; // flight should NEVER be null at this point
        if (i==NEW_RECORD) {
          flightCrewMember = new FlightCrewMember(flight, pilot);
          out.println("NEW flightCrewMember = " + flightCrewMember);
        }
        else {
          flightCrewMember = flightCrewMemberRepository.findOneByFlightAndPilot(flight, pilot);
        }
        
        if (flightCrewMemberNotess.length > 0)
          flightCrewMember.setNotes(flightCrewMemberNotess[i]);
        
        if (i==NEW_RECORD) {
          int insertResult = flightCrewMemberRepository.insertFlightCrewMember(flightCrewMember);
        }
        else {
          flightCrewMember = flightCrewMemberRepository.save(flightCrewMember);
        }
      }
    }
                
                 
    return flight;
  }
  
  @Override
  @Transactional
  public int deleteEntity(Integer flightId) {
    Flight flight = flightRepository.findOne(flightId);
    try {
      flightRepository.delete(flight);
      return 1;
    } catch (Exception e) { // WILL THIS EVER HAPPEN? WHAT HAPPENS IF DELETE FAILS?
      out.println("FlightServiceClass threw Exception: " + e.getMessage());
      e.printStackTrace();
      return -1;
    }
  }

  @Override
  @Transactional
  public int deleteFlightCrewMember 
                  ( Integer flightCrewMemberFlightId
                  , Integer flightCrewMemberPilotId
                  ) {
    Flight flight = flightRepository.findOne(flightCrewMemberFlightId);
    Pilot pilot = pilotRepository.findOne(flightCrewMemberPilotId);
    FlightCrewMember flightCrewMember = flightCrewMemberRepository.findOneByFlightAndPilot(flight, pilot);
    if (flightCrewMember != null) { 
      flightCrewMemberRepository.delete(flightCrewMember);
      return 1;
    }
    else { return -1; }
  }
  
  
  public List<Flight> getQualifiedFlightsByPilotId (Integer pilotId){
    return flightRepository.selectQualifiedFlightsByPilotId(pilotId);
  }
      
}


/*
 *  Generated from GenSpringBootGen
 *  Copyright(c) 2018 by RADical Information Design Corporation
 *  Template: ServiceTemplate.java.txt
*/ 
package com.radinfodesign.radspringbootgen.fboace.service;

import com.radinfodesign.radspringbootgen.fboace.model.Flight;
import com.radinfodesign.radspringbootgen.fboace.model.Pilot;
import java.util.List;

public interface FlightService {

  List<Flight> getAll();
  
  Flight getEntity (Integer flightId);
  
  Flight putEntity 
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
      ) throws Exception;
  
  int deleteEntity(Integer flightId);

  int deleteFlightCrewMember 
                  ( Integer flightCrewMemberFlightId
                  , Integer flightCrewMemberPilotId
                  );
  
  List<Flight> getQualifiedFlightsByPilotId (Integer pilotId);
      
}

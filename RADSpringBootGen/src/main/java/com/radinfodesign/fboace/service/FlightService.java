package com.radinfodesign.fboace.service;

import com.radinfodesign.fboace.model.Flight;
import com.radinfodesign.fboace.model.Pilot;
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

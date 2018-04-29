package com.radinfodesign.fboace.service;

import com.radinfodesign.fboace.model.Pilot;
import com.radinfodesign.fboace.model.AircraftType;
import com.radinfodesign.fboace.model.Flight;
import java.util.List;

public interface PilotService {

  List<Pilot> getAll();
  
  Pilot getEntity (Integer pilotId);
  
  Pilot putEntity 
      ( Integer pilotId
      , String lastName
      , String firstName
      , String middleInitial
      , String nationalIdNumber
      , String birthdate
      , String notes
      , String[] pilotCertificationCertificationNumbers
      , String[] pilotCertificationValidFromDates
      , String[] pilotCertificationExpirationDates
      , String[] pilotCertificationNotess
      , Integer[] pilotCertificationAircraftTypeIds
      , String[] flightCrewMemberNotess
      , Integer[] flightCrewMemberFlightIds
      , String[] pilotRareThingShortNames
      , String[] pilotRareThingLongNames
      , String[] pilotRareThingNotess
      ) throws Exception;
  
  int deleteEntity(Integer pilotId);

  int deletePilotCertification 
                  ( Integer pilotCertificationPilotId
                  , Integer pilotCertificationAircraftTypeId
                  );
  int deleteFlightCrewMember 
                  ( Integer flightCrewMemberFlightId
                  , Integer flightCrewMemberPilotId
                  );
                
  int deletePilotRareThing 
                  ( Integer pilotRareThingPilotId
                  );

  List<Pilot> getQualifiedPilotsByAircraftTypeId (Integer aircraftTypeId);
  List<Pilot> getQualifiedPilotsByFlightId (Integer flightId);
      
}

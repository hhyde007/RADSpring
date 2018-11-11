/*
 *  Generated from GenSpringBootGen
 *  Copyright(c) 2018 by RADical Information Design Corporation
 *  Template: ServiceTemplate.java.txt
*/ 
package com.radinfodesign.radspringbootgen.fboace.service;

import com.radinfodesign.radspringbootgen.fboace.model.Pilot;
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
  
  List<Pilot> getQualifiedPilotsByAircraftTypeId (Integer aircraftTypeId);
  List<Pilot> getQualifiedPilotsByFlightId (Integer flightId);
      
}

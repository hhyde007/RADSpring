/*
 *  Generated from GenSpringBootGen
 *  Copyright(c) 2018 by RADical Information Design Corporation
 *  Template: ServiceTemplate.java.txt
*/ 
package com.radinfodesign.radspringbootgen.fboace.service;

import com.radinfodesign.radspringbootgen.fboace.model.AircraftType;
import java.util.List;

public interface AircraftTypeService {

  List<AircraftType> getAll();
  
  AircraftType getEntity (Integer aircraftTypeId);
  
  AircraftType putEntity 
      ( Integer aircraftTypeId
      , String shortName
      , String longName
      , String description
      , String notes
      , Integer[] aircraftAircraftIds
      , String[] aircraftShortNames
      , String[] aircraftLongNames
      , String[] aircraftDescriptions
      , String[] aircraftNotess
      , String[] pilotCertificationCertificationNumbers
      , String[] pilotCertificationValidFromDates
      , String[] pilotCertificationExpirationDates
      , String[] pilotCertificationNotess
      , Integer[] pilotCertificationPilotIds
      ) throws Exception;
  
  int deleteEntity(Integer aircraftTypeId);

  int deletePilotCertification 
                  ( Integer pilotCertificationPilotId
                  , Integer pilotCertificationAircraftTypeId
                  );
  int deleteAircraft (Integer aircraftId);
  
  List<AircraftType> getQualifiedAircraftTypesByPilotId (Integer pilotId);
      
}

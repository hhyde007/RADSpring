/*
 *  Generated from GenSpringBootGen
 *  Copyright(c) 2018 by RADical Information Design Corporation
 *  Template: ServiceTemplate.java.txt
*/ 
package com.radinfodesign.radspringbootgen.fboace.service;

import com.radinfodesign.radspringbootgen.fboace.model.Aircraft;
import java.util.List;

public interface AircraftService {

  List<Aircraft> getAll();
  
  Aircraft getEntity (Integer aircraftId);
  
  Aircraft putEntity 
      ( Integer aircraftId
      , String shortName
      , String longName
      , String description
      , String notes
      , Integer aircraftTypeId
      ) throws Exception;
  
  int deleteEntity(Integer aircraftId);

  
      
}

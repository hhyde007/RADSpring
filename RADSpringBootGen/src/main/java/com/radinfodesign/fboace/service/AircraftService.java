package com.radinfodesign.fboace.service;

import com.radinfodesign.fboace.model.Aircraft;
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

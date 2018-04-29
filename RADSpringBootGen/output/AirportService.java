/*
 *  Generated from GenSpringBootComponents(TM)
 *  Copyright(c) 2018 by RADical Information Design Corporation
 *  Template: ServiceTemplate.java.txt
*/ 
package com.radinfodesign.fboace.service;

import com.radinfodesign.fboace.model.Airport;
import java.util.List;

public interface AirportService {

  List<Airport> getAll();
  
  Airport getEntity (Integer airportId);
  
  Airport putEntity 
      ( Integer airportId
      , String shortName
      , String iataCode
      , String description
      , String portType
      ) throws Exception;
  
  int deleteEntity(Integer airportId);

  
      
}

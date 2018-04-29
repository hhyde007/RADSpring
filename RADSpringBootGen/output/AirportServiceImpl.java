/*
 *  Generated from GenSpringBootComponents(TM)
 *  Copyright(c) 2018 by RADical Information Design Corporation
 *  Template: ServiceImplTemplate.java.txt
*/ 
package com.radinfodesign.fboace.service;

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

import com.radinfodesign.fboace.dao.AirportRepository;
import com.radinfodesign.fboace.model.Airport;

@Service
public class AirportServiceImpl implements AirportService{
  
  @Autowired
  AirportRepository airportRepository; 
  
  @Override
  public List<Airport> getAll() {
    return airportRepository.findAllInDefaultOrder();
  }
  
  @Override
  public Airport getEntity (Integer airportId) {
    return airportRepository.findOne(airportId);
  }
 
  @Override
  @Transactional
  public Airport putEntity 
       ( Integer airportId
       , String shortName
       , String iataCode
       , String description
       , String portType
       ) throws Exception
  {
    out.println("AirportServiceClass.putEntity()");
    Airport airport;
    if (airportId==null || airportId==0) airport = new Airport();
    else airport = airportRepository.findOne(airportId);
    
    
    airport.setShortName(shortName);
    airport.setIataCode(iataCode);
    airport.setDescription(description);
    airport.setPortType(portType);
    
    airport = airportRepository.save(airport);
    System.out.println("AirportServiceImpl.putEntity: id = " + airport.getAirportId());

                
                 
    return airport;
  }
  
  @Override
  @Transactional
  public int deleteEntity(Integer airportId) {
    Airport airport = airportRepository.findOne(airportId);
    try {
      airportRepository.delete(airport);
      return 1;
    } catch (Exception e) { // WILL THIS EVER HAPPEN? WHAT HAPPENS IF DELETE FAILS?
      out.println("AirportServiceClass threw Exception: " + e.getMessage());
      e.printStackTrace();
      return -1;
    }
  }

  
  
      
}


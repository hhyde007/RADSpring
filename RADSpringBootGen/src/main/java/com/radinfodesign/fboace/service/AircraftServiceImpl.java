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

import com.radinfodesign.fboace.dao.AircraftRepository;
import com.radinfodesign.fboace.dao.AircraftTypeRepository;
import com.radinfodesign.fboace.model.Aircraft;

@Service
public class AircraftServiceImpl implements AircraftService{
  
  @Autowired
  AircraftRepository aircraftRepository; 
  @Autowired
  AircraftTypeRepository aircraftTypeRepository;
  
  @Override
  public List<Aircraft> getAll() {
    return aircraftRepository.findAllInDefaultOrder();
  }
  
  @Override
  public Aircraft getEntity (Integer aircraftId) {
    return aircraftRepository.findOne(aircraftId);
  }
 
  @Override
  @Transactional
  public Aircraft putEntity 
       ( Integer aircraftId
       , String shortName
       , String longName
       , String description
       , String notes
       , Integer aircraftTypeId
       ) throws Exception
  {
    out.println("AircraftServiceClass.putEntity()");
    Aircraft aircraft;
    if (aircraftId==null || aircraftId==0) aircraft = new Aircraft();
    else aircraft = aircraftRepository.findOne(aircraftId);
    
    
    aircraft.setShortName(shortName);
    aircraft.setLongName(longName);
    aircraft.setDescription(description);
    aircraft.setNotes(notes);
    aircraft.setAircraftTypeId(aircraftTypeRepository.findOne(aircraftTypeId));
    
    aircraft = aircraftRepository.save(aircraft);
    System.out.println("AircraftServiceImpl.putEntity: id = " + aircraft.getAircraftId());

                
                 
    return aircraft;
  }
  
  @Override
  @Transactional
  public int deleteEntity(Integer aircraftId) {
    Aircraft aircraft = aircraftRepository.findOne(aircraftId);
    try {
      aircraftRepository.delete(aircraft);
      return 1;
    } catch (Exception e) { // WILL THIS EVER HAPPEN? WHAT HAPPENS IF DELETE FAILS?
      out.println("AircraftServiceClass threw Exception: " + e.getMessage());
      e.printStackTrace();
      return -1;
    }
  }

  
  
      
}


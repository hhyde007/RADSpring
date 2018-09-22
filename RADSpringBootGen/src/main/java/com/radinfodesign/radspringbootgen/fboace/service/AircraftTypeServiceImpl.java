/*
 *  Generated from GenSpringBootGen
 *  Copyright(c) 2019 by RADical Information Design Corporation
 *  Template: ServiceImplTemplate.java.txt
*/ 
package com.radinfodesign.radspringbootgen.fboace.service;

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

import com.radinfodesign.radspringbootgen.fboace.dao.AircraftTypeRepository;
import com.radinfodesign.radspringbootgen.fboace.dao.AircraftRepository;
import com.radinfodesign.radspringbootgen.fboace.dao.PilotCertificationRepository;
import com.radinfodesign.radspringbootgen.fboace.dao.PilotRepository;
import com.radinfodesign.radspringbootgen.fboace.model.AircraftType;
import com.radinfodesign.radspringbootgen.fboace.model.Aircraft;
import com.radinfodesign.radspringbootgen.fboace.model.PilotCertification;
import com.radinfodesign.radspringbootgen.fboace.model.Pilot;

@Service
public class AircraftTypeServiceImpl implements AircraftTypeService{
  
  @Autowired
  AircraftTypeRepository aircraftTypeRepository; 
  @Autowired
  PilotCertificationRepository pilotCertificationRepository;
  @Autowired
  PilotRepository pilotRepository;
  @Autowired
  AircraftRepository aircraftRepository;
  
  @Override
  public List<AircraftType> getAll() {
    return aircraftTypeRepository.findAllInDefaultOrder();
  }
  
  @Override
  public AircraftType getEntity (Integer aircraftTypeId) {
    return aircraftTypeRepository.findOne(aircraftTypeId);
  }
 
  @Override
  @Transactional
  public AircraftType putEntity 
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
       ) throws Exception
  {
    out.println("AircraftTypeServiceClass.putEntity()");
    AircraftType aircraftType;
    if (aircraftTypeId==null || aircraftTypeId==0) aircraftType = new AircraftType();
    else aircraftType = aircraftTypeRepository.findOne(aircraftTypeId);
    
    
    aircraftType.setShortName(shortName);
    aircraftType.setLongName(longName);
    aircraftType.setDescription(description);
    aircraftType.setNotes(notes);
    
    aircraftType = aircraftTypeRepository.save(aircraftType);
    System.out.println("AircraftTypeServiceImpl.putEntity: id = " + aircraftType.getAircraftTypeId());

    Pilot pilot = null;
    
    PilotCertification pilotCertification = null;
    if (pilotCertificationPilotIds != null) {
      final int NEW_RECORD = pilotCertificationPilotIds.length-1; // ASSUME LAST RECORD REPRESENTS NEW/BLANK TO BE INSERTED.
      for (int i=0; i<pilotCertificationPilotIds.length; i++) {
        pilot = pilotRepository.findOne(pilotCertificationPilotIds[i]);
        if (pilot == null | aircraftType == null) continue; // aircraftType should NEVER be null at this point
        if (i==NEW_RECORD) {
          pilotCertification = new PilotCertification(pilot, aircraftType);
          out.println("NEW pilotCertification = " + pilotCertification);
        }
        else {
          pilotCertification = pilotCertificationRepository.findOneByPilotAndAircraftType(pilot, aircraftType);
        }
        LocalDate validFromDate_ = null;
        try {
           validFromDate_ = LocalDate.parse(pilotCertificationValidFromDates[i], DateTimeFormatter.ISO_LOCAL_DATE);
        } catch (DateTimeParseException e) {
          out.println("No good value for validFromDate: " + e.getMessage());
        }
        pilotCertification.setValidFromDate(validFromDate_);
        LocalDate expirationDate_ = null;
        try {
           expirationDate_ = LocalDate.parse(pilotCertificationExpirationDates[i], DateTimeFormatter.ISO_LOCAL_DATE);
        } catch (DateTimeParseException e) {
          out.println("No good value for expirationDate: " + e.getMessage());
        }
        pilotCertification.setExpirationDate(expirationDate_);
        
        if (pilotCertificationCertificationNumbers.length > 0)
          pilotCertification.setCertificationNumber(pilotCertificationCertificationNumbers[i]);
        if (pilotCertificationNotess.length > 0)
          pilotCertification.setNotes(pilotCertificationNotess[i]);
        
        if (i==NEW_RECORD) {
          int insertResult = pilotCertificationRepository.insertPilotCertification(pilotCertification);
        }
        else {
          pilotCertification = pilotCertificationRepository.save(pilotCertification);
        }
      }
    }
                
    Aircraft aircraft = null;
    if (aircraftShortNames != null) {
      for (int i=0; i<aircraftShortNames.length; i++) {
      if (aircraftShortNames[i] == null |  aircraftShortNames[i].equals("")) continue;
        if ((aircraftAircraftIds.length == 0) || (aircraftAircraftIds[i] == null)) {
          aircraft = new Aircraft();
        } else {
          aircraft = aircraftRepository.findOne(aircraftAircraftIds[i]);
        }
        if (aircraftShortNames.length > 0)
          aircraft.setShortName(aircraftShortNames[i]);
        if (aircraftLongNames.length > 0)
          aircraft.setLongName(aircraftLongNames[i]);
        if (aircraftDescriptions.length > 0)
          aircraft.setDescription(aircraftDescriptions[i]);
        if (aircraftNotess.length > 0)
          aircraft.setNotes(aircraftNotess[i]);
        aircraft.setAircraftType(aircraftType);
        aircraft = aircraftRepository.save(aircraft);
      }
    }             
    return aircraftType;
  }
  
  @Override
  @Transactional
  public int deleteEntity(Integer aircraftTypeId) {
    AircraftType aircraftType = aircraftTypeRepository.findOne(aircraftTypeId);
    try {
      aircraftTypeRepository.delete(aircraftType);
      return 1;
    } catch (Exception e) { // WILL THIS EVER HAPPEN? WHAT HAPPENS IF DELETE FAILS?
      out.println("AircraftTypeServiceClass threw Exception: " + e.getMessage());
      e.printStackTrace();
      return -1;
    }
  }

  @Override
  @Transactional
  public int deletePilotCertification 
                  ( Integer pilotCertificationPilotId
                  , Integer pilotCertificationAircraftTypeId
                  ) {
    Pilot pilot = pilotRepository.findOne(pilotCertificationPilotId);
    AircraftType aircraftType = aircraftTypeRepository.findOne(pilotCertificationAircraftTypeId);
    PilotCertification pilotCertification = pilotCertificationRepository.findOneByPilotAndAircraftType(pilot, aircraftType);
    if (pilotCertification != null) { 
      pilotCertificationRepository.delete(pilotCertification);
      return 1;
    }
    else { return -1; }
  }
  
  @Override
  @Transactional
  public int deleteAircraft (Integer aircraftId) 
  {
    Aircraft aircraft = aircraftRepository.findOne(aircraftId);
    if (aircraft != null) { 
      aircraftRepository.delete(aircraft);
      return 1;
    }
    else { return -1; }
  }
  
  public List<AircraftType> getQualifiedAircraftTypesByPilotId (Integer pilotId){
    return aircraftTypeRepository.selectQualifiedAircraftTypesByPilotId(pilotId);
  }
      
}


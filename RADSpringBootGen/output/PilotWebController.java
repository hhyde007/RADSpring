package com.radinfodesign.fboace.controller;
/*
 *  Generated from GenSpringBootComponents(TM)
 *  Copyright(c) 2018 by RADical Information Design Corporation
 *  Template: WebControllerTemplate.java.txt
*/ 

import static java.lang.System.out;
import java.util.Map;
import javax.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.view.RedirectView;
import com.radinfodesign.util.Util;

import com.radinfodesign.fboace.model.Pilot;
import com.radinfodesign.fboace.service.PilotService;
import com.radinfodesign.fboace.service.AircraftTypeService;
import com.radinfodesign.fboace.service.FlightService;


@Controller
@RequestMapping(PilotWebController.ENTITY_URL)
public class PilotWebController {

  public static final String ENTITY_URL = "/Pilot";
  public static final String BUSINESS_ENTITY = "Pilot";
  public static final String BUSINESS_ENTITY_VAR = "businessEntity";
  public static final String INSTANCE = "pilot";
  public static final String INSTANCES = "instances";
  public static final String ALL_ENTITY_URL = "";
  public static final String ENTITY_EDIT_URL = "/Edit";
  public static final String ENTITY_DELETE_URL = "/Delete";
  public static final String ENTITY_PUT_URL = "/Put";
  public static final String ENTITY_LIST_PAGE = "entity/list";
  public static final String ENTITY_EDIT_PAGE = "entity/PilotEdit";
  public static final String ENTITY_ATT_ID = "pilotId";
  public static final String ENTITY_ATTRIB_LASTNAME="lastName";
  public static final String ENTITY_ATTRIB_FIRSTNAME="firstName";
  public static final String ENTITY_ATTRIB_MIDDLEINITIAL="middleInitial";
  public static final String ENTITY_ATTRIB_NATIONALIDNUMBER="nationalIdNumber";
  public static final String ENTITY_ATTRIB_BIRTHDATE="birthdate";
  public static final String ENTITY_ATTRIB_NOTES="notes";
  
  public static final String ENTITY_ATTRIB_PILOTCERTIFICATION_CERTIFICATIONNUMBER="pilotCertificationCertificationNumber";
  public static final String ENTITY_ATTRIB_PILOTCERTIFICATION_VALIDFROMDATE="pilotCertificationValidFromDate";
  public static final String ENTITY_ATTRIB_PILOTCERTIFICATION_EXPIRATIONDATE="pilotCertificationExpirationDate";
  public static final String ENTITY_ATTRIB_PILOTCERTIFICATION_NOTES="pilotCertificationNotes";
  public static final String ENTITY_ATTRIB_PILOTCERTIFICATION_AIRCRAFTTYPEID="pilotCertificationAircraftTypeId";
  public static final String ENTITY_ATTRIB_FLIGHTCREWMEMBER_NOTES="flightCrewMemberNotes";
  public static final String ENTITY_ATTRIB_FLIGHTCREWMEMBER_FLIGHTID="flightCrewMemberFlightId";
  public static final String ENTITY_ATTRIB_AIRCRAFTTYPES="aircraftTypes";
  public static final String ENTITY_ATTRIB_FLIGHTS="flights";
  public static final String MODEL_ATTRIBUTE_FORM_ACTION = "formAction";
  public static final String MODEL_ATTRIBUTE_DELETE_FORM_ACTION = "deleteFormAction";
  public static final String MODEL_ATTRIBUTE_ENTITY_ID = "entityId";
  public static final String MODEL_ATTRIBUTE_LIST_PATH = "listPath";

  public static final String MESSAGE = "message";
  public static final String MSG = "msg";
    
  @Autowired
  PilotService service;
  @Autowired 
  AircraftTypeService aircraftTypeService;
  @Autowired 
  FlightService flightService;
  
  @GetMapping(value=ALL_ENTITY_URL)
  public String listEntities (Model model) {
    model.addAttribute(INSTANCES, service.getAll());
    model.addAttribute(BUSINESS_ENTITY_VAR, BUSINESS_ENTITY);
    model.addAttribute(MODEL_ATTRIBUTE_FORM_ACTION, ENTITY_URL+ENTITY_EDIT_URL);
    model.addAttribute(MODEL_ATTRIBUTE_DELETE_FORM_ACTION, ENTITY_URL+ENTITY_DELETE_URL);
    model.addAttribute(MODEL_ATTRIBUTE_ENTITY_ID, ENTITY_ATT_ID);
    return ENTITY_LIST_PAGE;
  }

  @PostMapping(value=ENTITY_EDIT_URL)
  public String editEntity ( @RequestParam (name=ENTITY_ATT_ID, defaultValue="0") Integer pilotId
                           , Model model
                           , HttpServletRequest request
                           ) {
    Pilot entity = null;
    Map modelMap = model.asMap();
    Integer pilotId2 = (Integer)request.getAttribute(ENTITY_ATT_ID);
    String message = (String)modelMap.get(MESSAGE);
    if (pilotId==null || pilotId==0) {
      pilotId = pilotId2;
      if (pilotId==null || pilotId==0)
        entity = new
                 Pilot();
      else
        entity = service.getEntity(pilotId);
    }
    else entity = service.getEntity(pilotId);

    model.addAttribute(INSTANCE, entity);
    model.addAttribute(MODEL_ATTRIBUTE_LIST_PATH, ENTITY_URL+ALL_ENTITY_URL);
    model.addAttribute(MESSAGE, (String)request.getAttribute(MSG));
    model.addAttribute(MODEL_ATTRIBUTE_FORM_ACTION, ENTITY_URL+ENTITY_PUT_URL);
    if (pilotId == null) {
      model.addAttribute(ENTITY_ATTRIB_AIRCRAFTTYPES, aircraftTypeService.getAll());
    }
    else {
      model.addAttribute(ENTITY_ATTRIB_AIRCRAFTTYPES, aircraftTypeService.getQualifiedAircraftTypesByPilotId(entity.getPilotId()));
    }
    if (pilotId == null) {
      model.addAttribute(ENTITY_ATTRIB_FLIGHTS, flightService.getAll());
    }
    else {
      model.addAttribute(ENTITY_ATTRIB_FLIGHTS, flightService.getQualifiedFlightsByPilotId(entity.getPilotId()));
    }
    
    return ENTITY_EDIT_PAGE;
  }
    
  @PostMapping(value = ENTITY_PUT_URL)
  public String putEntity ( @RequestParam(name=ENTITY_ATT_ID, defaultValue="0") Integer pilotId
                          , @RequestParam(name=ENTITY_ATTRIB_LASTNAME) String lastName
                          , @RequestParam(name=ENTITY_ATTRIB_FIRSTNAME) String firstName
                          , @RequestParam(name=ENTITY_ATTRIB_MIDDLEINITIAL) String middleInitial
                          , @RequestParam(name=ENTITY_ATTRIB_NATIONALIDNUMBER) String nationalIdNumber
                          , @RequestParam(name=ENTITY_ATTRIB_BIRTHDATE) String birthdate
                          , @RequestParam(name=ENTITY_ATTRIB_NOTES) String notes
                          , @RequestParam(name=ENTITY_ATTRIB_PILOTCERTIFICATION_CERTIFICATIONNUMBER, required=false) String[] pilotCertificationCertificationNumbers
                          , @RequestParam(name=ENTITY_ATTRIB_PILOTCERTIFICATION_VALIDFROMDATE, required=false) String[] pilotCertificationValidFromDates
                          , @RequestParam(name=ENTITY_ATTRIB_PILOTCERTIFICATION_EXPIRATIONDATE, required=false) String[] pilotCertificationExpirationDates
                          , @RequestParam(name=ENTITY_ATTRIB_PILOTCERTIFICATION_NOTES, required=false) String[] pilotCertificationNotess
                          , @RequestParam(name=ENTITY_ATTRIB_PILOTCERTIFICATION_AIRCRAFTTYPEID, required=false) Integer[] pilotCertificationAircraftTypeIds
                          , @RequestParam(name=ENTITY_ATTRIB_FLIGHTCREWMEMBER_NOTES, required=false) String[] flightCrewMemberNotess
                          , @RequestParam(name=ENTITY_ATTRIB_FLIGHTCREWMEMBER_FLIGHTID, required=false) Integer[] flightCrewMemberFlightIds
                          , Model model
                          , HttpServletRequest request
                          )
  {
    String message = ""; 
    try {
      Pilot entity = service.putEntity( pilotId
                                         , lastName
                                         , firstName
                                         , middleInitial
                                         , nationalIdNumber
                                         , birthdate
                                         , notes
                                         , pilotCertificationCertificationNumbers
                                         , pilotCertificationValidFromDates
                                         , pilotCertificationExpirationDates
                                         , pilotCertificationNotess
                                         , pilotCertificationAircraftTypeIds
                                         , flightCrewMemberNotess
                                         , flightCrewMemberFlightIds
                                         );
      message = "Pilot saved.";
      request.setAttribute(ENTITY_ATT_ID, entity.getPilotId());
    }
    catch (Exception e) {
      message = Util.getFriendlyErrorMessage(e, "Sorry, Pilot NOT saved." + e.getMessage());
    }
    request.setAttribute(MSG, message);
    request.setAttribute(RedirectView.RESPONSE_STATUS_ATTRIBUTE, HttpStatus.TEMPORARY_REDIRECT);
    return "forward:"+ENTITY_URL+ENTITY_EDIT_URL;
  }
    
  @PostMapping(value = ENTITY_DELETE_URL)
  public String deleteEntity ( @RequestParam(name=ENTITY_ATT_ID, defaultValue="0") Integer pilotId
                             , HttpServletRequest request 
                             ) 
  {
    String message = "";
    int deleteSuccess = service.deleteEntity(pilotId);
    if (deleteSuccess == 1) {
    message = "Pilot record deleted.";
    } else {
      message = "Sorry, Pilot record NOT deleted. No further information is available, but it is not permitted to delete parent records referenced by child records.";
    }
    request.setAttribute(MSG, message);
    return "redirect:"+ENTITY_URL;
  }


  
  @PostMapping(value = "/DeletePilotCertification")
  public String deletePilotCertification ( @RequestParam(name="pilotId") Integer pilotCertificationPilotId
                                       , @RequestParam(name="aircraftTypeId") Integer pilotCertificationAircraftTypeId
                                       , Model model
                                       , HttpServletRequest request
                                       ) 
  {
    out.println("");
    String message = null;
    int deleteResult = service.deletePilotCertification (pilotCertificationPilotId, pilotCertificationAircraftTypeId); 
    
    if (deleteResult == 1) { 
      message = "PilotCertification record deleted.";  
    }
    else 
    {
      message = "PilotCertification deletion failed.";  
    }
    request.setAttribute(MSG, message);
    Pilot entity = service.getEntity(pilotCertificationPilotId);
    model.addAttribute(INSTANCE, entity);
    request.setAttribute(ENTITY_ATT_ID, entity.getPilotId());
    request.setAttribute(RedirectView.RESPONSE_STATUS_ATTRIBUTE, HttpStatus.TEMPORARY_REDIRECT);
    return "forward:"+ENTITY_URL+ENTITY_EDIT_URL;
  }

  @PostMapping(value = "/DeleteFlightCrewMember")
  public String deleteFlightCrewMember ( @RequestParam(name="flightId") Integer flightCrewMemberFlightId
                                       , @RequestParam(name="pilotId") Integer flightCrewMemberPilotId
                                       , Model model
                                       , HttpServletRequest request
                                       ) 
  {
    out.println("");
    String message = null;
    int deleteResult = service.deleteFlightCrewMember (flightCrewMemberFlightId, flightCrewMemberPilotId); 
    
    if (deleteResult == 1) { 
      message = "FlightCrewMember record deleted.";  
    }
    else 
    {
      message = "FlightCrewMember deletion failed.";  
    }
    request.setAttribute(MSG, message);
    Pilot entity = service.getEntity(flightCrewMemberPilotId);
    model.addAttribute(INSTANCE, entity);
    request.setAttribute(ENTITY_ATT_ID, entity.getPilotId());
    request.setAttribute(RedirectView.RESPONSE_STATUS_ATTRIBUTE, HttpStatus.TEMPORARY_REDIRECT);
    return "forward:"+ENTITY_URL+ENTITY_EDIT_URL;
  }


  
}

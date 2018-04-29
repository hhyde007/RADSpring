/* 
 * Copyright 2018 by RADical Information Design Corporation
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
*/
package com.radinfodesign.fboace.controller;
/*
 *  Generated from WebControllerTemplate.java.txt
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
import com.radinfodesign.radspringbootgen.util.Util;

import com.radinfodesign.fboace.model.Flight;
import com.radinfodesign.fboace.service.FlightService;
import com.radinfodesign.fboace.service.PilotService;
import com.radinfodesign.fboace.service.AircraftService;
import com.radinfodesign.fboace.service.AirportService;


@Controller
@RequestMapping(FlightWebController.ENTITY_URL)
public class FlightWebController {

  public static final String ENTITY_URL = "/Flight";
  public static final String BUSINESS_ENTITY = "Flight";
  public static final String BUSINESS_ENTITY_VAR = "businessEntity";
  public static final String INSTANCE = "flight";
  public static final String INSTANCES = "instances";
  public static final String ALL_ENTITY_URL = "";
  public static final String ENTITY_EDIT_URL = "/Edit";
  public static final String ENTITY_DELETE_URL = "/Delete";
  public static final String ENTITY_PUT_URL = "/Put";
  public static final String ENTITY_LIST_PAGE = "entity/list";
  public static final String ENTITY_EDIT_PAGE = "entity/FlightEdit";
  public static final String ENTITY_ATT_ID = "flightId";
  public static final String ENTITY_ATTRIB_SHORTNAME="shortName";
  public static final String ENTITY_ATTRIB_LONGNAME="longName";
  public static final String ENTITY_ATTRIB_DEPARTUREDATETIME="departureDateTime";
  public static final String ENTITY_ATTRIB_ARRIVALDATETIME="arrivalDateTime";
  public static final String ENTITY_ATTRIB_NOTES="notes";
  public static final String ENTITY_ATTRIB_AIRCRAFTID="aircraftId";
  public static final String ENTITY_ATTRIB_AIRPORTIDDEPARTURE="airportIdDeparture";
  public static final String ENTITY_ATTRIB_AIRPORTIDDESTINATION="airportIdDestination";
  
  public static final String ENTITY_ATTRIB_FLIGHTCREWMEMBER_NOTES="flightCrewMemberNotes";
  public static final String ENTITY_ATTRIB_FLIGHTCREWMEMBER_PILOTID="flightCrewMemberPilotId";
  public static final String ENTITY_ATTRIB_AIRCRAFTS="aircrafts";
  public static final String ENTITY_ATTRIB_AIRPORTS="airports";
  public static final String ENTITY_ATTRIB_PILOTS="pilots";
  public static final String MODEL_ATTRIBUTE_FORM_ACTION = "formAction";
  public static final String MODEL_ATTRIBUTE_DELETE_FORM_ACTION = "deleteFormAction";
  public static final String MODEL_ATTRIBUTE_ENTITY_ID = "entityId";
  public static final String MODEL_ATTRIBUTE_LIST_PATH = "listPath";

  public static final String MESSAGE = "message";
  public static final String MSG = "msg";
    
  @Autowired
  FlightService service;
  @Autowired 
  PilotService pilotService;
  @Autowired
  AircraftService aircraftService;
  @Autowired
  AirportService airportService;
  
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
  public String editEntity ( @RequestParam (name=ENTITY_ATT_ID, defaultValue="0") Integer flightId
                           , Model model
                           , HttpServletRequest request
                           ) {
    Flight entity = null;
    Map modelMap = model.asMap();
    Integer flightId2 = (Integer)request.getAttribute(ENTITY_ATT_ID);
    String message = (String)modelMap.get(MESSAGE);
    if (flightId==null || flightId==0) {
      flightId = flightId2;
      if (flightId==null || flightId==0)
        entity = new
                 Flight();
      else
        entity = service.getEntity(flightId);
    }
    else entity = service.getEntity(flightId);

    model.addAttribute(INSTANCE, entity);
    model.addAttribute(MODEL_ATTRIBUTE_LIST_PATH, ENTITY_URL+ALL_ENTITY_URL);
    model.addAttribute(MESSAGE, (String)request.getAttribute(MSG));
    model.addAttribute(MODEL_ATTRIBUTE_FORM_ACTION, ENTITY_URL+ENTITY_PUT_URL);
    model.addAttribute(ENTITY_ATTRIB_AIRCRAFTS, aircraftService.getAll());
    model.addAttribute(ENTITY_ATTRIB_AIRPORTS, airportService.getAll());
    if (flightId == null) {
      model.addAttribute(ENTITY_ATTRIB_PILOTS, pilotService.getAll());
    }
    else {
      model.addAttribute(ENTITY_ATTRIB_PILOTS, pilotService.getQualifiedPilotsByFlightId(entity.getFlightId()));
    }
    
    return ENTITY_EDIT_PAGE;
  }
    
  @PostMapping(value = ENTITY_PUT_URL)
  public String putEntity ( @RequestParam(name=ENTITY_ATT_ID, defaultValue="0") Integer flightId
                          , @RequestParam(name=ENTITY_ATTRIB_SHORTNAME) String shortName
                          , @RequestParam(name=ENTITY_ATTRIB_LONGNAME) String longName
                          , @RequestParam(name=ENTITY_ATTRIB_DEPARTUREDATETIME) String departureDateTime
                          , @RequestParam(name=ENTITY_ATTRIB_ARRIVALDATETIME) String arrivalDateTime
                          , @RequestParam(name=ENTITY_ATTRIB_NOTES) String notes
                          , @RequestParam(name=ENTITY_ATTRIB_AIRCRAFTID) Integer aircraftId
                          , @RequestParam(name=ENTITY_ATTRIB_AIRPORTIDDEPARTURE) Integer airportIdDeparture
                          , @RequestParam(name=ENTITY_ATTRIB_AIRPORTIDDESTINATION) Integer airportIdDestination
                          , @RequestParam(name=ENTITY_ATTRIB_FLIGHTCREWMEMBER_NOTES, required=false) String[] flightCrewMemberNotess
                          , @RequestParam(name=ENTITY_ATTRIB_FLIGHTCREWMEMBER_PILOTID, required=false) Integer[] flightCrewMemberPilotIds
                          , Model model
                          , HttpServletRequest request
                          )
  {
    String message = ""; 
    try {
      Flight entity = service.putEntity( flightId
                                         , shortName
                                         , longName
                                         , departureDateTime
                                         , arrivalDateTime
                                         , notes
                                         , aircraftId
                                         , airportIdDeparture
                                         , airportIdDestination
                                         , flightCrewMemberNotess
                                         , flightCrewMemberPilotIds
                                         );
      message = "Flight saved.";
      request.setAttribute(ENTITY_ATT_ID, entity.getFlightId());
    }
    catch (Exception e) {
      message = Util.getFriendlyErrorMessage(e, "Sorry, Flight NOT saved." + e.getMessage());
    }
    request.setAttribute(MSG, message);
    request.setAttribute(RedirectView.RESPONSE_STATUS_ATTRIBUTE, HttpStatus.TEMPORARY_REDIRECT);
    return "forward:"+ENTITY_URL+ENTITY_EDIT_URL;
  }
    
  @PostMapping(value = ENTITY_DELETE_URL)
  public String deleteEntity ( @RequestParam(name=ENTITY_ATT_ID, defaultValue="0") Integer flightId
                             , HttpServletRequest request 
                             ) 
  {
    String message = "";
    int deleteSuccess = service.deleteEntity(flightId);
    if (deleteSuccess == 1) {
    message = "Flight record deleted.";
    } else {
      message = "Sorry, Flight record NOT deleted. No further information is available, but it is not permitted to delete parent records referenced by child records.";
    }
    request.setAttribute(MSG, message);
    return "redirect:"+ENTITY_URL;
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
    Flight entity = service.getEntity(flightCrewMemberFlightId);
    model.addAttribute(INSTANCE, entity);
    request.setAttribute(ENTITY_ATT_ID, entity.getFlightId());
    request.setAttribute(RedirectView.RESPONSE_STATUS_ATTRIBUTE, HttpStatus.TEMPORARY_REDIRECT);
    return "forward:"+ENTITY_URL+ENTITY_EDIT_URL;
  }


  
}

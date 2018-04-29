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

import com.radinfodesign.fboace.model.AircraftType;
import com.radinfodesign.fboace.service.AircraftTypeService;
import com.radinfodesign.fboace.service.PilotService;

   
@Controller
@RequestMapping(AircraftTypeWebController.ENTITY_URL)
public class AircraftTypeWebController {

  public static final String ENTITY_URL = "/AircraftType";
  public static final String BUSINESS_ENTITY = "AircraftType";
  public static final String BUSINESS_ENTITY_VAR = "businessEntity";
  public static final String INSTANCE = "aircraftType";
  public static final String INSTANCES = "instances";
  public static final String ALL_ENTITY_URL = "";
  public static final String ENTITY_EDIT_URL = "/Edit";
  public static final String ENTITY_DELETE_URL = "/Delete";
  public static final String ENTITY_PUT_URL = "/Put";
  public static final String ENTITY_LIST_PAGE = "entity/list";
  public static final String ENTITY_EDIT_PAGE = "entity/AircraftTypeEdit";
  public static final String ENTITY_ATT_ID = "aircraftTypeId";
  public static final String ENTITY_ATTRIB_SHORTNAME="shortName";
  public static final String ENTITY_ATTRIB_LONGNAME="longName";
  public static final String ENTITY_ATTRIB_DESCRIPTION="description";
  public static final String ENTITY_ATTRIB_NOTES="notes";
  
  public static final String ENTITY_ATTRIB_AIRCRAFT_AIRCRAFTID="aircraftAircraftId";
  public static final String ENTITY_ATTRIB_AIRCRAFT_SHORTNAME="aircraftShortName";
  public static final String ENTITY_ATTRIB_AIRCRAFT_LONGNAME="aircraftLongName";
  public static final String ENTITY_ATTRIB_AIRCRAFT_DESCRIPTION="aircraftDescription";
  public static final String ENTITY_ATTRIB_AIRCRAFT_NOTES="aircraftNotes";
  public static final String ENTITY_ATTRIB_PILOTCERTIFICATION_CERTIFICATIONNUMBER="pilotCertificationCertificationNumber";
  public static final String ENTITY_ATTRIB_PILOTCERTIFICATION_VALIDFROMDATE="pilotCertificationValidFromDate";
  public static final String ENTITY_ATTRIB_PILOTCERTIFICATION_EXPIRATIONDATE="pilotCertificationExpirationDate";
  public static final String ENTITY_ATTRIB_PILOTCERTIFICATION_NOTES="pilotCertificationNotes";
  public static final String ENTITY_ATTRIB_PILOTCERTIFICATION_PILOTID="pilotCertificationPilotId";
  public static final String ENTITY_ATTRIB_PILOTS="pilots";
  public static final String MODEL_ATTRIBUTE_FORM_ACTION = "formAction";
  public static final String MODEL_ATTRIBUTE_DELETE_FORM_ACTION = "deleteFormAction";
  public static final String MODEL_ATTRIBUTE_ENTITY_ID = "entityId";
  public static final String MODEL_ATTRIBUTE_LIST_PATH = "listPath";

  public static final String MESSAGE = "message";
  public static final String MSG = "msg";
    
  @Autowired
  AircraftTypeService service;
  @Autowired 
  PilotService pilotService;
  
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
  public String editEntity ( @RequestParam (name=ENTITY_ATT_ID, defaultValue="0") Integer aircraftTypeId
                           , Model model
                           , HttpServletRequest request
                           ) {
    AircraftType entity = null;
    Map modelMap = model.asMap();
    Integer aircraftTypeId2 = (Integer)request.getAttribute(ENTITY_ATT_ID);
    String message = (String)modelMap.get(MESSAGE);
    if (aircraftTypeId==null || aircraftTypeId==0) {
      aircraftTypeId = aircraftTypeId2;
      if (aircraftTypeId==null || aircraftTypeId==0)
        entity = new
                 AircraftType();
      else
        entity = service.getEntity(aircraftTypeId);
    }
    else entity = service.getEntity(aircraftTypeId);

    model.addAttribute(INSTANCE, entity);
    model.addAttribute(MODEL_ATTRIBUTE_LIST_PATH, ENTITY_URL+ALL_ENTITY_URL);
    model.addAttribute(MESSAGE, (String)request.getAttribute(MSG));
    model.addAttribute(MODEL_ATTRIBUTE_FORM_ACTION, ENTITY_URL+ENTITY_PUT_URL);
    if (aircraftTypeId == null) {
      model.addAttribute(ENTITY_ATTRIB_PILOTS, pilotService.getAll());
    }
    else {
      model.addAttribute(ENTITY_ATTRIB_PILOTS, pilotService.getQualifiedPilotsByAircraftTypeId(entity.getAircraftTypeId()));
    }
    
    return ENTITY_EDIT_PAGE;
  }
    
  @PostMapping(value = ENTITY_PUT_URL)
  public String putEntity ( @RequestParam(name=ENTITY_ATT_ID, defaultValue="0") Integer aircraftTypeId
                          , @RequestParam(name=ENTITY_ATTRIB_SHORTNAME) String shortName
                          , @RequestParam(name=ENTITY_ATTRIB_LONGNAME) String longName
                          , @RequestParam(name=ENTITY_ATTRIB_DESCRIPTION) String description
                          , @RequestParam(name=ENTITY_ATTRIB_NOTES) String notes
                          , @RequestParam(name=ENTITY_ATTRIB_AIRCRAFT_AIRCRAFTID, required=false) Integer[] aircraftAircraftIds
                          , @RequestParam(name=ENTITY_ATTRIB_AIRCRAFT_SHORTNAME, required=false) String[] aircraftShortNames
                          , @RequestParam(name=ENTITY_ATTRIB_AIRCRAFT_LONGNAME, required=false) String[] aircraftLongNames
                          , @RequestParam(name=ENTITY_ATTRIB_AIRCRAFT_DESCRIPTION, required=false) String[] aircraftDescriptions
                          , @RequestParam(name=ENTITY_ATTRIB_AIRCRAFT_NOTES, required=false) String[] aircraftNotess
                          , @RequestParam(name=ENTITY_ATTRIB_PILOTCERTIFICATION_CERTIFICATIONNUMBER, required=false) String[] pilotCertificationCertificationNumbers
                          , @RequestParam(name=ENTITY_ATTRIB_PILOTCERTIFICATION_VALIDFROMDATE, required=false) String[] pilotCertificationValidFromDates
                          , @RequestParam(name=ENTITY_ATTRIB_PILOTCERTIFICATION_EXPIRATIONDATE, required=false) String[] pilotCertificationExpirationDates
                          , @RequestParam(name=ENTITY_ATTRIB_PILOTCERTIFICATION_NOTES, required=false) String[] pilotCertificationNotess
                          , @RequestParam(name=ENTITY_ATTRIB_PILOTCERTIFICATION_PILOTID, required=false) Integer[] pilotCertificationPilotIds
                          , Model model
                          , HttpServletRequest request
                          )
  {
    String message = ""; 
    try {
      AircraftType entity = service.putEntity( aircraftTypeId
                                         , shortName
                                         , longName
                                         , description
                                         , notes
                                         , aircraftAircraftIds
                                         , aircraftShortNames
                                         , aircraftLongNames
                                         , aircraftDescriptions
                                         , aircraftNotess
                                         , pilotCertificationCertificationNumbers
                                         , pilotCertificationValidFromDates
                                         , pilotCertificationExpirationDates
                                         , pilotCertificationNotess
                                         , pilotCertificationPilotIds
                                         );
      message = "AircraftType saved.";
      request.setAttribute(ENTITY_ATT_ID, entity.getAircraftTypeId());
    }
    catch (Exception e) {
      message = Util.getFriendlyErrorMessage(e, "Sorry, AircraftType NOT saved." + e.getMessage());
    }
    request.setAttribute(MSG, message);
    request.setAttribute(RedirectView.RESPONSE_STATUS_ATTRIBUTE, HttpStatus.TEMPORARY_REDIRECT);
    return "forward:"+ENTITY_URL+ENTITY_EDIT_URL;
  }
    
  @PostMapping(value = ENTITY_DELETE_URL)
  public String deleteEntity ( @RequestParam(name=ENTITY_ATT_ID, defaultValue="0") Integer aircraftTypeId
                             , HttpServletRequest request 
                             ) 
  {
    String message = "";
    int deleteSuccess = service.deleteEntity(aircraftTypeId);
    if (deleteSuccess == 1) {
    message = "AircraftType record deleted.";
    } else {
      message = "Sorry, AircraftType record NOT deleted. No further information is available, but it is not permitted to delete parent records referenced by child records.";
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
    AircraftType entity = service.getEntity(pilotCertificationAircraftTypeId);
    model.addAttribute(INSTANCE, entity);
    request.setAttribute(ENTITY_ATT_ID, entity.getAircraftTypeId());
    request.setAttribute(RedirectView.RESPONSE_STATUS_ATTRIBUTE, HttpStatus.TEMPORARY_REDIRECT);
    return "forward:"+ENTITY_URL+ENTITY_EDIT_URL;
  }


  
  @PostMapping(value = "/DeleteAircraft")
  public String deleteAircraft 
                     ( @RequestParam(name="aircraftId") Integer aircraftAircraftId
                     , @RequestParam(name="aircraftTypeId") Integer aircraftAircraftTypeId
                     , Model model
                     , HttpServletRequest request
                     ) 
  {
    out.println("");
    out.println("deleteAircraft()");
    String message = null;
    int deleteResult = service.deleteAircraft ( aircraftAircraftId ); 
    if (deleteResult == 1) { 
      message = "Aircraft record deleted.";  
    }
    else 
    {
      message = "Aircraft deletion failed.";  
    }
    request.setAttribute(MSG, message);
    AircraftType entity = service.getEntity(aircraftAircraftTypeId);
    model.addAttribute(INSTANCE, entity);
    request.setAttribute(ENTITY_ATT_ID, entity.getAircraftTypeId());
    request.setAttribute(RedirectView.RESPONSE_STATUS_ATTRIBUTE, HttpStatus.TEMPORARY_REDIRECT);
    return "forward:"+ENTITY_URL+ENTITY_EDIT_URL;
  }
  
}

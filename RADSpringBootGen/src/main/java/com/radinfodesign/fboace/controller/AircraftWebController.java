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

import com.radinfodesign.fboace.model.Aircraft;
import com.radinfodesign.fboace.service.AircraftService;
import com.radinfodesign.fboace.service.AircraftTypeService;


@Controller
@RequestMapping(AircraftWebController.ENTITY_URL)
public class AircraftWebController {

  public static final String ENTITY_URL = "/Aircraft";
  public static final String BUSINESS_ENTITY = "Aircraft";
  public static final String BUSINESS_ENTITY_VAR = "businessEntity";
  public static final String INSTANCE = "aircraft";
  public static final String INSTANCES = "instances";
  public static final String ALL_ENTITY_URL = "";
  public static final String ENTITY_EDIT_URL = "/Edit";
  public static final String ENTITY_DELETE_URL = "/Delete";
  public static final String ENTITY_PUT_URL = "/Put";
  public static final String ENTITY_LIST_PAGE = "entity/list";
  public static final String ENTITY_EDIT_PAGE = "entity/AircraftEdit";
  public static final String ENTITY_ATT_ID = "aircraftId";
  public static final String ENTITY_ATTRIB_SHORTNAME="shortName";
  public static final String ENTITY_ATTRIB_LONGNAME="longName";
  public static final String ENTITY_ATTRIB_DESCRIPTION="description";
  public static final String ENTITY_ATTRIB_NOTES="notes";
  public static final String ENTITY_ATTRIB_AIRCRAFTTYPEID="aircraftTypeId";
  
  public static final String ENTITY_ATTRIB_AIRCRAFTTYPES="aircraftTypes";
  public static final String MODEL_ATTRIBUTE_FORM_ACTION = "formAction";
  public static final String MODEL_ATTRIBUTE_DELETE_FORM_ACTION = "deleteFormAction";
  public static final String MODEL_ATTRIBUTE_ENTITY_ID = "entityId";
  public static final String MODEL_ATTRIBUTE_LIST_PATH = "listPath";

  public static final String MESSAGE = "message";
  public static final String MSG = "msg";
    
  @Autowired
  AircraftService service;
  @Autowired
  AircraftTypeService aircraftTypeService;
  
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
  public String editEntity ( @RequestParam (name=ENTITY_ATT_ID, defaultValue="0") Integer aircraftId
                           , Model model
                           , HttpServletRequest request
                           ) {
    Aircraft entity = null;
    Map modelMap = model.asMap();
    Integer aircraftId2 = (Integer)request.getAttribute(ENTITY_ATT_ID);
    String message = (String)modelMap.get(MESSAGE);
    if (aircraftId==null || aircraftId==0) {
      aircraftId = aircraftId2;
      if (aircraftId==null || aircraftId==0)
        entity = new
                 Aircraft();
      else
        entity = service.getEntity(aircraftId);
    }
    else entity = service.getEntity(aircraftId);

    model.addAttribute(INSTANCE, entity);
    model.addAttribute(MODEL_ATTRIBUTE_LIST_PATH, ENTITY_URL+ALL_ENTITY_URL);
    model.addAttribute(MESSAGE, (String)request.getAttribute(MSG));
    model.addAttribute(MODEL_ATTRIBUTE_FORM_ACTION, ENTITY_URL+ENTITY_PUT_URL);
    model.addAttribute(ENTITY_ATTRIB_AIRCRAFTTYPES, aircraftTypeService.getAll());
    
    return ENTITY_EDIT_PAGE;
  }
    
  @PostMapping(value = ENTITY_PUT_URL)
  public String putEntity ( @RequestParam(name=ENTITY_ATT_ID, defaultValue="0") Integer aircraftId
                          , @RequestParam(name=ENTITY_ATTRIB_SHORTNAME) String shortName
                          , @RequestParam(name=ENTITY_ATTRIB_LONGNAME) String longName
                          , @RequestParam(name=ENTITY_ATTRIB_DESCRIPTION) String description
                          , @RequestParam(name=ENTITY_ATTRIB_NOTES) String notes
                          , @RequestParam(name=ENTITY_ATTRIB_AIRCRAFTTYPEID) Integer aircraftTypeId
                          , Model model
                          , HttpServletRequest request
                          )
  {
    String message = ""; 
    try {
      Aircraft entity = service.putEntity( aircraftId
                                         , shortName
                                         , longName
                                         , description
                                         , notes
                                         , aircraftTypeId
                                         );
      message = "Aircraft saved.";
      request.setAttribute(ENTITY_ATT_ID, entity.getAircraftId());
    }
    catch (Exception e) {
      message = Util.getFriendlyErrorMessage(e, "Sorry, Aircraft NOT saved." + e.getMessage());
    }
    request.setAttribute(MSG, message);
    request.setAttribute(RedirectView.RESPONSE_STATUS_ATTRIBUTE, HttpStatus.TEMPORARY_REDIRECT);
    return "forward:"+ENTITY_URL+ENTITY_EDIT_URL;
  }
    
  @PostMapping(value = ENTITY_DELETE_URL)
  public String deleteEntity ( @RequestParam(name=ENTITY_ATT_ID, defaultValue="0") Integer aircraftId
                             , HttpServletRequest request 
                             ) 
  {
    String message = "";
    int deleteSuccess = service.deleteEntity(aircraftId);
    if (deleteSuccess == 1) {
    message = "Aircraft record deleted.";
    } else {
      message = "Sorry, Aircraft record NOT deleted. No further information is available, but it is not permitted to delete parent records referenced by child records.";
    }
    request.setAttribute(MSG, message);
    return "redirect:"+ENTITY_URL;
  }


  

  
}

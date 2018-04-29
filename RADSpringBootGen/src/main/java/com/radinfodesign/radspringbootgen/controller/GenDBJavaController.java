package com.radinfodesign.radspringbootgen.controller;

import static java.lang.System.out;

import javax.servlet.http.HttpServletRequest;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.radinfodesign.radspringbootgen.dao.DbUserTableColumnRepository;
import com.radinfodesign.radspringbootgen.util.GenJavaComponents;

@Controller
@RequestMapping("/Generate")
public class GenDBJavaController {

  @Autowired
  DbUserTableColumnRepository dbUserTableColumnRepository;
  
  @GetMapping(value="/home")
  public String home () {
    return "app/index";
  }

  @PostMapping(value="/Go")
  public String launchGen ( @RequestParam(name="entityList") String entityList
                          , @RequestParam(name="basePackage") String basePackage
                          , @RequestParam(name="outputDir") String outputDir
                          , @RequestParam(name="component") String[] components
//                          , Model model
//                          , HttpServletRequest request
                          )
                      {
    
    
    
    out.println("GenDBJavaController.launchGen: dbUserTableColumnRepository = " + dbUserTableColumnRepository);
//    GenJavaComponents.launch(dbUserTableColumnRepository);
    GenJavaComponents.launch( dbUserTableColumnRepository
                            , entityList
                            , basePackage
                            , outputDir
                            , components
                            );
    return "app/index"; // SHOULD HAVE A BETTER LANDING SCREEN.
  }

  
}

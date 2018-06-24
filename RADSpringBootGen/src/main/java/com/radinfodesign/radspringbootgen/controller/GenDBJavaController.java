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
package com.radinfodesign.radspringbootgen.controller;

import static java.lang.System.out;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.radinfodesign.radspringbootgen.util.GenJavaService;

/**
 * Web controller for code generation.
 * @author Howard Hyde
 *
 */
@Controller
@RequestMapping("/Generate")
public class GenDBJavaController {

  @Autowired
  protected GenJavaService genJavaService;
    
  @GetMapping(value="/home")
  public String home () {
    return "app/index";
  }

  /**
   * Calls GenJavaComponents.launch() with instructions received from web user
   * @param entityList: List of data model entities for which to generate code.
   * @param basePackage: Name of base application package under which all sub-packages and generated classes shall reside
   * @param outputDir: Output file directory, typically "output" under the root of the RADSpringBootGen app.
   * @param components: List (array) of components to generate for each of the entities: Service interface, Service implementation class, 
   * (web) Controller class, and/or Edit.html.
   * @return Name of landing html file.
   */
  @PostMapping(value="/Go")
  public String launchGen ( @RequestParam(name="entityList") String entityList
                          , @RequestParam(name="basePackage") String basePackage
                          , @RequestParam(name="outputDir") String outputDir
                          , @RequestParam(name="component") String[] components
//                          , Model model
//                          , HttpServletRequest request
                          )
                      {
    genJavaService.launch( entityList
                         , basePackage
                         , outputDir
                         , components
                         );
    return "app/index"; // SHOULD HAVE A BETTER LANDING SCREEN.
  }

  
}

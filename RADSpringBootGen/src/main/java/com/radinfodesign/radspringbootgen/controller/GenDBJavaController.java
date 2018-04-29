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

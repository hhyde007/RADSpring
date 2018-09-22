/*
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
package com.radinfodesign.radspringbootgen.util;
import static java.lang.System.out;

import java.io.BufferedReader;
import java.io.BufferedWriter;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.TreeMap;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

/**
 * Main entry point and master controller for RADSpringBootGen code generation system.
 * <br>NEED TO REFACTOR AS AN AUTOWIRED SERVICE WITH INSTANCE INSTEAD OF STATIC METHODS.
 * <br><br>VERY IMPORTANT CONCEPT: "DRIVING ENTITY": This is the focal database table in a business object. 
 * A module (suite of collaborating classes and UI forms) may expose elements from any number of tables linked by foreign key relationships 
 * (in OO terms, just think of classes that reference or 'use' one another).
 * One of them is the designated "Driver" around which the others revolve. 
 * <br>If the table has foreign keys to other tables in many-to-one relationships,
 * then those other tables may be represented as single values chosen from lists or drop-down boxes/HTML &lt;SELECT&gt; elements. 
 * If other tables reference the Driving table via foreign key relationships, then these may be represented as Collection attributes in the Model class
 * and multi-valued block of value in UI forms. 
 * And if the child tables reference other tables besides the Driving table, these "Third" tables may be considered part of the business object or module. 
 * In particular, when facilitating the adding or editing of child records, provision must be made for choosing values of the Third table reference 
 * from a list of valid values, rather than typing in something, like a foreign key numeric value.
 * <br>All referenced and referencing entities, whether parents, children or third-table references from children of the Driving table, may be represented 
 * in the UI by navigational links, permitting the user to access the module in which that parent, child or third-entity is the Driving entity of its own module.  
 * <br>MAKE SURE THESE CONCEPTS MAKE SENSE TO YOU BEFORE CONTINUING ANY FURTHER WITH THIS FRAMEWORK, OTHERWISE YOU WILL BE LOST.
 *  
 * @author Howard Hyde
 */
@Component
public class GenJavaServiceImpl implements GenJavaService {
  
  /**
   * Character(s) used in template files as one-line comment indicator.
   * {@value #TEMPLATE_COMMENT_MARKER}
   * Must be first character(s) of the line.
   */
  public static final String TEMPLATE_COMMENT_MARKER = "!!";

  @Autowired 
  EntityMetaFactoryImpl entityMetaFactory;
//  
//  @Autowired
//  InputStringTree inputFileTree;
//  
//  @Autowired
//  OutputStringTreeImpl outputFileTree;
  

  /**
   * Main method for code generation. Transforms the file name Strings into Path objects and delegates to its overload.
   * @param templateFileName Template file name
   * @param outputFileName Output (generated code) file name
   * @param drivingEntityName Name of "Driving Entity" model class
   * @param basePackageName Name of the base Java package under which collaborating Model, Repository/dao, Service and Controller packages
   * and their respective interfaces and classes will be located.
   * @throws IOException If cannot read from database metadata views
   */
  protected void genCodeFromTemplate (String templateFileName, String outputFileName, String drivingEntityName, String basePackageName) throws IOException {
    out.println ("GenJavaComponents.genJavaFromTemplate(String, String, String)");
    Path templateFile = Paths.get(templateFileName);
    Path outputFile = Paths.get(outputFileName);
    genCodeFromTemplate (templateFile, outputFile, drivingEntityName, basePackageName);
  }
    
  /**
   * Overload which takes the template and output files transformed as Path objects.
   * @throws IOException if can't read from template file or write to output file
   */
  protected void genCodeFromTemplate (Path templateFile, Path outputFile, String drivingEntityName, String basePackageName) throws IOException {
    out.println ("GenJavaComponents.genJavaFromTemplate(Path, Map, Path)");
    out.println ("templateFile = " + templateFile);
    out.println ("outputFile = " + outputFile);
    out.println ();
    TreeMap<String, String> tokenMap = new TreeMap<>();

    String fileString = null;
    StringBuilder fileStringBuilder = new StringBuilder();
    fileString = new String (fileStringBuilder);
    String fqDrivingModelEntity = basePackageName+".model."+drivingEntityName;

    try (BufferedReader reader = Files.newBufferedReader(templateFile)){
      String inputLine = null;
      int fileLength = 0;
      EntityMeta.FieldMeta[] fields = null; 
      Class drivingEntityClass = null;
      EntityMeta drivingEntityMeta = null;
      try {
        drivingEntityClass = Class.forName(fqDrivingModelEntity);
        out.println("fqDrivingModelEntity = " + fqDrivingModelEntity);
        out.println("drivingEntityClass.getName() = " + drivingEntityClass.getName());
        out.println("drivingEntityClass.getSimpleName() = " + drivingEntityClass.getSimpleName());
        out.println("drivingEntityClass.getDeclaredFields() = " + drivingEntityClass.getDeclaredFields());
    
      } catch (ClassNotFoundException e) {
        out.println("Sorry, ClassNotFoundException trying to load " + fqDrivingModelEntity +".");
      }
//      drivingEntityMeta = EntityMeta.getEntityMeta(drivingEntityClass.getName(), dbUserTableColumnRepository);
      drivingEntityMeta = EntityMetaFactoryImpl.entityMetaFactoryImplX.getEntityMeta(drivingEntityClass.getName());
      fields = drivingEntityMeta.getFieldMetaArray();
      while ((inputLine = reader.readLine())!=null) {
        if (!(inputLine.startsWith(TEMPLATE_COMMENT_MARKER)))  
          fileStringBuilder.append(inputLine + "\n");
      } 
      fileString = new String (fileStringBuilder); 
      fileLength = fileString.length();
      InputStringTree inputFileTree = InputStringTree.getInputStringTree(templateFile.toString(), fileString, drivingEntityName, basePackageName, drivingEntityMeta);
      out.println();
      out.println("inputFileTree.getNumNodes() = " + inputFileTree.getNumNodes());
      OutputStringTree outputFileTree = OutputStringTree.getOutputStringTree(inputFileTree);
      out.println();
      out.println("outputFileTree.getNumNodes() = " + outputFileTree.getNumNodes());
      fileString = (outputFileTree.isBuilt()?outputFileTree.traverse():""); // isBuilt() should ALWAYS return true 
      //fileString = outputFileTree.traverse(); // isBuilt() should ALWAYS return true 
      try (BufferedWriter writer = Files.newBufferedWriter(outputFile)) {
        writer.write(fileString);
      } catch (IOException e) {
        out.println("Sorry, could not write file " + outputFile);
        return;
      }
    } catch (IOException e) {
      out.println("Sorry, could not read file " + templateFile);
      return;
    }
  }
  
  
  /**
   * Main launch entry point for code generation.
   * @param entityList: List of data model entities for which to generate code.
   * @param basePackage: Name of base application package under which all sub-packages and generated classes shall reside
   * @param outputDir: Output file directory, typically "output" under the root of the RADSpringBootGen app.
   * @param components: List (array) of components to generate for each of the entities: Service interface, Service implementation class, 
   * (web) Controller class, and/or Edit.html.
  */
  public void launch ( String entityList
                     , String basePackage
                     , String outputDir
                     , String[] components
                     ) {
    String[] entities = entityList.split(",");
    String template = "";

    for (String entity: entities) {
      for (String component: components) {
        template = "templates/"+component+".template.txt";
        try {  
          genCodeFromTemplate ( template
                              , outputDir+"/"+entity.trim()+component
                              , entity.trim()
                              , basePackage
                              );
        }
        catch (Exception e) {
          out.println ("GenJavaComponents.launch(2) threw Exception: " + e.getMessage());
          e.printStackTrace();
        }
      }
    }
  }
  
  
}



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

import org.springframework.stereotype.Component;

import com.radinfodesign.radspringbootgen.dao.DbUserTableColumnRepository;


@Component
public class GenJavaComponents {
  // DEPRECATED CONSTANTS
//  public static final String DOUBLE_TOKEN_OPEN = "${${";
//  public static final String NESTED_DOUBLE_TOKEN_OPEN = "$[$[";
//  public static final String NESTED_DOUBLE_TOKEN_CLOSE = "$]$]";
//  public static final String TRIPLE_TOKEN_CLOSE = "}}}";
//  public static final String QUAD_TOKEN_CLOSE = "}}}}";
  
  // END DEPRECATED CONSTANTS

  public static final String TEMPLATE_COMMENT_MARKER = "!!";
  public static final String COLLECTION = "Collection";
  public static final String FIELD = "Field";
//  public static final String META_INFO = "MetaInfo";
//  public static final String FIELD_META_INFO = "FieldMetaInfo";
  
  // ARE THESE ALL USED? BY OTHER CLASSES IF NOT INTERNALLY?
  public static final String MODEL_PACKAGE = "com.radinfodesign.fboace.model"; // Hard-code!
  public static final String PATH_TO_MODEL_JAVA_FILES = "com/radinfodesign/fboace/model/";
  public static final String DEBUG_NULL_TOKEN = ""; // Leave blank for "production"
  public static final String DEBUG_NULL_CHILD_TOKEN = ""; // Leave blank for "production"
  
  public static final String CURLY_BRACE_OPEN = "{";
  public static final String DOUBLE_TOKEN_CLOSE = "}}";
  public static final char   TOKEN_SEPARATOR = '=';
  public static final String STRING_TOKEN_SEPARATOR = "=";

  public static final char   SPACE = ' ';
  public static final char   TAB = '	';  
  public static final String JAVA_PACKAGE = "java."; 
  public static final String JAVA_LANG_PACKAGE = "java.lang"; 
  public static final String JAVA_TIME_LOCAL_DATE = "java.time.LocalDate";
  public static final String JAVA_TIME_LOCAL_DATETIME = "java.time.LocalDateTime";
  public static final String ANNOTATION_ID = "Id";
  public static final String ANNOTATION_EMBEDDED_ID = "@EmbeddedId";
  public static final String ANNOTATION_COLUMN = "@Column";
  public static final String ANNOTATION_JOIN_COLUMN = "@JoinColumn";
  public static final String ANNOTATION_ENTITY = "@Entity";
  
  public static final String MODEL_ENTITY_IMPORT = "modelEntityImport"; // Token to retrieve fully-qualified name of primary driving entity class
  
  protected static DbUserTableColumnRepository dbUserTableColumnRepository;
  
//  public static void genJavaFromTemplate (String templateFileName, String drivingEntityName, String basePackagename, String outputFileName) {
//    
//  }
  

  public static void genJavaFromTemplate (String templateFileName, String outputFileName, String drivingEntityName, String basePackageName) throws IOException {
    out.println ("GenJavaComponents.genJavaFromTemplate(String, String, String)");
    Path templateFile = Paths.get(templateFileName);
    Path outputFile = Paths.get(outputFileName);
    int keyEndIndex = 0;
    String tokenKey = null;
    String tokenValue = null;
    String configLine = null;
    genJavaFromTemplate (templateFile, outputFile, drivingEntityName, basePackageName);
  }
    
    
    
  // TO BE DEPRECATED
//  public static void genJavaFromTemplate (String templateFileName, String tokenMapFileName, String outputFileName) {
//    out.println ("GenJavaComponents.genJavaFromTemplate(String, String, String)");
//    Path templateFile = Paths.get(templateFileName);
//    Path configFile = Paths.get(tokenMapFileName);
//    Path outputFile = Paths.get(outputFileName);
//    TreeMap<String, String> tokenMap = new TreeMap<>();
//    int keyEndIndex = 0;
//    String tokenKey = null;
//    String tokenValue = null;
//    String configLine = null;
//    try (BufferedReader reader = Files.newBufferedReader(configFile)){
//      while ((configLine = reader.readLine())!=null) {
//      //out.println("configLine = "+ configLine); // Debug
//      tokenKey = null;
//      keyEndIndex = configLine.indexOf(TOKEN_SEPARATOR);
//      if (keyEndIndex < 0) continue;
//      tokenKey = configLine.substring(0, keyEndIndex);
//      //out.println("tokenKey = "+ tokenKey); // Debug
//      tokenValue = configLine.substring(keyEndIndex+1);
//      //out.println("tokenValue = "+ tokenValue); // Debug
//      tokenMap.put(tokenKey, tokenValue);
//      }
//    }
//    catch (IOException e){
//      out.println("Sorry, could not read file " + tokenMapFileName);
//      return;
//    }
//    String fqDrivingModelEntity = tokenMap.get(MODEL_ENTITY_IMPORT);
//    genJavaFromTemplate (templateFile, tokenMap, outputFile, fqDrivingModelEntity);
//  }
  
//  public static void genJavaFromTemplate (Path templateFile, TreeMap<String, String> tokenMap, Path outputFile, String drivingEntityName, String basePackagename) {
  public static void genJavaFromTemplate (Path templateFile, Path outputFile, String drivingEntityName, String basePackageName) throws IOException {
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
      MetaInfo.FieldMetaInfo[] fields = null; 
      Class drivingEntityClass = null;
      MetaInfo drivingMetaInfo = null;
      try {
        drivingEntityClass = Class.forName(fqDrivingModelEntity);
        out.println("fqDrivingModelEntity = " + fqDrivingModelEntity);
        out.println("drivingEntityClass.getName() = " + drivingEntityClass.getName());
        out.println("drivingEntityClass.getSimpleName() = " + drivingEntityClass.getSimpleName());
        out.println("drivingEntityClass.getDeclaredFields() = " + drivingEntityClass.getDeclaredFields());
    
      } catch (ClassNotFoundException e) {
        out.println("Sorry, ClassNotFoundException trying to load " + fqDrivingModelEntity +".");
      }
      drivingMetaInfo = MetaInfo.getMetaInfo(drivingEntityClass.getName(), dbUserTableColumnRepository);
      fields = drivingMetaInfo.getFieldMetaInfoArray();
      while ((inputLine = reader.readLine())!=null) {
        if (!(inputLine.startsWith(TEMPLATE_COMMENT_MARKER)))  
          fileStringBuilder.append(inputLine + "\n");
      }
      fileString = new String (fileStringBuilder);
      fileLength = fileString.length();
      //out.println(fileString); // TESTING
//      InputStringTree inputFileTree = new InputStringTree(fileString);
      InputStringTree inputFileTree = new InputStringTree(fileString, drivingEntityName, basePackageName);
      tokenMap=inputFileTree.getTokenMap();

      inputFileTree.build(); // = buildInputTree(fileString, inputFileTree, inputNode); // Recursive
      out.println();
      out.println("inputFileTree.getNumNodes() = " + inputFileTree.getNumNodes());
      
      OutputStringTree outputFileTree = new OutputStringTree(inputFileTree);
      outputFileTree.build(tokenMap, drivingMetaInfo, drivingMetaInfo); // = buildOutputTree(inputFileTree, outputFileTree, tokenMap, drivingMetaInfo); // Recursive
      out.println();
      out.println("outputFileTree.getNumNodes() = " + outputFileTree.getNumNodes());
      
      fileString = outputFileTree.traverse();
      //fileString.replace("\n\n", "\n");
      //fileString.replaceAll("(?m)^\\s*$[\n\r]{1,}", "");
      //fileString.replaceAll("(?m)^[ \t]*\r?\n", "");
      
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
  public static DbUserTableColumnRepository getDbUserTableColumnRepository() {
    //GenJavaComponents.getDbUserTableColumnRepository()
    return GenJavaComponents.dbUserTableColumnRepository;
  }
  
  public static void launch (DbUserTableColumnRepository dbUserTableColumnRepository) {
    out.println ("GenJavaComponents.launch(" + dbUserTableColumnRepository + ")");
    GenJavaComponents.dbUserTableColumnRepository = dbUserTableColumnRepository;
    String basePackageName = "com.radinfodesign.fboace";
    String outputDir = "output";
//  String fileNameSuffix = "Service.java";
//  String template = "templates/ServiceTemplate.java.txt";
//  String fileNameSuffix = "ServiceImpl.java";
//  String template = "templates/ServiceImplTemplate.java.txt";
    String template = "templates/editTemplate.html.txt";
    String fileNameSuffix = "Edit.html";
    try {  
      genJavaFromTemplate ( template
          , outputDir+"/"+"Component"+fileNameSuffix
          , "Component"
          , basePackageName);

//    genJavaFromTemplate ( template
//    , outputDir+"Flight"+fileNameSuffix
//    , "Flight"
//    , basePackageName);
//
//      genJavaFromTemplate ( template
//          , outputDir+"Aircraft"+fileNameSuffix
//          , "Aircraft"
//          , basePackageName);
//    
//      genJavaFromTemplate ( template
//          , outputDir+"Pilot"+fileNameSuffix
//          , "Pilot"
//          , basePackageName);
//    
//      genJavaFromTemplate ( template
//          , outputDir+"Airport"+fileNameSuffix
//          , "Airport"
//          , basePackageName);
//    
//      genJavaFromTemplate ( template
//          , outputDir+"AircraftType"+fileNameSuffix
//          , "AircraftType"
//          , basePackageName);
      fileNameSuffix = "ServiceImpl.java";
      template = "templates/ServiceImplTemplate.java.txt";
      genJavaFromTemplate ( template
          , outputDir+"Component"+fileNameSuffix
          , "Component"
          , basePackageName);

//      genJavaFromTemplate ( template
//          , outputDir+"Flight"+fileNameSuffix
//          , "Flight"
//          , basePackageName);
//    
//      genJavaFromTemplate ( template
//          , outputDir+"Aircraft"+fileNameSuffix
//          , "Aircraft"
//          , basePackageName);
//    
//      genJavaFromTemplate ( template
//          , outputDir+"Pilot"+fileNameSuffix
//          , "Pilot"
//          , basePackageName);
//    
//      genJavaFromTemplate ( template
//          , outputDir+"Airport"+fileNameSuffix
//          , "Airport"
//          , basePackageName);
//    
//      genJavaFromTemplate ( template
//          , outputDir+"AircraftType"+fileNameSuffix
//          , "AircraftType"
//          , basePackageName);
      fileNameSuffix = "Service.java";
      template = "templates/ServiceTemplate.java.txt";
      genJavaFromTemplate ( template
          , outputDir+"Component"+fileNameSuffix
          , "Component"
          , basePackageName);

//      genJavaFromTemplate ( template
//          , outputDir+"Flight"+fileNameSuffix
//          , "Flight"
//          , basePackageName);
//    
//      genJavaFromTemplate ( template
//          , outputDir+"Aircraft"+fileNameSuffix
//          , "Aircraft"
//          , basePackageName);
//    
//      genJavaFromTemplate ( template
//          , outputDir+"Pilot"+fileNameSuffix
//          , "Pilot"
//          , basePackageName);
//    
//      genJavaFromTemplate ( template
//          , outputDir+"Airport"+fileNameSuffix
//          , "Airport"
//          , basePackageName);
//    
//      genJavaFromTemplate ( template
//          , outputDir+"AircraftType"+fileNameSuffix
//          , "AircraftType"
//          , basePackageName);
      template = "templates/WebControllerTemplate.java.txt";
      fileNameSuffix = "WebController.java";
      genJavaFromTemplate ( template
          , outputDir+"Component"+fileNameSuffix
          , "Component"
          , basePackageName);

//      genJavaFromTemplate ( template
//          , outputDir+"Flight"+fileNameSuffix
//          , "Flight"
//          , basePackageName);
//    
//      genJavaFromTemplate ( template
//          , outputDir+"Aircraft"+fileNameSuffix
//          , "Aircraft"
//          , basePackageName);
//    
//      genJavaFromTemplate ( template
//          , outputDir+"Pilot"+fileNameSuffix
//          , "Pilot"
//          , basePackageName);
//    
//      genJavaFromTemplate ( template
//          , outputDir+"Airport"+fileNameSuffix
//          , "Airport"
//          , basePackageName);
//    
//      genJavaFromTemplate ( template
//          , outputDir+"AircraftType"+fileNameSuffix
//          , "AircraftType"
//          , basePackageName);
    }
    catch (Exception e) {
      out.println ("GenJavaComponents.launch() threw Exception: " + e.getMessage());
      e.printStackTrace();
    }
  }
  
  
  public static void launch ( DbUserTableColumnRepository dbUserTableColumnRepository
                            , String entityList
                            , String basePackage
                            , String outputDir
                            , String[] components
                            ) {
    out.println ("GenJavaComponents.launch(" + dbUserTableColumnRepository + ", " + entityList + ", " +  basePackage + ", " +  outputDir + ")");
    GenJavaComponents.dbUserTableColumnRepository = dbUserTableColumnRepository;
    String[] entities = entityList.split(",");
    String template = "";

    for (String entity: entities) {
      for (String component: components) {
        template = "templates/"+component+".template.txt";
        try {  
          genJavaFromTemplate ( template
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
  
  
  public static void test() {
  } 

  
  
  /**
   * @param args the command line arguments
   */
//  public static void main(String[] args) throws IOException {
//    out.println ("GenJavaComponents.main(" + args + ")");
//  }

}



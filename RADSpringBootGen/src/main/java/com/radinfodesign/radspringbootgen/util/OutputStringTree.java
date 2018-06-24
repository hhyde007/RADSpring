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
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.TreeMap;

import com.radinfodesign.radspringbootgen.util.EntityMeta.FieldMeta;

/**
 * Input tree of input template txt file transformed by relational metadata
 * implicit in model entity class definitions and annotations plus some metadata
 * read from database into resulting output tree, to be written to output files. 
 */
//@Component
public class OutputStringTree extends IOStringTree {
//  public class OutputStringTreeImpl extends IOStringTree implements OutputStringTree {
  // Constants named "ACT_*" indicate instruction to ACT upon various elements of table/EntityMeta or column/attribute/FieldMeta
  public static final String ACT_ALL_ATTRIBS = "ACT_ALL_ATTRIBS"; // Flag indicating logic applying to all (non-collection) attributes of the entity
  public static final String ACT_UI_ATTRIBS = "ACT_UI_ATTRIBS"; // 
  public static final String ACT_SIMPLE_ATTRIBS = "ACT_SIMPLE_ATTRIBS"; // Flag indicating logic applying only to simple attributes (non-temporal primitives and wrapper types) 
  public static final String ACT_DATE_ATTRIBS = "ACT_DATE_ATTRIBS"; // Flag indicating logic applying only to Date (LocalDate) type attributes
  public static final String ACT_DATE_TIME_ATTRIBS = "ACT_DATE_TIME_ATTRIBS"; // Flag indicating logic applying only to Datetime (LocalDateTime) type attributes
  public static final String ACT_FK_REF_ENTITIES = "ACT_FK_REF_ENTITIES"; // Flag indicating logic applying only to FK-referenced entities, elimintating duplicate/redundant entries for the same referenced entity class
  public static final String ACT_NON_TEMPORAL_ATTRIBS = "ACT_NON_TEMPORAL_ATTRIBS"; // Flag indicating logic applying to non-temporal (LocalDate or LocalDateTimeTime) attributes
  public static final String ACT_FK_REF_ATTRIBS = "ACT_FK_REF_ATTRIBS"; // Flag indicating logic applying only to FK-referenced entities; no duplicate elimination
  public static final String ACT_NON_KEY_ATTRIBS = "ACT_NON_KEY_ATTRIBS"; // Flag indicating logic applying only to attributes that are NOT members of the primary key
  public static final String ACT_PK_ATTRIBS = "ACT_PK_ATTRIBS"; // Flag indicating logic applying only to attributes that ARE members of the primary key
  public static final String ACT_PK_ATTRIBS_COMMA_SEPARATED = "ACT_PK_ATTRIBS_COMMA_SEPARATED"; // Flag indicating logic applying only to attributes that ARE members of the primary key, separated by commas in the case of compound key
  
  public static final String ACT_FK_CHILD_ENTITIES = "ACT_FK_CHILD_ENTITIES"; // Flag indicating logic applying only to child entities. 
  public static final String ACT_FK_CHILD_ENTITIES_W_COMPOUND_KEYS = "ACT_FK_CHILD_ENTITIES_W_COMPOUND_KEYS"; // Flag indicating logic applying only to child entities have compound primary keys, one component being inherited from the Driving Entity 
  public static final String ACT_FK_CHILD_ENTITIES_W_COMPOUND_KEYS_FORCE_INCLUDE = "ACT_FK_CHILD_ENTITIES_W_COMPOUND_KEYS_FORCE_INCLUDE"; // Include this node even if FieldMeta.isExcludedEditFromParentModule()  
  public static final String ACT_FK_CHILD_ENTITIES_FORCE_INCLUDE = "ACT_FK_CHILD_ENTITIES_FORCE_INCLUDE"; // Include this node even if FieldMeta.isExcludedEditFromParentModule()  
  public static final String ACT_FK_CHILD_AND_THIRD_ENTITIES = "ACT_FK_CHILD_AND_THIRD_ENTITIES"; // Flag indicating logic applying only to child entities and entities referenced by child entities, excluding the driving entity. 
  public static final String ACT_FK_CHILD_W_COMPOUND_KEYS_AND_THIRD_ENTITIES = "ACT_FK_CHILD_W_COMPOUND_KEYS_AND_THIRD_ENTITIES"; // Logic applying only to child entities with compound primary keys, plus any third entities referenced by the same. 
  public static final String ACT_THIRD_ENTITIES_ONLY = "ACT_THIRD_ENTITIES_ONLY"; // Flag indicating logic applying only to third entities referenced by child entities that have compound primary keys. 
//  public static final String ACT_IF_THIRD_ENTITIES_EXIST = "ACT_IF_THIRD_ENTITIES_EXIST"; // Process the enclosed nodes only if the current driving entity is related to third entities through child/associative entities 
  public static final String ACT_OTHER_REF_ENTITIES = "ACT_OTHER_REF_ENTITIES";  
  public static final String ACT_FK_CHILD_ENTITY_ATTRIBS = "ACT_FK_CHILD_ENTITY_ATTRIBS"; // Flag indicating logic applying to attributes of child entities, excluding those referencing the driving entity (for now; how to handle multiple references? Future bug?) 
  public static final String ACT_FK_CHILD_ENTITY_W_COMPOUND_KEY_ATTRIBS = "ACT_FK_CHILD_ENTITY_W_COMPOUND_KEY_ATTRIBS"; // Flag indicating logic applying to attributes of child entities that have compound primary keys (presumably inheriting one member from the present driving entity.  
  public static final String ACT_THIRD_ENTITIES = "ACT_THIRD_ENTITIES"; // Flag indicating logic applying only to other entities referenced by child entities. Refinement of ACT_FK_CHILD_ENTITIES 
  public static final String ACT_FK_CHILD_EMBEDDED_ID = "ACT_FK_CHILD_EMBEDDED_ID"; // Flag indicating logic applying only to the embedded ID attribute of child entities. 
  public static final String ACT_ALL_FK_CHILD_ENTITIES = "ACT_ALL_FK_CHILD_ENTITIES"; // New/revised Flag indicating logic applying to child entities, whether having simple or compound primary keys 
  public static final String ACT_ALL_FK_CHILD_ENTITIES_FORCE_INCLUDE = "ACT_ALL_FK_CHILD_ENTITIES_FORCE_INCLUDE"; // New/revised Flag indicating logic applying to child entities, whether having simple or compound primary keys 
  public static final String FORCE_INCLUDE = "FORCE_INCLUDE";
  
  public static final String FK_REF_ENTITY = "FK_REF_ENTITY"; // Name of Entity class referenced by foreign key
  public static final String FK_REF_ENTITY_QUALIFIED = "FK_REF_ENTITY_QUALIFIED"; // Qualified identifier of Entity class referenced by foreign key
  public static final String FK_REF_ENTITY_ID = "FK_REF_ENTITY_ID"; // Primary key ID field of Entity class referenced by foreign key
  public static final String FK_REF_ENTITY_ID_INIT_CAP = "FK_REF_ENTITY_ID_INIT_CAP"; // Primary key ID field of Entity class referenced by foreign key
  public static final String FK_REF_ENTITY_INIT_SMALL = "FK_REF_ENTITY_INIT_SMALL"; // Name of Entity class referenced by foreign key
  public static final String FK_REF_ENTITY_LOWER = "FK_REF_ENTITY_LOWER"; // Name of child Entity class in lowercasse

  public static final String FK_CHILD_ENTITY = "FK_CHILD_ENTITY"; // Name of Entity class that is a child of the primary
  public static final String FK_CHILD_ENTITY_IDENTIFIER = "FK_CHILD_ENTITY_IDENTIFIER"; // Name given to reference to collection of Entity class that is a child of the primary, in context of parent
  public static final String FK_CHILD_ENTITY_QUALIFIED = "FK_CHILD_ENTITY_QUALIFIED"; // Qualified identifier of Entity class that is a child of the primary
  public static final String FK_CHILD_ENTITY_INIT_SMALL = "FK_CHILD_ENTITY_INIT_SMALL"; // Name of child Entity class referenced by foreign key
  public static final String FK_CHILD_ENTITY_LOWER = "FK_CHILD_ENTITY_LOWER"; // Name of Entity class referenced by foreign key, in lowercase
  public static final String FK_CHILD_ENTITY_UPPER = "FK_CHILD_ENTITY_UPPER"; // Name of Entity class referenced by foreign key, in UPPERCASE
  public static final String FK_CHILD_ENTITY_LOWER_PLURAL = "FK_CHILD_ENTITY_LOWER_PLURAL"; // Lowercase plural name of child entity class 
  public static final String FK_CHILD_ENTITY_UPPER_PLURAL = "FK_CHILD_ENTITY_UPPER_PLURAL"; // UPPERCASE plural name of child entity class 
  public static final String FK_CHILD_ENTITY_LABEL = "FK_CHILD_ENTITY_LABEL"; 
  public static final String FK_CHILD_TO_REF_ENTITY_VAR_EXPR = "FK_CHILD_TO_REF_ENTITY_VAR_EXPR"; // 
  public static final String FK_CHILD_EMBEDDED_ID = "FK_CHILD_EMBEDDED_ID"; // Embedded ID (foreign key column) field.  
  public static final String FK_CHILD_EMBEDDED_ID_INIT_CAPS = "FK_CHILD_EMBEDDED_ID_INIT_CAPS"; // Embedded ID (foreign key column) field in initial caps.  
  public static final String FK_CHILD_EMBEDDED_ID_INIT_SMALL = "FK_CHILD_EMBEDDED_ID_INIT_SMALL"; // Embedded ID (foreign key column) field in initial lower case.  
  public static final String FK_CHILD_EMBEDDED_PK = "FK_CHILD_EMBEDDED_PK"; // Child Entity Embedded PK object.  
  public static final String FK_CHILD_EMBEDDED_PK_INIT_SMALL = "FK_CHILD_EMBEDDED_PK_INIT_SMALL"; // Child Entity Embedded PK object in initial lowercase.  

  public static final String PK_ID_FIELD = "PK_ID_FIELD"; // Name of single primary key/ID field  
  public static final String PK_ID_FIELD_INIT_CAP = "PK_ID_FIELD_INIT_CAP"; // Name of single primary key/ID field  
  public static final String PK_FK_REF_ENTITY = "PK_FK_REF_ENTITY"; // Name of entity referenced by foreign key and (embedded) primary key  
  public static final String PK_FK_REF_ENTITY_INIT_SMALL = "PK_FK_REF_ENTITY_INIT_SMALL"; // ...with initial lowercase letter  
  public static final String PK_FK_REF_ENTITIES_DECLARE_REPOSITORY_FIND = "PK_FK_REF_ENTITIES_DECLARE_REPOSITORY_FIND"; // Complete multiple delarations and initializations of Entities referenced by embedded PK object by call to repository.findOne()
  // Example: Pilot pilot = pilotRepository.findOne(flightCrewMemberPilotId);
  public static final String FIND_ONE_BY_PK_FK_CRITERIA = "FIND_ONE_BY_PK_FK_CRITERIA";
  public static final String CALL_COMPOUND_CONSTRUCTOR = "CALL_COMPOUND_CONSTRUCTOR"; 
  public static final String GET_TH_HTML_FORM_DATA_VARS = "GET_TH_HTML_FORM_DATA_VARS"; 
  public static final String COMPOUND_PK_PARAM_LIST = "COMPOUND_PK_PARAM_LIST"; 
  public static final String COMPOUND_PK_PARAM_LIST_CHILD_ENTITY = "COMPOUND_PK_PARAM_LIST_CHILD_ENTITY"; 
  public static final String COMPOUND_INSERT_PARAM_LIST_CHILD_ENTITY = "COMPOUND_INSERT_PARAM_LIST_CHILD_ENTITY"; 
  
  public static final String FK_CHILD_ENTITY_ATTRIB = "FK_CHILD_ENTITY_ATTRIB"; // Name of Entity class that is a child of the primary
  public static final String FK_CHILD_ENTITY_ATTRIB_INIT_SMALL = "FK_CHILD_ENTITY_ATTRIB_INIT_SMALL"; // Name of child Entity attribute
  public static final String FK_CHILD_ENTITY_ATTRIB_LOWER = "FK_CHILD_ENTITY_ATTRIB_LOWER"; // Name of Entity attribute, in lowercase
  public static final String FK_CHILD_ENTITY_ATTRIB_UPPER = "FK_CHILD_ENTITY_ATTRIB_UPPER"; // Name of Entity attribute, in UPPERCASE
  public static final String FK_CHILD_ENTITY_ATTRIB_LOWER_PLURAL = "FK_CHILD_ENTITY_ATTRIB_LOWER_PLURAL"; // Lowercase plural name of child entity attribute 
  public static final String FK_CHILD_ENTITY_ATTRIB_UPPER_PLURAL = "FK_CHILD_ENTITY_ATTRIB_UPPER_PLURAL"; // UPPERCASE plural name of child entity attribute
  public static final String FK_CHILD_ENTITY_ATTRIB_LABEL = "FK_CHILD_ENTITY_ATTRIB_LABEL"; 

  public static final String FIRST_NON_KEY_REQUIRED_ATTRIB = "FIRST_NON_KEY_REQUIRED_ATTRIB"; // Name of the first required non-key field
  public static final String FIRST_NON_KEY_REQUIRED_ATTRIB_INIT_CAP = "FIRST_NON_KEY_REQUIRED_ATTRIB_INIT_CAP"; // Name of the first required non-key field, with initial capital letter

  public static final String FK_REF_ATTRIB_NAME = "FK_REF_ATTRIB_NAME"; // Name of Entity member attribute representing class referenced by foreign key
  public static final String FK_REF_ATTRIB_INITCAPS = "FK_REF_ATTRIB_INITCAPS"; // Name of Entity member attribute representing class referenced by foreign key, with Initial Capital
  public static final String FK_REF_ENTITY_LOWER_PLURAL = "FK_REF_ENTITY_LOWER_PLURAL"; // Lowercase plural name of entity class referenced by foreign key, suitable as reference variable name
  public static final String FK_REF_ENTITY_UPPER_PLURAL = "FK_REF_ENTITY_UPPER_PLURAL"; // UPPERCASE plural name of entity class referenced by foreign key, suitable as reference variable name
  public static final String ENTITY_ATTRIB_UPPER_NAME = "ENTITY_ATTRIB_UPPER_NAME"; // Upper-case underscore-separated name of entity attribute (table column)
  public static final String ENTITY_ATTRIB_NAME = "ENTITY_ATTRIB_NAME"; // Entity attribute name
  public static final String ENTITY_ATTRIB_LABEL = "ENTITY_ATTRIB_LABEL"; // Entity attribute formatted initcaps label
  public static final String ENTITY_ATTRIB_DEFAULT_DATATYPE = "ENTITY_ATTRIB_DEFAULT_DATATYPE"; // Entity attribute datatype; Non-primitive non-wrappers (entity classes) return Integer; Dates return String
  public static final String ENTITY_ATTRIB_INITCAPS = "ENTITY_ATTRIB_INITCAPS"; // Entity attribute name with initial capital, suitable in construction of prefixed identifier
  public static final String ENTITY_DATE_ATTRIB_NAME = "ENTITY_DATE_ATTRIB_NAME"; // Date type attribute name
  public static final String ENTITY_DATE_TIME_ATTRIB_NAME = "ENTITY_DATE_TIME_ATTRIB_NAME"; // Datetime type attribute name
  public static final String ENTITY_DATE_ATTRIB_INITCAPS = "ENTITY_DATE_ATTRIB_INITCAPS"; // Date type attribute name
  public static final String ENTITY_DATE_TIME_ATTRIB_INITCAPS = "ENTITY_DATE_TIME_ATTRIB_INITCAPS"; // Datetime type attribute name
  public static final String ENTITY_ATRRIB_INITCAP_NAME = "ENTITY_ATRRIB_INITCAP_NAME"; // Entity attribute name with InitialCapital
  public static final String MODEL_ADD_CHILD_ENTITY_RPSTRY_ATTRIB = "MODEL_ADD_CHILD_ENTITY_RPSTRY_ATTRIB"; 
  public static final String MODEL_ENTITY_IMPORT = "modelEntityImport"; // Token to retrieve fully-qualified name of primary driving entity class
    
  public static final String HTML_FORM_VERTICAL_INPUT = "HTML_FORM_VERTICAL_INPUT";
  public static final String HTML_FORM_HORIZONTAL_INPUT = "HTML_FORM_HORIZONTAL_INPUT";
  public static final String HTML_FORM_VERTICAL_INPUT_BLANK = "HTML_FORM_VERTICAL_INPUT_BLANK";
  public static final String HTML_FORM_HORIZONTAL_INPUT_BLANK = "HTML_FORM_HORIZONTAL_INPUT_BLANK";
  
  public static final String DATATYPE_INTEGER = "Integer"; 
  public static final String DATATYPE_STRING = "String"; 
  public static final String DATATYPE_LOCAL_DATE = "LocalDate"; 
  public static final String DATATYPE_LOCAL_DATE_TIME = "LocalDateTime";
  public static final String DATATYPE_COLLECTION = "java.util.Collection";
  public static final String SERIAL_VERSION_UID = "serialVersionUID";
  public static final String COLLECTION = "Collection";
  public static final String FIELD = "Field";
  public static final String JAVA_TIME_LOCAL_DATE = "java.time.LocalDate";
  public static final String JAVA_TIME_LOCAL_DATETIME = "java.time.LocalDateTime";
  public static final char   SPACE = ' ';
  public static final char   TAB = '\t';  
  public static final String JAVA_PACKAGE = "java."; 
  public static final String JAVA_LANG_PACKAGE = "java.lang"; 
  public static final String ANNOTATION_ID = "Id";
  public static final String ANNOTATION_EMBEDDED_ID = "@EmbeddedId";
  public static final String ANNOTATION_COLUMN = "@Column";
//  public static final String ANNOTATION_JOIN_COLUMN = "@JoinColumn";
  public static final String ANNOTATION_ENTITY = "@Entity";

  public static final String MODEL_PACKAGE = "com.radinfodesign.fboace.model";
  public static final String PATH_TO_MODEL_JAVA_FILES = "com/radinfodesign/fboace/model/";
  public static final String DEBUG_NULL_TOKEN = ""; // Leave blank for "production"
  public static final String DEBUG_NULL_CHILD_TOKEN = ""; // Leave blank for "production"


//  protected final InputStringTree inputStringTree;
  protected InputStringTree inputStringTree;
  static Map<String, String> enclosedTypesMap = new HashMap<>(); // REVISIT THIS
  
  private OutputStringTree (InputStringTree inputStringTree) {
    super(inputStringTree.getTopNode().getValue());
    this.inputStringTree = inputStringTree;
  }
  
  private static Map<InputStringTree, OutputStringTree> outputStringTreeMap = new HashMap<>();
  public static OutputStringTree getOutputStringTree (InputStringTree inputStringTree) {
    OutputStringTree outputStringTree = outputStringTreeMap.get(inputStringTree);
    if (outputStringTree == null) {
      outputStringTree = new OutputStringTree(inputStringTree);
    }
    if (outputStringTree != null) {
      if (!outputStringTree.isBuilt()) {
        outputStringTree.build();
      }
    } else {
      out.println("OutputStringTree getOutputStringTree(): outputStringTree is null. THIS SHOULD NEVER HAPPEN!");
    }
    return outputStringTree;
  }
  
  public void setInputStringTree (InputStringTree inputStringTree) {
    this.inputStringTree = inputStringTree;
  }
  
  public InputStringTree getInputStringTree() { return this.inputStringTree; } 
  
  public static boolean isPrimitiveOrWrapper (Class testClass){ // DEPRECATED? USE EntityMeta methods instead
    if (testClass.getName().indexOf(".") < 0 ) return true;
    if (testClass.getName().startsWith(JAVA_PACKAGE)) return true;
    else return false;
  }
  
  public static boolean isPrimitiveOrWrapper (EntityMeta.FieldMeta testField){ // DEPRECATED? USE METAINFO METHODS INSTEAD
    if (testField.getType().getName().indexOf(EntityMeta.PERIOD) < 0 ) return true;
    if (testField.getType().getName().startsWith(JAVA_PACKAGE)) return true;
    else return false;
  }
     
//  public static boolean hasEmbeddedId(Class testClass) {
//    return EntityMeta.foundFieldAnnotationContains(testClass, ANNOTATION_EMBEDDED_ID);
///  } 
  
  public static boolean isLocalDate (EntityMeta.FieldMeta testField){
    //out.println("isLocalDate() testField = " + testField.getName() + ": " + testField.getType().getName());
    if (testField.getType().getName().equals(JAVA_TIME_LOCAL_DATE)) return true;
    else return false;
  } 
  public static boolean isLocalDateTime (EntityMeta.FieldMeta testField){
    //out.println("isLocalDateTime() testField = " + testField.getName() + ": " + testField.getType().getName());
    if (testField.getType().getName().equals(JAVA_TIME_LOCAL_DATETIME)) return true;
    else return false;
  }
  public static boolean isTemporalType (EntityMeta.FieldMeta testField){
    return isLocalDate(testField) || isLocalDateTime(testField);
  }
  
  
//  @Override
//  public void build() throws Exception {
//    out.println("Please call overload of OutputStringTree.build with (TreeMap<String, String> tokenMap, EntityMeta drivingEntityMeta.)");
//    throw new Exception ("Please call overload of OutputStringTree.build with (TreeMap<String, String> tokenMap, EntityMeta drivingEntityMeta.)");
//  }
    
  @Override
  public void build() {
    this.build( this.getInputStringTree().getTopNode()
              , this.getTopNode()
              , this.getInputStringTree().getTokenMap()
              , this.getInputStringTree().getDrivingEntityMeta()
              , null
              , this.getInputStringTree().getDrivingEntityMeta()
              );
    this.built = true;
  }
    
//  //@Override
//  public void build(TreeMap<String, String> tokenMap, EntityMeta drivingEntityMeta, EntityMeta currentEntityMeta) {
//    this.build(this.getInputStringTree().getTopNode(), this.getTopNode(), tokenMap, drivingEntityMeta, null, currentEntityMeta);
//  }
    
  private void build ( StringNode inputNode
                     , StringNode outputNode
                     , TreeMap<String, String> tokenMap
                     , EntityMeta drivingEntityMeta
                     , FieldMeta drivingEntityMetaField
                     , EntityMeta currentEntityMeta
//                     , boolean childOfMultiToken
                     ) {
//    out.println("build[EntityMeta] " + inputNode.getValue());
////    out.println("  tokenMap = " + tokenMap);
//    out.println("  inputNode.getTokenKey() = " + inputNode.getTokenKey());
//    out.println("  inputNode.getTokenInstruction() = " + inputNode.getTokenInstruction());
//    out.println("  inputNode.isSingleTokenExpression() = " + inputNode.isSingleTokenExpression());
//    out.println("[build]  inputNode.isMultiTokenExpression() = " + inputNode.isMultiTokenExpression());
    List<StringNode> childNodes = inputNode.getChildren();
    StringNode nextOutputNode = outputNode;
    String tokenValue = null;
    //String tokenInstruction = null;
    
//    if (!(inputNode.isSingleTokenExpression() | (inputNode.isMultiTokenExpression()))) {
//    if ((!inputNode.isSingleTokenExpression() & (!inputNode.isMultiTokenExpression()))) {
    if (inputNode.isLiteralExpression()) {
//      out.println("addNode( !(inputNode.isSingleTokenExpression() | (inputNode.isMultiTokenExpression())) ): " + inputNode.getValue());
      nextOutputNode = this.addNode(inputNode.getValue(), outputNode);
    }
    else if (inputNode.isSingleTokenExpression()) {
      tokenValue = tokenMap.get(inputNode.getTokenKey());
      if (tokenValue==null) {
        tokenValue = getAttributeAttribute (drivingEntityMeta, drivingEntityMetaField, currentEntityMeta, inputNode.getTokenKey(), tokenMap);
      }
//      out.println("addNode( (inputNode.isSingleTokenExpression() ): " + (tokenValue!=null?tokenValue:inputNode.getValue()));
      nextOutputNode = this.addNode(tokenValue!=null?tokenValue:inputNode.getValue(), outputNode);
    }
    else if (inputNode.isMultiTokenExpression()) {
//      out.println("tokenInstruction = :");
     // Next look for potentially multivalued instructions    
      String tokenInstruction = inputNode.getTokenInstruction();
      //out.println("tokenInstruction = :" + tokenInstruction);
      
//      for (StringNode childNode: inputNode.getChildren()) {
        //nextOutputNode = outputFileTree.addNode(childNode.getValue(), outputNode);
        buildMultivaluedExpression ( inputNode
                                   , outputNode
                                   , tokenMap
                                   , drivingEntityMeta
                                   , currentEntityMeta
//                                   , inputNode.getTokenInstruction()
                                   );
//  }
      return; 
    }
//    if (nextOutputNode == null) { //?????????????????
//      //nextOutputNode = this.addNode(inputNode.getValue(), outputNode);
//    }

    for (StringNode childNode: childNodes) {
      //nextOutputNode = outputFileTree.addNode(childNode.getValue(), outputNode);
      this.build(childNode, nextOutputNode, tokenMap, drivingEntityMeta, null, currentEntityMeta);
    }
    return; // outputFileTree;
  }  
  
  
  private void build ( StringNode inputNode
                     , StringNode outputNode
                     , TreeMap<String, String> tokenMap
                     , EntityMeta drivingEntityMeta
                     , EntityMeta currentEntityMeta
                     , FieldMeta currentField // Difference
                     ) {
//    out.println("OutputStringTree.build[FieldMeta] " + currentEntityMeta.getSimpleName()+"."+currentField.getName());
//    out.println("  tokenMap = " + tokenMap);
    StringNode nextOutputNode = null;
    String tokenValue = null;
    String tokenInstruction = null;
    
    if (!(inputNode.isSingleTokenExpression() | (inputNode.isMultiTokenExpression()))) {
//      out.println("addNode( !(inputNode.isSingleTokenExpression() | (inputNode.isMultiTokenExpression())) ): " + inputNode.getValue());
      nextOutputNode = this.addNode(inputNode.getValue(), outputNode);
    }
    if (inputNode.isSingleTokenExpression()) {
      tokenValue = tokenMap.get(inputNode.getTokenKey());
      if (tokenValue==null) {
        tokenValue = getAttributeAttribute (drivingEntityMeta, currentEntityMeta, currentField, inputNode.getTokenKey(), tokenMap);
      }
//      out.println("addNode( (inputNode.isSingleTokenExpression() ): " + (tokenValue!=null?tokenValue:inputNode.getValue()));
      nextOutputNode = this.addNode(tokenValue!=null?tokenValue:inputNode.getValue(), outputNode);
    }
    if (nextOutputNode == null) { //?????????????????
//      nextOutputNode = this.addNode(inputNode.getValue(), outputNode);
    }
    for (StringNode childNode: inputNode.getChildren()) { // DOES NESTING/RECURSION GO THIS DEEP?
      //nextOutputNode = outputFileTree.addNode(childNode.getValue(), outputNode);
      this.build(childNode, nextOutputNode, tokenMap, drivingEntityMeta, currentField, currentEntityMeta);
    }
    return; // outputFileTree;
  }  
  
  
  private void buildMultivaluedExpression ( StringNode inputNode
                                          , StringNode outputNode
                                          , TreeMap<String, String> tokenMap
                                          , EntityMeta drivingEntityMeta
                                          , EntityMeta currentEntityMeta
  //                                        , String tokenInstruction
                                          ) {
//    out.println("");
//    out.println("****************************");
//  out.println("buildMultivaluedExpression (" + inputNode.getValue() + ")");
//  out.println("buildMultivaluedExpression currentEntityMeta = " + currentEntityMeta.getSimpleName());
//    out.println("  tokenMap = " + tokenMap);
//    Annotation[] fieldAnnotations = null;
    TempEntityMeta collectionOfEntityMeta = null; // Representation of Child table records encapsulated in a Collection attribute of the main driving entity EntityMeta object
    List<TempEntityMeta> collectionOfEntityMetas = null;
    FieldMeta[] fields = currentEntityMeta.getFieldMetaArray();
    Map<String, FieldMeta> duplicateFKRefClassMap = new HashMap<>(); 
    Map<String, FieldMeta> duplicateFKChildClassMap = new HashMap<>(); 
    Map<String, EntityMeta> duplicateEntityMetaMap = new HashMap<>(); 
    String tokenInstruction = inputNode.getTokenInstruction();
    

    for (int i = 0; i < fields.length; i++) {
//      out.println("buildMultivaluedExpression field["+i+"] = " + fields[i].getName());
//      perAttributeLine = null;
      if (fields[i].getName().equals(SERIAL_VERSION_UID)) continue;
      //if (fields[i].isId()) continue; ////TEST TEST TEST 2018.03.02
      switch (tokenInstruction) {
      case ACT_ALL_ATTRIBS: 
        if (fields[i].isId()) continue;
//        out.println("case " + ACT_ALL_ATTRIBS);
        if (getCollectionEnclosedEntityMeta(fields[i]) != null) break; // skip collections...continue?
        for (StringNode childNode: inputNode.getChildren()) {
//          out.println("childNode.getValue("+fields[i].getName()+") = " + childNode.getValue());
          this.build(childNode, outputNode, tokenMap, drivingEntityMeta, currentEntityMeta, fields[i]);
        }
        break;
      case ACT_UI_ATTRIBS: 
        if (fields[i].isId()) continue;
//        out.println("case " + ACT_ALL_ATTRIBS);
        if (getCollectionEnclosedEntityMeta(fields[i]) != null) break; // skip collections...continue?
        if (fields[i].isEmbeddedIdMemberField()) continue;
        if (!(fields[i].isPrimitiveOrWrapper() | fields[i].isEmbeddedId())) continue; 
        for (StringNode childNode: inputNode.getChildren()) {
//          out.println("childNode.getValue("+fields[i].getName()+") = " + childNode.getValue());
          this.build(childNode, outputNode, tokenMap, drivingEntityMeta, currentEntityMeta, fields[i]);
        }
        break;
      case ACT_NON_KEY_ATTRIBS: 
        if (fields[i].isId()) continue;
//        out.println("case " + ACT_NON_KEY_ATTRIBS);
//        out.println("fields[i].getName() = " + fields[i].getName());
//        out.println("fields[i].getResolvedIdentifier() = " + fields[i].getResolvedIdentifier());
        if (getCollectionEnclosedEntityMeta(fields[i]) != null) break; // skip collections
        if (fields[i].isId()) { break; }
        if (fields[i].isEmbeddedIdMemberField()) { break; }// skip primary key column attributes
        if (fields[i].isEmbeddedId()) { break; }// skip embedded compound primary key object
        for (StringNode childNode: inputNode.getChildren()) {
//          out.println("childNode.getValue("+fields[i].getName()+") = " + childNode.getValue());
          this.build(childNode, outputNode, tokenMap, drivingEntityMeta, currentEntityMeta, fields[i]);
        }
//        this.addNode("\n", outputNode);
        break;
      case ACT_PK_ATTRIBS: 
        if (!(fields[i].isId() | fields[i].isEmbeddedIdMemberField())) { break; }// Process ONLY primary key column attributes
        for (StringNode childNode: inputNode.getChildren()) {
//          out.println("childNode.getValue("+fields[i].getName()+") = " + childNode.getValue());
          this.build(childNode, outputNode, tokenMap, drivingEntityMeta, currentEntityMeta, fields[i]);
        }
        break;
      case ACT_PK_ATTRIBS_COMMA_SEPARATED: 
//        out.println("case " + ACT_PK_ATTRIBS_COMMA_SEPARATED);
//        if (currentEntityMeta.getSimpleName().startsWith("F")) { // TEST/DEBUG
//          out.println(""); 
//          out.println("ACT_PK_ATTRIBS_COMMA_SEPARATED currentEntityMeta = " + currentEntityMeta.getSimpleName()); 
//          out.println("fields["+i+"].getName() = " + fields[i].getName());
//          out.println("fields["+i+"].isId() = " + fields[i].isId());
//          out.println("fields["+i+"].isEmbeddedIdMemberField = " + fields[i].isEmbeddedIdMemberField());
//        }
        
        if (!(fields[i].isId() | fields[i].isEmbeddedIdMemberField())) { break; }// Process ONLY primary key column attributes
        //int iteration = 0;
        for (StringNode childNode: inputNode.getChildren()) {
          this.build(childNode, outputNode, tokenMap, drivingEntityMeta, currentEntityMeta, fields[i]);
        }
        if (fields[i].isEmbeddedIdMemberField() & (!fields[i].isLastEmbeddedIdMemberField())) {
          this.addNode(", ", outputNode);
        }
        break;
      case ACT_SIMPLE_ATTRIBS:
        if (fields[i].isId()) continue;
        if (isPrimitiveOrWrapper(fields[i])) {
          for (StringNode childNode: inputNode.getChildren()) {
//            out.println("childNode.getValue("+fields[i].getName()+") = " + childNode.getValue());
            this.build(childNode, outputNode, tokenMap, drivingEntityMeta, currentEntityMeta, fields[i]);
          }
        }
//        this.addNode("\r\n", outputNode);
        break;
      case ACT_DATE_ATTRIBS:
        if (fields[i].isId()) continue; // But what if the primary key contains a Date? Convention says don't do that.
        if (isLocalDate(fields[i])) {
          for (StringNode childNode: inputNode.getChildren()) {
//            out.println("childNode.getValue("+fields[i].getName()+") = " + childNode.getValue());
            this.build(childNode, outputNode, tokenMap, drivingEntityMeta, currentEntityMeta, fields[i]);
          }
        }
//        this.addNode("\r\n", outputNode);
        break;
      case ACT_DATE_TIME_ATTRIBS:
        if (isLocalDateTime(fields[i])) {
          for (StringNode childNode: inputNode.getChildren()) {
//            out.println("childNode.getValue("+fields[i].getName()+") = " + childNode.getValue());
            this.build(childNode, outputNode, tokenMap, drivingEntityMeta, currentEntityMeta, fields[i]);
          }
        }
        break;
      case ACT_FK_REF_ATTRIBS:
        if (drivingEntityMeta.getSimpleName().equals("Flight")) { // Hard-coded test/debug
//          out.println("case ACT_FK_REF_ATTRIBS:");
//          out.println("  fields["+i+"]) = " + fields[i].getName());
//          out.println("  isPrimitiveOrWrapper(fields["+i+"]) = " + isPrimitiveOrWrapper(fields[i]));
//          out.println("  getCollectionEnclosedEntityMeta(fields["+i+"]) = " + getCollectionEnclosedEntityMeta(fields[i]));
        }
        if (!isPrimitiveOrWrapper(fields[i]) & getCollectionEnclosedEntityMeta(fields[i]) == null) {
          out.println("    if (!isPrimitiveOrWrapper(fields["+i+"]) & getCollectionEnclosedEntityMeta(fields[i]) == null) PASSED");
          for (StringNode childNode: inputNode.getChildren()) {
            if (fields[i].getType().getSimpleName().equals(drivingEntityMeta.getSimpleName())) {
//              out.println("    if (fields["+i+"].getType().getSimpleName().equals(drivingEntityMeta.getSimpleName())) TRUE");
              continue; 
            }
//            out.println("    if (fields["+i+"].getType().getSimpleName().equals(drivingEntityMeta.getSimpleName())) FALSE");
//              out.println("childNode.getValue("+fields[i].getName()+") = " + childNode.getValue());
              this.build(childNode, outputNode, tokenMap, drivingEntityMeta, currentEntityMeta, fields[i]);
          }
        }
        break;
        case ACT_FK_REF_ENTITIES:
          // out.println(ACT_FK_REF_ENTITIES);
          if (duplicateFKRefClassMap.get(fields[i].getType().getName()) != null) {
            break;
          }
          duplicateFKRefClassMap.put(fields[i].getType().getName(), fields[i]);
          if (!isPrimitiveOrWrapper(fields[i])) {
            // perAttributeLine = replaceTokens(subSegment, fields[i]);
            // perAttributeLine = replaceTokens(subSegment, fields[i].getType());
            for (StringNode childNode: inputNode.getChildren()) {
//              out.println("childNode.getValue("+fields[i].getName()+") = " + childNode.getValue());
              this.build(childNode, outputNode, tokenMap, drivingEntityMeta, currentEntityMeta, fields[i]);
              //perAttributeLine = replaceTokens(subSegment, EntityMeta.getEntityMeta(fields[i].getType().getName()), tokenMap);
            }
          }
          break;
        case ACT_FK_CHILD_ENTITIES_W_COMPOUND_KEYS:
        case ACT_FK_CHILD_ENTITIES:
        case ACT_ALL_FK_CHILD_ENTITIES:
        case ACT_FK_CHILD_ENTITIES_W_COMPOUND_KEYS_FORCE_INCLUDE:
        case ACT_FK_CHILD_ENTITIES_FORCE_INCLUDE:
        case ACT_ALL_FK_CHILD_ENTITIES_FORCE_INCLUDE:
//          out.println("case " + tokenInstruction);
//          if (duplicateFKChildClassMap.get(fields[i].getType().getName()) != null) {
//            break;
//          }
          if (fields[i].isExcludedEditFromParentModule() & (!tokenInstruction.contains(FORCE_INCLUDE))) break;
          if (!fields[i].isExcludedEditFromParentModule() & (tokenInstruction.contains(FORCE_INCLUDE))) break;
          duplicateFKChildClassMap.put(fields[i].getType().getName(), fields[i]); // Necessary in this case?
          collectionOfEntityMeta = null;
          if ((collectionOfEntityMeta = getCollectionEnclosedEntityMeta(fields[i])) != null) {
            //out.println ("Found " + collectionOfEntityMeta.getEntityMeta().getSimpleName() + " enclosed in field " + fields[i].getName());
            if (tokenInstruction.equals(ACT_FK_CHILD_ENTITIES_W_COMPOUND_KEYS)) {
//              if (drivingEntityMeta.getSimpleName().equals("Pilot")) { // & fields[i].getName().startsWith("FlightCrewMember")) { // TEST/DEBUG
//                out.println("case ACT_FK_CHILD_ENTITIES_W_COMPOUND_KEYS Pilot/FlightCrewMember");
//                out.println("  fields[i].getName() = " + fields[i].getName());
//              }
              if (!(collectionOfEntityMeta.getEntityMeta().hasEmbeddedId())) { 
              break;
              } 
            }
            if (tokenInstruction.equals(ACT_FK_CHILD_ENTITIES)) {
              if (collectionOfEntityMeta.getEntityMeta().hasEmbeddedId()) { 
              break;
              } 
            }
            for (StringNode childNode: inputNode.getChildren()) {
//              out.println("childNode.getValue("+fields[i].getName()+") = " + childNode.getValue());
              this.build(childNode, outputNode, tokenMap, drivingEntityMeta, fields[i], collectionOfEntityMeta.getEntityMeta()); // <------------< **************
            }
          }
          break;
        case ACT_FK_CHILD_W_COMPOUND_KEYS_AND_THIRD_ENTITIES:
        case ACT_THIRD_ENTITIES_ONLY:
        case ACT_FK_CHILD_AND_THIRD_ENTITIES:
          {
            if (fields[i].isExcludedEditFromParentModule()) break;
  //          out.println(ACT_FK_CHILD_AND_THIRD_ENTITIES);
  //          if (duplicateFKChildClassMap.get(fields[i].getType().getName()) != null) {
  //            break;
  //          }
  //          duplicateFKChildClassMap.put(fields[i].getType().getName(), fields[i]);
            // if (isCollection(fields[i], collectionOfClass)) {
            // if ((collectionOfClass = getCollectionEnclosedClass(fields[i])) != null) {
            int iteration = 0;
            if ((collectionOfEntityMetas = getCollectionEnclosedEntityMetas(fields[i])) != null) {
              duplicateEntityMetaMap = new HashMap<>();
              for (TempEntityMeta childEntityMeta : collectionOfEntityMetas) {
                if (childEntityMeta.isEmbeddedPkInfo()) continue;
                iteration++; 
                if (duplicateEntityMetaMap.get(childEntityMeta.getEntityMeta().getSimpleName()) != null) {
                  continue;
                }
                duplicateEntityMetaMap.put(childEntityMeta.getEntityMeta().getSimpleName(), childEntityMeta.getEntityMeta());
                if ((tokenInstruction.equals(ACT_FK_CHILD_W_COMPOUND_KEYS_AND_THIRD_ENTITIES)) | (tokenInstruction.equals(ACT_THIRD_ENTITIES_ONLY))) {
  //                if (!(childEntityMeta.getEntityMeta().hasEmbeddedId()) | (childEntityMeta.isXReferenced())) { 
                  if (!(childEntityMeta.isXReferenced())) { 
                    continue;
                  }
                }
                if ((iteration == 1) & (tokenInstruction.equals(ACT_THIRD_ENTITIES_ONLY))) {
  //                if (tokenInstruction.equals(ACT_THIRD_ENTITIES_ONLY)) {
                  continue; // Skip the child entity, go for the third
  //                  if (childEntityMeta.isEmbeddedPkInfo()) continue;
                }
                if (childEntityMeta.getEntityMeta().getSimpleName().equals(drivingEntityMeta.getSimpleName())) continue; 
  //              perAttributeLine += "\n" + indent + replaceTokens(subSegment, entityMeta, tokenMap);
                for (StringNode childNode: inputNode.getChildren()) {
                  this.build(childNode, outputNode, tokenMap, drivingEntityMeta, fields[i], childEntityMeta.getEntityMeta()); // <------------< ********
                  //perAttributeLine = replaceTokens(subSegment, EntityMeta.getEntityMeta(fields[i].getType().getName()), tokenMap);
                }
              }
            }
          }
          break;
//        case ACT_IF_THIRD_ENTITIES_EXIST:
//          {
//            if (fields[i].isExcludedEditFromParentModule()) break;
//            if ((collectionOfEntityMetas = getCollectionEnclosedEntityMetas(fields[i])) != null) {
//              for (TempEntityMeta childEntityMeta : collectionOfEntityMetas) {
//                if (childEntityMeta.isThirdEntity) {
//                  for (StringNode childNode: inputNode.getChildren()) {
//                    out.println("case ACT_IF_THIRD_ENTITIES_EXIST: childNode = [" + childNode.nodeValue+"]");
//                    this.build(childNode, outputNode, tokenMap, drivingEntityMeta, fields[i], currentEntityMeta); // No drill-down here; Stay at same level
////                  this.build(childNode, outputNode, tokenMap, drivingEntityMeta, fields[i], childEntityMeta.getEntityMeta()); 
//                  }
//                  break; // Break the outer loop; only one response to positive match
//                }  
//              }
//            }
//          }
//          break;
        case ACT_OTHER_REF_ENTITIES:
          if (!currentEntityMeta.hasEmbeddedId()) continue;
          out.println("case ACT_OTHER_REF_ENTITIES:");
          if (fields[i].isEmbeddedIdMemberField()) {
            if (fields[i].getType().getName().equals(drivingEntityMeta.getClassName())) {
              continue;
            }
            else { // This is an "other" that we want.
              for (StringNode childNode: inputNode.getChildren()) {
                this.build(childNode, outputNode, tokenMap, drivingEntityMeta, currentEntityMeta, fields[i]);
              }
            }
          }
          break;
        case ACT_THIRD_ENTITIES:
//          out.println(ACT_THIRD_ENTITIES);
          if (duplicateFKChildClassMap.get(fields[i].getType().getName()) != null) {
            break;
          }
          duplicateFKChildClassMap.put(fields[i].getType().getName(), fields[i]);
          if ((collectionOfEntityMetas = getCollectionEnclosedEntityMetas(fields[i])) != null) {
            for (TempEntityMeta childEntityMeta : collectionOfEntityMetas) {
              if (duplicateEntityMetaMap.get(childEntityMeta.getEntityMeta().getSimpleName()) != null) {
                break;
              }
              duplicateEntityMetaMap.put(childEntityMeta.getEntityMeta().getSimpleName(), childEntityMeta.getEntityMeta());
              if (childEntityMeta.getEntityMeta().getSimpleName().equals(drivingEntityMeta.getSimpleName()))  continue;
//              out.println("entityMeta = " + childEntityMeta);
// /             out.println("getCollectionEnclosedEntityMeta(fields[i]).getSimpleName()) = "
//                  + getCollectionEnclosedEntityMeta(fields[i]).getSimpleName());
              if (childEntityMeta.getEntityMeta().getSimpleName().equals(getCollectionEnclosedEntityMeta(fields[i]).getEntityMeta().getSimpleName()))
                continue; // What remains are entity classes referenced by a child entity class
//              perAttributeLine += "\n" + indent + replaceTokens(subSegment, entityMeta, tokenMap);
              for (StringNode childNode: inputNode.getChildren()) {
//                out.println("childNode.getValue("+fields[i].getName()+") = " + childNode.getValue());
                this.build(childNode, outputNode, tokenMap, drivingEntityMeta, fields[i], childEntityMeta.getEntityMeta()); // <------------< **************
                //perAttributeLine = replaceTokens(subSegment, EntityMeta.getEntityMeta(fields[i].getType().getName()), tokenMap);
              }
              //this.addNode("\r\n", outputNode);
            }
          }
          break;
        case ACT_FK_CHILD_ENTITY_ATTRIBS:
        case ACT_FK_CHILD_ENTITY_W_COMPOUND_KEY_ATTRIBS:
          if (fields[i].isExcludedEditFromParentModule()) break;
          // out.println(ACT_FK_CHILD_ENTITY_ATTRIBS);
//          if (duplicateFKChildClassMap.get(fields[i].getType().getName()) != null) {
////            out.println("Found duplicate in duplicateFKChildClassMap.");
//            break;
//          }
//          duplicateFKChildClassMap.put(fields[i].getType().getName(), fields[i]);
          // out.println("duplicateFKChildClassMap = " + duplicateFKChildClassMap);
          // Class refClass = null;
          collectionOfEntityMeta = null;
          if ((collectionOfEntityMeta = getCollectionEnclosedEntityMeta(fields[i])) != null) {
            // out.println("refClass = " + refClass);
            if (collectionOfEntityMeta.getEntityMeta().getSimpleName().equals(drivingEntityMeta.getSimpleName()))
              continue;
            if (tokenInstruction.equals(ACT_FK_CHILD_ENTITY_W_COMPOUND_KEY_ATTRIBS) & !collectionOfEntityMeta.getEntityMeta().hasEmbeddedId()) break;
            EntityMeta.FieldMeta[] childEntityFields = collectionOfEntityMeta.getEntityMeta().getFieldMetaArray();
            // out.println("childEntityFields = " + childEntityFields);
            // out.println("subSegment = " + subSegment);
            for (EntityMeta.FieldMeta childField : childEntityFields) {
//              if (drivingEntityMeta.getSimpleName().startsWith("Air")) { // DEBUG
//                System.out.println("Debugging isExcludedEditFromParentModule()");
//                System.out.println("  fields[i] = " + fields[i].getName());
//              }
//              if (childField.isExcludedEditFromParentModule()) break;
              if (childField.getType().getSimpleName().equals(drivingEntityMeta.getSimpleName())) {
//                // out.println("SKIPPING [redundant back-reference]" +
//                // childField.getType().getSimpleName());
                continue; // [Skip;] WILL HAVE TO REVISIT THIS FOR MULTIPLE FOREIGN KEYS REFERENCING
//                          // DRIVING ENTITY FROM CHILD ENTITY
              }
              if (!(childField.isColumnOrJoinColumn())) {
//                out.println("SKIPPING [not column]" + childField.getName());
                continue; // [Skip;] WILL HAVE TO REVISIT THIS FOR MULTIPLE FOREIGN KEYS REFERENCING
                          // DRIVING ENTITY FROM CHILD ENTITY
              }
              for (StringNode childNode: inputNode.getChildren()) {
//                out.println("childNode.getValue("+fields[i].getName()+") = " + childNode.getValue());
                this.build(childNode, outputNode, tokenMap, drivingEntityMeta, currentEntityMeta, childField);  // <-------------------------<
              }
            }
            break;
          }
          break;
//      case ACT_FK_CHILD_EMBEDDED_ID:
//        out.println(ACT_FK_CHILD_EMBEDDED_ID);
//        if (duplicateFKChildClassMap.get(fields[i].getType().getName()) != null) {
//          out.println("Found duplicate in duplicateFKChildClassMap.");
//          break;
//        }
//        duplicateFKChildClassMap.put(fields[i].getType().getName(), fields[i]);
//        out.println("duplicateFKChildClassMap = " + duplicateFKChildClassMap);
//        // Class refClass = null;
//        collectionOfEntityMeta = null;
//        if ((collectionOfEntityMeta = getCollectionEnclosedEntityMeta(fields[i])) != null) {
//          out.println("collectionOfClass = " + collectionOfEntityMeta);
//          if (collectionOfEntityMeta.getSimpleName().equals(drivingEntityClass.getSimpleName()))
//            continue;
//          EntityMeta.FieldMeta[] childEntityFields = collectionOfEntityMeta.getFieldMetaArray(); // .getDeclaredFields();
//          out.println("childEntityFields = " + childEntityFields);
//          out.println("subSegment = " + subSegment);
//          int iteration = 0;
//          for (EntityMeta.FieldMeta childField : childEntityFields) {
//            // for (int k=0; k< childEntityFields.length; k++) {
//            out.println("childField.getName() = " + childField.getName());
//            out.println("childField.getType().getSimpleName() = '" + childField.getType().getSimpleName() + "'");
//            out.println("drivingEntityClass.getSimpleName() = '" + drivingEntityClass.getSimpleName() + "'");
//            if (childField.getType().getSimpleName().equals(drivingEntityClass.getSimpleName())) {
//              out.println("SKIPPING [redundant back-reference]" + childField.getType().getSimpleName());
//              continue; // [Skip;] WILL HAVE TO REVISIT THIS FOR MULTIPLE FOREIGN KEYS REFERENCING
//                        // DRIVING ENTITY FROM CHILD ENTITY
//            }
//            if (childField.isEmbeddedId()) {
//              perAttributeLine = replaceTokens(subSegment, childField, tokenMap);
//              out.println("perAttributeLine [may be multiple lines] = " + perAttributeLine);
//              break;
//            } else {
//              out.println("SKIPPING [not embeddedId]" + childField.getName());
//              continue;
//            }
//          }
//        }
//        break;
        case ACT_NON_TEMPORAL_ATTRIBS:
          if (fields[i].isId()) continue;
          if ((isPrimitiveOrWrapper(fields[i])) & (!isTemporalType(fields[i]))
              & (getCollectionEnclosedEntityMeta(fields[i]) == null) // Not collection type
          ) {
//            perAttributeLine = replaceTokens(subSegment, fields[i], tokenMap);
            for (StringNode childNode: inputNode.getChildren()) {
//              out.println("childNode.getValue("+fields[i].getName()+") = " + childNode.getValue());
              this.build(childNode, outputNode, tokenMap, drivingEntityMeta, currentEntityMeta, fields[i]);  
              //perAttributeLine = replaceTokens(subSegment, EntityMeta.getEntityMeta(fields[i].getType().getName()), tokenMap);
            }
//            this.addNode("\r\n", outputNode);
          }
          break;
      }
    }
  }
  
  public String getAttributeAttribute ( EntityMeta drivingEntityMeta
                                      , EntityMeta currentEntityMeta
                                      , EntityMeta.FieldMeta field
                                      , String token
                                      , Map<String, String> parentTokenMap
                                      ) {
    if (field.getName().equals(SERIAL_VERSION_UID)) return null;
//    out.println ("getAttributeAttribute(" + field + ", " + token+")");
//    out.println ("  field getType().getTypeName() = " + field.getType().getTypeName());
  //  out.println ("  " + field.getType().getTypeName().substring(field.getType().getTypeName().lastIndexOf(PERIOD)+1));
  
    String returnValue = null;
    String interim = null;
    //Field[] fields = entityClass.getDeclaredFields();
    TempEntityMeta collectionOfEntityMeta = null;
    if ((collectionOfEntityMeta = getCollectionEnclosedEntityMeta (field)) != null) {
  //  if (isCollection(field, collectionOfClass)) { 
      switch (token) {
      case FK_CHILD_ENTITY:
//      out.println("Found " + FK_CHILD_ENTITY + " " + field.getResolvedIdentifier() + ": " + collectionOfEntityMeta);
        returnValue = collectionOfEntityMeta.getEntityMeta().getSimpleName();
        break;
//      case FK_CHILD_ENTITY_IDENTIFIER:
//        returnValue = field.getName();
//        break;
      case FK_CHILD_ENTITY_LABEL:
//      out.println("Found " + FK_CHILD_ENTITY + " " + field.getResolvedIdentifier() + ": " + collectionOfEntityMeta);
        returnValue = collectionOfEntityMeta.getEntityMeta().getLabel();
        break;
      case FK_CHILD_ENTITY_INIT_SMALL:
//        out.println("Found " + FK_CHILD_ENTITY_INIT_SMALL + " " + field.getResolvedIdentifier() + ": " + collectionOfEntityMeta);
        interim = collectionOfEntityMeta.getEntityMeta().getSimpleName();
        returnValue = interim.substring(0,1).toLowerCase()+interim.substring(1);
        break;
      case FK_CHILD_ENTITY_LOWER:
        returnValue = collectionOfEntityMeta.getEntityMeta().getSimpleName().toLowerCase();
        break;

      case FK_CHILD_ENTITY_LOWER_PLURAL:
        returnValue = collectionOfEntityMeta.getEntityMeta().getSimpleName().toLowerCase()+"s";
        break;
      case FK_CHILD_ENTITY_UPPER:
        returnValue = collectionOfEntityMeta.getEntityMeta().getSimpleName().toUpperCase();
        break;
      case FK_CHILD_ENTITY_UPPER_PLURAL:
        returnValue = collectionOfEntityMeta.getEntityMeta().getSimpleName().toUpperCase()+"S";
        break;
//      case FK_CHILD_EMBEDDED_PK:
//        out.println("case FK_CHILD_EMBEDDED_PK");
//      case FK_CHILD_EMBEDDED_PK_INIT_SMALL:
//        out.println("case FK_CHILD_EMBEDDED_PK_INIT_SMALL");
////        out.println("Found FK_CHILD_EMBEDDED_ID " + FK_CHILD_EMBEDDED_ID + " " + currentEntityMeta.getSimpleName() + ": " + currentEntityMeta);
//        EntityMeta embeddedPK = currentEntityMeta.getEmbeddedPKInfo();
//        if (embeddedPK != null) {
//          out.println("Found FK_CHILD_EMBEDDED_ID " + FK_CHILD_EMBEDDED_ID + " " + currentEntityMeta.getSimpleName() + ": " + currentEntityMeta);
//          returnValue = embeddedPK.getSimpleName();
//        }
//        if (returnValue!=null & token.equals(FK_CHILD_EMBEDDED_PK_INIT_SMALL)) {
//          returnValue=returnValue.substring(0,1).toLowerCase() + returnValue.substring(1);
//        }
//        out.println("returnValue = " + returnValue);
//        break;
      }
    }
//    if (!isPrimitiveOrWrapper(field)) { // It's a FK Ref Entity
    if (!field.isPrimitiveOrWrapper()) { // It's a FK Ref Entity
      switch (token) {
      case FK_REF_ENTITY: 
        returnValue = field.getType().getSimpleName();
      break;
      case FK_REF_ENTITY_QUALIFIED: 
//        try {
//          returnValue = EntityMeta.getEntityMeta(field.getType().getName()).getLabel().replaceAll(" ", "");
          returnValue = field.getLabel().replaceAll(" ", "");
//        } catch (IOException e) {
//          out.println("case FK_REF_ENTITY_QUALIFIED should NEVER throw IOException!!!");
//        }
      break;
      case FK_REF_ENTITY_INIT_SMALL:
        interim = field.getType().getSimpleName();
        returnValue = interim.substring(0,1).toLowerCase()+interim.substring(1);
        break;
      case FK_REF_ENTITY_LOWER:
        returnValue = field.getType().getSimpleName().toLowerCase();
        break;
      case FK_REF_ENTITY_LOWER_PLURAL:
        returnValue = field.getType().getSimpleName().toLowerCase()+"s";
        break;
      case FK_REF_ENTITY_UPPER_PLURAL:
        returnValue = field.getType().getSimpleName().toUpperCase()+"S";
        break;
      case FK_REF_ENTITY_ID:
        try {
          out.println("case FK_REF_ENTITY_ID: ");
          out.println("  currentEntityMeta = " + currentEntityMeta.getSimpleName());
          out.println("  field = " + field.getName());
          
          returnValue = EntityMetaFactoryImpl.entityMetaFactoryImplX.getEntityMeta(field.getType().getName()).getIDField().getName(); 
//              currentEntityMeta.getIDField().getName();
//              
//        } catch (IOException e) {
        } catch (Exception e) {
          returnValue = "EntityMeta.getEntityMeta() SHOULD NOT THROW Exception (getAttributeAttribute case FK_REF_ENTITY_ID)";
        }
        break;
      case FK_REF_ATTRIB_NAME:
        returnValue = field.getResolvedIdentifier();
        break;
      case FK_REF_ATTRIB_INITCAPS:
        returnValue = field.getResolvedIdentifier().substring(0,1).toUpperCase()+field.getResolvedIdentifier().substring(1);
        break;
        }
      } 
      switch (token) {
        case FK_CHILD_EMBEDDED_ID:
        case FK_CHILD_EMBEDDED_ID_INIT_SMALL:
          returnValue = currentEntityMeta.getEmbeddedPKInfo().getSimpleName(); // .getEmbeddedPKInfo().getSimpleName();
          if (token.equals(FK_CHILD_EMBEDDED_ID_INIT_SMALL)) {
            returnValue = returnValue.substring(0, 1).toLowerCase()+ returnValue.substring(1);
          }
        break;
        case ENTITY_ATRRIB_INITCAP_NAME:
          if (!isPrimitiveOrWrapper(field.getType())) {
            returnValue = field.getResolvedIdentifier().substring(0,1).toUpperCase()+field.getResolvedIdentifier().substring(1);
          }
          break;
        case ENTITY_ATTRIB_UPPER_NAME:
          returnValue = field.getResolvedIdentifier().toUpperCase();
          break;
        case ENTITY_ATTRIB_NAME:
          returnValue = field.getResolvedIdentifier();
          break;
        case ENTITY_ATTRIB_LABEL:
          if (field.isEmbeddedId()) {
            returnValue = field.getLabel(drivingEntityMeta);
          }
          else {
            returnValue = field.getLabel();
          }
          break;
        case ENTITY_ATTRIB_DEFAULT_DATATYPE:
          if (!isPrimitiveOrWrapper(field)) {
            returnValue = DATATYPE_INTEGER;
          } else if (isTemporalType(field)) {
            returnValue = DATATYPE_STRING;
          } else {
            try { 
              returnValue = field.getType().getSimpleName();
            } catch (Exception e) {
              returnValue = field.getType().getName();
            }
          }
          break;
        case ENTITY_ATTRIB_INITCAPS:
          returnValue = field.getResolvedIdentifier().substring(0,1).toUpperCase()+field.getResolvedIdentifier().substring(1);
          break;
        case ENTITY_DATE_ATTRIB_NAME:
          if (field.getType().getName().endsWith(DATATYPE_LOCAL_DATE)){
            returnValue = field.getResolvedIdentifier();
          }
          break;
        case ENTITY_DATE_TIME_ATTRIB_NAME:
          if (field.getType().getName().endsWith(DATATYPE_LOCAL_DATE_TIME)){
            returnValue = field.getResolvedIdentifier();
          }
          break;
        case ENTITY_DATE_ATTRIB_INITCAPS:
          if (field.getType().getName().endsWith(DATATYPE_LOCAL_DATE)){
            returnValue = field.getResolvedIdentifier().substring(0,1).toUpperCase()+field.getResolvedIdentifier().substring(1);
          }
          break;
        case ENTITY_DATE_TIME_ATTRIB_INITCAPS:
          if (field.getType().getName().endsWith(DATATYPE_LOCAL_DATE_TIME)){
            returnValue = field.getResolvedIdentifier().substring(0,1).toUpperCase()+field.getResolvedIdentifier().substring(1);
          }
          break;
        case GET_TH_HTML_FORM_DATA_VARS: 
        {
          returnValue = "";
          int iteration = 0;
          String compoundEntityPlusPK = currentEntityMeta.getSimpleName().substring(0,1).toLowerCase()+currentEntityMeta.getSimpleName().substring(1)
                                      + "."
                                      + currentEntityMeta.getEmbeddedPKInfo().getSimpleName().substring(0,1).toLowerCase()
                                      + currentEntityMeta.getEmbeddedPKInfo().getSimpleName().substring(1);
          for (String embeddidIdField: currentEntityMeta.getEmbeddedIdFieldIdentifiers()) {
            if (iteration > 0) {returnValue += ", ";}
            returnValue += "data-" + embeddidIdField + "=${" + compoundEntityPlusPK + "." + embeddidIdField + "}";
      //    th:attr="data-pilotId=${flightCrewMember.flightCrewMemberPK.pilotId}, data-flightId=${flightCrewMember.flightCrewMemberPK.flightId}"
            iteration++;
          }
          break;
        }
//        case HTML_FORM_VERTICAL_INPUT:
//        case HTML_FORM_HORIZONTAL_INPUT:
//        {
//          StringBuilder sb = new StringBuilder("");
//          String indent = "          "; // 10 spaces
//          
//          boolean isFkRef = (!isPrimitiveOrWrapper(field) & getCollectionEnclosedEntityMeta(field) == null);
//          boolean isFKChildCollection = (getCollectionEnclosedEntityMeta(field) != null);
//          String htmlFormInputControl = field.getHtmlFormInputControl();
//          
//          
//          sb.append(indent + "<tr>\n");
//          sb.append(indent + "  <td><label for=\"" + field.getResolvedIdentifier() + "\">" + field.getLabel() + "</label></td>\n");
//          String htmlFormVar = field.getDeclaringClassName().substring(0, 1).toLowerCase()+field.getDeclaringClassName().substring(1) + "." + field.getName();
//          
//          if ((!isFkRef) & (!isFKChildCollection)){
//            switch (htmlFormInputControl) {
//              case "text": // DECLARE CONSTANTS FOR THESE
//                sb.append(indent + "  <td><input type=\"" + htmlFormInputControl + "\" id=\"" + field.getName() + "\" size=\"" + field.getFieldWidth() + "\" name=\"" + field.getName() + "\" th:value=\"${" + htmlFormVar + "}\"/></td>\r\n");
//                break; 
//              case "textarea":
//                sb.append(indent + "  <td><" + htmlFormInputControl + " rows=\"2\" class=\"form-control\" id=\"" + field.getName() + "\" name=\"" + field.getName() + "\" cols=\"" + field.getFieldWidth() + "\" th:text=\"${" + htmlFormVar + "}\"/></td>\n");
//                break;
//              case "date": 
//                sb.append(indent + "  <td><input type=\"" + htmlFormInputControl + "\" id=\"" + field.getName() + "\" size=\"" + field.getFieldWidth() + "\" name=\"" + field.getName() + "\" th:value=\"${" + htmlFormVar + "}\"/></td>\r\n");
//                break; 
//              case "datetime-local": 
//                sb.append(indent + "  <td><input type=\"" + htmlFormInputControl + "\" id=\"" + field.getName() + "\" size=\"" + field.getFieldWidth() + "\" name=\"" + field.getName() + "\" th:value=\"${" + htmlFormVar + "}\"/></td>\r\n");
//                break; 
//            }
//          } 
//          else if (isFkRef) {
//            String fkRefEntityInitUpper = field.getType().getSimpleName();
//            String fkRefEntity = fkRefEntityInitUpper.substring(0, 1).toLowerCase() + fkRefEntityInitUpper.substring(1);
//            String fkRefEntityId = "COULD NOT GET fkRefEntityId";
//            try {
//              fkRefEntityId = EntityMeta.getEntityMeta(field.getType().getName()).getIDField().getName();
//            } catch (IOException e) {}
//            sb.append(indent + "  <td>\r\n");
//            sb.append(indent + "  <select th:field=\"*{" + htmlFormVar + "}\">\r\n");
//            sb.append(indent + "  <option value=\"0\">[Please select...]</option>\r\n");
//            sb.append(indent + "  <option th:each=\""+fkRefEntity+" : ${"+fkRefEntity+"s}\" \r\n");
//            sb.append(indent + "          th:value=\"${"+fkRefEntity+"."+fkRefEntityId+"}\" \r\n");
//            sb.append(indent + "          th:text=\"${"+fkRefEntity+"}\">null</option>\r\n");
//            sb.append(indent + "  </select>\r\n");
//            sb.append(indent + "              <button data-btn=\""+field.getName()+"-edit\" th:attr=\"data-"+field.getName()+"=${"+htmlFormVar+"}==null?0:${"+htmlFormVar+"."+fkRefEntityId+"}\" type=\"SUBMIT\" class=\"frmEdit\" NAME=\"frmEdit\" VALUE=\"View/Edit "+fkRefEntityInitUpper+"\">\r\n");
//            sb.append(indent + "              <span class=\"fa-stack\">\r\n");
//            sb.append(indent + "                  <i class=\"glyphicon glyphicon-edit\"></i>\r\n");
//            sb.append(indent + "              </span>\r\n");
//            sb.append(indent + "              </button>\r\n");
//            sb.append(indent + "  </td>\r\n");
//          }
//          sb.append(indent + "</tr>\n");
//          returnValue = sb.toString();
//        }
//        break;
        case HTML_FORM_VERTICAL_INPUT:
        case HTML_FORM_VERTICAL_INPUT_BLANK:
        case HTML_FORM_HORIZONTAL_INPUT:
        case HTML_FORM_HORIZONTAL_INPUT_BLANK:
        {
          returnValue = "";
          if (field.isEmbeddedId()) break;
          StringBuilder sb = new StringBuilder("");
          String indent = "          "; // 10 spaces
          
          boolean isFkRef = (!isPrimitiveOrWrapper(field) & getCollectionEnclosedEntityMeta(field) == null);
          boolean isFKChildCollection = (getCollectionEnclosedEntityMeta(field) != null); // FLAWED?
          boolean currentEntityMetaIsChild = (!currentEntityMeta.equals(drivingEntityMeta));
          String fieldType = field.getType().getSimpleName();
          String drivingEntityMetaName = drivingEntityMeta.getSimpleName();
          if (currentEntityMetaIsChild) { // NEED TO HANDLE MULTIPLE FKs back to same driving parent
            if (fieldType.equals(drivingEntityMetaName)) break; 
          }
          String htmlFormInputControl = field.getHtmlFormInputControl();
          boolean isVertical = token.startsWith(HTML_FORM_VERTICAL_INPUT);
          boolean isHorizontal = token.startsWith(HTML_FORM_HORIZONTAL_INPUT);
          boolean isBlank = token.endsWith("_BLANK"); 
          if (field.isEmbeddedIdMemberField() & !isBlank) break;
          
          sb.append(isVertical?"<tr>\n":"");
          //sb.append(isVertical?indent + "<tr>\n":"");
          sb.append(isVertical?indent + "  <td><label for=\"" + field.getResolvedIdentifier() + "\">" + field.getLabel() + "</label></td>\n":"");
          String classVar = field.getDeclaringClassName().substring(0, 1).toLowerCase()+field.getDeclaringClassName().substring(1);
          String htmlFormVar = classVar + "." + field.getName();
          String valueClause = isBlank?" value=\"\"":" th:value=\"${" + htmlFormVar + "}\"";
          String textClause = isBlank?" text=\"\"":" th:text=\"${" + htmlFormVar + "}\"";
          String textAreaRows = (isBlank?"\"2\"":"\"1\"");
          
          String fieldName = "";
          int fieldWidth = field.getFieldWidth();
          if (currentEntityMetaIsChild) { // Horizontal
            fieldName = classVar + (field.getName().substring(0, 1).toUpperCase()+field.getName().substring(1));
          }
          else { // Vertical
            fieldName = field.getName();
          }
          
          if ((!isFkRef) & (!isFKChildCollection)) {
            switch (htmlFormInputControl) {
              case "text": // DECLARE CONSTANTS FOR THESE
                sb.append(indent + "  <td><input type=\"" + htmlFormInputControl + "\" id=\"" + fieldName + "\" size=\"" + fieldWidth + "\" name=\"" + fieldName + "\""+valueClause+"/></td>\r\n");
                break; 
              case "textarea":
                sb.append(indent + "  <td><" + htmlFormInputControl + " rows=" + textAreaRows + " id=\"" + fieldName + "\" name=\"" + fieldName + "\" cols=\"" + fieldWidth + "\""+textClause+"/></td>\n");
                break;
              case "date": 
                sb.append(indent + "  <td><input type=\"" + htmlFormInputControl + "\" id=\"" + fieldName + "\" size=\"" + fieldWidth + "\" name=\"" + fieldName + "\""+valueClause+"/></td>\r\n");
                break; 
              case "datetime-local": 
                sb.append(indent + "  <td><input type=\"" + htmlFormInputControl + "\" id=\"" + fieldName + "\" size=\"" + fieldWidth + "\" name=\"" + fieldName + "\""+valueClause+"/></td>\r\n");
                break; 
            }
          } 
          else if ((isFkRef) & (!isFKChildCollection) &(isVertical)) {
            String fkRefEntityInitUpper = field.getType().getSimpleName();
            String fkRefEntity = fkRefEntityInitUpper.substring(0, 1).toLowerCase() + fkRefEntityInitUpper.substring(1);
            String fkRefEntityQualified = field.getLabel().replaceAll(" ", "");
            String fkRefEntityId = "COULD NOT GET fkRefEntityId";
            try {
              fkRefEntityId = EntityMetaFactoryImpl.entityMetaFactoryImplX.getEntityMeta(field.getType().getName()).getIDField().getName();
            } catch (IOException e) {}
            sb.append(indent + "  <td>\r\n");
            sb.append(indent + "  <select th:field=\"*{" + htmlFormVar + "}\">\r\n");
            sb.append(indent + "  <option value=\"0\">[Please select...]</option>\r\n");
            sb.append(indent + "  <option th:each=\""+fkRefEntity+" : ${"+fkRefEntity+"s}\" \r\n");
            sb.append(indent + "          th:value=\"${"+fkRefEntity+"."+fkRefEntityId+"}\" \r\n");
            sb.append(indent + "          th:text=\"${"+fkRefEntity+"}\">null</option>\r\n");
            sb.append(indent + "  </select>\r\n");
//            sb.append(indent + "              <button data-btn=\""+fkRefEntityQualified+"-edit\" th:attr=\"data-"+fieldName+"=${"+htmlFormVar+"}==null?0:${"+htmlFormVar+"."+fkRefEntityId+"}\" type=\"SUBMIT\" class=\"frmEdit\" NAME=\"frmEdit\" VALUE=\"View/Edit "+fkRefEntityInitUpper+"\">\r\n");
            sb.append(indent + "              <button data-btn=\""+field.getName()+"-edit\" th:attr=\"data-"+fieldName+"=${"+htmlFormVar+"}==null?0:${"+htmlFormVar+"."+fkRefEntityId+"}\" type=\"SUBMIT\" class=\"frmEdit\" NAME=\"frmEdit\" VALUE=\"View/Edit "+fkRefEntityInitUpper+"\">\r\n");
            sb.append(indent + "              <span class=\"fa-stack\">\r\n");
            sb.append(indent + "                  <i class=\"glyphicon glyphicon-edit\"></i>\r\n");
            sb.append(indent + "              </span>\r\n");
            sb.append(indent + "              </button>\r\n");
            sb.append(indent + "  </td>\r\n");
          }
          sb.append(isVertical?indent + "</tr>\n":"");
          returnValue = sb.toString();
        }
        break;
      }
      if (returnValue == null) {
//        out.println("returnValue == null");
        // One more try on FK_CHILD_ENTITY token
        switch (token) {
        case FK_CHILD_ENTITY:
//          out.println("Found " + FK_CHILD_ENTITY + " " + field.getResolvedIdentifier() + ": ");
//          returnValue = field.getDeclaringClass().getSimpleName();
          returnValue = field.getDeclaringClassName();
          break;
        case FK_CHILD_ENTITY_LABEL:
          returnValue = currentEntityMeta.getLabel();
          break;
        case FK_CHILD_ENTITY_QUALIFIED:
          returnValue = field.getLabel().replaceAll(" ", "");
          break;
        case FK_CHILD_ENTITY_INIT_SMALL:
          interim = field.getDeclaringClassName();
          returnValue = interim.substring(0,1).toLowerCase()+interim.substring(1);
          break;
        case FK_CHILD_ENTITY_LOWER:
          returnValue = field.getDeclaringClassName().toLowerCase();
          break;
        case FK_CHILD_ENTITY_LOWER_PLURAL:
          returnValue = field.getDeclaringClassName().toLowerCase()+"s";
          break;
        case FK_CHILD_ENTITY_UPPER:
          returnValue = field.getDeclaringClassName().toUpperCase();
          break;
        case FK_CHILD_ENTITY_UPPER_PLURAL:
          returnValue = field.getDeclaringClassName().toUpperCase()+"S";
          break;
        }
      }
      //    out.println ("returnValue = " + returnValue );
    return returnValue;
  }
  
  public String getAttributeAttribute ( EntityMeta drivingEntityMeta
                                      , FieldMeta drivingEntityMetaField
                                      , EntityMeta currentEntityMeta
                                      , String token
                                      , Map<String, String> parentTokenMap
                                      ) {
    String[] excluded = null;
    return getAttributeAttribute (drivingEntityMeta, drivingEntityMetaField, currentEntityMeta, token, excluded);
  }

  public String getAttributeAttribute ( EntityMeta drivingEntityMeta
                                      , FieldMeta drivingEntityMetaField
                                      , EntityMeta currentEntityMeta
                                      , String token
                                      , String[] excluded
                                      ) {
//    out.println("getAttributeAttribute " + currentEntityMeta.getSimpleName() + ", " + token);
    String returnValue = null;
    String interim = null;
    boolean currentEntityMetaIsChild = (!currentEntityMeta.equals(drivingEntityMeta));
    String drivingEntityMetaName = drivingEntityMeta.getSimpleName();
    
    switch (token) { 
    case ENTITY_ATTRIB_LABEL:
      returnValue = drivingEntityMetaField.getLabel();
      break;
    
//    case ENTITY_ATTRIB_UPPER_NAME:
//    returnValue = field.getResolvedIdentifier().toUpperCase();
//    break;
//  case ENTITY_ATTRIB_NAME:
//    returnValue = field.getResolvedIdentifier();
//    break;
    case FIRST_NON_KEY_REQUIRED_ATTRIB:
    case FIRST_NON_KEY_REQUIRED_ATTRIB_INIT_CAP:
  //    out.println("Found FK_CHILD_ENTITY " + FK_CHILD_ENTITY + " " + currentEntityMeta.getSimpleName() + ": " + currentEntityMeta);
      returnValue = currentEntityMeta.getFirstNonKeyRequiredFieldName();
      if (token.equals(FIRST_NON_KEY_REQUIRED_ATTRIB_INIT_CAP)) {
        returnValue = returnValue.substring(0,1).toUpperCase() + returnValue.substring(1);  
      }
      break;
    case FK_CHILD_ENTITY:
  //    out.println("Found FK_CHILD_ENTITY " + FK_CHILD_ENTITY + " " + currentEntityMeta.getSimpleName() + ": " + currentEntityMeta);
      returnValue = currentEntityMeta.getSimpleName();
      break;
    case FK_CHILD_ENTITY_IDENTIFIER:
      returnValue = drivingEntityMetaField.getName();
      break;
    case FK_CHILD_ENTITY_INIT_SMALL:
      interim = currentEntityMeta.getSimpleName();
      returnValue = interim.substring(0,1).toLowerCase()+interim.substring(1);
      break;
//    case FK_CHILD_ENTITY_QUALIFIED:
//      returnValue = currentEntityMeta.getLabel().replaceAll(" ", "");
//      break;
    case FK_CHILD_ENTITY_LABEL:
      returnValue = currentEntityMeta.getLabel();
      break;
    case FK_CHILD_ENTITY_LOWER:
      returnValue = currentEntityMeta.getSimpleName().toLowerCase();
      break;
    case FK_CHILD_ENTITY_LOWER_PLURAL:
      returnValue = currentEntityMeta.getSimpleName().toLowerCase()+"s";
      break;
    case FK_CHILD_ENTITY_UPPER:
      returnValue = currentEntityMeta.getSimpleName().toUpperCase();
      break;
    case FK_CHILD_ENTITY_UPPER_PLURAL:
      returnValue = currentEntityMeta.getSimpleName().toUpperCase()+"S";
      break;
    case FK_REF_ENTITY:
    case FK_REF_ENTITY_INIT_SMALL:
      {
          out.println("Found FK_REF_ENTITY " + FK_REF_ENTITY + " " + currentEntityMeta.getSimpleName() + ": " + currentEntityMeta);
        //returnValue = currentEntityMeta.getSimpleName();
        EntityMeta[] embeddedIdRefEntities = currentEntityMeta.getEmbeddedIdRefEntities();
        if (embeddedIdRefEntities == null) break; 
        for (EntityMeta embeddedIdRefEntity: embeddedIdRefEntities) {
          if (embeddedIdRefEntity.equals(drivingEntityMeta)) continue;
          returnValue = embeddedIdRefEntity.getSimpleName();
        }
        if (token.equals(FK_REF_ENTITY_INIT_SMALL)) {
          returnValue = returnValue.substring(0,1).toLowerCase()+returnValue.substring(1);
        }
      }
      break;
    case FK_REF_ENTITY_ID:
    case FK_REF_ENTITY_ID_INIT_CAP:
      returnValue = "";
      out.println("case FK_REF_ENTITY_ID: ");
      out.println("  drivingEntityMetaName = " + drivingEntityMetaName);
      out.println("  currentEntityMeta = " + currentEntityMeta.getSimpleName());
      
//      returnValue = EntityMeta.getEntityMeta(field.getType().getName()).getIDField().getName(); 
      //if (returnValue == null) 
      EntityMeta[] embeddedIdRefEntities = currentEntityMeta.getEmbeddedIdRefEntities();
      if (embeddedIdRefEntities != null) {
        for (EntityMeta embeddidIdRefEntity: embeddedIdRefEntities) {
  //        String embeddedIdRefFieldName = embeddidIdRefField.getName();
  //        String embeddedIdRefFieldType = embeddidIdRefField.getType().getSimpleName();
  //        embeddidIdRefField.get
  //        out.println("  embeddedIdRefFieldName = " + embeddedIdRefFieldName);
  //        out.println("  embeddedIdRefFieldType = " + embeddedIdRefFieldType);
          if (embeddidIdRefEntity == null || embeddidIdRefEntity.equals(drivingEntityMeta)) {
            continue;
          }
          returnValue = embeddidIdRefEntity.getIDField().getName();
          if (token.equals(FK_REF_ENTITY_ID_INIT_CAP)) {
            returnValue = returnValue.substring(0, 1).toUpperCase()+returnValue.substring(1);
          }
          break;
        }
      }
      break;
    case FK_REF_ENTITY_LOWER:
      returnValue = currentEntityMeta.getSimpleName().toLowerCase();
      break;
    case FK_REF_ENTITY_LOWER_PLURAL:
      returnValue = currentEntityMeta.getSimpleName().toLowerCase()+"s";
      break;
    case FK_REF_ENTITY_UPPER_PLURAL:
      returnValue = currentEntityMeta.getSimpleName().toUpperCase()+"S";
      break;
    case FK_CHILD_EMBEDDED_ID:
    case FK_CHILD_EMBEDDED_ID_INIT_SMALL:
      returnValue = currentEntityMeta.getEmbeddedPKInfo().getSimpleName(); // .getEmbeddedPKInfo().getSimpleName();
      if (token.equals(FK_CHILD_EMBEDDED_ID_INIT_SMALL)) {
        returnValue = returnValue.substring(0, 1).toLowerCase()+ returnValue.substring(1);
      }
      break;      
//    case FK_CHILD_EMBEDDED_ID:
//    case FK_CHILD_EMBEDDED_ID_INIT_CAPS:
//      out.println("Found FK_CHILD_EMBEDDED_ID " + FK_CHILD_EMBEDDED_ID + " " + currentEntityMeta.getSimpleName() + ": " + currentEntityMeta);
//      String[] embeddedIdFieldIdentifiers = currentEntityMeta.getEmbeddedIdFieldIdentifiers();
//      out.println("embeddedIdFieldIdentifiers = " + embeddedIdFieldIdentifiers);
//      if (embeddedIdFieldIdentifiers != null) {
//        boolean complete = false;
//        for (String fieldIdentifier: embeddedIdFieldIdentifiers) {
//          out.println("fieldIdentifier = " + fieldIdentifier);
//          if (fieldIdentifier.toLowerCase().startsWith(drivingEntityMeta.getSimpleName().toLowerCase())){ 
//            continue; // We're looking for the 'other' key field
//            // LATENT BUG ALERT! THIS MECHANISM IS INADEQUATE FOR HANDLING CHILD ENTITIES WITH COMPOUND PRIMARY KEYS EXCEEDING 2 FIELDS
//          } 
//          if (complete) break;
//          if (excluded != null) { // THE EXCLUDED ARRAY MECHANISM WAS NEVER FULLY IMPLEMENTED. DEPRECATE/DESTROY?
//            for (String exclude: excluded) {
////              out.println("exclude = " + exclude);
//              if (fieldIdentifier.toLowerCase().startsWith(exclude.toLowerCase())){
//                break;
//              } else {
//                returnValue = fieldIdentifier;
//                complete = true; // to break out of outer loop
//              }
//            }
//          } else {
//            returnValue = fieldIdentifier;
//          }
//        }
//      }
//      if (returnValue!=null & token.equals(FK_CHILD_EMBEDDED_ID_INIT_CAPS)) {
//        returnValue=returnValue.substring(0,1).toUpperCase() + returnValue.substring(1);
//      }
//      break; 
    case PK_ID_FIELD:
    case PK_ID_FIELD_INIT_CAP:
//      if (currentEntityMeta.hasEmbeddedId()) 
      try {
        returnValue = currentEntityMeta.getIDField().getName();
      } catch (NullPointerException e) {
//        returnValue = currentEntityMeta.getSimpleName() + " doesn't have a primary key ID field.";
//        returnValue = returnValue.toUpperCase();
        returnValue = null;
        break;
      }
      if (token.equals(PK_ID_FIELD_INIT_CAP)) {
        returnValue = returnValue.substring(0,1).toUpperCase() + returnValue.substring(1);
      }
      break;
    case PK_FK_REF_ENTITY: 
    case PK_FK_REF_ENTITY_INIT_SMALL:
      // THIS IS A MESS!
      out.println("Found PK_FK_REF_ENTITY " + PK_FK_REF_ENTITY + " " + currentEntityMeta.getSimpleName() + ": " + currentEntityMeta);
      //getEmbeddedIdRefEntityIdentifiers
      String[] embeddedIdRefEntityIdentifiers = currentEntityMeta.getEmbeddedIdRefEntityIdentifiers();
      out.println("embeddedIdRefEntityIdentifiers = " + embeddedIdRefEntityIdentifiers);
      if (embeddedIdRefEntityIdentifiers != null) {
        boolean complete = false;
        for (String refEntityName: embeddedIdRefEntityIdentifiers) {
          out.println("refEntityName = " + refEntityName);
          if (refEntityName == null) break;
          if (refEntityName.equals(drivingEntityMeta.getSimpleName())){ 
            continue; // We're looking for the 'other' key ref entity 
            // LATENT BUG ALERT! THIS MECHANISM IS INADEQUATE FOR HANDLING CHILD ENTITIES WITH COMPOUND PRIMARY KEYS EXCEEDING 2 FIELDS
          } 
          if (complete) break;
          if (excluded != null) { // THE EXCLUDED ARRAY MECHANISM WAS NEVER FULLY IMPLEMENTED. DEPRECATE/DESTROY?
            for (String exclude: excluded) {
//              out.println("exclude = " + exclude);
              if (refEntityName.toLowerCase().startsWith(exclude.toLowerCase())){
                break;
              } else {
                returnValue = refEntityName;
                complete = true; // to break out of outer loop
              }
            }
          } else {
            returnValue = refEntityName;
          }
        }
      }
      if (token.equals(PK_FK_REF_ENTITY_INIT_SMALL) & ((returnValue != null) && (returnValue.trim().length()>1))) {
        returnValue = returnValue.substring(0,1).toLowerCase() + returnValue.substring(1);
      }
      break;
    case PK_FK_REF_ENTITIES_DECLARE_REPOSITORY_FIND: // Most hard-coded case so far 2018.03.04
      returnValue = "";
      String currentTableVarPrefix = currentEntityMeta.getSimpleName().substring(0, 1).toLowerCase()+currentEntityMeta.getSimpleName().substring(1);
      int iteration = 0;
      String fieldNameInitCap = null;
      String embeddidIdRefClassNameInitSmall = null;
      for (String embeddidIdRefClassName: currentEntityMeta.getEmbeddedIdRefEntityIdentifiers()) {
        if (iteration > 0) {returnValue += "\n    ";}
        if (embeddidIdRefClassName == null) break;
        embeddidIdRefClassNameInitSmall = embeddidIdRefClassName.substring(0,1).toLowerCase()+ embeddidIdRefClassName.substring(1);
        out.println("getPkFkRefClassFieldMap() = " + currentEntityMeta.getPkFkRefClassFieldMap());
        fieldNameInitCap = currentEntityMeta.getPkFkRefClassFieldMap().get(embeddidIdRefClassNameInitSmall);
        if (fieldNameInitCap != null) {
          fieldNameInitCap = fieldNameInitCap.substring(0, 1).toUpperCase() + fieldNameInitCap.substring(1);
          returnValue += embeddidIdRefClassName + " " + embeddidIdRefClassNameInitSmall
                       + " = " + embeddidIdRefClassNameInitSmall + "Repository.findOne(" + currentTableVarPrefix + fieldNameInitCap + ");";
        }
//Pilot pilot = repository.findOne(flightCrewMemberPilotId); getPkFkRefClassFieldMap()
        iteration++;
      }
      break;
    case CALL_COMPOUND_CONSTRUCTOR: 
    //FlightCrewMember(tempFlight, pilot)
    returnValue = currentEntityMeta.getSimpleName() + "(";
    iteration = 0;
    fieldNameInitCap = null;
    for (String embeddidIdRefClassName: currentEntityMeta.getEmbeddedIdRefEntityIdentifiers()) {
      if (iteration > 0) {returnValue += ", ";}
      if (embeddidIdRefClassName == null) break;
      embeddidIdRefClassNameInitSmall = embeddidIdRefClassName.substring(0,1).toLowerCase()+ embeddidIdRefClassName.substring(1);
      returnValue += embeddidIdRefClassNameInitSmall;
      iteration++;
    }
    returnValue += ")";
    break;
//    case GET_TH_HTML_FORM_DATA_VARS: 
//    {
//      //FlightCrewMember(tempFlight, pilot)
//      iteration = 0;
//  //    fieldNameInitCap = null;
//      String compoundEntityPlusPK = currentEntityMeta.getSimpleName().substring(0,1).toLowerCase()+currentEntityMeta.getSimpleName().substring(1)
//                                  + "."
//                                  + currentEntityMeta.getEmbeddedPKInfo().getSimpleName().substring(0,1).toLowerCase()
//                                  + currentEntityMeta.getEmbeddedPKInfo().getSimpleName().substring(1);
//      for (String embeddidIdField: currentEntityMeta.getEmbeddedIdFieldIdentifiers()) {
//        if (iteration > 0) {returnValue += ", ";}
//        returnValue += "dta-" + embeddidIdField + "${" + compoundEntityPlusPK + "." + embeddidIdField + "}";
//  //    th:attr="data-pilotId=${flightCrewMember.flightCrewMemberPK.pilotId}, data-flightId=${flightCrewMember.flightCrewMemberPK.flightId}"
//        iteration++;
//      }
//    }
//    break;
    case COMPOUND_PK_PARAM_LIST:
    case COMPOUND_PK_PARAM_LIST_CHILD_ENTITY:
    {  
      String prefix = "";
      boolean isPrefixed = false;
      if (token.equals(COMPOUND_PK_PARAM_LIST_CHILD_ENTITY)) {
        isPrefixed = true;
        prefix = currentEntityMeta.getSimpleName().substring(0, 1).toLowerCase() + currentEntityMeta.getSimpleName().substring(1); 
      }
      //FlightCrewMember(tempFlight, pilot)
      returnValue = "(";
      iteration = 0;
      fieldNameInitCap = null;
      for (String embeddidIdFieldName: currentEntityMeta.getEmbeddedIdFieldIdentifiers()) {
        if (iteration > 0) {returnValue += ", ";}
//        embeddidIdFieldName = embeddidIdFieldName.substring(0,1).toLowerCase()+ embeddidIdRefClassName.substring(1);
        if (isPrefixed) {
          returnValue += prefix+embeddidIdFieldName.substring(0,1).toUpperCase()+embeddidIdFieldName.substring(1);
        }
        else {
          returnValue += embeddidIdFieldName;
        }
        iteration++;
      }
      returnValue += ")";
      break;
    }
    case COMPOUND_INSERT_PARAM_LIST_CHILD_ENTITY:
    {  
      String prefix = currentEntityMeta.getSimpleName().substring(0, 1).toLowerCase() + currentEntityMeta.getSimpleName().substring(1); 
      //FlightCrewMember(tempFlight, pilot)
      returnValue = "(";
      iteration = 0;
      fieldNameInitCap = null;
//      for (EntityMeta.FieldMeta embeddidIdField: currentEntityMeta.getEmbeddedIdFields()) {
      for (EntityMeta.FieldMeta field: currentEntityMeta.getFieldMetaArray()) {
        if (field.getName().equals(SERIAL_VERSION_UID)) continue;
        if (iteration > 0) {returnValue += ", ";}
        if (field.getType().getSimpleName().equals(drivingEntityMeta.getSimpleName())) {
          returnValue += field.getName(); // need to pre-pend entity var name plus getter() call
        }
        else
        {
//        returnValue += prefix+embeddidIdField.getName().substring(0,1).toUpperCase()+embeddidIdField.getName().substring(1);
          returnValue += prefix+field.getName().substring(0,1).toUpperCase()+field.getName().substring(1);
        }
        iteration++;
      }
      returnValue += ")";
      break;
    }
    case FIND_ONE_BY_PK_FK_CRITERIA: // Second most hard-coded case so far 2018.03.04
      //findOneByFlightAndPilot(flight, pilot);
      returnValue = "findOneBy";
      currentTableVarPrefix = currentEntityMeta.getSimpleName().substring(0, 1).toLowerCase()+currentEntityMeta.getSimpleName().substring(1);
      iteration = 0;
      fieldNameInitCap = null;
      for (String embeddidIdRefClassName: currentEntityMeta.getEmbeddedIdRefEntityIdentifiers()) {
        if (iteration > 0) {returnValue += "And";}
        returnValue += embeddidIdRefClassName;
        iteration++;
      }
      returnValue += "(";
      iteration = 0;
      embeddidIdRefClassNameInitSmall = null;
      for (String embeddidIdRefClassName: currentEntityMeta.getEmbeddedIdRefEntityIdentifiers()) {
        if (iteration > 0) {returnValue += ", ";}
        if (embeddidIdRefClassName == null) break;
        embeddidIdRefClassNameInitSmall = embeddidIdRefClassName.substring(0,1).toLowerCase()+ embeddidIdRefClassName.substring(1);
        returnValue += embeddidIdRefClassNameInitSmall;
        iteration++;
      }
      returnValue += ")";
      break;
    case FK_CHILD_EMBEDDED_PK:
      out.println("case FK_CHILD_EMBEDDED_PK");
    case FK_CHILD_EMBEDDED_PK_INIT_SMALL:
      out.println("case FK_CHILD_EMBEDDED_PK_INIT_SMALL");
      EntityMeta embeddedPK = currentEntityMeta.getEmbeddedPKInfo();
      if (embeddedPK != null) {
        returnValue = embeddedPK.getSimpleName();
      }
      if (returnValue!=null & token.equals(FK_CHILD_EMBEDDED_PK_INIT_SMALL)) {
        returnValue=returnValue.substring(0,1).toLowerCase() + returnValue.substring(1);
      }
      out.println("returnValue = " + returnValue);
      return returnValue;
    }
//    out.println ("returnValue = " + returnValue );
    return returnValue;
  }
  
  public String labelFormat(String input) {
    String label = "";
    String[] words = input.split("_| [A-Z]");
    for (int i=0; i<words.length; i++) {
      if (i>0) {label += " ";}
      label += words[i].substring(0, 1).toUpperCase() + words[i].substring(1).toLowerCase(); 
    }
    return label;
  }
  

  public TempEntityMeta getCollectionEnclosedEntityMeta (EntityMeta.FieldMeta testField) { 
    List<TempEntityMeta> collectionOfEntityMetaList = getCollectionEnclosedEntityMetas (testField, 1); 
    return (collectionOfEntityMetaList !=null?collectionOfEntityMetaList.get(0):null);
  }

  
  public List<TempEntityMeta> getCollectionEnclosedEntityMetas (EntityMeta.FieldMeta testField) { 
    return getCollectionEnclosedEntityMetas (testField, 99); 
   }
     
  public List<TempEntityMeta> getCollectionEnclosedEntityMetas (EntityMeta.FieldMeta testField, int limit) { // SHOULDN'T THIS BE MOVED TO CLASS EntityMeta??
   //out.println("getCollectionEnclosedClasses");
   if (!(testField.getType().getName().equals(DATATYPE_COLLECTION))) { return null; }
   List<TempEntityMeta> collectionOfEntityMetaList = new ArrayList<>();
   EntityMeta enclosedClassInfo;
   EntityMeta enclosedFKRefClassInfo;
   TempEntityMeta tempEntityMeta;
   TempEntityMeta tempEnclosedFKRefClassInfo;
//   Set<String> duplicateEntityMetaSet = new HashSet();
   boolean xReferenced = false;
//   if (testField.getType().getName().equals(DATATYPE_COLLECTION)) {
     out.println("isCollection() " + testField.getName());
     String collectionOfClassName = this.getEnclosedType(testField);
//     out.println("  collectionOfClassName = " + collectionOfClassName);
     try {
//       enclosedClassInfo = EntityMeta.getEntityMeta(MODEL_PACKAGE+"."+collectionOfClassName, ANNOTATION_ENTITY);
       enclosedClassInfo = EntityMetaFactoryImpl.entityMetaFactoryImplX.getEntityMeta(MODEL_PACKAGE+"."+collectionOfClassName);
       if (enclosedClassInfo == null) return null;
       tempEntityMeta = new TempEntityMeta(enclosedClassInfo);
//       duplicateEntityMetaSet.add(tempEntityMeta.getEntityMeta().getSimpleName());
       if (enclosedClassInfo.hasEmbeddedId()) {
         xReferenced = true;
       }
       tempEntityMeta.setXReferenced(xReferenced);
       collectionOfEntityMetaList.add(tempEntityMeta);
       if (limit == 1) return collectionOfEntityMetaList;
       EntityMeta.FieldMeta[] fields = enclosedClassInfo.getFieldMetaArray();
       enclosedFKRefClassInfo = null;
       for (EntityMeta.FieldMeta field: fields) {
         if (!isPrimitiveOrWrapper(field)) {
           out.println( "  FK Ref Field from child enclosed class = " + field.getResolvedIdentifier());
          out.println( "    FK Ref Field Type = " + field.getType().getName());
           enclosedFKRefClassInfo = EntityMetaFactoryImpl.entityMetaFactoryImplX.getEntityMeta(field.getType().getName(), ANNOTATION_ENTITY);
           if (enclosedFKRefClassInfo != null) {
//             if (duplicateEntityMetaSet.contains(enclosedFKRefClassInfo.getSimpleName())) continue;
//             duplicateEntityMetaSet.add(enclosedFKRefClassInfo.getSimpleName());
             tempEnclosedFKRefClassInfo = new TempEntityMeta(enclosedFKRefClassInfo);
             tempEnclosedFKRefClassInfo.setXReferenced(xReferenced); 
             tempEnclosedFKRefClassInfo.setThirdEntity(true); 
//             out.println( "    Adding " + enclosedFKRefClassInfo + " to collectionOfClassList... " );
//             collectionOfEntityMetaList.add(field.getType());
             collectionOfEntityMetaList.add(tempEnclosedFKRefClassInfo);
           } else {
             out.println("enclosedFKRefClassInfo = " + enclosedFKRefClassInfo);
             out.println( "    NOT Adding " + field.getType().getName() + " to collectionOfClassList... " );
           }
         }
       }
       if (collectionOfEntityMetaList != null) return collectionOfEntityMetaList;
       else return null;
       } catch (IOException e) {
         out.println("Sorry, IOException trying to load " + MODEL_PACKAGE+"."+collectionOfClassName);
       }
//       out.println("boolean getCollectionEnclosedClasses() to return true on field " + testField.getName() + ": collectionOfClass = " + collectionOfEntityMetaList);
//     } else return null;
     return null; // Dummy statement to satisfy compiler
   }

  public String getEnclosedType (EntityMeta.FieldMeta field) { // SHOULDN'T THIS BE MOVED TO CLASS EntityMeta??
     String fieldName = field.getName();
     String drivingEntityClassName = field.getDeclaringClassName();
//     out.println("getEnclosedType(" + fieldName + ")");
     fieldName = fieldName.substring(0,1).toUpperCase()+fieldName.substring(1);
//     out.println("  fieldName = " + fieldName );
//     out.println("  drivingEntityClassName = " + drivingEntityClassName );
     if (fieldName.indexOf(COLLECTION) > 1) {
       fieldName = fieldName.substring(0, fieldName.indexOf(COLLECTION));
     }
//     out.println("  fieldName = " + fieldName );
     String genericClassName = enclosedTypesMap.get(fieldName);
     if (genericClassName != null) return genericClassName;
     
     
//     Path file = Paths.get(PATH_TO_MODEL_JAVA_FILES, fieldName + ".java"); // HARD CODE ALERT!!!!!!!!!!!!!!!!!!!!!!
     Path file = Paths.get(PATH_TO_MODEL_JAVA_FILES, drivingEntityClassName +".java");
     String fileLine = null;
     int indexOfKeyword = -1;
     int indexEndKeyword = -1;
     int indexOfFieldName = -1;
     int indexOfOpenBracket = -1;
     int indexOfCloseBracket = -1;
     
     try (BufferedReader reader = Files.newBufferedReader(file)){
       while ((fileLine = reader.readLine())!=null) {
//         out.println("  fileLine = " + fileLine );
         indexOfFieldName = fileLine.indexOf(fieldName);
         if (indexOfFieldName >= 0) {
//           out.println("  indexOfFieldName = " + indexOfFieldName );
           
           indexOfKeyword = fileLine.indexOf(COLLECTION+"<");
           if (indexOfKeyword > 0) {
//             out.println("  indexOfKeyword = " + indexOfKeyword );
             indexEndKeyword =  indexOfKeyword + COLLECTION.length()+1;
//             if (indexEndKeyword > indexOfKeyword+1)
//               out.println("  indexEndKeyword = " + indexEndKeyword );
               indexOfOpenBracket  = fileLine.indexOf("<");
//               if (indexOfOpenBracket - indexEndKeyword == 1) {
//                 out.println("  indexOfOpenBracket = " + indexOfOpenBracket );
                 indexOfCloseBracket = fileLine.indexOf(">");
//                 if ((indexOfOpenBracket>=0) & (indexOfCloseBracket - indexOfOpenBracket > 1)) {
//                 if (indexOfCloseBracket - indexOfOpenBracket > 1) {
                 if ((indexOfCloseBracket - indexOfFieldName)  > 1) {
//                   out.println("  indexOfOpenBracket = " + indexOfOpenBracket );
//                   out.println("  indexOfCloseBracket = " + indexOfCloseBracket );
//                   genericClassName = fileLine.substring(indexOfFieldName, indexOfCloseBracket);
                   genericClassName = fileLine.substring(indexOfOpenBracket+1, indexOfCloseBracket);
//                   out.println("  genericClassName = " + genericClassName );
                   enclosedTypesMap.put(fieldName, genericClassName);
                   break;
                 }
               }
             }
//         }
       }
     }
     catch (IOException e){
       out.println("Sorry, could not read file " + file);
       return null;
     }
     return genericClassName;
   }
   
   public String getEmbeddedIdEntityFindStatements(EntityMeta entityMetaWithEmbeddedPK) {
     StringBuilder stringB = new StringBuilder("");
     for (EntityMeta.FieldMeta field: entityMetaWithEmbeddedPK.getEmbeddedIdFields()) {
//       stringB.append(field.getDeclaringClassName())
     }
      return null;
   }
   
  
 }


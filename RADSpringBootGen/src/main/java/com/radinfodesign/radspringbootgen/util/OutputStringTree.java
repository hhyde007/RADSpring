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

import java.io.IOException;
import java.util.Collection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import com.radinfodesign.radspringbootgen.fboace.model.Flight;
import com.radinfodesign.radspringbootgen.util.EntityMeta.FieldMeta;

/**
 * Input tree transformed into Output tree
 * <br> by way of template txt file transformed by relational metadata
 * implicit in model entity class definitions and annotations plus some metadata
 * read from database into resulting output tree, to be written to output files. 
 * <br><strong>This is the largest class in the RADSpringBoot framework</strong>, the one where the bulk of the code generation occurs.
 * <br> Most of the public constants are the tokens that may be used in template 
 * files to give an instruction about what elements to iterate over and/or what to substitute at that place in the code.
 * <br>The values of these token constants are the same as their names.
 * <br>Constants named "ACT_*" indicate instruction to ACT upon/iterate over various elements 
 * of table/EntityMeta or column/attribute/FieldMeta; equivalent to a "for each" tag.
 * These are the potentially multivalued elements; tokens that may nest other tokens within them.
 * <br>  
 * @see <a href="https://github.com/hhyde007/RADSpringBootGen/blob/master/RADSpringBootGen/doc/RADSpringBootGen-Doc.docx" target="_blank">See the detailed technical documentation</a>
 * for a comprehensive explanation of the templates, literal/verbatim text, simple and nested expression tokens and their uses.
 * Refer to the individual comments on each member for quick reference. 
 * Their semantics range from the simple and obvious to increasingly complex to criminally hard-coded kludges unfit for a self-respecting template system.
 * <br>Finally, search for a token value in one of the templates and see how it is resolved in the corresponding output file. 
 */
public class OutputStringTree extends IOStringTree {
// Constants named "ACT_*" indicate instruction to 
//           ACT upon various elements of table/EntityMeta or column/attribute/FieldMeta;
//           These are potentially multivalued elements; tokens that may nest other tokens within them.
  
//  The token values, their meanings, naming conventions and consequent code generation actions are based on the following requirements:
//    • Relational/Referential modeling (refer again to the data model diagram)
//    o Entities
//      •  "Driving" or main entities, like Flight for the Flight module/stack
//      •  "REF" entities; entities referenced from the driving entity, like Airport and/or Aircraft from Flight
//      •  Child/FK entities; those representing tables referencing the driving table via foreign keys, like FlightCrewMember.
//    • Child/FK entities with simple primary key identifiers, as Aircraft is to AircraftType.
//    • Child/FK entities with compound/multivalued primary key identifiers, as FlightCrewMember and PilotCertification are to Pilot.
//      •  "Third" entities; entities referenced by child entities. Pilot and Flight are third entities to each other, via FlightCrewMember; Aircraft Type is a third entity to Pilot, via PilotCertification.
//    o Entity Attributes (of any and all of the above entities)
//      •  Identifiers/keys
//    • Simple, single-valued identifiers, indicated by the @Id annotation in the model entity class
//    • Compound, multivalued identifiers (the current version of RADSpringBootGen supports a maximum of 2), indicated by the @EmbeddeId annotation in the model entity class
//      •  Simple, Non-key, Non-Collection/Non-multivalued attributes
//    • (Local)Date/Datetime vs. NON-Date/Datetime attributes (code to manage attributes of temporal types is radically different than that for simple primitives or wrapper classes like int, Integer and String.)
//      •  Attributes which are single-valued references to other ("REF") entities, for example Flight.aircraftId.
//      •  Attributes which are potentially multivalued list/collection references to child and/or "Third" entities, for example Flight.flightCrewMemberCollection.
//      •  Attributes that may be exposed to the user (internal keys are NOT)
//    • Java element naming conventions
//    o Verbatim: Identifiers rendered just as they are in the model entity class code, without modification to case.
//    o UPPER/lower/InitCaps/InitSmall: Transforming a code element by modifications to case. For example, to construct variable names to represent attributes of a child entity, we concatenate the child entity name to the child entity attribute name, rendering the initial letter of the former in lower case (contrary to what it normally is) and the initial letter of the latter in UPPER case (also contrary). Recall the earlier passage:
//    PilotService.java
//          , String[] pilotCertificationCertificationNumbers
//          , String[] pilotCertificationValidFromDates
//          , String[] pilotCertificationExpirationDates
//          , String[] pilotCertificationNotess
//          , Integer[] pilotCertificationAircraftTypeIds
//          , String[] flightCrewMemberNotess
//          , Integer[] flightCrewMemberFlightIds
//    Those lines result from the template segment
//             {${ACT_FK_CHILD_ENTITY_ATTRIBS=, {${ENTITY_ATTRIB_DEFAULT_DATATYPE}$}[] {${FK_CHILD_ENTITY_INIT_SMALL}$}{${ENTITY_ATTRIB_INITCAPS}$}s
//          }$}
//

  
//   If you have doubts about any particular token, search for it in the internal methods of this class 
//     and in the sample templates, see how it is used and what results from it.
//   Note: Most of the descriptions below may be prepended with 
//        "Token indicating logic applying to ..."
  
  /**
   *  Non-key, non-collection attributes
   */
  public static final String ACT_ALL_ATTRIBS = "ACT_ALL_ATTRIBS"; 
  
  /**
   *  Attributes permissible to expose to user interface (excludes keys, key components, child collections etc.)
   *  Most often encloses ENTITY_ATTRIB_LABEL 
   */
  public static final String ACT_UI_ATTRIBS = "ACT_UI_ATTRIBS"; 
  
  /**
   *  Simple attributes (non-temporal primitives and wrapper types like Integer, String etc.)
   */
  public static final String ACT_SIMPLE_ATTRIBS = "ACT_SIMPLE_ATTRIBS";  
  
  /**
   *  Date- (LocalDate) type attributes
   */
  public static final String ACT_DATE_ATTRIBS = "ACT_DATE_ATTRIBS"; 

  /**
   *  DateTime- (LocalDateTime) type attributes
   */
  public static final String ACT_DATE_TIME_ATTRIBS = "ACT_DATE_TIME_ATTRIBS";
  
  /**
   *  Foreign key-referenced entities
   *  <br>Eliminates duplicate/redundant entries for the same referenced entity class
   *  <br>Good for things like import statements and declarations of @Autowired services
   *  <br>Example: On flight, will return Aircraft and Airport,
   *  only once each even though Airport is referenced twice from Flight. 
   */
  public static final String ACT_FK_REF_ENTITIES = "ACT_FK_REF_ENTITIES"; 
  
  /** Attributes representing pointers to FK-referenced entities, 
   *   without elimination of duplicate foreign entities.
   *   <br>For example on the Flight entity, this will return both airportIdDeparture and airportIdDestination.
   * 
   */
  public static final String ACT_FK_REF_ATTRIBS = "ACT_FK_REF_ATTRIBS"; 
  
  /**
   * Non-temporal (non-LocalDate or LocalDateTimeTime) attributes
   */ 
  public static final String ACT_NON_TEMPORAL_ATTRIBS = "ACT_NON_TEMPORAL_ATTRIBS"; 
  
  /**
   *  Attributes that ARE members of the primary key (@Id or @EmbeddedId)
   */
  public static final String ACT_PK_ATTRIBS = "ACT_PK_ATTRIBS"; 
 
  /** Attributes that ARE members of the primary key (@Id or @EmbeddedId),
   *  separated by commas in the case of compound key
   */  
  public static final String ACT_PK_ATTRIBS_COMMA_SEPARATED = "ACT_PK_ATTRIBS_COMMA_SEPARATED"; 
  
  /**
   * Suffix to differentiate from W_COMPOUND_KEYS
   */
  public static final String W_SIMPLE_KEYS = "W_SIMPLE_KEYS"; 
  
  /** Child entities with single-column/attribute primary key identifiers annotated with @Id; 
   *   entities that reference the current driving entity via foreign keys
  */
  public static final String ACT_FK_CHILD_ENTITIES_W_SIMPLE_KEYS = "ACT_FK_CHILD_ENTITIES_W_SIMPLE_KEYS"; 

  /**
   * Suffix indicating include child elements even if model entity is annotated with @ExcludeEditFromParentModule
   * Sometimes you want to exclude some child entity elements from some modules but not others.
   * <br>In the Flight module, you want both editable fields and navigation links for FlightCrewMember.
   * But for the Airport and Aircraft modules you might not want to edit the child Flight records 
   * on the same form as the parent edit form, but you still might want to list the child Flight records
   * and provide navigation links to them.  
   * <br>To accomodate these flexible needs, we have the tokens ACT_FK_CHILD_ENTITIES 
   * and ACT_FK_CHILD_ENTITIES_W_SIMPLE_KEYS_FORCE_INCLUDE, and the annotation @ExcludeEditFromParentModule
   * <br>To include all child elements in a module, use ACT_FK_CHILD_ENTITIES without the annotation.
   * <br>To indicate that child elements should not be included for some entities, 
   * annotate the child collection attribute, the one also annotated with @OneToMany(mappedBy = ...),
   * with @ExcludeEditFromParentModule
   * <br>To indicate that child elements should be included even if the @ExcludeEditFromParentModule
   * annotation is present (for example to included read-only child navigation links without editable controls,
   * use the token ACT_FK_CHILD_ENTITIES_W_SIMPLE_KEYS_FORCE_INCLUDE. 
   */
  public static final String FORCE_INCLUDE = "FORCE_INCLUDE";
  
  /**
   * ACT_FK_CHILD_ENTITIES_W_SIMPLE_KEYS_FORCE_INCLUDE is the same as ACT_FK_CHILD_ENTITIES_W_SIMPLE_KEYS EXCEPT:
   * <br>Will include even if model entity is annotated with @ExcludeEditFromParentModule
   * <br>Put another way, annotate your entities with @ExcludeEditFromParentModule and use ACT_FK_CHILD_ENTITIES
   * if you don't want them included as editable children in their parent entity's module.
   * <br>Note also that this means that in your template, some code blocks may be exclusive of other code blocks;
   * That is, some code is intended to be generated in the case of no annotation, and other code is intended
   * to be generated in the case of the annotation @ExcludeEditFromParentModule. 
   * <br>See the sample Edit.html.template.txt for examples of this.
   */
  public static final String ACT_FK_CHILD_ENTITIES_W_SIMPLE_KEYS_FORCE_INCLUDE = "ACT_FK_CHILD_ENTITIES_W_SIMPLE_KEYS_FORCE_INCLUDE";   
  
  /**
   * Suffix to differentiate from W_SIMPLE_KEYS
   */
  public static final String W_COMPOUND_KEYS = "W_COMPOUND_KEYS";
  
  /** Child entities that have compound/multivalued primary keys (@EmbeddedId), 
   *  one component being inherited from the Driving Entity
  */
  public static final String ACT_FK_CHILD_ENTITIES_W_COMPOUND_KEYS = "ACT_FK_CHILD_ENTITIES_W_COMPOUND_KEYS";  

  /** Child entities that have compound/multivalued primary keys (@EmbeddedId), 
   *  one component being inherited from the Driving Entity.
   *  <br> Include even if model entity is annotated with @ExcludeEditFromParentModule.
  */
  public static final String ACT_FK_CHILD_ENTITIES_W_COMPOUND_KEYS_FORCE_INCLUDE = "ACT_FK_CHILD_ENTITIES_W_COMPOUND_KEYS_FORCE_INCLUDE";  

  /**
   *   Child entities and entities referenced by child entities, excluding the driving entity.
   */
  public static final String ACT_FK_CHILD_AND_THIRD_ENTITIES = "ACT_FK_CHILD_AND_THIRD_ENTITIES";  
  
  /**
   *  Child entities with compound primary keys, plus any third entities referenced by the same.
   */
  public static final String ACT_FK_CHILD_W_COMPOUND_KEYS_AND_THIRD_ENTITIES = "ACT_FK_CHILD_W_COMPOUND_KEYS_AND_THIRD_ENTITIES";  

  /**
   *  Only "Third" entities; entities besides the driving one referenced by child entities that have compound primary keys.
   */
  public static final String ACT_THIRD_ENTITIES_ONLY = "ACT_THIRD_ENTITIES_ONLY";  

  //final String ACT_THIRD_ENTITIES = "ACT_THIRD_ENTITIES"; // REMOVED FROM SERVICE
  
  /** Similar to ACT_THIRD_ENTITIES_ONLY, BUT... 
  * <br>Used while nested within ACT_FK_CHILD_ENTITIES_W_COMPOUND_KEYS.
  * <br>In that context, returns all entities referenced by that child entity.
  * <br>Note that primary attributes of the child entity are still available.
  * So for example in an HTML UI form, a row representing a child entity 
  *   of the driving entity which also references a third entity,
  *   may provide a navigation link to the third entity and also a Delete button for the child entity.
  *   <br>See Edit.html.template.txt
  */
  public static final String ACT_OTHER_REF_ENTITIES = "ACT_OTHER_REF_ENTITIES";  
  
  /**
   *  Attributes of child entities, excluding those referencing the driving entity (for now; how to handle multiple references? Future bug?)
   */
  public static final String ACT_FK_CHILD_ENTITY_ATTRIBS = "ACT_FK_CHILD_ENTITY_ATTRIBS";  
  
  /**
   *  Attributes of child entities that have compound primary keys (presumably inheriting one member from the present driving entity).
   */
  public static final String ACT_FK_CHILD_ENTITY_W_COMPOUND_KEY_ATTRIBS = "ACT_FK_CHILD_ENTITY_W_COMPOUND_KEY_ATTRIBS";   
  
//  /**
//   * Iterate over the field names of the @EmbeddedID/compound primary key, assuming it exists
//   */
//  public static final String ACT_EMBEDDED_ID_FIELDS = "ACT_EMBEDDED_ID_FIELDS";   
  
  /**
   * Name of Entity class referenced by a foreign key from the Driving entity
   */
  public static final String FK_REF_ENTITY = "FK_REF_ENTITY"; 
  
  /**
   * Identifier of Entity class referenced by foreign key, filtered by some qualifying condition
   * <br> This "feature" has not been fully developed and tested yet. The intention is to filter lists
   * like drop-down list boxes/HTML SELECTs to "permissible" choices to reference in a given context.
   */
  public static final String FK_REF_ENTITY_QUALIFIED = "FK_REF_ENTITY_QUALIFIED";
  
  /**
   * Qualified identifier of Entity class that is a child of the primary
   */
  public static final String FK_CHILD_ENTITY_QUALIFIED = "FK_CHILD_ENTITY_QUALIFIED"; 

  /**
   * Primary key ID field of Entity class referenced by foreign key
   */
  public static final String FK_REF_ENTITY_ID = "FK_REF_ENTITY_ID";
  
  /**
   * Primary key ID field of Entity class referenced by foreign key, with InitalCapital letter.
   */
  public static final String FK_REF_ENTITY_ID_INIT_CAP = "FK_REF_ENTITY_ID_INIT_CAP";
  
  /**
   * Name of Entity class referenced by foreign key, with initial lower-case letter.
   */
  public static final String FK_REF_ENTITY_INIT_SMALL = "FK_REF_ENTITY_INIT_SMALL";
  
//  /**
//   * Name of child Entity class in lowercase
//   */
//  public static final String FK_REF_ENTITY_LOWER = "FK_REF_ENTITY_LOWER"; 

  /**
   * Name given to reference to collection of Entity class that is a child of the Driving entity, in context of parent
   * <br>For example, in the Demo app FBOAce, Pilot has pilotCertificationCollection and flightCrewMemberCollection. 
   */
  public static final String FK_CHILD_ENTITY_IDENTIFIER = "FK_CHILD_ENTITY_IDENTIFIER";
  /**
   * Name of Entity class that is a child of the primary
   */
  public static final String FK_CHILD_ENTITY = "FK_CHILD_ENTITY"; 
  
  /**
   * Name of child entity class, with inital lower-case letter
   */
  public static final String FK_CHILD_ENTITY_INIT_SMALL = "FK_CHILD_ENTITY_INIT_SMALL"; 
  
  /**
   * Name of child entity class, in all lower-case letters
   */
  public static final String FK_CHILD_ENTITY_LOWER = "FK_CHILD_ENTITY_LOWER"; 
  
  /**
   * Name of child entity class, in all UPPERCASE letters
   */
  public static final String FK_CHILD_ENTITY_UPPER = "FK_CHILD_ENTITY_UPPER";
  
  /**
   * lowercase plural name of child entity class
   */
  public static final String FK_CHILD_ENTITY_LOWER_PLURAL = "FK_CHILD_ENTITY_LOWER_PLURAL";  
  
  /**
   * UPPERCASE name of child entity class
   */
  public static final String FK_CHILD_ENTITY_UPPER_PLURAL = "FK_CHILD_ENTITY_UPPER_PLURAL";
  
  /**
   * Business-friendly version of the child entity name, typically the initcap of the class name.
   * <br>Labels can be specified using this framework's @Label annotation on the entity or one of its attributes.
   * <br>By default, RADSpringBootGen will parse table column names, and if an underscore is encountered, 
   * a space will replace it and the next letter will be rendered in Upper case.  Thus, the table column 
   * DEPARTURE_DATE_TIME is rendered as "Departure Date Time".
   */
  public static final String FK_CHILD_ENTITY_LABEL = "FK_CHILD_ENTITY_LABEL"; 
  
  /**
   * Name of the child member variable annotated with @EmbeddedId annotation to represent a multivalued 
   * identifier, with initial small letter guaranteed.
   * <br>For example, the PILOT_CERTIFICATION table has a primary key consisting of PILOT_ID, 
   * which is also the foreign key to the PILOT table, and AIRCRAFT_TYPE_ID, which is the FK
   * to the AIRCRAFT_TYPE table. This compound primary key is represented in Java as its own class
   * PilotCertificationPK, which has the two corresponding member attributes. An instance of PilotCertificationPK
   * is declared in the PilotCertification class with the annotation @EmbeddedId.
   * <br>This might be needed in an HTML form, for example 
   * ${{${FK_CHILD_ENTITY_INIT_SMALL}$}.{${FK_CHILD_EMBEDDED_ID_INIT_SMALL}$}.{${FK_REF_ENTITY_ID}$}}
   * being transformed into ${pilotCertification.pilotCertificationPK.aircraftTypeId}.
   */
  public static final String FK_CHILD_EMBEDDED_ID_INIT_SMALL = "FK_CHILD_EMBEDDED_ID_INIT_SMALL";  

//  public static final String FK_CHILD_EMBEDDED_PK = "FK_CHILD_EMBEDDED_PK"; // Child Entity Embedded PK object.  
//  public static final String FK_CHILD_EMBEDDED_PK_INIT_SMALL = "FK_CHILD_EMBEDDED_PK_INIT_SMALL"; // Child Entity Embedded PK object in initial lowercase.  

  /**
   * Name of single primary key/ID field for entities other than the Driving entity, such as child entities
   */
  public static final String PK_ID_FIELD = "PK_ID_FIELD";  

  /**
   * Name of single primary key/ID field for entities other than the Driving entity, with InitialCapital letter.
   */
  public static final String PK_ID_FIELD_INIT_CAP = "PK_ID_FIELD_INIT_CAP";
  
  /**
   * Aka "Third Entity"
   * <br>Name of an other entity referenced by a child entity,
   * which child entity inherits compound primary key components from the Driving entity and the Third entity. 
   */
  public static final String PK_FK_REF_ENTITY = "PK_FK_REF_ENTITY";  
  
  /**
   * Same as PK_FK_REF_ENTITY but with initial lowercase letter.
   */
  public static final String PK_FK_REF_ENTITY_INIT_SMALL = "PK_FK_REF_ENTITY_INIT_SMALL";   
  
  /**
   * HARD-WIRED KLUDGE for the ServiceImpl class delete-child-having-compound-key method.
   * Needs work to make it more generic; too much content that should be literal text in the template
   * is wired into the Java method that processes this token. 
   * Too many, too narrow assumptions. But it works. 
   * <br> Needs to get an instance of the entities referenced by the child entity,
   * including the driving entity and the third entity, via calls to their respective Repository services.
   * See the sample app methods FlightServiceImpl.deleteFlightCrewMember(), 
   * PilotServiceImpl.deleteFlightCrewMember(), PilotServiceImpl.deletePilotCertification(), and
   * AircraftTypeServiceImpl.deletePilotCertification().    
   */
  public static final String PK_FK_REF_ENTITIES_DECLARE_REPOSITORY_FIND = "PK_FK_REF_ENTITIES_DECLARE_REPOSITORY_FIND"; // Complete multiple declarations and initializations of Entities referenced by embedded PK object by call to repository.findOne()

  /**
   * Express a call to a custom Repository find() method on a child entity a having compound primary key/@Embedded id,
   * which find method takes takes two parent entities as its arguments.
   * <br>For example, the Demo app PilotCertificationRepository class (hand-written, not yet generated) declares a method:
   * <br>PilotCertification findOneByPilotAndAircraftType(Pilot pilot, AircraftType aircraftType);
   * <br>Therefore to call it requires something like 
   * <br>findOneByPilotAndAircraftType(pilot, aircraftType);
   * <br>Note that whether this is called from the Pilot module or the AircraftType module, the parameters are given in the same, correct order.
   */
  public static final String FIND_ONE_BY_PK_FK_CRITERIA = "FIND_ONE_BY_PK_FK_CRITERIA";
  
  /**
   * Express a call to the constructor of an entity having a compound primary key/@EmbeddedId, which constructor
   * takes instances of its parent entities as arguments.
   * <br>Note that regardless of which parent module is calling this constructor, the order of parameters is the same and correct.
   */
  public static final String CALL_COMPOUND_CONSTRUCTOR = "CALL_COMPOUND_CONSTRUCTOR"; 
  
//  DEPRECATED; Hard-coded kludge for Edit.html.template.txt no longer necessary          
//  public static final String GET_TH_HTML_FORM_DATA_VARS = "GET_TH_HTML_FORM_DATA_VARS"; 

  /**
   * Comma-separated list of primary key/ID fields.
   * If single-column PK, this is equivalent to PK_ID_FIELD; returns with no comma or space
   */
  public static final String PK_ID_ATTRIB_LIST = "PK_ID_ATTRIB_LIST";  

  // DEPRECATED
  //public static final String COMPOUND_INSERT_PARAM_LIST_CHILD_ENTITY = "COMPOUND_INSERT_PARAM_LIST_CHILD_ENTITY"; 
  
  /**
   * Name of the first required/not nullable non-key field in the current entity.
   * <br>This is useful for testing whether a set of entity attribute variables missing a real database primary key value 
   * represent a real business entity instance to be persisted, or a blank record to be discarded and/or ignored. 
   * It is used as such by the ServiceImpl class to interpret variables passed from an Edit html submit form 
   * through the web controller to the service for interpretation and processing. 
   */
  public static final String FIRST_NON_KEY_REQUIRED_ATTRIB = "FIRST_NON_KEY_REQUIRED_ATTRIB";
  
  /**
   * Name of the first required non-key field, with initial capital letter
   */
  public static final String FIRST_NON_KEY_REQUIRED_ATTRIB_INIT_CAP = "FIRST_NON_KEY_REQUIRED_ATTRIB_INIT_CAP"; 

  /**
   *  Returns the mappedBy attribute value of the @OneToMany annotation 
   *    of a child entity collection attribute, for example 
   *    <br>  private Collection<Flight> flightDepartureCollection;
   *    <br> in Airport.
   *  Which is to say, given a driving entity and one of its child entities, 
   *    returns the attribute name of the child entity by which it references the parent. 
   *  This is needed because a child entity may reference the same parent entity more than once
   *  and by different names, for example Flight.AirportDeparture and Flight.AirportDestination.
  */
  public static final String MODEL_ENTITY_MAPPED_REF_ATTRIB = "MODEL_ENTITY_MAPPED_REF_ATTRIB"; 
  public static final String MODEL_ENTITY_MAPPED_REF_ATTRIB_INIT_CAP = "MODEL_ENTITY_MAPPED_REF_ATTRIB_INIT_CAP";
  
  /*
   * DEPRECATED: Name of Entity member attribute representing class referenced by foreign key?
   */
  //public static final String FK_REF_ATTRIB_NAME = "FK_REF_ATTRIB_NAME"; 
  
  /**
   * Virtual attribute name representing a foreign key-referenced entity, derived from the FK column name.
   * <br>For example, The Flight table has a foreign key to Aircraft, implemented with the column Aircraft_ID
   *   which references the Aircraft table's primary key column Aircraft_ID.
   *   <br>The Flight Java data model entity class represents this relationship with an attribute of the type
   *   Aircraft. But for purposes of passing identifying references of the Aircraft to from the data layer
   *   to the UI layer and back, it is convenient to revert to the integer AIRCRAFT_ID value, and to refer
   *   to it by the name aircraftId in Service interfaces, ServiceImpl and Controller classes, and Edit.html code.  
   *   <br>For this reason, the Flight entity (again, as an example) has a getAircraftId() method (though no
   *   setAircraftId) and there is the need to insert "aircraftId" into the code at strategic points related to Flight.
   *   <br>That is what FK_REF_ENTITY_IDENTIFIER accomplishes.
   * <br>Note one more twist: In the above example, the attribute in the referencING entity/table and in the
   *   referencED entity/table have the same name. But that is not required, and in fact it is necessary 
   *   that they should have different names when there is more than one foreign key reference from the 
   *   child to parent entity/table, as is the case with Flight and Airport. There is one reference in the 
   *   role of Departure, and a second in the role of Destination. The Flight attributes (of type Airport) 
   *   are named airportDeparture and airportDestination. The numeric column names in the Flight table are 
   *   AIRPORT_ID_DEPARTURE and AIRPORT_ID_DESTINATION. The derived/virtual Java and HTML identifiers are 
   *   airportIdDeparture and airportIdDestination; and those are what get inserted into code generated 
   *   from this framework by the token FK_REF_ENTITY_IDENTIFIER.
   */
  public static final String FK_REF_ENTITY_IDENTIFIER = "FK_REF_ENTITY_IDENTIFIER";
  
  /**
   * Name of Entity member attribute representing class referenced by foreign key, with Initial Capital
   * See notes for FK_REF_ENTITY_IDENTIFIER. Whereas that one returns an identifier derived from the 
   * database foreign key column name, this one returns the original reference attribute name, 
   * except with an initial capital letter.
   * For example again using Flight as the example, iterating over the model entity class-reference (as opposed to simple 
   * String, numeric or Date/time) attributes, this token returns "Aircraft" for aircraft, 
   * "AirportDeparture" for airportDeparture, and "AirportDestination" for airportDestination. 
   */
  public static final String FK_REF_ATTRIB_INITCAPS = "FK_REF_ATTRIB_INITCAPS"; 
  
  /*
   * DEPRECATED: Lowercase plural name of entity class referenced by foreign key, suitable as reference variable name
   */
  //public static final String FK_REF_ENTITY_LOWER_PLURAL = "FK_REF_ENTITY_LOWER_PLURAL"; 
  
  /**
   * UPPERCASE plural name of entity class referenced by foreign key
   * <br>This is useful for declarations and usages of String constants in UPPER_CASE 
   * representing referenced model entity classes.
   */
  public static final String FK_REF_ENTITY_UPPER_PLURAL = "FK_REF_ENTITY_UPPER_PLURAL"; 
  
  /**
   * Upper-case underscore-separated name of entity attribute (table column)
   * <br>This is useful for declarations and usages of String constants in UPPER_CASE 
   * representing attributes of referenced model entity classes.
   */
  public static final String ENTITY_ATTRIB_UPPER_NAME = "ENTITY_ATTRIB_UPPER_NAME"; 
  
  /**
   * Name of the model entity attribute, unmodified as to case.
   */
  public static final String ENTITY_ATTRIB_NAME = "ENTITY_ATTRIB_NAME";
  
  /**
   * Entity attribute formatted as a user-friendly label
   * First looks for @Label annotation on model entity attribute;
   * if none found, attempts to construct one from the attribute name.
   */
  public static final String ENTITY_ATTRIB_LABEL = "ENTITY_ATTRIB_LABEL";
  
  /**
   * Entity attribute default datatype
   * <br>Used for HTML parameters prior to parsing/conversion to richer datatypes,
   * or to lookup instances of other classes. 
   * <br>Non-primitive non-wrappers (entity classes) return "Integer"; Dates return "String"
   */
  public static final String ENTITY_ATTRIB_DEFAULT_DATATYPE = "ENTITY_ATTRIB_DEFAULT_DATATYPE"; 
  
  /**
   * Entity attribute name with initial capital letter
   * <br>Use for example in construction of variable name representing entity attribute
   * where a prefix (such as the name of the entity) compels the upper case conversion.
   */
  public static final String ENTITY_ATTRIB_INITCAPS = "ENTITY_ATTRIB_INITCAPS";
  
  /*
   * DEPRECATED: Date-type attribute name
   */
//  public static final String ENTITY_DATE_ATTRIB_NAME = "ENTITY_DATE_ATTRIB_NAME"; // 
  
  /*
   * DEPRECATED: Datetime-type attribute name 
   */
//  public static final String ENTITY_DATE_TIME_ATTRIB_NAME = "ENTITY_DATE_TIME_ATTRIB_NAME";
  
  /*
   * DEPRECATED: Date type attribute name, initial capital letter
   */
  //public static final String ENTITY_DATE_ATTRIB_INITCAPS = "ENTITY_DATE_ATTRIB_INITCAPS"; // Date type attribute name
  
  /*
   * DEPRECATED: Datetime type attribute name
   */
//  public static final String ENTITY_DATE_TIME_ATTRIB_INITCAPS = "ENTITY_DATE_TIME_ATTRIB_INITCAPS";

  /*
   * DEPRECATED FOR NON-USE
   */
  //public static final String MODEL_ADD_CHILD_ENTITY_RPSTRY_ATTRIB = "MODEL_ADD_CHILD_ENTITY_RPSTRY_ATTRIB"; 
    
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
  public static final String ANNOTATION_COLUMN = "@Column";
  public static final String ANNOTATION_ENTITY = "@Entity";
  public static final String MODEL_PACKAGE = "com.radinfodesign.radspringbootgen.fboace.model"; // HARD-CODE ALERT!
  public static final String PATH_TO_MODEL_JAVA_FILES = "com/radinfodesign/radspringbootgen/fboace/model/"; // HARD-CODE ALERT!

  public static final String JAVA_TIME_LOCAL_DATE = "java.time.LocalDate";
  public static final String JAVA_TIME_LOCAL_DATETIME = "java.time.LocalDateTime";
  public static final String JAVA_PACKAGE = "java."; 

  protected InputStringTree inputStringTree;
  static Map<String, String> enclosedTypesMap = new HashMap<>(); // REVISIT THIS
  
  
  private OutputStringTree (InputStringTree inputStringTree) {
    super(inputStringTree.getTopNode().getValue());
    this.inputStringTree = inputStringTree;
  }
  
  protected Map<String, String> getTokenMap() {
    return this.inputStringTree.getTokenMap();
  }
  
  private static Map<InputStringTree, OutputStringTree> outputStringTreeMap = new HashMap<>();
  
  /**
   * 
   * @param inputStringTree Input tree; hierarchy of text elements based on a parse of a template txt file,
   * segregating nodes of literal text from those of nested and single-valued expression tokens.
   * @return the tree of StringNodes fully generated and built out based on the input tree, 
   * its template text and its implicit relational metadata. 
   */
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
  
  public static boolean isPrimitiveOrWrapper (Class testClass) { // DEPRECATED? USE EntityMeta methods instead
    if (testClass.getName().indexOf(".") < 0 ) return true;
    if (testClass.getName().startsWith(JAVA_PACKAGE)) return true;
    else return false;
  }

//  public static boolean isPrimitiveOrWrapper (EntityMeta.FieldMeta testField){ // DEPRECATED? USE EntityMeta METHODS INSTEAD
//    if (testField.getType().getName().indexOf(EntityMeta.PERIOD) < 0 ) return true;
//    if (testField.getType().getName().startsWith(JAVA_PACKAGE)) return true;
//    else return false;
//  }
     
  protected static boolean isLocalDate (EntityMeta.FieldMeta testField){
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
  
  
  /**
   * Entry point to generate output file from input template and model entity metadata
   */
  @Override
  public void build() {
    this.build( this.getInputStringTree().getTopNode()
              , this.getTopNode()
              , this.getInputStringTree().getDrivingEntityMeta()
              , null
              , this.getInputStringTree().getDrivingEntityMeta()
              );
    this.built = true;
  }
    
  
  /**
   * Overload to call when currently operating at the entity/table level
   * or a field/attribute of the driving entity.
   * @param inputNode
   * @param outputNode
   * @param drivingEntityMeta
   * @param drivingEntityMetaField
   * @param currentEntityMeta
  */
  protected void build ( StringNode inputNode
                       , StringNode outputNode
                       , EntityMeta drivingEntityMeta
                       , FieldMeta drivingEntityMetaField
                       , EntityMeta currentEntityMeta
//                     , boolean childOfMultiToken
                     ) {
//    out.println("build[EntityMeta] " + inputNode.getValue());
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
      tokenValue = getTokenMap().get(inputNode.getTokenKey());
      if (tokenValue==null) {
        tokenValue = getAttributeAttribute (drivingEntityMeta, drivingEntityMetaField, currentEntityMeta, inputNode.getTokenKey());
      }
//      out.println("addNode( (inputNode.isSingleTokenExpression() ): " + (tokenValue!=null?tokenValue:inputNode.getValue()));
      nextOutputNode = this.addNode(tokenValue!=null?tokenValue:inputNode.getValue(), outputNode);
    }
    else if (inputNode.isMultiTokenExpression()) {
//      out.println("tokenInstruction = :");
     // Next look for potentially multivalued instructions    
      String tokenInstruction = inputNode.getTokenInstruction();
        buildMultivaluedExpression ( inputNode
                                   , outputNode
                                   , drivingEntityMeta
                                   , currentEntityMeta
                                   );
      return; 
    }
    // Note that the first call on the Top Node, NONE of the above conditions are true 
    //   and processing falls to the recursive call on the child nodes.
    for (StringNode childNode: childNodes) {
      this.build(childNode, nextOutputNode, drivingEntityMeta, null, currentEntityMeta);
    }
    return; // outputFileTree;
  }  
  
  /** 
   * Overload to call when operating at the level of a field/attribute of a child entity(?)
   * @param inputNode
   * @param outputNode
   * @param drivingEntityMeta
   * @param currentEntityMeta
   * @param currentField
   */
  protected void build ( StringNode inputNode
                       , StringNode outputNode
                       , EntityMeta drivingEntityMeta
                       , EntityMeta currentEntityMeta
                       , FieldMeta currentField // Difference
                       ) {
//    out.println("OutputStringTree.build[FieldMeta] " + currentEntityMeta.getSimpleName()+"."+currentField.getName());
    StringNode nextOutputNode = null;
    String tokenValue = null;
    String tokenInstruction = null;
    
    if (inputNode.isLiteralExpression()) {
      nextOutputNode = this.addNode(inputNode.getValue(), outputNode);
    }
    if (inputNode.isSingleTokenExpression()) {
      tokenValue = getTokenMap().get(inputNode.getTokenKey());
      if (tokenValue==null) {
        tokenValue = getAttributeAttribute (drivingEntityMeta, currentEntityMeta, currentField, inputNode.getTokenKey());
      }
      nextOutputNode = this.addNode(tokenValue!=null?tokenValue:inputNode.getValue(), outputNode);
    }
    return; 
  }  
  
  
  private void buildMultivaluedExpression ( StringNode inputNode
                                          , StringNode outputNode
                                          , EntityMeta drivingEntityMeta
                                          , EntityMeta currentEntityMeta
  //                                        , String tokenInstruction
                                          ) {
//    out.println("");
//    out.println("****************************");
//  out.println("buildMultivaluedExpression (" + inputNode.getValue() + ")");
//  out.println("buildMultivaluedExpression currentEntityMeta = " + currentEntityMeta.getSimpleName());
//    Annotation[] fieldAnnotations = null;
    TempEntityMeta collectionOfEntityMeta = null; // Representation of Child table records encapsulated in a Collection attribute of the main driving entity EntityMeta object
    List<TempEntityMeta> collectionOfEntityMetas = null;
    FieldMeta[] fields = currentEntityMeta.getFieldMetaArray();
    Map<String, FieldMeta> duplicateFKRefClassMap = new HashMap<>(); 
//    Map<String, FieldMeta> duplicateFKChildClassMap = new HashMap<>(); 
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
        if (EntityMeta.getCollectionEnclosedEntityMeta(fields[i]) != null) break; // skip collections...continue?
        for (StringNode childNode: inputNode.getChildren()) {
//          out.println("childNode.getValue("+fields[i].getName()+") = " + childNode.getValue());
          // DEBUGGING
//          if (currentEntityMeta.getSimpleName().equals("Flight") & fields[i].getName().startsWith("aircraft")) {
//            out.println("Debugging case ACT_ALL_ATTRIBS Flight.aircraft..."); // Set breakpoint on this line
//          }
          // END DEBUG
          this.build(childNode, outputNode, drivingEntityMeta, currentEntityMeta, fields[i]);
        }
        break;

//      case ACT_EMBEDDED_ID_FIELDS:
//        String debugDummy = "debugDummy"; 
//        out.println(debugDummy);
//        if (!fields[i].isEmbeddedId()) break;
//        EntityMeta.FieldMeta[] embeddedIdFields = fields[i].getEmbeddedIdFields();
//        for (EntityMeta.FieldMeta childField : embeddedIdFields) {
//          for (StringNode childNode: inputNode.getChildren()) {
//            this.build(childNode, outputNode, drivingEntityMeta, currentEntityMeta, childField);  // <-------------------------<
//          }
//        }
//        break;          
        
      case ACT_UI_ATTRIBS: 
        if (fields[i].isId()) continue;
//        out.println("case " + ACT_ALL_ATTRIBS);
        if (EntityMeta.getCollectionEnclosedEntityMeta(fields[i]) != null) break; // skip collections...continue?
        if (fields[i].isEmbeddedIdMemberField()) continue;
        if (!(fields[i].isPrimitiveOrWrapper() | fields[i].isEmbeddedId())) continue; 
        for (StringNode childNode: inputNode.getChildren()) {
//          out.println("childNode.getValue("+fields[i].getName()+") = " + childNode.getValue());
          this.build(childNode, outputNode, drivingEntityMeta, currentEntityMeta, fields[i]);
        }
        break;

      
      
//      case ACT_NON_KEY_ATTRIBS: 
//        if (fields[i].isId()) continue;
//        if (getCollectionEnclosedEntityMeta(fields[i]) != null) break; // skip collections
//        if (fields[i].isId()) { break; } // Isn't this redundant?
//        if (fields[i].isEmbeddedIdMemberField()) { break; }// skip primary key column attributes
//        if (fields[i].isEmbeddedId()) { break; }// skip embedded compound primary key object
//        for (StringNode childNode: inputNode.getChildren()) {
//          this.build(childNode, outputNode, drivingEntityMeta, currentEntityMeta, fields[i]);
//        }
//        break;
      
      
      
      case ACT_PK_ATTRIBS: 
        if (!(fields[i].isId() | fields[i].isEmbeddedIdMemberField())) { break; }// Process ONLY primary key column attributes
        for (StringNode childNode: inputNode.getChildren()) {
//          out.println("childNode.getValue("+fields[i].getName()+") = " + childNode.getValue());
          this.build(childNode, outputNode, drivingEntityMeta, currentEntityMeta, fields[i]);
        }
        break;
      case ACT_PK_ATTRIBS_COMMA_SEPARATED: 
        if (!(fields[i].isId() | fields[i].isEmbeddedIdMemberField())) { break; }// Process ONLY primary key column attributes
        //int iteration = 0;
        for (StringNode childNode: inputNode.getChildren()) {
          this.build(childNode, outputNode, drivingEntityMeta, currentEntityMeta, fields[i]);
        }
        if (fields[i].isEmbeddedIdMemberField() & (!fields[i].isLastEmbeddedIdMemberField())) {
          this.addNode(", ", outputNode);
        }
        break;
      case ACT_SIMPLE_ATTRIBS:
        if (fields[i].isId()) continue;
        if ((fields[i].isPrimitiveOrWrapper())) {
          for (StringNode childNode: inputNode.getChildren()) {
            this.build(childNode, outputNode, drivingEntityMeta, currentEntityMeta, fields[i]);
          }
        }
        break;
      case ACT_DATE_ATTRIBS:
        if (fields[i].isId()) continue; // But what if the primary key contains a Date? Convention says don't do that.
        if (isLocalDate(fields[i])) {
          for (StringNode childNode: inputNode.getChildren()) {
            this.build(childNode, outputNode, drivingEntityMeta, currentEntityMeta, fields[i]);
          }
        }
        break;
      case ACT_DATE_TIME_ATTRIBS:
        if (isLocalDateTime(fields[i])) {
          for (StringNode childNode: inputNode.getChildren()) {
//            out.println("childNode.getValue("+fields[i].getName()+") = " + childNode.getValue());
            this.build(childNode, outputNode, drivingEntityMeta, currentEntityMeta, fields[i]);
          }
        }
        break;
      case ACT_FK_REF_ATTRIBS:
        if (drivingEntityMeta.getSimpleName().equals("Flight")) { // Hard-coded test/debug
        }
        if (!(fields[i].isPrimitiveOrWrapper()) & EntityMeta.getCollectionEnclosedEntityMeta(fields[i]) == null) {
          out.println("    if (!isPrimitiveOrWrapper(fields["+i+"]) & getCollectionEnclosedEntityMeta(fields[i]) == null) PASSED");
          for (StringNode childNode: inputNode.getChildren()) {
            if (fields[i].getType().getSimpleName().equals(drivingEntityMeta.getSimpleName())) {
              continue; 
            }
              this.build(childNode, outputNode, drivingEntityMeta, currentEntityMeta, fields[i]);
          }
        }
        break;
        case ACT_FK_REF_ENTITIES:
          // out.println(ACT_FK_REF_ENTITIES);
          if (duplicateFKRefClassMap.get(fields[i].getType().getName()) != null) {
            break;
          }
          duplicateFKRefClassMap.put(fields[i].getType().getName(), fields[i]);
          if (!(fields[i].isPrimitiveOrWrapper())) {
            for (StringNode childNode: inputNode.getChildren()) {
              this.build(childNode, outputNode, drivingEntityMeta, currentEntityMeta, fields[i]);
            }
          }
          break;
        case ACT_FK_CHILD_ENTITIES_W_SIMPLE_KEYS:
//          String DebuggingDummy = "DebuggingDummy";
        case ACT_FK_CHILD_ENTITIES_W_COMPOUND_KEYS:
        case ACT_FK_CHILD_ENTITIES_W_SIMPLE_KEYS_FORCE_INCLUDE:
        case ACT_FK_CHILD_ENTITIES_W_COMPOUND_KEYS_FORCE_INCLUDE:
          // The next two conditions segregate mutually exclusive blocks of code
          // If the present field -- which is to say the child entity collection attribute --
          //   is annotated to be excluded from its parent entity module, then skip it UNLESS
          //   the token contains "FORCE_INCLUDE".
          // If the field is not annotated to be excluded BUT the token contains "FORCE_INCLUDE"
          //   then this is interpreted to be the opposite case and should be skipped.
          //   Put another way, code not annotated as excluded should only be included if the token
          //     does NOT contain FORCE_INCLUDE.  
          if (fields[i].isExcludedFromParentModule() & (!tokenInstruction.contains(FORCE_INCLUDE))) break;
          if (!fields[i].isExcludedFromParentModule() & (tokenInstruction.contains(FORCE_INCLUDE))) break;
//          duplicateFKChildClassMap.put(fields[i].getType().getName(), fields[i]); // Necessary in this case?
          collectionOfEntityMeta = null;
          if ((collectionOfEntityMeta = EntityMeta.getCollectionEnclosedEntityMeta(fields[i])) != null) {
            //out.println ("Found " + collectionOfEntityMeta.getEntityMeta().getSimpleName() + " enclosed in field " + fields[i].getName());
//            if (tokenInstruction.equals(ACT_FK_CHILD_ENTITIES_W_COMPOUND_KEYS)) {
            if (tokenInstruction.contains(W_COMPOUND_KEYS)) {
              if (!(collectionOfEntityMeta.getEntityMeta().hasEmbeddedId())) { 
              break;
              } 
            }
//            if (tokenInstruction.equals(ACT_FK_CHILD_ENTITIES_W_SIMPLE_KEYS)) {
            if (tokenInstruction.contains(W_SIMPLE_KEYS)) {
              if (collectionOfEntityMeta.getEntityMeta().hasEmbeddedId()) { 
              break;
              } 
            }
            for (StringNode childNode: inputNode.getChildren()) {
//              out.println("childNode.getValue("+fields[i].getName()+") = " + childNode.getValue());
              this.build(childNode, outputNode, drivingEntityMeta, fields[i], collectionOfEntityMeta.getEntityMeta()); // <------------< **************
            }
          }
          break;
        case ACT_FK_CHILD_W_COMPOUND_KEYS_AND_THIRD_ENTITIES:
        case ACT_THIRD_ENTITIES_ONLY:
        case ACT_FK_CHILD_AND_THIRD_ENTITIES:
          {
            if (fields[i].isExcludedFromParentModule()) break;
            int iteration = 0;
            if ((collectionOfEntityMetas = EntityMeta.getCollectionEnclosedEntityMetas(fields[i])) != null) {
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
                // The first element in the collection is ASS U ME'd to be the child entity, all others "Third"
                // A more structural algorithm would be preferred.
                if ((iteration == 1) & (tokenInstruction.equals(ACT_THIRD_ENTITIES_ONLY))) {
                  continue; // Skip the child entity, go for the third
                }
                if (childEntityMeta.getEntityMeta().getSimpleName().equals(drivingEntityMeta.getSimpleName())) continue; 
                for (StringNode childNode: inputNode.getChildren()) {
                  this.build(childNode, outputNode, drivingEntityMeta, fields[i], childEntityMeta.getEntityMeta());
                }
              }
            }
          }
          break;
        case ACT_OTHER_REF_ENTITIES:
          if (!currentEntityMeta.hasEmbeddedId()) continue;
          out.println("case ACT_OTHER_REF_ENTITIES:");
          if (fields[i].isEmbeddedIdMemberField()) {
            if (fields[i].getType().getName().equals(drivingEntityMeta.getClassName())) {
              continue;
            }
            else { // This is an "other" that we want.
              for (StringNode childNode: inputNode.getChildren()) {
                this.build(childNode, outputNode, drivingEntityMeta, currentEntityMeta, fields[i]);
              }
            }
          }
          break;

          
//        case ACT_THIRD_ENTITIES: // REMOVED FROM SERVICE
//          if (duplicateFKChildClassMap.get(fields[i].getType().getName()) != null) {
//            break;
//          }
//          duplicateFKChildClassMap.put(fields[i].getType().getName(), fields[i]);
//          if ((collectionOfEntityMetas = getCollectionEnclosedEntityMetas(fields[i])) != null) {
//            for (TempEntityMeta childEntityMeta : collectionOfEntityMetas) {
//              if (duplicateEntityMetaMap.get(childEntityMeta.getEntityMeta().getSimpleName()) != null) {
//                break;
//              }
//              duplicateEntityMetaMap.put(childEntityMeta.getEntityMeta().getSimpleName(), childEntityMeta.getEntityMeta());
//              if (childEntityMeta.getEntityMeta().getSimpleName().equals(drivingEntityMeta.getSimpleName()))  continue;
//              if (childEntityMeta.getEntityMeta().getSimpleName().equals(getCollectionEnclosedEntityMeta(fields[i]).getEntityMeta().getSimpleName()))
//                continue; // What remains are entity classes referenced by a child entity class
//              for (StringNode childNode: inputNode.getChildren()) {
//                this.build(childNode, outputNode, drivingEntityMeta, fields[i], childEntityMeta.getEntityMeta()); // <------------< **************
//              }
//            }
//          }
//          break;
        case ACT_FK_CHILD_ENTITY_ATTRIBS:
        case ACT_FK_CHILD_ENTITY_W_COMPOUND_KEY_ATTRIBS:
          if (fields[i].isExcludedFromParentModule()) break;
          collectionOfEntityMeta = null;
          if ((collectionOfEntityMeta = EntityMeta.getCollectionEnclosedEntityMeta(fields[i])) != null) {
            if (collectionOfEntityMeta.getEntityMeta().getSimpleName().equals(drivingEntityMeta.getSimpleName()))
              continue;
            if (tokenInstruction.equals(ACT_FK_CHILD_ENTITY_W_COMPOUND_KEY_ATTRIBS) & !collectionOfEntityMeta.getEntityMeta().hasEmbeddedId()) break;
            EntityMeta.FieldMeta[] childEntityFields = collectionOfEntityMeta.getEntityMeta().getFieldMetaArray();
            for (EntityMeta.FieldMeta childField : childEntityFields) {
              if (childField.getType().getSimpleName().equals(drivingEntityMeta.getSimpleName())) {
                continue; // [Skip;] WILL HAVE TO REVISIT THIS FOR MULTIPLE FOREIGN KEYS REFERENCING DRIVING ENTITY FROM CHILD ENTITY
              }
              if (!(childField.isColumnOrJoinColumn())) {
                continue; // [Skip;] WILL HAVE TO REVISIT THIS FOR MULTIPLE FOREIGN KEYS REFERENCING DRIVING ENTITY FROM CHILD ENTITY
              }
              for (StringNode childNode: inputNode.getChildren()) {
                this.build(childNode, outputNode, drivingEntityMeta, currentEntityMeta, childField);  // <-------------------------<
              }
            }
            break;
          }
          break;
          
//        case ACT_EMBEDDED_ID_FIELDS:
//          String debugDummy = "debugDummy"; 
//          out.println(debugDummy);
//          if (!fields[i].isEmbeddedId()) break;
//          EntityMeta.FieldMeta[] embeddedIdFields = fields[i].getEmbeddedIdFields();
//          for (EntityMeta.FieldMeta childField : embeddedIdFields) {
//            for (StringNode childNode: inputNode.getChildren()) {
//              this.build(childNode, outputNode, drivingEntityMeta, currentEntityMeta, childField);  // <-------------------------<
//            }
//          }
//          break;          
//          
        case ACT_NON_TEMPORAL_ATTRIBS:
          if (fields[i].isId()) continue;
          if (((fields[i].isPrimitiveOrWrapper())) & (!isTemporalType(fields[i]))
              & (EntityMeta.getCollectionEnclosedEntityMeta(fields[i]) == null) // Not collection type
          ) {
            for (StringNode childNode: inputNode.getChildren()) {
              this.build(childNode, outputNode, drivingEntityMeta, currentEntityMeta, fields[i]);  
            }
          }
          break;
      }
    }
  }
  
  protected String getAttributeAttribute ( EntityMeta drivingEntityMeta
                                         , EntityMeta currentEntityMeta
                                         , EntityMeta.FieldMeta field
                                         , String token
                                         ) {
    if (field.getName().equals(SERIAL_VERSION_UID)) return null;
  
    String returnValue = null;
    String interim = null;
    //Field[] fields = entityClass.getDeclaredFields();
    TempEntityMeta collectionOfEntityMeta = null;
    if ((collectionOfEntityMeta = EntityMeta.getCollectionEnclosedEntityMeta (field)) != null) {
      switch (token) {
      case FK_CHILD_ENTITY:
        returnValue = collectionOfEntityMeta.getEntityMeta().getSimpleName();
        break;
      case FK_CHILD_ENTITY_LABEL:
//      case ENTITY_ATTRIB_LABEL:
        returnValue = collectionOfEntityMeta.getEntityMeta().getLabel();
        break;
      case FK_CHILD_ENTITY_INIT_SMALL:
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
      }
    }
    if (!field.isPrimitiveOrWrapper()) { // It's a FK Ref Entity
      switch (token) {
        case FK_REF_ENTITY: 
          returnValue = field.getType().getSimpleName();
        break;
        case FK_REF_ENTITY_QUALIFIED: 
          returnValue = field.getLabel().replaceAll(" ", "");
        break;
        case FK_REF_ENTITY_INIT_SMALL:
          interim = field.getType().getSimpleName();
          returnValue = interim.substring(0,1).toLowerCase()+interim.substring(1);
          break;
//        case FK_REF_ENTITY_LOWER:
//          returnValue = field.getType().getSimpleName().toLowerCase();
//          break;
          
        // DEPRECATED FOR NON-USE:
//        case FK_REF_ENTITY_LOWER_PLURAL:
//          returnValue = field.getType().getSimpleName().toLowerCase()+"s";
//          break;
        case FK_REF_ENTITY_UPPER_PLURAL:
          returnValue = field.getType().getSimpleName().toUpperCase()+"S";
          break;
        case FK_REF_ENTITY_ID:
          try {
            out.println("case FK_REF_ENTITY_ID: ");
            out.println("  currentEntityMeta = " + currentEntityMeta.getSimpleName());
            out.println("  field = " + field.getName());
            returnValue = EntityMetaFactoryImpl.entityMetaFactoryImplX.getEntityMeta(field.getType().getName()).getIDField().getName(); 
          } catch (Exception e) {
            returnValue = "EntityMeta.getEntityMeta() SHOULD NOT THROW Exception (getAttributeAttribute case FK_REF_ENTITY_ID)";
          }
          //out.println("***DEBUG: FK_REF_ENTITY_ID -> " + returnValue + "; FK_REF_ENTITY_IDENTIFIER -> " + field.getResolvedIdentifier());
          break;
        // DEPRECATED
//        case FK_REF_ATTRIB_NAME:
//          returnValue = field.getName();
//          break;
        case FK_REF_ENTITY_IDENTIFIER:
          returnValue = field.getResolvedIdentifier();
          break;
        case FK_REF_ATTRIB_INITCAPS:
  //        returnValue = field.getResolvedIdentifier().substring(0,1).toUpperCase()+field.getResolvedIdentifier().substring(1);
          returnValue = field.getName().substring(0,1).toUpperCase()+field.getName().substring(1);
          break;
        }
      } 
      switch (token) {
//        case FK_CHILD_EMBEDDED_ID:
        case FK_CHILD_EMBEDDED_ID_INIT_SMALL:
          returnValue = currentEntityMeta.getEmbeddedPKInfo().getSimpleName(); // .getEmbeddedPKInfo().getSimpleName();
          if (token.equals(FK_CHILD_EMBEDDED_ID_INIT_SMALL)) {
            returnValue = returnValue.substring(0, 1).toLowerCase()+ returnValue.substring(1);
          }
        break;
//        case ENTITY_ATRRIB_INITCAP_NAME:
//          if (!isPrimitiveOrWrapper(field.getType())) {
//            returnValue = field.getResolvedIdentifier().substring(0,1).toUpperCase()+field.getResolvedIdentifier().substring(1);
//          }
//          break;
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
          if (!(field.isPrimitiveOrWrapper())) {
            returnValue = DATATYPE_INTEGER;
          } else if (isTemporalType(field)) {
            returnValue = DATATYPE_STRING;
          } else {
            try { 
              returnValue = field.getType().getSimpleName();
            } catch (Exception e) { // what Exception?
              returnValue = field.getType().getName();
            }
          }
          break;
        case ENTITY_ATTRIB_INITCAPS:
          returnValue = field.getResolvedIdentifier().substring(0,1).toUpperCase()+field.getResolvedIdentifier().substring(1);
          break;
          
        // DEPRECATED AS UNNECESSARY
//        case ENTITY_DATE_ATTRIB_NAME:
//          if (field.getType().getName().endsWith(DATATYPE_LOCAL_DATE)){
//            returnValue = field.getResolvedIdentifier();
//          }
//          break;

          // DEPRECATED AS UNNECESSARY
//        case ENTITY_DATE_TIME_ATTRIB_NAME:
//          if (field.getType().getName().endsWith(DATATYPE_LOCAL_DATE_TIME)){
//            returnValue = field.getResolvedIdentifier();
//          }
//          break;

          // DEPRECATED AS UNNECESSARY
//        case ENTITY_DATE_ATTRIB_INITCAPS:
//          if (field.getType().getName().endsWith(DATATYPE_LOCAL_DATE)){
//            returnValue = field.getResolvedIdentifier().substring(0,1).toUpperCase()+field.getResolvedIdentifier().substring(1);
//          }
//          break;

          // DEPRECATED AS UNNECESSARY
//        case ENTITY_DATE_TIME_ATTRIB_INITCAPS:
//          if (field.getType().getName().endsWith(DATATYPE_LOCAL_DATE_TIME)){
//            returnValue = field.getResolvedIdentifier().substring(0,1).toUpperCase()+field.getResolvedIdentifier().substring(1);
//          }
//          break;
          
//        case ACT_EMBEDDED_ID_FIELDS:
//          String debugDummy = "debugDummy"; 
//          out.println(debugDummy);
//          if (!field.isEmbeddedId()) break;
//          EntityMeta.FieldMeta[] embeddedIdFields = field.getEmbeddedIdFields();
//          for (EntityMeta.FieldMeta childField : embeddedIdFields) {
//            for (StringNode childNode: inputNode.getChildren()) {
//              this.build(childNode, outputNode, drivingEntityMeta, currentEntityMeta, childField);  // <-------------------------<
//            }
//          }
//          break;          
          

//        DEPRECATED; Hard-coded kludge for Edit.html.template.txt no longer necessary          
//        case GET_TH_HTML_FORM_DATA_VARS: 
//        {
//          returnValue = "";
//          int iteration = 0;
//          String compoundEntityPlusPK = currentEntityMeta.getSimpleName().substring(0,1).toLowerCase()+currentEntityMeta.getSimpleName().substring(1)
//                                      + "."
//                                      + currentEntityMeta.getEmbeddedPKInfo().getSimpleName().substring(0,1).toLowerCase()
//                                      + currentEntityMeta.getEmbeddedPKInfo().getSimpleName().substring(1);
//          for (String embeddidIdField: currentEntityMeta.getEmbeddedIdFieldIdentifiers()) {
//            if (iteration > 0) {returnValue += ", ";}
//            returnValue += "data-" + embeddidIdField + "=${" + compoundEntityPlusPK + "." + embeddidIdField + "}";
//      //    th:attr="data-pilotId=${flightCrewMember.flightCrewMemberPK.pilotId}, data-flightId=${flightCrewMember.flightCrewMemberPK.flightId}"
//            iteration++;
//          }
//          break;
//        }
       
        case HTML_FORM_VERTICAL_INPUT:
        case HTML_FORM_VERTICAL_INPUT_BLANK:
        case HTML_FORM_HORIZONTAL_INPUT:
        case HTML_FORM_HORIZONTAL_INPUT_BLANK:
        {
          // DEBUGGING
          if (currentEntityMeta.getSimpleName().equals("Flight") & field.getName().startsWith("aircraft")) {
            out.println("Debugging case HTML_FORM_* Flight.aircraft..."); // Set breakpoint on this line
          }
          // END DEBUG
          returnValue = "";
          if (field.isEmbeddedId()) break;
          StringBuilder sb = new StringBuilder("");
          String indent = "          "; // 10 spaces
          
          boolean isFkRef = (!(field.isPrimitiveOrWrapper()) & EntityMeta.getCollectionEnclosedEntityMeta(field) == null);
          boolean isFKChildCollection = (EntityMeta.getCollectionEnclosedEntityMeta(field) != null); // FLAWED?
          boolean currentEntityMetaIsChild = (!currentEntityMeta.equals(drivingEntityMeta));
          String fieldType = field.getType().getSimpleName();
          String drivingEntityMetaName = drivingEntityMeta.getSimpleName();
          if (currentEntityMetaIsChild) { // NEED TO HANDLE MULTIPLE FKs back to same driving parent
            if (fieldType.equals(drivingEntityMetaName)) break; // Ignore references back to driving parent
          }
          String htmlFormInputControl = field.getHtmlFormInputControl();
          boolean isVertical = token.startsWith(HTML_FORM_VERTICAL_INPUT);
          boolean isHorizontal = token.startsWith(HTML_FORM_HORIZONTAL_INPUT);
          boolean isBlank = token.endsWith("_BLANK"); 
          if (field.isEmbeddedIdMemberField() & !isBlank) break;
          
          sb.append(isVertical?"<tr>\n":"");
          //sb.append(isVertical?indent + "<tr>\n":"");
          sb.append(isVertical?indent + "  <td><label for=\"" + field.getResolvedIdentifier() + "\">" + field.getLabel() + "</label></td>\n":"");
          String declaringClassVar = field.getDeclaringClassName().substring(0, 1).toLowerCase()+field.getDeclaringClassName().substring(1);
//          String htmlFormVar = declaringClassVar + "." + field.getName();
          String htmlFormVar = declaringClassVar + "." + field.getResolvedIdentifier(); // For example flight.aircraftId
          String fqRefVar = declaringClassVar + "." + field.getName();                  // For example flight.aircraft
          String valueClause = isBlank?" value=\"\"":" th:value=\"${" + htmlFormVar + "}\"";
          String textClause = isBlank?" text=\"\"":" th:text=\"${" + htmlFormVar + "}\"";
          String textAreaRows = (isBlank?"\"2\"":"\"1\"");
          
          String fieldName = "";
          int fieldWidth = field.getFieldWidth();
          if (currentEntityMetaIsChild) { // Horizontal
//            fieldName = declaringClassVar + (field.getName().substring(0, 1).toUpperCase()+field.getName().substring(1));
            fieldName = declaringClassVar + (field.getResolvedIdentifier().substring(0, 1).toUpperCase()+field.getResolvedIdentifier().substring(1));
          }
          else { // Vertical
//            fieldName = field.getName();
            fieldName = field.getResolvedIdentifier();
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
//            sb.append(indent + "              <button data-btn=\""+field.getName()+"-edit\" th:attr=\"data-"+fieldName+"=${"+htmlFormVar+"}==null?0:${"+htmlFormVar+"."+fkRefEntityId+"}\" type=\"SUBMIT\" class=\"frmEdit\" NAME=\"frmEdit\" VALUE=\"View/Edit "+fkRefEntityInitUpper+"\">\r\n");
//            sb.append(indent + "              <button data-btn=\""+field.getResolvedIdentifier()+"-edit\" th:attr=\"data-"+fieldName+"=${"+htmlFormVar+"}==null?0:${"+htmlFormVar+"."+fkRefEntityId+"}\" type=\"SUBMIT\" class=\"frmEdit\" NAME=\"frmEdit\" VALUE=\"View/Edit "+fkRefEntityInitUpper+"\">\r\n");
            sb.append(indent + "              <button data-btn=\""+field.getResolvedIdentifier()+"-edit\" th:attr=\"data-"+field.getResolvedIdentifier()+"=${"+fqRefVar+"}==null?0:${"+fqRefVar+"."+fkRefEntityId+"}\" type=\"SUBMIT\" class=\"frmEdit\" NAME=\"frmEdit\" VALUE=\"View/Edit "+fkRefEntityInitUpper+"\">\r\n");
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
        switch (token) {
        case FK_CHILD_ENTITY:
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
  
  protected String getAttributeAttribute ( EntityMeta drivingEntityMeta
                                         , FieldMeta drivingEntityMetaField
                                         , EntityMeta currentEntityMeta
                                         , String token
                                         ) {
    String[] excluded = null;
    return getAttributeAttribute (drivingEntityMeta, drivingEntityMetaField, currentEntityMeta, token, excluded);
  }

  protected String getAttributeAttribute ( EntityMeta drivingEntityMeta
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
//      returnValue = EntityMeta.getCollectionEnclosedEntityMeta (drivingEntityMetaField).getEntityMeta().getLabel();
//      if (returnValue != null) break;
      returnValue = drivingEntityMetaField.getLabel();
      break;
    case FIRST_NON_KEY_REQUIRED_ATTRIB:
    case FIRST_NON_KEY_REQUIRED_ATTRIB_INIT_CAP:
  //    out.println("Found FK_CHILD_ENTITY " + FK_CHILD_ENTITY + " " + currentEntityMeta.getSimpleName() + ": " + currentEntityMeta);
      returnValue = currentEntityMeta.getFirstNonKeyRequiredFieldName();
      if (token.equals(FIRST_NON_KEY_REQUIRED_ATTRIB_INIT_CAP)) {
        returnValue = returnValue.substring(0,1).toUpperCase() + returnValue.substring(1);  
      }
      break;
    case MODEL_ENTITY_MAPPED_REF_ATTRIB:
    case MODEL_ENTITY_MAPPED_REF_ATTRIB_INIT_CAP:
      returnValue = drivingEntityMetaField.getAnnotationAttributeValue(EntityMeta.ANNOTATION_ONE_TO_MANY, EntityMeta.ANNOTATION_ATTRIBUTE_MAPPED_BY);
      if (token.equals(MODEL_ENTITY_MAPPED_REF_ATTRIB_INIT_CAP))
        returnValue = returnValue.substring(0,1).toUpperCase()+returnValue.substring(1);
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
//      out.println("case FK_REF_ENTITY_ID: ");
//      out.println("  drivingEntityMetaName = " + drivingEntityMetaName);
//      out.println("  currentEntityMeta = " + currentEntityMeta.getSimpleName());
      EntityMeta[] embeddedIdRefEntities = currentEntityMeta.getEmbeddedIdRefEntities();
      if (embeddedIdRefEntities != null) {
        for (EntityMeta embeddidIdRefEntity: embeddedIdRefEntities) {
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
//    case FK_REF_ENTITY_LOWER:
//      returnValue = currentEntityMeta.getSimpleName().toLowerCase();
//      break;
    // DEPRECATED  
//    case FK_REF_ENTITY_LOWER_PLURAL:
//      returnValue = currentEntityMeta.getSimpleName().toLowerCase()+"s";
//      break;
    case FK_REF_ENTITY_UPPER_PLURAL:
      returnValue = currentEntityMeta.getSimpleName().toUpperCase()+"S";
      break;
//    case FK_CHILD_EMBEDDED_ID:
    case FK_CHILD_EMBEDDED_ID_INIT_SMALL:
      returnValue = currentEntityMeta.getEmbeddedPKInfo().getSimpleName(); // .getEmbeddedPKInfo().getSimpleName();
      if (token.equals(FK_CHILD_EMBEDDED_ID_INIT_SMALL)) {
        returnValue = returnValue.substring(0, 1).toLowerCase()+ returnValue.substring(1);
      }
      break;      
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
        iteration++;
      }
      break;
    case CALL_COMPOUND_CONSTRUCTOR: 
    //FlightCrewMember(tempFlight, pilot)
    returnValue = currentEntityMeta.getSimpleName() + "(";
    iteration = 0;
    for (String embeddidIdRefClassName: currentEntityMeta.getEmbeddedIdRefEntityIdentifiers()) {
      if (iteration > 0) {returnValue += ", ";}
      if (embeddidIdRefClassName == null) break;
      embeddidIdRefClassNameInitSmall = embeddidIdRefClassName.substring(0,1).toLowerCase()+ embeddidIdRefClassName.substring(1);
      returnValue += embeddidIdRefClassNameInitSmall;
      iteration++;
    }
    returnValue += ")";
    break;
    case PK_ID_ATTRIB_LIST:
    {  
      returnValue = ""; //"(";
      iteration = 0;
      if (currentEntityMeta.getEmbeddedIdFieldIdentifiers() == null) {
        returnValue = currentEntityMeta.getIDField().getName();
      } else {      
        for (String embeddidIdFieldName: currentEntityMeta.getEmbeddedIdFieldIdentifiers()) {
          if (iteration > 0) {returnValue += ", ";}
          iteration++;
          returnValue += embeddidIdFieldName;
        }
      }
      break;
    }
    //DEPRECATED
//    case COMPOUND_INSERT_PARAM_LIST_CHILD_ENTITY:
//    {  
//      String prefix = currentEntityMeta.getSimpleName().substring(0, 1).toLowerCase() + currentEntityMeta.getSimpleName().substring(1); 
//      returnValue = "(";
//      iteration = 0;
//      for (EntityMeta.FieldMeta field: currentEntityMeta.getFieldMetaArray()) {
//        if (field.getName().equals(SERIAL_VERSION_UID)) continue;
//        if (iteration > 0) {returnValue += ", ";}
//        if (field.getType().getSimpleName().equals(drivingEntityMeta.getSimpleName())) {
//          returnValue += field.getName(); // need to pre-pend entity var name plus getter() call
//        }
//        else
//        {
//          returnValue += prefix+field.getName().substring(0,1).toUpperCase()+field.getName().substring(1);
//        }
//        iteration++;
//      }
//      returnValue += ")";
//      break;
//    }
    case FIND_ONE_BY_PK_FK_CRITERIA: // Second most hard-coded case so far 2018.03.04
      returnValue = "findOneBy";
      currentTableVarPrefix = currentEntityMeta.getSimpleName().substring(0, 1).toLowerCase()+currentEntityMeta.getSimpleName().substring(1);
      iteration = 0;
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
//    case FK_CHILD_EMBEDDED_PK:
//      out.println("case FK_CHILD_EMBEDDED_PK");
//    case FK_CHILD_EMBEDDED_PK_INIT_SMALL:
//      out.println("case FK_CHILD_EMBEDDED_PK_INIT_SMALL");
//      EntityMeta embeddedPK = currentEntityMeta.getEmbeddedPKInfo();
//      if (embeddedPK != null) {
//        returnValue = embeddedPK.getSimpleName();
//      }
//      if (returnValue!=null & token.equals(FK_CHILD_EMBEDDED_PK_INIT_SMALL)) {
//        returnValue=returnValue.substring(0,1).toLowerCase() + returnValue.substring(1);
//      }
//      out.println("returnValue = " + returnValue);
//      return returnValue;
    }
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
  
  
}


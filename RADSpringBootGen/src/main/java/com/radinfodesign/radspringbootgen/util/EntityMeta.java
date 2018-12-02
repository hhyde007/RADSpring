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
import java.lang.reflect.Field;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.StringTokenizer;

import org.springframework.beans.factory.annotation.Autowired;

import com.radinfodesign.radspringbootgen.dao.DbUserTableColumnRepository;
import com.radinfodesign.radspringbootgen.metamodel.DbUserTableColumn;


/**
 * Wrapper class for data model entity metadata, 
 * a.k.a. all the attributes of a database table as represented by a Java model entity class.
 * 
 * @author Howard Hyde
 *
 */
public class EntityMeta {
  public static final char   PERIOD = '.'; 
//  public static final String TAB = "  ";  
  public static final char   SPACE = ' ';
  public static final String AT_SIGN = "@"; 
  public static final String JAVA_PACKAGE = "java."; 
  public static final String ANNOTATION_ID = "@Id"; 
  public static final String ANNOTATION_EMBEDDABLE = "@Embeddable";
  public static final String ANNOTATION_EMBEDDED_ID = "@EmbeddedId";
  public static final String ANNOTATION_TABLE = "@Table";
  public static final String ANNOTATION_COLUMN = "@Column";
  public static final String ANNOTATION_LABEL = "@Label";
  public static final String ANNOTATION_ONE_TO_MANY = "@OneToMany";
  public static final String ANNOTATION_JOIN_COLUMN = "@JoinColumn";
  public static final String ANNOTATION_BASIC = "@Basic";
  public static final String ANNOTATION_ENTITY = "@Entity";
  public static final String ANNOTATION_EXCLUDED_EDIT_FROM_PARENT_MODULE = "@ExcludeFromParentModule";
  public static final String ANNOTATION_ATTRIBUTE_NAME = "name";
  public static final String ANNOTATION_ATTRIBUTE_MAPPED_BY = "mappedBy";
  public static final String MODEL_PACKAGE = "com.radinfodesign.radspringbootgen.fboace.model";
  public static final String DATATYPE_COLLECTION = "java.util.Collection";
  public static final String COLLECTION = "Collection";

  protected static final String PATH_TO_MODEL_JAVA_FILES = "com/radinfodesign/radspringbootgen/fboace/model/"; // HARD-CODE ALERT!
  
//  private static Map<String, EntityMeta> entityMetaMap = new HashMap<>();
  
  // NOT @Autowired
  protected DbUserTableColumnRepository dbUserTableColumnRepository;

  protected String className = null;
  protected Class subjectClass = null;
  protected String tableName = null;
  protected ArrayList<String> sourceCodeLines = new ArrayList<>();
//  protected Map<String, ArrayList<String>> fieldAnnotationMapList = new HashMap<>();
  protected ArrayList<String> classAnnotationList = new ArrayList<>();
  protected EntityMeta embeddedPKInfo = null;
  protected EntityMeta embeddingEntityMeta = null;
  protected boolean isEmbeddedPkInfo = false;
  protected List<EntityMeta> pkReferencedEntityMetas = null;
  protected String embeddedPKInfoClassName = null;
//  protected Map<String, Field> fieldMap = new HashMap<>();
  protected Map<String, FieldMeta> fieldMetaMap = new HashMap<>();
  protected FieldMeta[] fieldMetaArray;
  protected FieldMeta idField;
  
  protected Map<String, String> pkFkRefClassFieldMap = null;
  protected String label;
  protected EntityMeta[] embeddedIdRefEntities = null;  

  static Map<String, String> enclosedTypesMap = new HashMap<>(); // REVISIT THIS
  
  public FieldMeta getIDField() { 
    if (this.idField != null) return this.idField;
    else { // Might not be set yet.
      if (this.getFieldMetaArray() != null) {
        for (FieldMeta field: this.getFieldMetaArray()) {
          if (field.isId() | field.isEmbeddedId()) {
            this.idField = field;
            break;
          }
        }
      }
    }
    return this.idField; 
  }
    
  /**
   * Wrapper class for data model entity FIELD metadata, 
   * a.k.a. all the attributes of a database table COLUMN as represented by a Java class.
   * 
   * @author Howard Hyde
   *
   */
  class FieldMeta {
    Field field;
    ArrayList<String> fieldAnnotationList = new ArrayList<>();
    String label = null;
    String htmlFormInputControl = null; //"text"; // textarea, date, select
    DbUserTableColumn dbUserTableColumn = null;
    String dbTableColumnName = null;
    
    FieldMeta (Field field) {
      this.field = field;
    }
    FieldMeta() {    
    }

// CHICKEN OR EGG?    
    public String getDbTableColumnName() {
      if (dbTableColumnName == null) {
        dbTableColumnName = this.getAnnotationAttributeValue(ANNOTATION_COLUMN, ANNOTATION_ATTRIBUTE_NAME);
      }
      return this.dbTableColumnName;
    }

    public DbUserTableColumn getDbUserTableColumn() {
      if (dbUserTableColumn == null) {
        out.println("dbUserTableColumnRepository = " + EntityMeta.this.dbUserTableColumnRepository);
        try {
          this.dbUserTableColumn = dbUserTableColumnRepository.findOneByTableNameAndColumnName(EntityMeta.this.getDbTableName().toUpperCase(), this.getDbTableColumnName().toUpperCase());
        }
        catch (NullPointerException e) {
          out.println ("NullPointerException on dbUserTableColumnRepository: field = " + this.getResolvedIdentifier()); 
          out.println ("  EntityMeta.this.getDbTableName() = " + EntityMeta.this.getDbTableName()); 
          out.println ("  this.getDbTableColumnName() = " + this.getDbTableColumnName()); 
          //e.printStackTrace();
        }
      }
      return dbUserTableColumn;
    }
//    public void setDbUserTableColumn(DbUserTableColumn dbUserTableColumn) {
//      this.dbUserTableColumn = dbUserTableColumn;
//    }
    public int getFieldWidth() {
      if (getDbUserTableColumn() == null) return 20;
      return this.getDbUserTableColumn().getFieldWidth();
    }

    public String getHtmlFormInputControl () {
      if (htmlFormInputControl == null) {
        if (!this.isPrimitiveOrWrapper() & (!this.getType().getName().equals(DATATYPE_COLLECTION))) {
          htmlFormInputControl = "select";
          return htmlFormInputControl; 
        }
        String dataType = this.getDataType();
        if (dataType == null) {
          htmlFormInputControl = "text";
          return htmlFormInputControl;
        }
        switch (dataType) {
          case "VARCHAR":
          case "VARCHAR2":
          case "NVARCHAR2":
          case "CHAR":
          case "NCHAR":
            if (this.getDataLength()>64) {
              htmlFormInputControl = "textarea"; // DECLARE CONSTANT
            }
            else {
              htmlFormInputControl = "text";
            }
            break;
          case "NUMBER":
            htmlFormInputControl = "text";
            break;
          case "DATE":
            if (this.getName().toLowerCase().contains("time")) {
              htmlFormInputControl = "datetime-local";
            }
            else {
              htmlFormInputControl = "date"; 
            }
            break;
          case "TIMESTAMP":
            htmlFormInputControl = "datetime-local";
            break;
          case "CLOB":
            htmlFormInputControl = "textarea";
            break;
          default:
            htmlFormInputControl = "text";
            break;
        }
      }
      return htmlFormInputControl; // "text"; // DECLARE CONSTANT
    }

    public String getDataType() {
      try {
        return this.getDbUserTableColumn().getDataType();
      }
      catch (NullPointerException e) {
        out.println("FieldMeta.getDataType() threw NullPointerException");
        return null;
      }
    }
    public int getDataLength() {
      if (getDbUserTableColumn() == null) return 20;
      return this.getDbUserTableColumn().getDataLength();
    }
    public int getDataPrecision() {
      if (getDbUserTableColumn() == null) return 10;
      return this.getDbUserTableColumn().getDataPrecision();
    }
    public int getDataScale() {
      if (getDbUserTableColumn() == null) return 2;
      return this.getDbUserTableColumn().getDataScale();
    }
    public boolean isRequired() {
      if (getDbUserTableColumn() == null) return this.isRequiredField();
      return this.getDbUserTableColumn().getNullable().equals("N");
    }
    public int getOrdinal() {
      if (getDbUserTableColumn() == null) return 10;
      return this.getDbUserTableColumn().getColumnId();
    }
    public String getDataDefault() {
      if (getDbUserTableColumn() == null) return null;
      return this.getDbUserTableColumn().getDataDefault();
    }
    
    public boolean isPrimitiveOrWrapper () { 
      if (field.getType().getName().indexOf(PERIOD) < 0 ) return true;
      if (field.getType().getName().startsWith(JAVA_PACKAGE)) return true;
      else return false;
    }
    public String getDeclaringClassName() { return this.field.getDeclaringClass().getSimpleName(); }
    public String getName() { return this.field.getName(); }
    public Class getType() { return this.field.getType(); }
    public boolean isEmbeddedId() {
      for (String annotation: fieldAnnotationList) {
        if (annotation.contains(ANNOTATION_EMBEDDED_ID)) return true;
      }
      return false;
    }
    public boolean isId() {
      for (String annotation: fieldAnnotationList) {
        if (annotation.contains(ANNOTATION_ID)) return true;
      }
      return false;
    }
    public String getAnnotationNameAttribute (String annotationToken) {
      String returnValue = null;
      for (String annotation: fieldAnnotationList) {
        int indexOfAnnotation = annotation.indexOf(annotationToken);
        if (indexOfAnnotation < 0) continue;
        int indexOfName = annotation.indexOf(ANNOTATION_ATTRIBUTE_NAME, indexOfAnnotation);
        if (indexOfName < 0) continue;
        int indexOfOpenQuote = annotation.indexOf("\"", indexOfName); 
        if (indexOfOpenQuote < 0) continue;
        int indexOfCloseQuote = annotation.indexOf("\"", indexOfOpenQuote+1); 
        returnValue = annotation.substring(indexOfOpenQuote, indexOfCloseQuote);
        break;
      }
      return returnValue;
    }
    
    public String getAnnotationAttribute (String annotationToken) {
      for (String annotation: fieldAnnotationList) {
        int indexOfAnnotation = annotation.indexOf(annotationToken);
        if (indexOfAnnotation >= 0) {
          //out.println("FieldMeta.getAnnotationAttribute() found annotation "+ annotationToken + " on " + EntityMeta.this.getSimpleName() + "." + this.getName());
          return annotation;
        }
      }
      return null;
    }
    
    public String getAnnotationAttributeValue (String annotationToken, String attribute) {
      String returnValue = null;
      for (String annotation: fieldAnnotationList) {
        int indexOfAnnotation = annotation.indexOf(annotationToken);
        if (indexOfAnnotation < 0) continue;
        int indexOfAttribute = annotation.indexOf(attribute, indexOfAnnotation);
        if (indexOfAttribute < 0) continue;
        int indexOfTrue = annotation.indexOf("true", indexOfAttribute);
        if (indexOfTrue > 1) return "true";
        int indexOfFalse = annotation.indexOf("false", indexOfAttribute);
        if (indexOfFalse > 1) return "false";
        int indexOfOpenQuote = annotation.indexOf("\"", indexOfAttribute); 
        if (indexOfOpenQuote < 0) continue;
        int indexOfCloseQuote = annotation.indexOf("\"", indexOfOpenQuote+1); 
        returnValue = annotation.substring(indexOfOpenQuote+1, indexOfCloseQuote);
        break;
      }
      return returnValue;
    }
    
    List<EntityMeta> getPkReferencedEntityMetas () {
      return pkReferencedEntityMetas;
    }
    
    public boolean isExcludedFromParentModule () {
      return (this.getAnnotationAttribute(ANNOTATION_EXCLUDED_EDIT_FROM_PARENT_MODULE) != null);
    }
    public String getLabel() {
      return getLabel(null);
    }
    public String getLabel(EntityMeta drivingEntityMeta) {
      if (this.isEmbeddedId() & drivingEntityMeta != null) {
//        EntityMeta embeddedEntityMeta = EntityMeta.this;
        //for (EntityMeta refdEntityMeta: embeddedEntityMeta.getPkReferencedEntityMetas()) {
        for (EntityMeta refdEntityMeta: this.getPkReferencedEntityMetas()) {
          if (!refdEntityMeta.equals(drivingEntityMeta)) { // Because we want the name of the OTHER entity
            return refdEntityMeta.getLabel();
          }
        }
      }
      if (this.label == null) {
        this.label = getAnnotationAttributeValue (ANNOTATION_LABEL, ANNOTATION_ATTRIBUTE_NAME);
        if (this.label == null) {
          String tempLabel = this.getAnnotationAttributeValue (ANNOTATION_COLUMN, ANNOTATION_ATTRIBUTE_NAME);
          if (tempLabel == null) {
//            try {
              this.label = EntityMeta.getCollectionEnclosedEntityMeta (this).getEntityMeta().getLabel();
//            } catch (NullPointerException e)  {}
            if (this.label == null) {
              this.label = this.getResolvedIdentifier();
            }
          }
          else {
            String[] labelWords = tempLabel.split("_");
            tempLabel = "";
            for (int i=0; i<labelWords.length; i++) {
              if (i>0) tempLabel += " ";
              tempLabel += labelWords[i].substring(0, 1).toUpperCase() + labelWords[i].substring(1).toLowerCase(); 
            }
            this.label = tempLabel;
          }
        }
      }
      return this.label;
    }
    public boolean isRequiredField() {
      try {
        return this.getAnnotationAttributeValue (ANNOTATION_BASIC, "optional").equals("false");
      }
      catch (NullPointerException e) {
        return false;
      }
    }
    
    
    public boolean isEmbeddedIdMemberField() {
      if (EntityMeta.this.hasEmbeddedId()) {
        for (FieldMeta pkField: EntityMeta.this.getEmbeddedIdFields()) {
          if (pkField.getName().equals(this.getResolvedIdentifier())) {
//            out.println("FieldMeta.isEmbeddedIdMemberField returning true: "+ this.getResolvedIdentifier());
            return true;
          }
        }
      }
      return false;
    }
    public boolean isLastEmbeddedIdMemberField() {
      if (!this.isEmbeddedIdMemberField()) return false;
      FieldMeta pkField = null;
      FieldMeta[] pkFields = EntityMeta.this.getEmbeddedIdFields();
      for (int i=0; i<pkFields.length; i++) {
        pkField = pkFields[i];
      }
      if (this.getResolvedIdentifier().equals(pkField.getResolvedIdentifier())) return true;
      else return false;
    }
    
    public boolean isColumnOrJoinColumn() {
      for (String annotation: fieldAnnotationList) {
        if (annotation.contains(ANNOTATION_COLUMN) | annotation.contains(ANNOTATION_JOIN_COLUMN)) return true;
      }
      return false;
    }
    public String getResolvedIdentifier() {
//      out.println("FieldMeta["+ getName() +"].getResolvedIdentifier()");
      String returnValue = null;
      for (String annotationLine: fieldAnnotationList) {
        if (annotationLine.contains(ANNOTATION_JOIN_COLUMN)) {
          String annotationAttributeValue = EntityMeta.getAnnotationAttributeValue(ANNOTATION_JOIN_COLUMN, ANNOTATION_ATTRIBUTE_NAME, annotationLine);
          if (annotationAttributeValue != null) {
            returnValue = convertDBIdentifierToJava (annotationAttributeValue);
//            out.println("FieldMeta["+this.getName() +"].getResolvedIdentifier() returning " + returnValue);
            return returnValue;
          }
        }
//        if (returnValue == null && this.getType().getName().equals(DATATYPE_COLLECTION))
      }
      return this.getName();
    }
    public EntityMeta getEnclosingEntityMeta() {
      return EntityMeta.this;
    }

    public String[] getEmbeddedIdFieldIdentifiers() {
      if (!this.isEmbeddedId()) return null;
      String[] embeddedIdFieldNames = new String [embeddedPKInfo.fieldMetaArray.length];
      for (int i=0; i<embeddedPKInfo.fieldMetaArray.length; i++) {
        embeddedIdFieldNames[i] = embeddedPKInfo.fieldMetaArray[i].getResolvedIdentifier();
      }
      return embeddedIdFieldNames;    
    }
  
    public FieldMeta[] getEmbeddedIdFields() {
      if (!this.isEmbeddedId()) return null;
      return embeddedPKInfo.fieldMetaArray;
//      String[] embeddedIdFieldNames = new String [embeddedPKInfo.fieldMetaArray.length];
//      for (int i=0; i<embeddedPKInfo.fieldMetaArray.length; i++) {
//        embeddedIdFieldNames[i] = embeddedPKInfo.fieldMetaArray[i].getResolvedIdentifier();
//      }
//      return embeddedIdFieldNames;    
    }
  
  
  }
  // END INNER CLASS FieldMeta
  
  
  public FieldMeta[] getFieldMetaArray() { return this.fieldMetaArray;}
  
  protected EntityMeta (String className, DbUserTableColumnRepository dbUserTableColumnRepository) 
  {
    this.className = className;
    this.dbUserTableColumnRepository = dbUserTableColumnRepository;
    out.println("EntityMeta constructor: this.dbUserTableColumnRepository = " + this.dbUserTableColumnRepository);
  } 
  
//  private EntityMeta (String className) 
//  {
//    this.className = className;
//    out.println("EntityMeta constructor: this.dbUserTableColumnRepository = " + this.dbUserTableColumnRepository);
//  } 
  
  public String getSimpleName () {return this.subjectClass.getSimpleName(); }
  
//  public static EntityMeta getEntityMeta (String className) throws IOException { // Only for existing ones
////    return getEntityMeta (className, GenJavaServiceImpl.getDbUserTableColumnRepository(), null); 
//    return getEntityMeta (className, null); 
////    return entityMetaMap.get(className);
//  }
//
//// DEPRECATED 2018.06.03
////  public static EntityMeta getEntityMeta (String className, DbUserTableColumnRepository dbUserTableColumnRepository) throws IOException {
////    return getEntityMeta (className, dbUserTableColumnRepository, null); 
////  }
//  
//  
////  public static EntityMeta getEntityMeta (String className, DbUserTableColumnRepository dbUserTableColumnRepository, String requiredClassAnnotation) throws IOException {
//  public static EntityMeta getEntityMeta (String className, String requiredClassAnnotation) throws IOException {
////    out.println("public static EntityMeta getEntityMeta (" + className +")");
//    // DEBUG
////    out.println("");
////    out.println("PRINTING entityMetaMap:");
////    for (EntityMeta entityMetaX: entityMetaMap.values() )
////      out.println(entityMetaX.toString());
//    // END DEBUG
//    EntityMeta entityMeta = entityMetaMap.get(className);
//    if (entityMeta == null ) {
//      out.println ("entityMeta " + className + " not found. Creating new...");
//      ArrayList<Field> fieldList = null;
////      entityMeta = new EntityMeta(className, dbUserTableColumnRepository);
//      entityMeta = new EntityMeta(className);
//      try {
//        entityMeta.subjectClass = Class.forName(className);
//        entityMetaMap.put(entityMeta.className, entityMeta);
////        out.println("subjectClass = " + entityMeta.subjectClass);
////        out.println("subjectClass.getName() = " + entityMeta.subjectClass.getName());
////        out.println("subjectClass.getSimpleName() = " + entityMeta.subjectClass.getSimpleName());
////        out.println("subjectClass.getDeclaredFields() = " + entityMeta.subjectClass.getDeclaredFields());
////        entityMeta.fields = entityMeta.subjectClass.getDeclaredFields();
//      } catch (ClassNotFoundException e) {
//        out.println("Sorry, ClassNotFoundException trying to load " + entityMeta.subjectClass +".");
//      }
//      
//      Path classFile = Paths.get(className.replace('.', '/')+".java");
//      out.println("Processing Model/Entity class: " + classFile);
//      String fileLine = null;
//      try (BufferedReader reader = Files.newBufferedReader(classFile)){
//        while ((fileLine = reader.readLine())!=null) {
//          entityMeta.sourceCodeLines.add(fileLine); 
//        }
//      }
//      catch (IOException e){
//        out.println("Sorry, could not read file " + className.replace('.', '/')+".java");
//        throw e;
//      }
//      
//      // Get class annotations
//      for (int i=0; i<entityMeta.sourceCodeLines.size(); i++) {
//        if (entityMeta.sourceCodeLines.get(i).contains("public class " + entityMeta.subjectClass.getSimpleName())) {
//          for (int j=i-1; j>0; j--) {
//            if (entityMeta.sourceCodeLines.get(j).trim().startsWith(AT_SIGN)) {
//              out.println("Found class annotation: " + entityMeta.sourceCodeLines.get(j));
//              entityMeta.classAnnotationList.add(entityMeta.sourceCodeLines.get(j));
//            }
//            else break;
//          }
//        }
//      }
////      out.println("classAnnotationList = " + entityMeta.classAnnotationList);
//      
//      String searchField = null;
//      ArrayList<String> annotationList = null;
//      entityMeta.fieldMetaArray = new FieldMeta[entityMeta.subjectClass.getDeclaredFields().length]; 
//      int fieldNo = 0;
//      for (Field field: entityMeta.subjectClass.getDeclaredFields()) {
//        FieldMeta fieldMeta = entityMeta.new FieldMeta(field);
////        if (fieldMeta.isId()) entityMeta.idField = fieldMeta;
//        annotationList = new ArrayList<>();
//        searchField = " " + field.getName();
//        for (int i=0; i<entityMeta.sourceCodeLines.size(); i++) {
//          //out.println("Searching for  '" + searchField + "'");
//          if (entityMeta.sourceCodeLines.get(i).contains(searchField)) {
////            out.println("");
////            out.println("Found searchField '" + searchField + "'");
////            out.println("entityMeta.sourceCodeLines.get(i) = '" + entityMeta.sourceCodeLines.get(i) + "'");
////            out.println("entityMeta.sourceCodeLines.get(j) = '" + entityMeta.sourceCodeLines.get(i-1) + "'");
//            
//            for (int j=i-1; j>0; j--) {
//              if (entityMeta.sourceCodeLines.get(j).trim().startsWith(AT_SIGN)) {
//                out.println("Found annotation: " + entityMeta.sourceCodeLines.get(j));
//                annotationList.add(entityMeta.sourceCodeLines.get(j));
//              }
//              else break;
//            }
//          }          
//        }
//        fieldMeta.fieldAnnotationList = annotationList;
//        entityMeta.fieldMetaMap.put(field.getName(), fieldMeta);
//        entityMeta.fieldMetaArray[fieldNo++] = fieldMeta; 
//      }
//    }
////    for (Field field: entityMeta.subjectClass.getDeclaredFields()) {
//    if (entityMeta.fieldMetaArray != null) {
//      for (FieldMeta fieldMeta: entityMeta.fieldMetaArray) {
//  //      if (entityMeta.isEmbeddedId(fieldMeta)) {
//        if (fieldMeta.isEmbeddedId()) {
//          out.println("fieldMeta " + fieldMeta.getName() + " is an Embedded ID.");
//  //        entityMeta.embeddedPKInfo = EntityMeta.getEntityMeta(className).getEntityMeta(field.getDeclaringClass().getSimpleName(), ANNOTATION_EMBEDDABLE);
//  //        out.println("fieldMeta.getDeclaringClassName() = " + fieldMeta.getDeclaringClassName());
//  //        entityMeta.embeddedPKInfo = EntityMeta.getEntityMeta(MODEL_PACKAGE+"." + fieldMeta.getDeclaringClassName(), ANNOTATION_EMBEDDABLE);
//  //        out.println("entityMeta.getClassName() = " + entityMeta.getClassName());
//  //        out.println("entityMeta number of fields = " + entityMeta.getFieldMetaArray().length);
//  //        out.println("fieldMeta.getType().getName() = " + fieldMeta.getType().getName());
//
//          //entityMeta.setEmbeddedPKInfo(EntityMeta.getEntityMeta(fieldMeta.getType().getName(), dbUserTableColumnRepository, ANNOTATION_EMBEDDABLE));
//          entityMeta.setEmbeddedPKInfo(EntityMeta.getEntityMeta(fieldMeta.getType().getName(), ANNOTATION_EMBEDDABLE));
//
//          //        entityMeta.embeddedPKInfo = EntityMeta.getEntityMeta(fieldMeta.getDeclaringClassName(), ANNOTATION_EMBEDDABLE);
//          if (entityMeta.getEmbeddedPKInfo() != null) {
//            entityMeta.setEmbeddedPKInfoClassName(entityMeta.getEmbeddedPKInfo().getClassName());
//            entityMeta.getEmbeddedPKInfo().isEmbeddedPkInfo=true;
//            entityMetaMap.put(entityMeta.getEmbeddedPKInfo().getClassName(), entityMeta.getEmbeddedPKInfo());
//            entityMetaMap.put(entityMeta.className, entityMeta);
//          }
//        }
//      }
//    }
////    entityMetaMap.put(entityMeta.className, entityMeta);
////    if (requiredClassAnnotation == null | entityMeta.classAnnotationsContain(requiredClassAnnotation)) {
//    if (requiredClassAnnotation != null & (!entityMeta.classAnnotationsContain(requiredClassAnnotation))) {
//      return null;
//    } else  { 
//      return entityMeta;
//    }
//  }
  
  public boolean isEmbeddedPkInfo() {
    return isEmbeddedPkInfo;
  }

  
  public void setEmbeddedPKInfoClassName(String embeddedPKInfoClassName) 
  {  
    this.embeddedPKInfoClassName = embeddedPKInfoClassName;
  }  
  public String getEmbeddedPKInfoClassName() {return this.embeddedPKInfoClassName;}  
  
  public void setEmbeddedPKInfo(EntityMeta embeddedPKInfo) 
  { 
//    out.println("EntityMeta[" + this.getSimpleName() + "].setEmbeddedPKInfo(" + embeddedPKInfo + ")");
    this.embeddedPKInfo = embeddedPKInfo;
    if (embeddedPKInfo != null) {
      embeddedPKInfo.embeddingEntityMeta = this;
      this.pkFkRefClassFieldMap = new HashMap<>();
      this.pkReferencedEntityMetas = new ArrayList<>();
      for (FieldMeta field: this.fieldMetaArray) {
  //      for (String embeddedField: embeddedPKInfo.getEmbeddedIdFieldIdentifiers()) {
        for (String embeddedField: this.getEmbeddedIdFieldIdentifiers()) {
          if (field.getResolvedIdentifier().equals(embeddedField)) {
            pkFkRefClassFieldMap.put(field.getName(), embeddedField);
          }
        }
        for (FieldMeta embeddedFieldMI: this.getEmbeddedIdFields()) {
          if (field.getResolvedIdentifier().equals(embeddedFieldMI.getResolvedIdentifier())) {
            //pkFkRefClassFieldMap.put(field.getName(), embeddedField);
            try {
//              out.println("embeddedFieldMI.getName() = " + embeddedFieldMI.getName());
//              out.println("field.getType().getName() = " + field.getType().getName());
//              this.pkReferencedEntityMetas.add(EntityMeta.getEntityMeta(embeddedFieldMI.getType().getName()));
              this.pkReferencedEntityMetas.add(EntityMetaFactoryImpl.entityMetaFactoryImplX.getEntityMeta(field.getType().getName()));
            } catch (IOException e) {
              out.println ("setEmbeddedPKInfo threw IOException!");
            }
            }
        }
      }
    }
  }
  public EntityMeta getEmbeddedPKInfo() { 
    if (this.embeddedPKInfo==null & this.getEmbeddedPKInfoClassName()!=null) // WHY THE @#$% THIS CONDITION SHOULD OCCUR STILL ELUDES ME AFTER TOO MANY HOURS!
    try {
//      this.setEmbeddedPKInfo(getEntityMeta(getEmbeddedPKInfoClassName(), dbUserTableColumnRepository));
//      this.setEmbeddedPKInfo(getEntityMeta(getEmbeddedPKInfoClassName()));
      this.setEmbeddedPKInfo(EntityMetaFactoryImpl.entityMetaFactoryImplX.getEntityMeta(getEmbeddedPKInfoClassName()));
    } catch (IOException e) {
//      out.println ("public EntityMeta getEmbeddedPKInfo(["+ this.getEmbeddedPKInfoClassName() +"]) threw IOException.");
    }
    return this.embeddedPKInfo;
  }
  
  public Map<String, String> getPkFkRefClassFieldMap() {
    out.println("getPkFkRefClassFieldMap: " + this.pkFkRefClassFieldMap);
    return this.pkFkRefClassFieldMap;
  }
  
  
  public String getClassName() {return this.className;}
  public Class getSubjectClass() {return this.subjectClass;}
  public String getDbTableName() {
    if (tableName == null) {
      tableName = EntityMeta.this.getAnnotationAttributeValue(ANNOTATION_TABLE, ANNOTATION_ATTRIBUTE_NAME);
    }
    return this.tableName;
  }
  public Field[] getFields() {return this.subjectClass.getDeclaredFields();}
  public FieldMeta getFieldMeta (String fieldName) { return this.fieldMetaMap.get(fieldName); }
  public ArrayList<String> getSourceCodeLines() {return this.sourceCodeLines;}
//  public Map<String, ArrayList<String>> getFieldAnnotationList() {return this.fieldAnnotationList;}
  public boolean foundFieldAnnotation(String fieldName, String annotation) {
//    out.println("EntityMeta.foundFieldAnnotation([instance])");
    return (this.fieldMetaMap.get(fieldName).fieldAnnotationList.contains(annotation));
  }
  
//  public boolean isEmbeddedId(FieldMeta fieldMeta) {
//    return fieldMeta.isEmbeddedId();
////    return this.foundFieldAnnotationContains(fieldMeta.getName(), ANNOTATION_EMBEDDED_ID);
//  }
  
  public boolean hasEmbeddedId() {
    for (FieldMeta fieldMeta: this.getFieldMetaArray()) {
      if (fieldMeta.isEmbeddedId()) {
        return true;
      } 
    }
    return false;
  }
  
  public boolean fieldIsPrimitiveOrWrapper (String fieldName){ 
    FieldMeta fieldMeta = this.getFieldMeta(fieldName);
    if (fieldMeta == null) return false;
    if (fieldMeta.getType().getName().indexOf(PERIOD) < 0 ) return true;
    if (fieldMeta.getType().getName().startsWith(JAVA_PACKAGE)) return true;
    else return false;
  }
   
//  public static boolean foundFieldAnnotation(Field field, String annotation) {
//    out.println("EntityMeta.foundFieldAnnotation([static]): field name = " + field.getName() + "; Declaring class= " + field.getDeclaringClass().getTypeName());
//    try {
//      EntityMeta testEntityMeta = getEntityMeta(field.getDeclaringClass().getTypeName());
//      return (testEntityMeta.foundFieldAnnotationContains(field.getName(), annotation));
//    } catch (IOException e) {
//      out.println("ERROR: EntityMeta.foundFieldAnnotation() could not open source code file for " + field.getDeclaringClass().getTypeName());
//      return false;
//    }
//  }
  
//  public static boolean foundClassAnnotation(Class testClass, String annotation) {
////    out.println("EntityMeta.foundClassAnnotation([static]): class name = " + testClass.getSimpleName());
//    try {
//      EntityMeta testEntityMeta = getEntityMeta(testClass.getName());
//      return (testEntityMeta.classAnnotationsContain(annotation));
//    } catch (IOException e) {
////      out.println("ERROR: EntityMeta.foundClassAnnotation() could not open source code file for " + testClass.getSimpleName());
//      return false;
//    }
//  }
  
  public boolean foundFieldAnnotationContains(String fieldName, String annotation) {
    ArrayList<String> annotationList = this.fieldMetaMap.get(fieldName).fieldAnnotationList;
    for (String fieldAnnotation: annotationList) {
      if (fieldAnnotation.contains(annotation)) return true;
    }
    return false;
  }

  
//  public static boolean foundFieldAnnotationContains(Class testClass, String annotation) {
//    ArrayList<String> annotationList = null;
//    try {
//      EntityMeta testEntityMeta = getEntityMeta(testClass.getName());
//      Field[] fields = testEntityMeta.getFields();
//      for (Field field: fields) {
//        annotationList = testEntityMeta.fieldMetaMap.get(field.getName()).fieldAnnotationList;;
//        for (String fieldAnnotation: annotationList) {
//          if (fieldAnnotation.contains(annotation)) { 
////            out.println("EntityMeta.foundFieldAnnotationContains(" + annotation + ") returning true.");
//            return true;
//          }
//        }
//      }
//    } catch (IOException e) {
////      out.println("ERROR: EntityMeta.foundFieldAnnotationContains(\" + annotation + \") threw IOException trying to process " + testClass.getSimpleName());
//    }
//      return false;
//  }
  

  public boolean classAnnotationsContain(String annotation) {
    if (annotation == null) return false;
    for (String classAnnotation: classAnnotationList) {
      if (classAnnotation == null) continue; // WHY SHOULD THIS CONDITION OCCUR?
      if (classAnnotation.contains(annotation)) return true;
    }
    return false;
  }
  
  public static String convertDBIdentifierToJava (String dbIdentifier) {
//    out.println("convertDBIdentifierToJava(" + dbIdentifier + ")");
    String javaIdentifier = "";
    StringTokenizer tokenizer = new StringTokenizer (dbIdentifier, "_");
    boolean firstIteration = true;
    String token = null;
    while (tokenizer.hasMoreTokens()) {
      token = tokenizer.nextToken();
//      out.println("convertDBIdentifierToJava(" + dbIdentifier + ")");
      if (firstIteration) {
        javaIdentifier += token.toLowerCase();  
      } else {
        javaIdentifier += token.substring(0, 1).toUpperCase() + token.substring(1).toLowerCase();  
      }
      firstIteration = false;
    }
    return javaIdentifier;
  }
  
  
  public static String getAnnotationAttributeValue (String annotation, String attribute, String codeLine) {
//    out.println("getAnnotationAttributeValue (" + annotation + ", " + attribute + ", " + codeLine + ")");
    String annotationAttributeValue = null;
    int indexOfAnnotation = codeLine.indexOf(annotation);
//    out.println("indexOfAnnotation= " + indexOfAnnotation);
    if (indexOfAnnotation < 0) return null;
    
    int annotationLength = annotation.length();
    int indexOfAttribute = codeLine.indexOf(attribute, annotationLength);
//    out.println("annotationLength= " + annotationLength);
//    out.println("indexOfAttribute= " + indexOfAttribute);

    if (indexOfAttribute < annotationLength) return null;

    int indexOfOpenParenthesis = codeLine.indexOf('(', indexOfAnnotation);
    int indexOfCloseParenthesis = codeLine.indexOf(')', indexOfAttribute);
//    out.println("indexOfOpenParenthesis= " + indexOfOpenParenthesis);
//    out.println("indexOfCloseParenthesis= " + indexOfCloseParenthesis);
    
    if (!(indexOfOpenParenthesis >= (indexOfAnnotation+annotationLength) & indexOfOpenParenthesis < (indexOfAnnotation+annotationLength + 2))) return null;

    int indexOfOpenQuote = codeLine.indexOf('"', indexOfAnnotation);
    int indexOfCloseQuote = codeLine.indexOf('"', indexOfOpenQuote+1);
//    out.println("indexOfOpenQuote= " + indexOfOpenQuote);
//    out.println("indexOfCloseQuote= " + indexOfCloseQuote);

    if ((indexOfCloseQuote < indexOfOpenQuote)) return null;
    
    annotationAttributeValue = codeLine.substring(indexOfOpenQuote+1, indexOfCloseQuote);
//    out.println("annotationAttributeValue (" + annotation + ", " + attribute + ") = " + annotationAttributeValue);
    return annotationAttributeValue;
  }
  
  public FieldMeta[] getEmbeddedIdFields() {
    //out.println("getEmbeddedIdFields");
    if (this.embeddedPKInfo == null) return null;
    return embeddedPKInfo.fieldMetaArray;    
  }
  
  public String[] getEmbeddedIdFieldIdentifiers() {
//    out.println("getEmbeddedIdFieldIdentifiers");
//    out.println("this.getSimpleName() = " + this.getSimpleName());
//    out.println("this.embeddedPKInfo = " + this.embeddedPKInfo);
    if (this.embeddedPKInfo == null) return null;
    String[] embeddedIdFieldNames = new String [embeddedPKInfo.fieldMetaArray.length];
    for (int i=0; i<embeddedPKInfo.fieldMetaArray.length; i++) {
      embeddedIdFieldNames[i] = embeddedPKInfo.fieldMetaArray[i].getResolvedIdentifier();
    }
    return embeddedIdFieldNames;    
  }
  
  public String[] getEmbeddedIdRefEntityIdentifiers() {
    out.println("getEmbeddedIdRefEntityIdentifiers");
    if (this.embeddedPKInfo == null) return null;
    String[] embeddedIdFieldIdentifiers = getEmbeddedIdFieldIdentifiers();
    String[] embeddedIdRefEntityIdentifiers = new String[embeddedIdFieldIdentifiers.length];
    
    int i=0;
    for (String embeddedIdField: embeddedIdFieldIdentifiers){
      out.println("embeddedIdField = " + embeddedIdField);
      for (FieldMeta field: this.getFieldMetaArray()) {
        if (field.getResolvedIdentifier().equals(embeddedIdField)){
          out.println("field.getResolvedIdentifier() = " + field.getResolvedIdentifier());
          embeddedIdRefEntityIdentifiers[i] = field.getType().getSimpleName();
          break;
        }
      }
      i++;
    }
    return embeddedIdRefEntityIdentifiers;
  }
  
  public EntityMeta[] getEmbeddedIdRefEntities() {
    out.println("getEmbeddedIdRefEntities");
    if (this.embeddedPKInfo == null) return null;
    String[] embeddedIdFieldIdentifiers = getEmbeddedIdFieldIdentifiers();
    EntityMeta[] embeddedIdRefEntities = new EntityMeta[embeddedIdFieldIdentifiers.length];
    
    int i=0;
    for (String embeddedIdField: embeddedIdFieldIdentifiers){
      //out.println("embeddedIdField = " + embeddedIdField);
      for (FieldMeta field: this.getFieldMetaArray()) {
        if (field.getResolvedIdentifier().equals(embeddedIdField)){
          //out.println("field.getResolvedIdentifier() = " + field.getResolvedIdentifier());
          try {
            embeddedIdRefEntities[i] = EntityMetaFactoryImpl.entityMetaFactoryImplX.getEntityMeta(field.getType().getName());
          } catch (IOException e) {
            out.println ("getEmbeddedIdRefEntities SHOULD NEVER THROW THIS IOException!!!");
          }
          //break;
        }
      }
      i++;
    }
    return embeddedIdRefEntities;
  }
  
  public FieldMeta getFirstNonKeyRequiredField() {
    for (FieldMeta field: this.fieldMetaArray) {
      if (field.isRequiredField() & (!field.isId()) & (!field.isEmbeddedId()))
        return field;
    }
    return null;
  }
  
  public String getFirstNonKeyRequiredFieldName() {
    try {
      return this.getFirstNonKeyRequiredField().getName();
    }
    catch (NullPointerException e) {
      return null;
    }
  }

  public String getAnnotationAttributeValue (String annotationToken, String attribute) {
    String returnValue = null;
    for (String annotation: this.classAnnotationList) {
      int indexOfAnnotation = annotation.indexOf(annotationToken);
      if (indexOfAnnotation < 0) continue;
      int indexOfAttribute = annotation.indexOf(attribute, indexOfAnnotation);
      if (indexOfAttribute < 0) continue;
      int indexOfTrue = annotation.indexOf("true", indexOfAttribute);
      if (indexOfTrue > 1) return "true";
      int indexOfFalse = annotation.indexOf("false", indexOfAttribute);
      if (indexOfFalse > 1) return "false";
      int indexOfOpenQuote = annotation.indexOf("\"", indexOfAttribute); 
      if (indexOfOpenQuote < 0) continue;
      int indexOfCloseQuote = annotation.indexOf("\"", indexOfOpenQuote+1); 
      returnValue = annotation.substring(indexOfOpenQuote+1, indexOfCloseQuote);
      break;
    }
    return returnValue;
  }
  public String getLabel() {
    if (this.label == null) {
      this.label = getAnnotationAttributeValue (ANNOTATION_LABEL, ANNOTATION_ATTRIBUTE_NAME);
      if (this.label == null) {
        String tempLabel = this.getAnnotationAttributeValue (ANNOTATION_TABLE, ANNOTATION_ATTRIBUTE_NAME);
        if (tempLabel == null) {
          this.label = this.getSimpleName();
        }
        else {
          String[] labelWords = tempLabel.split("_");
          tempLabel = "";
          for (int i=0; i<labelWords.length; i++) {
            if (i>0) tempLabel += " ";
            tempLabel += labelWords[i].substring(0, 1).toUpperCase() + labelWords[i].substring(1).toLowerCase(); 
          }
          this.label = tempLabel;
        }
      }
    }
    return this.label;
  }
  
  public static TempEntityMeta getCollectionEnclosedEntityMeta (EntityMeta.FieldMeta testField) { 
    List<TempEntityMeta> collectionOfEntityMetaList = getCollectionEnclosedEntityMetas (testField, 1); 
    return (collectionOfEntityMetaList !=null?collectionOfEntityMetaList.get(0):null);
  }
  
  public static List<TempEntityMeta> getCollectionEnclosedEntityMetas (EntityMeta.FieldMeta testField) { 
    return getCollectionEnclosedEntityMetas (testField, 99); 
   }
     
  public static List<TempEntityMeta> getCollectionEnclosedEntityMetas (EntityMeta.FieldMeta testField, int limit) {
   //out.println("getCollectionEnclosedClasses");
   if (!(testField.getType().getName().equals(DATATYPE_COLLECTION))) { return null; }
   List<TempEntityMeta> collectionOfEntityMetaList = new ArrayList<>();
   EntityMeta enclosedClassInfo;
   EntityMeta enclosedFKRefClassInfo;
   TempEntityMeta tempEntityMeta;
   TempEntityMeta tempEnclosedFKRefClassInfo;
   boolean xReferenced = false;
     //out.println("isCollection() " + testField.getName());
     String collectionOfClassName = getEnclosedType(testField);
     try {
       enclosedClassInfo = EntityMetaFactoryImpl.entityMetaFactoryImplX.getEntityMeta(MODEL_PACKAGE+"."+collectionOfClassName);
       if (enclosedClassInfo == null) return null;
       tempEntityMeta = new TempEntityMeta(enclosedClassInfo);
       if (enclosedClassInfo.hasEmbeddedId()) {
         xReferenced = true;
       }
       tempEntityMeta.setXReferenced(xReferenced);
       collectionOfEntityMetaList.add(tempEntityMeta);
       if (limit == 1) return collectionOfEntityMetaList;
       EntityMeta.FieldMeta[] fields = enclosedClassInfo.getFieldMetaArray();
       enclosedFKRefClassInfo = null;
       for (EntityMeta.FieldMeta field: fields) {
//         if (!isPrimitiveOrWrapper(field)) {
         if (!(field.isPrimitiveOrWrapper())) {
           out.println( "  FK Ref Field from child enclosed class = " + field.getResolvedIdentifier());
          out.println( "    FK Ref Field Type = " + field.getType().getName());
           enclosedFKRefClassInfo = EntityMetaFactoryImpl.entityMetaFactoryImplX.getEntityMeta(field.getType().getName(), ANNOTATION_ENTITY);
           if (enclosedFKRefClassInfo != null) {
             tempEnclosedFKRefClassInfo = new TempEntityMeta(enclosedFKRefClassInfo);
             tempEnclosedFKRefClassInfo.setXReferenced(xReferenced); 
             tempEnclosedFKRefClassInfo.setThirdEntity(true); 
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
     return null; // Unreachable Dummy statement to satisfy compiler
   }

  public static String getEnclosedType (EntityMeta.FieldMeta field) { // SHOULDN'T THIS BE MOVED TO CLASS EntityMeta??
     String fieldName = field.getName();
     String drivingEntityClassName = field.getDeclaringClassName();
     fieldName = fieldName.substring(0,1).toUpperCase()+fieldName.substring(1);
     if (fieldName.indexOf(COLLECTION) > 1) {
       fieldName = fieldName.substring(0, fieldName.indexOf(COLLECTION));
     }
     String genericClassName = enclosedTypesMap.get(fieldName);
     if (genericClassName != null) return genericClassName;
     
     
     Path file = Paths.get(PATH_TO_MODEL_JAVA_FILES, drivingEntityClassName +".java");
     String fileLine = null;
     int indexOfKeyword = -1;
     int indexEndKeyword = -1;
     int indexOfFieldName = -1;
     int indexOfOpenBracket = -1;
     int indexOfCloseBracket = -1;
     
     try (BufferedReader reader = Files.newBufferedReader(file)){
       while ((fileLine = reader.readLine())!=null) {
         indexOfFieldName = fileLine.indexOf(fieldName);
         if (indexOfFieldName >= 0) {
           indexOfKeyword = fileLine.indexOf(COLLECTION+"<");
           if (indexOfKeyword > 0) {
             indexEndKeyword =  indexOfKeyword + COLLECTION.length()+1;
               indexOfOpenBracket  = fileLine.indexOf("<");
                 indexOfCloseBracket = fileLine.indexOf(">");
                 if ((indexOfCloseBracket - indexOfFieldName)  > 1) {
                   genericClassName = fileLine.substring(indexOfOpenBracket+1, indexOfCloseBracket);
                   enclosedTypesMap.put(fieldName, genericClassName);
                   break;
                 }
               }
             }
       }
     }
     catch (IOException e){
       out.println("Sorry, could not read file " + file);
       return null;
     }
     return genericClassName;
   }
   
   public static String getEmbeddedIdEntityFindStatements(EntityMeta entityMetaWithEmbeddedPK) {
     StringBuilder stringB = new StringBuilder("");
     for (EntityMeta.FieldMeta field: entityMetaWithEmbeddedPK.getEmbeddedIdFields()) {
//       stringB.append(field.getDeclaringClassName())
     }
      return null;
   }
   
  @Override
  public String toString () {
    String returnString = "EntityMeta TO_STRING for " + this.getClassName() + "\n"
//                        + "  Fields = " + this.getSubjectClass().getDeclaredFields().toString() + "\n"
                        + "  Number of Fields = " + this.fieldMetaArray.length + "\n"
                        + "  embeddedPKInfo = " + (this.embeddedPKInfo!=null?this.embeddedPKInfo.getClassName():null) + "\n"
                        + "  embeddedPKInfoClassName = " + this.getEmbeddedPKInfoClassName() + "\n"
                        + " classAnnotationList = " + this.classAnnotationList + "\n"
//                        + "  sourceCodeLines = " + this.sourceCodeLines + "\n\n" 
//                        + "  Annotations = " + this.fieldAnnotationMapList
                        ;
  
        return returnString;
  }


}


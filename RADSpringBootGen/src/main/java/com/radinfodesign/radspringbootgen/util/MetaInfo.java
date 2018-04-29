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

import com.radinfodesign.metamodel.DbUserTableColumn;
import com.radinfodesign.radspringbootgen.dao.DbUserTableColumnRepository;

public class MetaInfo {
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
  public static final String ANNOTATION_JOIN_COLUMN = "@JoinColumn";
  public static final String ANNOTATION_BASIC = "@Basic";
  public static final String ANNOTATION_ENTITY = "@Entity";
  public static final String ANNOTATION_EXCLUDED_EDIT_FROM_PARENT_MODULE = "@ExcludeEditFromParentModule";
  public static final String ANNOTATION_ATTRIBUTE_NAME = "name";
  public static final String MODEL_PACKAGE = "com.radinfodesign.fboace.model";
  public static final String DATATYPE_COLLECTION = "java.util.Collection";

  private static Map<String, MetaInfo> metaInfoMap = new HashMap<>();
  
  // NOT @Autowired
  DbUserTableColumnRepository dbUserTableColumnRepository = null;

  private String className = null;
  private Class subjectClass = null;
  private String tableName = null;
  private ArrayList<String> sourceCodeLines = new ArrayList<>();
//  private Map<String, ArrayList<String>> fieldAnnotationMapList = new HashMap<>();
  private ArrayList<String> classAnnotationList = new ArrayList<>();
  private MetaInfo embeddedPKInfo = null;
  private MetaInfo embeddingMetaInfo = null;
  private boolean isEmbeddedPkInfo = false;
  private List<MetaInfo> pkReferencedMetaInfos = null;
  private String embeddedPKInfoClassName = null;
//  private Map<String, Field> fieldMap = new HashMap<>();
  private Map<String, FieldMetaInfo> fieldMetaInfoMap = new HashMap<>();
  private FieldMetaInfo[] fieldMetaInfoArray;
  private FieldMetaInfo idField;
  
  private Map<String, String> pkFkRefClassFieldMap = null;
  private String label;
  
  public FieldMetaInfo getIDField() { 
    if (this.idField != null) return this.idField;
    else { // Might not be set yet.
      if (this.getFieldMetaInfoArray() != null) {
        for (FieldMetaInfo field: this.getFieldMetaInfoArray()) {
          if (field.isId() | field.isEmbeddedId()) {
            this.idField = field;
            break;
          }
        }
      }
    }
    return this.idField; 
  }
    
  class FieldMetaInfo {
    Field field;
    ArrayList<String> fieldAnnotationList = new ArrayList<>();
    String label = null;
    String htmlFormInputControl = null; //"text"; // textarea, date, select
    DbUserTableColumn dbUserTableColumn = null;
    String dbTableColumnName = null;

    
//    int dataLength = 30;
//    int dataPrecision;
//    int dataScale;
//    boolean required = false;
//    int ordinal = 10;
//    String dataDefault = null;
    
    FieldMetaInfo (Field field) {
      this.field = field;
    }
    FieldMetaInfo() {    
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
        out.println("dbUserTableColumnRepository = " + MetaInfo.this.dbUserTableColumnRepository);
        try {
          this.dbUserTableColumn = dbUserTableColumnRepository.findOneByTableNameAndColumnName(MetaInfo.this.getDbTableName().toUpperCase(), this.getDbTableColumnName().toUpperCase());
        }
        catch (NullPointerException e) {
          out.println ("NullPointerException on dbUserTableColumnRepository: field = " + this.getResolvedIdentifier()); 
          out.println ("  MetaInfo.this.getDbTableName() = " + MetaInfo.this.getDbTableName()); 
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
        out.println("FieldMetaInfo.getDataType() threw NullPointerException");
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
          out.println("FieldMetaInfo.getAnnotationAttribute() found annotation "+ annotationToken + " on " + MetaInfo.this.getSimpleName() + "." + this.getName());
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
    
    List<MetaInfo> getPkReferencedMetaInfos () {
      return pkReferencedMetaInfos;
    }
    
    public boolean isExcludedEditFromParentModule () {
      return (this.getAnnotationAttribute(ANNOTATION_EXCLUDED_EDIT_FROM_PARENT_MODULE) != null);
    }
    public String getLabel() {
      return getLabel(null);
    }
    public String getLabel(MetaInfo drivingMetaInfo) {
      if (this.isEmbeddedId() & drivingMetaInfo != null) {
        MetaInfo embeddedMetaInfo = MetaInfo.this;
        //for (MetaInfo refdMetaInfo: embeddedMetaInfo.getPkReferencedMetaInfos()) {
        for (MetaInfo refdMetaInfo: this.getPkReferencedMetaInfos()) {
          if (!refdMetaInfo.equals(drivingMetaInfo)) { // Because we want the name of the OTHER entity
            return refdMetaInfo.getLabel();
          }
        }
//        return "Label";
      }
      if (this.label == null) {
        this.label = getAnnotationAttributeValue (ANNOTATION_LABEL, ANNOTATION_ATTRIBUTE_NAME);
        if (this.label == null) {
          String tempLabel = this.getAnnotationAttributeValue (ANNOTATION_COLUMN, ANNOTATION_ATTRIBUTE_NAME);
          if (tempLabel == null) {
            this.label = this.getResolvedIdentifier();
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
      if (MetaInfo.this.hasEmbeddedId()) {
        for (FieldMetaInfo pkField: MetaInfo.this.getEmbeddedIdFields()) {
          if (pkField.getName().equals(this.getResolvedIdentifier())) {
//            out.println("FieldMetaInfo.isEmbeddedIdMemberField returning true: "+ this.getResolvedIdentifier());
            return true;
          }
        }
      }
      return false;
    }
    public boolean isLastEmbeddedIdMemberField() {
      if (!this.isEmbeddedIdMemberField()) return false;
      FieldMetaInfo pkField = null;
      FieldMetaInfo[] pkFields = MetaInfo.this.getEmbeddedIdFields();
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
//      out.println("FieldMetaInfo["+ getName() +"].getResolvedIdentifier()");
      for (String annotationLine: fieldAnnotationList) {
        if (annotationLine.contains(ANNOTATION_JOIN_COLUMN)) {
          String annotationAttributeValue = MetaInfo.getAnnotationAttributeValue(ANNOTATION_JOIN_COLUMN, ANNOTATION_ATTRIBUTE_NAME, annotationLine);
          if (annotationAttributeValue != null) {
            String returnValue = convertDBIdentifierToJava (annotationAttributeValue);
//            out.println("FieldMetaInfo["+this.getName() +"].getResolvedIdentifier() returning " + returnValue);
            return returnValue;
          }
        }
      }
      return this.getName();
    }
    public MetaInfo getEnclosingMetaInfo() {
      return MetaInfo.this;
    }
  }
  // END INNER CLASS FieldMetaInfo
  
  
  public FieldMetaInfo[] getFieldMetaInfoArray() { return this.fieldMetaInfoArray;}
  
  private MetaInfo (String className, DbUserTableColumnRepository dbUserTableColumnRepository) 
  {
    this.className = className;
    this.dbUserTableColumnRepository = dbUserTableColumnRepository;
    out.println("MetaInfo constructor: this.dbUserTableColumnRepository = " + this.dbUserTableColumnRepository);
  } 
  
  public String getSimpleName () {return this.subjectClass.getSimpleName(); }
  
  public static MetaInfo getMetaInfo (String className, String requiredClassAnnotation) throws IOException { 
    return getMetaInfo (className, GenJavaComponents.getDbUserTableColumnRepository(), null); 
//    MetaInfo metaInfo = metaInfoMap.get(className);
//    if (requiredClassAnnotation != null & (!metaInfo.classAnnotationsContain(requiredClassAnnotation))) {
//      return null;
//    } else  { 
//      return metaInfo;
//    }
  }

  public static MetaInfo getMetaInfo (String className) throws IOException { // Only for existing ones
    return getMetaInfo (className, GenJavaComponents.getDbUserTableColumnRepository(), null); 
//    return metaInfoMap.get(className);
  }

  public static MetaInfo getMetaInfo (String className, DbUserTableColumnRepository dbUserTableColumnRepository) throws IOException {
    return getMetaInfo (className, dbUserTableColumnRepository, null); 
  }
  
  
  public static MetaInfo getMetaInfo (String className, DbUserTableColumnRepository dbUserTableColumnRepository, String requiredClassAnnotation) throws IOException {
//    out.println("public static MetaInfo getMetaInfo (" + className +")");
    // DEBUG
//    out.println("");
//    out.println("PRINTING metaInfoMap:");
//    for (MetaInfo metaInfoX: metaInfoMap.values() )
//      out.println(metaInfoX.toString());
    // END DEBUG
    MetaInfo metaInfo = metaInfoMap.get(className);
    if (metaInfo == null ) {
      out.println ("metaInfo " + className + " not found. Creating new...");
      ArrayList<Field> fieldList = null;
      metaInfo = new MetaInfo(className, dbUserTableColumnRepository);
      try {
        metaInfo.subjectClass = Class.forName(className);
        metaInfoMap.put(metaInfo.className, metaInfo);
//        out.println("subjectClass = " + metaInfo.subjectClass);
//        out.println("subjectClass.getName() = " + metaInfo.subjectClass.getName());
//        out.println("subjectClass.getSimpleName() = " + metaInfo.subjectClass.getSimpleName());
//        out.println("subjectClass.getDeclaredFields() = " + metaInfo.subjectClass.getDeclaredFields());
//        metaInfo.fields = metaInfo.subjectClass.getDeclaredFields();
      } catch (ClassNotFoundException e) {
        out.println("Sorry, ClassNotFoundException trying to load " + metaInfo.subjectClass +".");
      }
      
      Path classFile = Paths.get(className.replace('.', '/')+".java");
      out.println("Processing Model/Entity class: " + classFile);
      String fileLine = null;
      try (BufferedReader reader = Files.newBufferedReader(classFile)){
        while ((fileLine = reader.readLine())!=null) {
          metaInfo.sourceCodeLines.add(fileLine); 
        }
      }
      catch (IOException e){
        out.println("Sorry, could not read file " + className.replace('.', '/')+".java");
        throw e;
      }
      
      // Get class annotations
      for (int i=0; i<metaInfo.sourceCodeLines.size(); i++) {
        if (metaInfo.sourceCodeLines.get(i).contains("public class " + metaInfo.subjectClass.getSimpleName())) {
          for (int j=i-1; j>0; j--) {
            if (metaInfo.sourceCodeLines.get(j).trim().startsWith(AT_SIGN)) {
              out.println("Found class annotation: " + metaInfo.sourceCodeLines.get(j));
              metaInfo.classAnnotationList.add(metaInfo.sourceCodeLines.get(j));
            }
            else break;
          }
        }
      }
//      out.println("classAnnotationList = " + metaInfo.classAnnotationList);
      
      String searchField = null;
      ArrayList<String> annotationList = null;
      metaInfo.fieldMetaInfoArray = new FieldMetaInfo[metaInfo.subjectClass.getDeclaredFields().length]; 
      int fieldNo = 0;
      for (Field field: metaInfo.subjectClass.getDeclaredFields()) {
        FieldMetaInfo fieldMetaInfo = metaInfo.new FieldMetaInfo(field);
//        if (fieldMetaInfo.isId()) metaInfo.idField = fieldMetaInfo;
        annotationList = new ArrayList<>();
        searchField = " " + field.getName();
        for (int i=0; i<metaInfo.sourceCodeLines.size(); i++) {
          //out.println("Searching for  '" + searchField + "'");
          if (metaInfo.sourceCodeLines.get(i).contains(searchField)) {
//            out.println("");
//            out.println("Found searchField '" + searchField + "'");
//            out.println("metaInfo.sourceCodeLines.get(i) = '" + metaInfo.sourceCodeLines.get(i) + "'");
//            out.println("metaInfo.sourceCodeLines.get(j) = '" + metaInfo.sourceCodeLines.get(i-1) + "'");
            
            for (int j=i-1; j>0; j--) {
              if (metaInfo.sourceCodeLines.get(j).trim().startsWith(AT_SIGN)) {
                out.println("Found annotation: " + metaInfo.sourceCodeLines.get(j));
                annotationList.add(metaInfo.sourceCodeLines.get(j));
              }
              else break;
            }
          }          
        }
        fieldMetaInfo.fieldAnnotationList = annotationList;
        metaInfo.fieldMetaInfoMap.put(field.getName(), fieldMetaInfo);
        metaInfo.fieldMetaInfoArray[fieldNo++] = fieldMetaInfo; 
      }
    }
//    for (Field field: metaInfo.subjectClass.getDeclaredFields()) {
    if (metaInfo.fieldMetaInfoArray != null) {
      for (FieldMetaInfo fieldMetaInfo: metaInfo.fieldMetaInfoArray) {
  //      if (metaInfo.isEmbeddedId(fieldMetaInfo)) {
        if (fieldMetaInfo.isEmbeddedId()) {
          out.println("fieldMetaInfo " + fieldMetaInfo.getName() + " is an Embedded ID.");
  //        metaInfo.embeddedPKInfo = MetaInfo.getMetaInfo(className).getMetaInfo(field.getDeclaringClass().getSimpleName(), ANNOTATION_EMBEDDABLE);
  //        out.println("fieldMetaInfo.getDeclaringClassName() = " + fieldMetaInfo.getDeclaringClassName());
  //        metaInfo.embeddedPKInfo = MetaInfo.getMetaInfo(MODEL_PACKAGE+"." + fieldMetaInfo.getDeclaringClassName(), ANNOTATION_EMBEDDABLE);
  //        out.println("metaInfo.getClassName() = " + metaInfo.getClassName());
  //        out.println("metaInfo number of fields = " + metaInfo.getFieldMetaInfoArray().length);
  //        out.println("fieldMetaInfo.getType().getName() = " + fieldMetaInfo.getType().getName());
          metaInfo.setEmbeddedPKInfo(MetaInfo.getMetaInfo(fieldMetaInfo.getType().getName(), dbUserTableColumnRepository, ANNOTATION_EMBEDDABLE));
  //        metaInfo.embeddedPKInfo = MetaInfo.getMetaInfo(fieldMetaInfo.getDeclaringClassName(), ANNOTATION_EMBEDDABLE);
          if (metaInfo.getEmbeddedPKInfo() != null) {
            metaInfo.setEmbeddedPKInfoClassName(metaInfo.getEmbeddedPKInfo().getClassName());
            metaInfo.getEmbeddedPKInfo().isEmbeddedPkInfo=true;
  //          out.println("  metaInfo.getClassName() = " + metaInfo.getClassName());
  //          out.println("  metaInfo.embeddedPKInfo.getClassName() = " + metaInfo.getEmbeddedPKInfo().getClassName());
  //          out.println("  metaInfo.embeddedPKInfo.toString() = " + metaInfo.getEmbeddedPKInfo().toString());
  //          out.println("  metaInfo.embeddedPKInfo number of fields = " + metaInfo.getEmbeddedPKInfo().getFieldMetaInfoArray().length);
            metaInfoMap.put(metaInfo.getEmbeddedPKInfo().getClassName(), metaInfo.getEmbeddedPKInfo());
            metaInfoMap.put(metaInfo.className, metaInfo);
          }
        }
      }
    }
//    metaInfoMap.put(metaInfo.className, metaInfo);
//    if (requiredClassAnnotation == null | metaInfo.classAnnotationsContain(requiredClassAnnotation)) {
    if (requiredClassAnnotation != null & (!metaInfo.classAnnotationsContain(requiredClassAnnotation))) {
      return null;
    } else  { 
      return metaInfo;
    }
  }
  
  public boolean isEmbeddedPkInfo() {
    return isEmbeddedPkInfo;
  }

  
  public void setEmbeddedPKInfoClassName(String embeddedPKInfoClassName) 
  {  
    this.embeddedPKInfoClassName = embeddedPKInfoClassName;
  }  
  public String getEmbeddedPKInfoClassName() {return this.embeddedPKInfoClassName;}  
  
  public void setEmbeddedPKInfo(MetaInfo embeddedPKInfo) 
  { 
//    out.println("MetaInfo[" + this.getSimpleName() + "].setEmbeddedPKInfo(" + embeddedPKInfo + ")");
    this.embeddedPKInfo = embeddedPKInfo;
    if (embeddedPKInfo != null) {
      embeddedPKInfo.embeddingMetaInfo = this;
      this.pkFkRefClassFieldMap = new HashMap<>();
      this.pkReferencedMetaInfos = new ArrayList<>();
      for (FieldMetaInfo field: this.fieldMetaInfoArray) {
  //      for (String embeddedField: embeddedPKInfo.getEmbeddedIdFieldIdentifiers()) {
        for (String embeddedField: this.getEmbeddedIdFieldIdentifiers()) {
          if (field.getResolvedIdentifier().equals(embeddedField)) {
            pkFkRefClassFieldMap.put(field.getName(), embeddedField);
          }
        }
        for (FieldMetaInfo embeddedFieldMI: this.getEmbeddedIdFields()) {
          if (field.getResolvedIdentifier().equals(embeddedFieldMI.getResolvedIdentifier())) {
            //pkFkRefClassFieldMap.put(field.getName(), embeddedField);
            try {
//              out.println("embeddedFieldMI.getName() = " + embeddedFieldMI.getName());
//              out.println("field.getType().getName() = " + field.getType().getName());
//              this.pkReferencedMetaInfos.add(MetaInfo.getMetaInfo(embeddedFieldMI.getType().getName()));
              this.pkReferencedMetaInfos.add(MetaInfo.getMetaInfo(field.getType().getName()));
            } catch (IOException e) {
              out.println ("setEmbeddedPKInfo threw IOException!");
            }
            }
        }
      }
    }
  }
  public MetaInfo getEmbeddedPKInfo() { 
    if (this.embeddedPKInfo==null & this.getEmbeddedPKInfoClassName()!=null) // WHY THE @#$% THIS CONDITION SHOULD OCCUR STILL ELUDES ME AFTER TOO MANY HOURS!
    try {
      this.setEmbeddedPKInfo(getMetaInfo(getEmbeddedPKInfoClassName(), dbUserTableColumnRepository));
    } catch (IOException e) {
//      out.println ("public MetaInfo getEmbeddedPKInfo(["+ this.getEmbeddedPKInfoClassName() +"]) threw IOException.");
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
      tableName = MetaInfo.this.getAnnotationAttributeValue(ANNOTATION_TABLE, ANNOTATION_ATTRIBUTE_NAME);
    }
    return this.tableName;
  }
  public Field[] getFields() {return this.subjectClass.getDeclaredFields();}
  public FieldMetaInfo getFieldMetaInfo (String fieldName) { return this.fieldMetaInfoMap.get(fieldName); }
  public ArrayList<String> getSourceCodeLines() {return this.sourceCodeLines;}
//  public Map<String, ArrayList<String>> getFieldAnnotationList() {return this.fieldAnnotationList;}
  public boolean foundFieldAnnotation(String fieldName, String annotation) {
//    out.println("MetaInfo.foundFieldAnnotation([instance])");
    return (this.fieldMetaInfoMap.get(fieldName).fieldAnnotationList.contains(annotation));
  }
  
//  public boolean isEmbeddedId(FieldMetaInfo fieldMetaInfo) {
//    return fieldMetaInfo.isEmbeddedId();
////    return this.foundFieldAnnotationContains(fieldMetaInfo.getName(), ANNOTATION_EMBEDDED_ID);
//  }
  
  public boolean hasEmbeddedId() {
    for (FieldMetaInfo fieldMetaInfo: this.getFieldMetaInfoArray()) {
      if (fieldMetaInfo.isEmbeddedId()) {
        return true;
      } 
    }
    return false;
  }
  
  public boolean fieldIsPrimitiveOrWrapper (String fieldName){ 
    FieldMetaInfo fieldMetaInfo = this.getFieldMetaInfo(fieldName);
    if (fieldMetaInfo == null) return false;
    if (fieldMetaInfo.getType().getName().indexOf(PERIOD) < 0 ) return true;
    if (fieldMetaInfo.getType().getName().startsWith(JAVA_PACKAGE)) return true;
    else return false;
  }
   
//  public static boolean foundFieldAnnotation(Field field, String annotation) {
//    out.println("MetaInfo.foundFieldAnnotation([static]): field name = " + field.getName() + "; Declaring class= " + field.getDeclaringClass().getTypeName());
//    try {
//      MetaInfo testMetaInfo = getMetaInfo(field.getDeclaringClass().getTypeName());
//      return (testMetaInfo.foundFieldAnnotationContains(field.getName(), annotation));
//    } catch (IOException e) {
//      out.println("ERROR: MetaInfo.foundFieldAnnotation() could not open source code file for " + field.getDeclaringClass().getTypeName());
//      return false;
//    }
//  }
  
//  public static boolean foundClassAnnotation(Class testClass, String annotation) {
////    out.println("MetaInfo.foundClassAnnotation([static]): class name = " + testClass.getSimpleName());
//    try {
//      MetaInfo testMetaInfo = getMetaInfo(testClass.getName());
//      return (testMetaInfo.classAnnotationsContain(annotation));
//    } catch (IOException e) {
////      out.println("ERROR: MetaInfo.foundClassAnnotation() could not open source code file for " + testClass.getSimpleName());
//      return false;
//    }
//  }
  
  public boolean foundFieldAnnotationContains(String fieldName, String annotation) {
    ArrayList<String> annotationList = this.fieldMetaInfoMap.get(fieldName).fieldAnnotationList;
    for (String fieldAnnotation: annotationList) {
      if (fieldAnnotation.contains(annotation)) return true;
    }
    return false;
  }

  
//  public static boolean foundFieldAnnotationContains(Class testClass, String annotation) {
//    ArrayList<String> annotationList = null;
//    try {
//      MetaInfo testMetaInfo = getMetaInfo(testClass.getName());
//      Field[] fields = testMetaInfo.getFields();
//      for (Field field: fields) {
//        annotationList = testMetaInfo.fieldMetaInfoMap.get(field.getName()).fieldAnnotationList;;
//        for (String fieldAnnotation: annotationList) {
//          if (fieldAnnotation.contains(annotation)) { 
////            out.println("MetaInfo.foundFieldAnnotationContains(" + annotation + ") returning true.");
//            return true;
//          }
//        }
//      }
//    } catch (IOException e) {
////      out.println("ERROR: MetaInfo.foundFieldAnnotationContains(\" + annotation + \") threw IOException trying to process " + testClass.getSimpleName());
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
  
  public FieldMetaInfo[] getEmbeddedIdFields() {
    //out.println("getEmbeddedIdFields");
    if (this.embeddedPKInfo == null) return null;
    return embeddedPKInfo.fieldMetaInfoArray;    
  }
  
  public String[] getEmbeddedIdFieldIdentifiers() {
//    out.println("getEmbeddedIdFieldIdentifiers");
//    out.println("this.getSimpleName() = " + this.getSimpleName());
//    out.println("this.embeddedPKInfo = " + this.embeddedPKInfo);
    if (this.embeddedPKInfo == null) return null;
    String[] embeddedIdFieldNames = new String [embeddedPKInfo.fieldMetaInfoArray.length];
    for (int i=0; i<embeddedPKInfo.fieldMetaInfoArray.length; i++) {
      embeddedIdFieldNames[i] = embeddedPKInfo.fieldMetaInfoArray[i].getResolvedIdentifier();
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
      for (FieldMetaInfo field: this.getFieldMetaInfoArray()) {
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
  
  public MetaInfo[] getEmbeddedIdRefEntities() {
    out.println("getEmbeddedIdRefEntities");
    if (this.embeddedPKInfo == null) return null;
    String[] embeddedIdFieldIdentifiers = getEmbeddedIdFieldIdentifiers();
    MetaInfo[] embeddedIdRefEntities = new MetaInfo[embeddedIdFieldIdentifiers.length];
    
    int i=0;
    for (String embeddedIdField: embeddedIdFieldIdentifiers){
      //out.println("embeddedIdField = " + embeddedIdField);
      for (FieldMetaInfo field: this.getFieldMetaInfoArray()) {
        if (field.getResolvedIdentifier().equals(embeddedIdField)){
          //out.println("field.getResolvedIdentifier() = " + field.getResolvedIdentifier());
          try {
            embeddedIdRefEntities[i] = getMetaInfo(field.getType().getName());
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
  
  public FieldMetaInfo getFirstNonKeyRequiredField() {
    for (FieldMetaInfo field: this.fieldMetaInfoArray) {
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

    
  @Override
  public String toString () {
    String returnString = "MetaInfo TO_STRING for " + this.getClassName() + "\n"
//                        + "  Fields = " + this.getSubjectClass().getDeclaredFields().toString() + "\n"
                        + "  Number of Fields = " + this.fieldMetaInfoArray.length + "\n"
                        + "  embeddedPKInfo = " + (this.embeddedPKInfo!=null?this.embeddedPKInfo.getClassName():null) + "\n"
                        + "  embeddedPKInfoClassName = " + this.getEmbeddedPKInfoClassName() + "\n"
                        + " classAnnotationList = " + this.classAnnotationList + "\n"
//                        + "  sourceCodeLines = " + this.sourceCodeLines + "\n\n" 
//                        + "  Annotations = " + this.fieldAnnotationMapList
                        ;
  
        return returnString;
  }

  public static void main(String[] args) throws IOException {
  }
  

}


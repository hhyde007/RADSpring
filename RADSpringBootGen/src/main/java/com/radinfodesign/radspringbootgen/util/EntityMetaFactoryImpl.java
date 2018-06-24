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
import java.util.Map;

import javax.annotation.PostConstruct;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Component;

import com.radinfodesign.radspringbootgen.dao.DbUserTableColumnRepository;
import com.radinfodesign.radspringbootgen.util.EntityMeta.FieldMeta;


/**
 * Wrapper class for data model entity metadata, 
 * a.k.a. all the attributes of a database table as represented by a Java model entity class.
 * 
 * @author Howard Hyde
 *
 */
@Component
public class EntityMetaFactoryImpl implements EntityMetaFactory {

  public static final String AT_SIGN = "@"; 
  public static final String ANNOTATION_EMBEDDABLE = "@Embeddable";
  protected Map<String, EntityMeta> entityMetaMap = new HashMap<>();
  
//  public static DbUserTableColumnRepository dbUserTableColumnRepositoryX;
  public static EntityMetaFactoryImpl entityMetaFactoryImplX;
  
  @PostConstruct
  private void init() {
    entityMetaFactoryImplX = this;
  }
  
  @Autowired
  DbUserTableColumnRepository dbUserTableColumnRepository;
  
  public EntityMeta getEntityMeta (String className) throws IOException { // Only for existing ones
    return getEntityMeta (className, null); 
  }

  public EntityMeta getEntityMeta (String className, String requiredClassAnnotation) throws IOException {
    EntityMeta entityMeta = entityMetaMap.get(className);
    if (entityMeta == null ) {
      out.println ("entityMeta " + className + " not found. Creating new...");
      ArrayList<Field> fieldList = null;
      entityMeta = new EntityMeta(className, dbUserTableColumnRepository);
      try {
        entityMeta.subjectClass = Class.forName(className);
        entityMetaMap.put(entityMeta.className, entityMeta);
      } catch (ClassNotFoundException e) {
        out.println("Sorry, ClassNotFoundException trying to load " + entityMeta.subjectClass +".");
      }
      
      Path classFile = Paths.get(className.replace('.', '/')+".java");
      out.println("Processing Model/Entity class: " + classFile);
      String fileLine = null;
      try (BufferedReader reader = Files.newBufferedReader(classFile)){
        while ((fileLine = reader.readLine())!=null) {
          entityMeta.sourceCodeLines.add(fileLine); 
        }
      }
      catch (IOException e){
        out.println("Sorry, could not read file " + className.replace('.', '/')+".java");
        throw e;
      }
      
      // Get class annotations
      for (int i=0; i<entityMeta.sourceCodeLines.size(); i++) {
        if (entityMeta.sourceCodeLines.get(i).contains("public class " + entityMeta.subjectClass.getSimpleName())) {
          for (int j=i-1; j>0; j--) {
            if (entityMeta.sourceCodeLines.get(j).trim().startsWith(AT_SIGN)) {
              out.println("Found class annotation: " + entityMeta.sourceCodeLines.get(j));
              entityMeta.classAnnotationList.add(entityMeta.sourceCodeLines.get(j));
            }
            else break;
          }
        }
      }
//      out.println("classAnnotationList = " + entityMeta.classAnnotationList);
      
      String searchField = null;
      ArrayList<String> annotationList = null;
      entityMeta.fieldMetaArray = new FieldMeta[entityMeta.subjectClass.getDeclaredFields().length]; 
      int fieldNo = 0;
      for (Field field: entityMeta.subjectClass.getDeclaredFields()) {
        FieldMeta fieldMeta = entityMeta.new FieldMeta(field);
        annotationList = new ArrayList<>();
        searchField = " " + field.getName();
        for (int i=0; i<entityMeta.sourceCodeLines.size(); i++) {
          if (entityMeta.sourceCodeLines.get(i).contains(searchField)) {
            for (int j=i-1; j>0; j--) {
              if (entityMeta.sourceCodeLines.get(j).trim().startsWith(AT_SIGN)) {
                out.println("Found annotation: " + entityMeta.sourceCodeLines.get(j));
                annotationList.add(entityMeta.sourceCodeLines.get(j));
              }
              else break;
            }
          }          
        }
        fieldMeta.fieldAnnotationList = annotationList;
        entityMeta.fieldMetaMap.put(field.getName(), fieldMeta);
        entityMeta.fieldMetaArray[fieldNo++] = fieldMeta; 
      }
    }
//    for (Field field: entityMeta.subjectClass.getDeclaredFields()) {
    if (entityMeta.fieldMetaArray != null) {
      for (FieldMeta fieldMeta: entityMeta.fieldMetaArray) {
        if (fieldMeta.isEmbeddedId()) {
          out.println("fieldMeta " + fieldMeta.getName() + " is an Embedded ID.");
          this.setEmbeddedPKInfo(entityMeta, this.getEntityMeta(fieldMeta.getType().getName(), ANNOTATION_EMBEDDABLE));
          if (getEmbeddedPKInfo(entityMeta) != null) {
            entityMeta.setEmbeddedPKInfoClassName(getEmbeddedPKInfo(entityMeta).getClassName());
            getEmbeddedPKInfo(entityMeta).isEmbeddedPkInfo=true;
            entityMetaMap.put(getEmbeddedPKInfo(entityMeta).getClassName(), getEmbeddedPKInfo(entityMeta));
            entityMetaMap.put(entityMeta.className, entityMeta);
          }
        }
      }
    }
    setEmbeddedIdRefEntities(entityMeta);
    if (requiredClassAnnotation != null & (!entityMeta.classAnnotationsContain(requiredClassAnnotation))) {
      return null;
    } else  { 
      return entityMeta;
    }
  }
  
//  public boolean isEmbeddedPkInfo() {
//    return isEmbeddedPkInfo;
//  }

  
  public void setEmbeddedPKInfo(EntityMeta entityMeta, EntityMeta embeddedPKInfo) 
  { 
    entityMeta.embeddedPKInfo = embeddedPKInfo;
    if (embeddedPKInfo != null) {
      embeddedPKInfo.embeddingEntityMeta = entityMeta;
      entityMeta.pkFkRefClassFieldMap = new HashMap<>();
      entityMeta.pkReferencedEntityMetas = new ArrayList<>();
      for (FieldMeta field: entityMeta.fieldMetaArray) {
  //      for (String embeddedField: embeddedPKInfo.getEmbeddedIdFieldIdentifiers()) {
        for (String embeddedField: entityMeta.getEmbeddedIdFieldIdentifiers()) {
          if (field.getResolvedIdentifier().equals(embeddedField)) {
            entityMeta.pkFkRefClassFieldMap.put(field.getName(), embeddedField);
          }
        }
        for (FieldMeta embeddedFieldMI: entityMeta.getEmbeddedIdFields()) {
          if (field.getResolvedIdentifier().equals(embeddedFieldMI.getResolvedIdentifier())) {
            //pkFkRefClassFieldMap.put(field.getName(), embeddedField);
            try {
//              out.println("embeddedFieldMI.getName() = " + embeddedFieldMI.getName());
//              out.println("field.getType().getName() = " + field.getType().getName());
//              this.pkReferencedEntityMetas.add(EntityMeta.getEntityMeta(embeddedFieldMI.getType().getName()));
              entityMeta.pkReferencedEntityMetas.add(this.getEntityMeta(field.getType().getName()));
            } catch (IOException e) {
              out.println ("setEmbeddedPKInfo threw IOException!");
            }
            }
        }
      }
    }
  }
      
  public EntityMeta getEmbeddedPKInfo(EntityMeta entityMeta) { 
    if (entityMeta.embeddedPKInfo==null & entityMeta.getEmbeddedPKInfoClassName()!=null) 
    try {
      this.setEmbeddedPKInfo(entityMeta, getEntityMeta(entityMeta.getEmbeddedPKInfoClassName()));
    } catch (IOException e) {
    }
    return entityMeta.embeddedPKInfo;
  }
  
  protected void setEmbeddedIdRefEntities(EntityMeta entityMeta) {
    //out.println("setEmbeddedIdRefEntities");
    if (entityMeta.embeddedPKInfo == null) return;
    String[] embeddedIdFieldIdentifiers = entityMeta.getEmbeddedIdFieldIdentifiers();
    EntityMeta[] embeddedIdRefEntities = new EntityMeta[embeddedIdFieldIdentifiers.length];
    
    int i=0;
    for (String embeddedIdField: embeddedIdFieldIdentifiers){
      //out.println("embeddedIdField = " + embeddedIdField);
      for (FieldMeta field: entityMeta.getFieldMetaArray()) {
        if (field.getResolvedIdentifier().equals(embeddedIdField)){
          //out.println("field.getResolvedIdentifier() = " + field.getResolvedIdentifier());
          try {
            embeddedIdRefEntities[i] = getEntityMeta(field.getType().getName());
          } catch (IOException e) {
            out.println ("setEmbeddedIdRefEntities SHOULD NEVER THROW THIS IOException!!!");
          }
          //break;
        }
      }
      i++;
    }
    return;
  }
  
  
  @Override
  public String toString () {
    String returnString = "EntityMetaFactoryImpl";
        return returnString;
  }

}


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
import java.util.StringTokenizer;
import java.util.TreeMap;

import com.radinfodesign.radspringbootgen.util.MetaInfo.FieldMetaInfo;

public class InputStringTree extends IOStringTree {
  
  protected final String TOKEN_DRIVING_ENTITY_NAME = "drivingEntityName"; 
  protected final String TOKEN_BASE_PACKAGE_NAME = "basePackageName";
  //
  protected final String TOKEN_MODEL_PACKAGE_NAME="modelPackageName";
  protected final String TOKEN_CONTROLLER_PACKAGE_NAME = "controllerPackageName";
  protected final String TOKEN_SERVICE_PACKAGE_NAME = "servicePackageName";
  protected final String TOKEN_REPOSITORY_PACKAGE_NAME = "repositoryPackageName";
  protected final String TOKEN_REPOSITORY_IMPORT = "repositoryImport";
  protected final String TOKEN_MODEL_ENTITY_IMPORT="modelEntityImport";
  protected final String TOKEN_WEB_CONTROLLER_CLASS = "webControllerClass";
  protected final String TOKEN_ENTITY_URL = "ENTITY_URL";
  protected final String TOKEN_ENTITY_GET_ONE_URL = "ENTITY_GET_ONE_URL";
  protected final String TOKEN_ENTITY_EDIT_PAGE = "ENTITY_EDIT_PAGE";
  protected final String TOKEN_ENTITY_ATT_ID ="ENTITY_ATT_ID";  
  protected final String TOKEN_ENTITY_ATT_ID_INIT_CAP = "ENTITY_ATT_ID_INIT_CAP";  
  protected final String TOKEN_GET_ENTITY_ATT_ID="GET_ENTITY_ATT_ID";  
  protected final String TOKEN_ENTITY_REPOSITORY = "EntityRepository"; 
  protected final String TOKEN_BUSINESS_ENTITY = "BUSINESS_ENTITY"; 
  protected final String TOKEN_INSTANCE = "INSTANCE"; 
  protected final String TOKEN_MODEL_ENTITY = "MODEL_ENTITY"; 
  protected final String TOKEN_MODEL_ENTITY_INIT_SMALL = "MODEL_ENTITY_INIT_SMALL"; 
  protected final String TOKEN_MODEL_ENTITY_LOWER = "MODEL_ENTITY_LOWER"; 
  
  
  // All of these configuration and token values may be modified by the program
  // These first two drive all the others:
  protected String drivingEntityName ="Flight"; // Example/default
  protected String basePackageName ="com.radinfodesign.fboace";
//  //
  protected String fqDrivingEntityName ="com.radinfodesign.fboace.model.Flight";
  protected String modelPackageName ="com.radinfodesign.fboace.model";
  
  protected TreeMap<String, String> tokenMap = new TreeMap<>();
  
  public String getDrivingEntityName() { return this.drivingEntityName; }
  public String getBasePackageName() { return this.basePackageName; }
  public String getFQDrivingEntityName() { return this.fqDrivingEntityName; }


  public InputStringTree(String topValue, String drivingEntityName, String basePackageName) throws IOException {
    super(topValue);
    this.topNode = new StringNode(topValue); // REDUNDANT
    this.drivingEntityName = drivingEntityName;
    this.basePackageName = basePackageName;
    this.modelPackageName = basePackageName+"."+"model";
    this.fqDrivingEntityName = this.modelPackageName + "."+drivingEntityName;
    tokenMap.put(TOKEN_DRIVING_ENTITY_NAME, drivingEntityName);
    tokenMap.put(TOKEN_BASE_PACKAGE_NAME, basePackageName);

    tokenMap.put(TOKEN_MODEL_PACKAGE_NAME, modelPackageName); 
    tokenMap.put(TOKEN_BUSINESS_ENTITY, drivingEntityName); 
    tokenMap.put(TOKEN_INSTANCE, drivingEntityName.toLowerCase()); 
    tokenMap.put(TOKEN_MODEL_ENTITY, drivingEntityName); 
    tokenMap.put(TOKEN_MODEL_ENTITY_LOWER, drivingEntityName.toLowerCase()); 
    tokenMap.put(TOKEN_MODEL_ENTITY_INIT_SMALL, drivingEntityName.substring(0, 1).toLowerCase() + drivingEntityName.substring(1)); 
    tokenMap.put(TOKEN_CONTROLLER_PACKAGE_NAME, basePackageName+".controller");
    tokenMap.put(TOKEN_SERVICE_PACKAGE_NAME, basePackageName+".service");
    tokenMap.put(TOKEN_REPOSITORY_PACKAGE_NAME,basePackageName+".dao");
    tokenMap.put(TOKEN_REPOSITORY_IMPORT, tokenMap.get(TOKEN_REPOSITORY_PACKAGE_NAME)+"."+drivingEntityName+"Repository");
    tokenMap.put(TOKEN_MODEL_ENTITY_IMPORT, tokenMap.get(TOKEN_MODEL_PACKAGE_NAME)+"."+drivingEntityName);
    tokenMap.put(TOKEN_WEB_CONTROLLER_CLASS, drivingEntityName+"WebController");
    tokenMap.put(TOKEN_ENTITY_URL, "/"+drivingEntityName);
    tokenMap.put(TOKEN_ENTITY_GET_ONE_URL, "");
//    tokenMap.put(TOKEN_ENTITY_EDIT_PAGE, drivingEntityName.toLowerCase()+"/edit");
    tokenMap.put(TOKEN_ENTITY_EDIT_PAGE, "entity/" + drivingEntityName +"Edit");
    MetaInfo drivingMetaInfo = MetaInfo.getMetaInfo(fqDrivingEntityName);
    out.println("drivingMetaInfo = "  + drivingMetaInfo.getClassName());
    FieldMetaInfo idField = drivingMetaInfo.getIDField();
    out.println("idField = "  + idField);
    String idFieldName = idField.getName();
    out.println("idFieldName = "  + idFieldName);
//    tokenMap.put(TOKEN_ENTITY_ATT_ID, MetaInfo.getMetaInfo(fqDrivingEntityName).getIDField().getName());
    tokenMap.put(TOKEN_ENTITY_ATT_ID, idFieldName);  
    tokenMap.put(TOKEN_ENTITY_ATT_ID_INIT_CAP, idFieldName.substring(0,1).toUpperCase() + idFieldName.substring(1)); 
    tokenMap.put(TOKEN_GET_ENTITY_ATT_ID, "get"+idFieldName.substring(0,1).toUpperCase() + idFieldName.substring(1)); 
    tokenMap.put(TOKEN_ENTITY_REPOSITORY, drivingEntityName+"Repository");
  }
  
  
  public TreeMap<String, String> getTokenMap() { return this.tokenMap; }

  
//  public InputStringTree(String topValue) {
//    super(topValue);
//  }

  public void build() {
    this.build(this.getTopNode().getValue(), this.getTopNode(), 1);
  }
  
  private void build(String nodeString, StringNode currentParentNode, int nestLevel) {
//    out.println("InputStringTree.build(nodeString, currentParentNode, int nestLevel = "+nestLevel+")");
    int fileLength = nodeString.length();
    int tokenOpenIndex = 0;
    int tokenNextStartIndex = 0;
    int tokenCloseIndex = 0;
    //int nestLevel = 0;
    StringNode childNode = null;
    String tokenSegment = null;
    int fireEscape = 6;
    if (nestLevel++ > fireEscape) return;  // this; // ABORT AND DEBUG
    
    int indexOffset = 0;
    while (indexOffset < fileLength) { 
      //  [Need to deal with malformed documents?]
      //
      // Where are you?
      //  At the beginning, or after an End token, looking for the next Start token
      tokenOpenIndex = nodeString.indexOf(StringNode.TOKEN_OPEN, indexOffset);
      if (tokenOpenIndex < indexOffset) { // sprint to the end /////////////////////////////(BTW, would that be -1?)
        //   You may find you are at the end, with no more tokens.
        //    If so, create the last node and break the loop.
        tokenSegment = nodeString.substring(indexOffset);
//        out.println("tokenSegment [should be last one] = [" + tokenSegment + "]");
        this.addNode(tokenSegment, currentParentNode);
        break;
      } else { // tokenOpenIndex >= indexOffset, so find the end of this open, accounting for nesting
        //   Or you may find a(nother) Start token.
        if (tokenOpenIndex > indexOffset) {
          tokenSegment = nodeString.substring(indexOffset, tokenOpenIndex);
//          out.println("tokenSegment = [" + tokenSegment + "]");
          this.addNode(tokenSegment, currentParentNode);
          indexOffset = tokenOpenIndex+StringNode.TOKEN_OPEN_LENGTH; // May not matter yet; control variable at this point is tokenOpenIndex
        } // tokenOpenIndex may be == indexOffset
        //    After a Start token, look for the corresponding end token
        tokenCloseIndex = nodeString.indexOf(StringNode.TOKEN_CLOSE, tokenOpenIndex);
        //     Because of nesting, you may have to LOOP to find the right end token, skipping over nested Starts and Ends.
        tokenNextStartIndex = nodeString.indexOf(StringNode.TOKEN_OPEN, tokenOpenIndex+StringNode.TOKEN_OPEN_LENGTH);
//        out.println("tokenOpenIndex = " + tokenOpenIndex);
//        out.println("tokenCloseIndex = " + tokenCloseIndex);
//        out.println("tokenNextStartIndex = " + tokenNextStartIndex);
//        out.println("tokenSegment MIGHT BE [" + nodeString.substring(tokenOpenIndex, tokenCloseIndex+StringNode.TOKEN_CLOSE_LENGTH) + "]");
        if ((tokenNextStartIndex < 0) || (tokenNextStartIndex > tokenCloseIndex)) {
          tokenSegment = nodeString.substring(tokenOpenIndex, tokenCloseIndex+StringNode.TOKEN_CLOSE_LENGTH); // Keep the token delimiters
//          out.println("tokenSegment [single token] = [" + tokenSegment + "]");
          childNode=this.addNode(tokenSegment, currentParentNode);
          indexOffset = tokenCloseIndex+StringNode.TOKEN_CLOSE_LENGTH;
          continue;
        }
        else {
          while ((tokenNextStartIndex > 0 && (tokenNextStartIndex < tokenCloseIndex))) {
  //          tokenCloseIndex = nodeString.indexOf(TOKEN_CLOSE, tokenNextStartIndex);
            tokenCloseIndex = nodeString.indexOf(StringNode.TOKEN_CLOSE, tokenCloseIndex+StringNode.TOKEN_CLOSE_LENGTH);
            tokenNextStartIndex = nodeString.indexOf(StringNode.TOKEN_OPEN, tokenNextStartIndex+StringNode.TOKEN_OPEN_LENGTH);
//            out.println("tokenOpenIndex = " + tokenOpenIndex);
//            out.println("tokenCloseIndex = " + tokenCloseIndex);
//            out.println("tokenNextStartIndex = " + tokenNextStartIndex);
  //          out.println("tokenSegment MIGHT HAVE BEEN [" + nodeString.substring(tokenOpenIndex, tokenCloseIndex+TOKEN_CLOSE_LENGTH) + "]");
          }
          // At this point tokenCloseIndex is less than tokenNextStartIndex if the latter is not negative
          tokenSegment = nodeString.substring(tokenOpenIndex, tokenCloseIndex+StringNode.TOKEN_CLOSE_LENGTH); // Keep the token delimiters
//          out.println("tokenSegment [nested tokens] = [" + tokenSegment + "]");
          childNode=this.addNode(tokenSegment, currentParentNode);
          if (tokenSegment.indexOf(StringNode.STRING_TOKEN_SEPARATOR) < 0) {
            tokenSegment = tokenSegment.substring(tokenSegment.indexOf(StringNode.TOKEN_OPEN)+StringNode.TOKEN_OPEN_LENGTH);
          }
          else {
            tokenSegment = tokenSegment.substring(tokenSegment.indexOf(StringNode.STRING_TOKEN_SEPARATOR)+1);
          }
          tokenSegment = tokenSegment.substring(0, tokenSegment.length()-StringNode.TOKEN_CLOSE_LENGTH);
//          if (nestLevel > 0) {
//          Here's the magic recursion?:
//            this = buildInputTree(tokenSegment, this, childNode, nestLevel);
          this.build(tokenSegment, childNode, nestLevel);
//          }
        }
      }
      indexOffset = tokenCloseIndex+StringNode.TOKEN_CLOSE_LENGTH;
    }
    return; // this;
  }
  
  public static void test() {
//    StringTree stringTree = new InputStringTree("ONCE");
//    StringNode childNode = stringTree.addNode("Una vez estaban...", stringTree.topNode);
//    StringNode grandchildNode1 = stringTree.addNode("Once upon ", childNode);
//    StringNode grandchildNode2 = stringTree.addNode("a time, \n", childNode);
//    StringNode childNode2 = stringTree.addNode("THERE WER", stringTree.topNode);
//    StringNode childNode3 = stringTree.addNode("There were", childNode2);
//    StringNode childNode4 = stringTree.addNode(" three bears.", stringTree.topNode);
//    out.println(stringTree.traverse(stringTree.topNode));
  }
  
  public static void main(String[] args) {
    test();
  }

}


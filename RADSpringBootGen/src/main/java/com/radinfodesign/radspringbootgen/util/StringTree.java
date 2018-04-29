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

abstract class StringTree {
  public StringNode topNode;
  public int numNodes = 0;
  
  public StringTree(String topValue) {
    this.topNode = new StringNode(topValue);
  }
  public int getNumNodes() {return this.numNodes;}
  
  public StringNode getTopNode() { return this.topNode; }

 
//  public void addNode (String newNodeString, StringNode parentNode, StringNode previousNode) {
  public StringNode addNode (String newNodeString, StringNode parentNode) {
//    out.println("");
//    out.println("****************************");
//    out.println("StringTree.addNode 
    if (newNodeString == null) throw new RuntimeException ("null String passed to StringTree.addNode()");
    StringNode newNode = new StringNode(newNodeString);
    parentNode.addChild(newNode);
    numNodes++;
    return newNode;
  }
  
  
  public String traverse () {
    StringNode topNode = this.getTopNode();
    return traverse (topNode);
  }
  
  public String traverse (StringNode node) {
    //out.println("StringTree.traverseAscending");
    String resultString = "";
    StringBuilder resultStringBuilder = new StringBuilder("");
    if (node.getChildren().size()==0) return node.getValue();
    else {
      for (StringNode childNode: node.getChildren()) {
        resultStringBuilder.append(traverse(childNode));
      }
      resultString = new String(resultStringBuilder);
    }
    return resultString;
  }
    
  
 }


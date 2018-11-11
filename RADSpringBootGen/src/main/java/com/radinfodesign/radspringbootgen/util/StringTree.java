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

/**
 * Parent abstract class for more specialized trees of nodes.
 * Identifies its top-level node, which may have any number of child nodes, grandchild nodes etc.
 * @author Howard Hyde
 *
 */
 abstract class StringTree {
  protected StringNode topNode;
  protected int numNodes = 0;
  
  public StringTree(String topValue) {
    this.topNode = new StringNode(topValue);
  }
  public StringTree() {
  }
  public int getNumNodes() {return this.numNodes;}
  
  public StringNode getTopNode() { return this.topNode; }

 
  protected StringNode addNode (String newNodeString, StringNode parentNode) {
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


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

import java.util.ArrayList;
import java.util.List;

/**
 * Represents a node in a hierarchical tree (input template or generated output code) of strings. 
 * May have zero or one parent nodes and zero or any number of child nodes.
 * If used in an {@link InputStringTree}, will be read in from template file, which contains a mix
 * of verbatim code and token-identified expressions. These tokens may result in simple substitution
 * of one generated value apiece, or multiple values based on some form of iteration, for example
 * as with all of the columns within a database table. 
 */
public class StringNode  {
  /**
   * Sequence of characters that indicate the opening of a variable or macro-substitution token
   */
  public static final String TOKEN_OPEN = "{${";

  /**
   * Sequence of characters that indicate the closing of a variable or macro-substitution token
   */
  public static final String TOKEN_CLOSE = "}$}";
  
  protected static final int TOKEN_OPEN_LENGTH = TOKEN_OPEN.length();
  protected static final int TOKEN_CLOSE_LENGTH = TOKEN_CLOSE.length();
  
  /**
   * Character used to separate the token from its content/value
   */
  public static final String STRING_TOKEN_SEPARATOR = "=";

  protected String nodeValue = null;
  protected String tokenKey = null;
  protected String tokenInstruction = null;
  protected StringNode parentNode=null;
  protected List<StringNode> children = new ArrayList<>();
  protected int childCount = 0;
  
  /**
   * Assigns nodeValue to member variable; If the node value is a single- or 
   * multi-valued expression, then tokenKey or tokenInstruction get assigned values
   * parsed from the nodeValue.
   * @param nodeValue String value of this node
   */
  public StringNode (String nodeValue) {
    this.nodeValue=nodeValue;
    if (this.isSingleTokenExpression()) {
      this.tokenKey=this.nodeValue.substring(TOKEN_OPEN_LENGTH, this.nodeValue.length()-TOKEN_OPEN_LENGTH);
    } 
    else if (this.isMultiTokenExpression()) {
      this.tokenInstruction=this.nodeValue.substring(TOKEN_OPEN_LENGTH, this.nodeValue.indexOf(STRING_TOKEN_SEPARATOR));
    } 
  }
  
  public String getValue() {return this.nodeValue;}
  
  public StringNode getParent () {return this.parentNode;}
  public void setParent (StringNode parentNode) {this.parentNode = parentNode;}
  
  public List<StringNode> getChildren () {return this.children;}
  public void addChild (StringNode childNode) {this.children.add(childNode);}
  
  public String getTokenKey() { return this.tokenKey; }
  public String getTokenInstruction() { return this.tokenInstruction; }
  
  @Override
  public String toString() {
    return "" + this.nodeValue;
  }
  
  /**
   * Indicates whether or not the contents of the this node consists in an expression token alone; 
   * with NO other expression tokens nested within it.
   */
  public boolean isSingleTokenExpression () {
    return ((this.getValue().indexOf(TOKEN_OPEN) == 0) 
        && (this.getValue().indexOf(TOKEN_CLOSE)
                 ==(this.getValue().length()-TOKEN_CLOSE_LENGTH)));
        
  }
  
  /**
   * Indicates whether or not the contents of the this node consists in an expression token 
   * with one or more other expression tokens nested within it.
   */
  public boolean isMultiTokenExpression () {
    int tokenOpenIndex = this.getValue().indexOf(TOKEN_OPEN);
    if (tokenOpenIndex!=0) return false;
    int tokenCloseIndex = this.getValue().indexOf(TOKEN_CLOSE, tokenOpenIndex);
    int tokenNextStartIndex = this.getValue().indexOf(TOKEN_OPEN, tokenOpenIndex+TOKEN_OPEN_LENGTH);
    if (tokenCloseIndex < tokenNextStartIndex) return false;
    int countCloseTokens = (tokenCloseIndex > tokenOpenIndex?1:0);
    int countOpenTokens = (tokenOpenIndex >= 0?tokenNextStartIndex>tokenOpenIndex?2:1:0);
    while ((tokenNextStartIndex > 0 && (tokenNextStartIndex < tokenCloseIndex))) {
      tokenCloseIndex = this.getValue().indexOf(TOKEN_CLOSE, tokenCloseIndex+TOKEN_CLOSE_LENGTH);
      countCloseTokens+=(tokenCloseIndex>tokenOpenIndex?1:0);
      tokenNextStartIndex = this.getValue().indexOf(TOKEN_OPEN, tokenNextStartIndex+TOKEN_OPEN_LENGTH);
      countOpenTokens+=(tokenNextStartIndex>0?1:0);
    }
    if ((countOpenTokens > 1) && (countOpenTokens==countCloseTokens) 
        &&  (tokenOpenIndex == 0) // Already tested above
        && (tokenCloseIndex ==(this.getValue().length()-TOKEN_CLOSE_LENGTH))) {
//      out.println("isMultiTokenExpression returning true: " + this.getValue());
//      out.println("StringNode.getTokenInstruction() = " + this.getTokenInstruction());
      
      return true;
    }
    else {
      return false;
    }
  }
  
  /**
   * Indicates whether or not the contents of the this node starts and ends with expression token delimiters.
   */
  public boolean isLiteralExpression() {
    return ((!isSingleTokenExpression() & (!isMultiTokenExpression ())));
  }
  

  
  
  public static void main (String[] args) {
    String expression1 = "@RequestParam(name=ENTITY_ATT_ID, defaultValue=\"0\") Integer {${ENTITY_ATT_ID}$}";
    String expression2 = "{${ENTITY_ATT_ID}$}";
    String expression3 = "{${ACT_ALL_ATTRIBS=, @RequestParam(name=ENTITY_ATTRIB_{${ENTITY_ATTRIB_UPPER_NAME}$}, required=false) {${ENTITY_ATTRIB_DEFAULT_DATATYPE}$} {${ENTITY_ATTRIB_NAME}$}}$}";
    out.println(new StringNode (expression1).isSingleTokenExpression());
    out.println(new StringNode (expression1).isMultiTokenExpression());
    out.println();
    out.println(new StringNode (expression2).isSingleTokenExpression());
    out.println(new StringNode (expression2).isMultiTokenExpression());
    out.println();
    out.println(new StringNode (expression3).isSingleTokenExpression());
    out.println(new StringNode (expression3).isMultiTokenExpression());
    out.println();
  }
  
  
}






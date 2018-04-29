package com.radinfodesign.radspringbootgen.util;
import static java.lang.System.out;

import java.util.ArrayList;
import java.util.List;

public class StringNode  {
  public static final String TOKEN_OPEN = "{${";
  public static final String TOKEN_CLOSE = "}$}";
  public static final int TOKEN_OPEN_LENGTH = TOKEN_OPEN.length();
  public static final int TOKEN_CLOSE_LENGTH = TOKEN_CLOSE.length();
  public static final String STRING_TOKEN_SEPARATOR = "=";

  protected String nodeValue = null;
  protected String tokenKey = null;
  protected String tokenInstruction = null;
  protected StringNode parentNode=null;
  protected List<StringNode> children = new ArrayList<>();
  protected int childCount = 0;
  
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
  
  public boolean isSingleTokenExpression () {
    return ((this.getValue().indexOf(TOKEN_OPEN) == 0) 
        && (this.getValue().indexOf(TOKEN_CLOSE)
                 ==(this.getValue().length()-TOKEN_CLOSE_LENGTH)));
        
  }
//  public boolean isSingleTokenExpressionX () {
//    int indexOfTokenOpen = this.getValue().indexOf(TOKEN_OPEN);
//    int indexOfTokenClose = this.getValue().indexOf(TOKEN_CLOSE);
//    int indexOfSeconTokenOpen = this.getValue().indexOf(TOKEN_OPEN, indexOfTokenClose+1);
//    if ((indexOfTokenOpen >=0) && (indexOfTokenClose > indexOfTokenOpen) && (indexOfSeconTokenOpen < 0)) {
//      out.println("isSingleTokenExpressionX returning true: " + this.getValue());
//      return true;
//    }
//    else
//    {
//      return false;
//    }
//  }

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






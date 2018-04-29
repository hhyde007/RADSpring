package com.radinfodesign.radspringbootgen.util;
import static java.lang.System.out;

import java.util.StringTokenizer;

abstract class IOStringTree extends StringTree {
  protected boolean built = false;
  
  public IOStringTree(String topValue) {
    super(topValue);
  }

  public boolean isBuilt () { return this.built;}
  
  public void build() throws Exception {}
  
 }


package com.radinfodesign.radspringbootgen.util;


// Wrapper class for MetaInfo for transient purposes
public class TempMetaInfo {
  MetaInfo metaInfo;
  boolean xReferenced = false;
  boolean isThirdEntity = false;
  
  public TempMetaInfo (MetaInfo metaInfo) {
    this.metaInfo = metaInfo;
  }

  public boolean isXReferenced() {
    return xReferenced;
  }

  public void setXReferenced(boolean xReferenced) {
    this.xReferenced = xReferenced;
  }

  public boolean isThirdEntity() {
    return isThirdEntity;
  }

  public void setThirdEntity(boolean isThirdEntity) {
    this.isThirdEntity = isThirdEntity;
  }

  public MetaInfo getMetaInfo() {
    return metaInfo;
  }
  
  public boolean isEmbeddedPkInfo() {
    return this.metaInfo.isEmbeddedPkInfo();
  }


}

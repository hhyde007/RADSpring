package com.radinfodesign.radspringbootgen.util;

public interface GenJavaService {
  //public static DbUserTableColumnRepository dbUserTableColumnRepository=null;

  public void launch ( String entityList
                     , String basePackage
                     , String outputDir
                     , String[] components
                     );

}

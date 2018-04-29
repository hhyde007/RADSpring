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

import java.sql.SQLException;

public class Util {
  public static final String ORA_MINUS = "ORA-";

  //BUT WHAT IF THE DATABASE ISN'T ORACLE? HOW TO RETURN THE FRIENDLIEST-POSSIBLE ERROR MESSAGE TO THE USER?
  public static String getFriendlySQLErrorMessage (SQLException sqlException) {
    String sqlErrMsg = sqlException.getMessage();
    String friendlyMessage = sqlErrMsg;
    try {
      friendlyMessage = sqlErrMsg.substring(sqlErrMsg.indexOf(ORA_MINUS)+11, sqlErrMsg.indexOf(ORA_MINUS, 12));
    } 
    catch (StringIndexOutOfBoundsException x) 
    {
      try 
      {
        friendlyMessage= sqlErrMsg.substring(sqlErrMsg.indexOf(ORA_MINUS)+11);
      } 
      catch (StringIndexOutOfBoundsException y) {}
    }
    return friendlyMessage;
  }

  
  // HOW TO GET ACCESS TO spring.datasource.username=hhyde_fboace03_oltp_tab
  // FROM application.properties?
  
  public static String getFriendlyErrorMessage (Exception e, String defaultMessage) {
    String message = defaultMessage;
    Throwable x = e;
    Throwable y;
    while ((y=x.getCause()) != null) {
      x=y;
      if (x instanceof SQLException) {
        message = "Sorry, a database error was reported. Something about..."
                + Util.getFriendlySQLErrorMessage((SQLException)x)
                + " Please correct and try again.";
      }
    }
    out.println("message = " + message);
    e.printStackTrace();
    return message;
  }

  
  
}

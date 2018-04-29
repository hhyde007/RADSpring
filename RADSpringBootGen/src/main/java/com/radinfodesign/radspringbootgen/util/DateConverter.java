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

import java.time.LocalDate;

import javax.persistence.AttributeConverter;
import javax.persistence.Converter;

@Converter (autoApply=true)
public class DateConverter implements AttributeConverter<LocalDate, java.sql.Date> {

  @Override
  public java.sql.Date convertToDatabaseColumn(LocalDate localDate) {
    return localDate==null?null:java.sql.Date.valueOf(localDate);
  }

  @Override
  public LocalDate convertToEntityAttribute(java.sql.Date sqlDate) {
    return sqlDate==null?null:sqlDate.toLocalDate();
  }
  
}

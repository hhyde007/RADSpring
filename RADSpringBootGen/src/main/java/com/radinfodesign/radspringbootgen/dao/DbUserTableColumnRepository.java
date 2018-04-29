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
package com.radinfodesign.radspringbootgen.dao;
import java.util.List;

import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;

import com.radinfodesign.metamodel.DbUserTableColumn;
import com.radinfodesign.metamodel.DbUserTableColumnPK;

public interface DbUserTableColumnRepository extends CrudRepository<DbUserTableColumn, Integer> {
  DbUserTableColumn findOneByDbUserTableColumnPK(DbUserTableColumnPK pk);
//  DbUserTableColumn findOneByTableNameAndColumnName(String tableName, String);
	DbUserTableColumn findOneByTableNameAndColumnName(String tableName, String columnName);
	
//  Collection<DbUserTableColumn> findByTableName(String tableName);
  
  @Modifying
  @Query( value="select * "
                + "from user_tables "
               + "where table_name = :tableName "
                + "order by column_id "
        , nativeQuery=true
        )
  List<DbUserTableColumn> findByTableName(@Param("tableName") String tableName);
  
 
}

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

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
package com.radinfodesign.radspringbootgen.metamodel;

import static java.lang.System.out;

import java.io.Serializable;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.Table;
import javax.xml.bind.annotation.XmlRootElement;

/**
 *
 * @author Howard Hyde
 */
@Entity
@Table(name = "USER_TAB_COLUMNS")
@XmlRootElement
public class DbUserTableColumn implements Serializable {

  private static final long serialVersionUID = 1L;
  @EmbeddedId
  protected DbUserTableColumnPK dbUserTableColumnPK;
  
  @Basic(optional = false)
  @Column(name = "TABLE_NAME", insertable=false, updatable=false)
  protected String tableName=null; // Facade
  @Basic(optional = false)
  @Column(name = "COLUMN_NAME", insertable=false, updatable=false)
  protected String columnName=null; 
  
  
  @Basic(optional = false)
  @Column(name = "DATA_TYPE")
  protected String dataType;
  
  @Basic(optional = false)
  @Column(name = "DATA_LENGTH")
  protected Integer dataLength;
  
  @Basic(optional = false)
  @Column(name = "DATA_PRECISION")
  protected Integer dataPrecision;
  
  @Basic(optional = false)
  @Column(name = "DATA_SCALE")
  protected Integer dataScale;
  
  //Integer fieldWidth = null;
  
  @Basic(optional = false)
  @Column(name = "COLUMN_ID")
  protected Integer columnId;
  
  @Basic(optional = false)
  @Column(name = "NULLABLE")
  private String nullable;
  
  @Basic(optional = false)
  @Column(name = "DATA_DEFAULT")
  private String dataDefault;
  
  public DbUserTableColumn() {
  }
  public DbUserTableColumn(DbUserTableColumnPK dbUserTableColumnPK) {
    this.dbUserTableColumnPK = dbUserTableColumnPK;
  }

  public void setDbUserTableColumnPK (DbUserTableColumnPK dbUserTableColumn) {
    this.dbUserTableColumnPK = dbUserTableColumn;
  }
  public DbUserTableColumnPK getDbUserTableColumnPK () {
    return this.dbUserTableColumnPK;
  }
  
  public String getTableName () {
    return this.getDbUserTableColumnPK().getTableName();
  }
  public String getColumnName () {
    return this.getDbUserTableColumnPK().getColumnName();
  }

  public String getDataType() {
    return dataType;
  }

  public void setDataType(String dataType) {
    this.dataType = dataType;
  }

  public Integer getDataLength() {
    return dataLength;
  }

  public void setDataLength(Integer dataLength) {
    this.dataLength = dataLength;
  }

  public Integer getDataPrecision() {
    return dataPrecision;
  }

  public void setDataPrecision(Integer dataPrecision) {
    this.dataPrecision = dataPrecision;
  }

  public Integer getDataScale() {
    return dataScale;
  }

  public void setDataScale(Integer dataScale) {
    this.dataScale = dataScale;
  }

  public Integer getColumnId() {
    return columnId;
  }

  public void setColumnId(Integer columnId) {
    this.columnId = columnId;
  }

  public String getNullable() {
    return nullable;
  }

  public void setNullable(String nullable) {
    this.nullable = nullable;
  }

  public String getDataDefault() {
    return dataDefault;
  }
  public void setDataDefault(String dataDefault) {
    this.dataDefault = dataDefault;
  }
  
//  public boolean

  public int getFieldWidth() {
    int fieldWidth = 20;
//    if (fieldWidth == null) {
    String dataType = this.getDataType();
    Integer dataLength = this.getDataLength();
    Integer dataPrecision = this.getDataPrecision();
    Integer dataScale = this.getDataScale();
      switch (dataType) {
      case "VARCHAR":
      case "VARCHAR2":
      case "NVARCHAR2":
      case "CHAR":
      case "NCHAR":
        fieldWidth = Math.min(this.dataLength, 40);
        break;
      case "NUMBER":
        try {
          fieldWidth = Math.min((this.dataPrecision+this.dataScale), 10);
        }
        catch (NullPointerException e) {
          fieldWidth = 39;
          out.println("getFieldWidth threw NullPointerException.");
          out.println("  this.getTableName() = " + this.getTableName());
          out.println("  this.getColumnName() = " + this.getColumnName());
          out.println("  this.getDataPrecision() = " + this.getDataPrecision());
          out.println("  this.getDataScale() = " + this.getDataScale());
        }
        break;
      case "DATE":
        fieldWidth = 12; 
        break;
      case "TIMESTAMP":
        fieldWidth = 20; 
        break;
      case "CLOB":
        fieldWidth = 41;
        break;
      }      
//    }    
    return fieldWidth;
  }
  
  @Override
  public int hashCode() {
//    int hash = 0;
//    hash += (airportId != null ? airportId.hashCode() : 0);
    return 101;
  }

//  @Override
//  public boolean equals(Object object) {
//    // TODO: Warning - this method won't work in the case the id fields are not set
//    if (!(object instanceof Airport)) {
//      return false;
//    }
//    Airport other = (Airport) object;
//    if ((this.airportId == null && other.airportId != null) || (this.airportId != null && !this.airportId.equals(other.airportId))) {
//      return false;
//    }
//    return true;
//  }

  @Override
  public String toString() {
    return this.dbUserTableColumnPK.getTableName() + ": " + this.dbUserTableColumnPK.getColumnName();
  }
  
}

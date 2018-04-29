package com.radinfodesign.metamodel;

import java.io.Serializable;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Embeddable;

/**
 *
 * @author Tarzan
 */
@Embeddable
public class DbUserTableColumnPK implements Serializable {

  @Basic(optional = false)
  @Column(name = "TABLE_NAME")
  private String tableName;
  @Basic(optional = false)
  @Column(name = "COLUMN_NAME")
  private String columnName;

  public DbUserTableColumnPK() {
  }

  public void setTableName(String tableName) {
    this.tableName = tableName;
  }
  public String getTableName() {
    return this.tableName;
  }
  public void setColumnName(String columnName) {
    this.columnName = columnName;
  }
  public String getColumnName() {
    return this.columnName;
  }



  @Override
  public int hashCode() {
//    int hash = 0;
//    hash += (tableName != null ? tableName.hashCode() : 0);
//    hash += (columnName != null ? columnName.hashCode() : 0);
    return 100;
  }

  @Override
  public boolean equals(Object object) {
    // TODO: Warning - this method won't work in the case the id fields are not set
    if (!(object instanceof DbUserTableColumnPK)) {
      return false;
    }
    DbUserTableColumnPK other = (DbUserTableColumnPK) object;
    if ((this.tableName == null && other.tableName != null) || (this.tableName != null && !this.tableName.equals(other.tableName))) {
      return false;
    }
    if ((this.columnName == null && other.columnName != null) || (this.columnName != null && !this.columnName.equals(other.columnName))) {
      return false;
    }
    return true;
  }

  @Override
  public String toString() {
    return "[ tableName=" + tableName + ", columnName=" + columnName + " ]";
  }
  
}

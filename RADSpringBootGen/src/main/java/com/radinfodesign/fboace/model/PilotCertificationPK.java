/*
 * Sample application model entity class for RADSpringBootGen
 * Copyright(c) 2018 by RADical Information Design Corporation
 * PilotCertificationPK
 *   Representing compound (multi-column) primary key
 */
package com.radinfodesign.fboace.model;

import java.io.Serializable;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Embeddable;

/**
 *
 * @author Tarzan
 */
@Embeddable
public class PilotCertificationPK implements Serializable {

  @Basic(optional = false)
  @Column(name = "PILOT_ID")
  private Integer pilotId;
  @Basic(optional = false)
  @Column(name = "AIRCRAFT_TYPE_ID")
  private Integer aircraftTypeId;

  public PilotCertificationPK() {
  }

  public PilotCertificationPK(Integer pilotId, Integer aircraftTypeId) {
    this.pilotId = pilotId;
    this.aircraftTypeId = aircraftTypeId;
  }

  public Integer getPilotId() {
    return pilotId;
  }

  public void setPilotId(Integer pilotId) {
    this.pilotId = pilotId;
  }

  public Integer getAircraftTypeId() {
    return aircraftTypeId;
  }

  public void setAircraftTypeId(Integer aircraftTypeId) {
    this.aircraftTypeId = aircraftTypeId;
  }

  @Override
  public int hashCode() {
    int hash = 0;
    hash += (pilotId != null ? pilotId.hashCode() : 0);
    hash += (aircraftTypeId != null ? aircraftTypeId.hashCode() : 0);
    return hash;
  }

  @Override
  public boolean equals(Object object) {
    // TODO: Warning - this method won't work in the case the id fields are not set
    if (!(object instanceof PilotCertificationPK)) {
      return false;
    }
    PilotCertificationPK other = (PilotCertificationPK) object;
    if ((this.pilotId == null && other.pilotId != null) || (this.pilotId != null && !this.pilotId.equals(other.pilotId))) {
      return false;
    }
    if ((this.aircraftTypeId == null && other.aircraftTypeId != null) || (this.aircraftTypeId != null && !this.aircraftTypeId.equals(other.aircraftTypeId))) {
      return false;
    }
    return true;
  }

  @Override
  public String toString() {
    return "com.radinfodesign.fboace03.entities.PilotCertificationPK[ pilotId=" + pilotId + ", aircraftTypeId=" + aircraftTypeId + " ]";
  }
  
}

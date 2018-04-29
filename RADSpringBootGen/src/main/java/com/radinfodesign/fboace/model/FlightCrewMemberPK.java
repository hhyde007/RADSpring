/*
 * Sample application model entity class for RADSpringBootGen
 * Copyright(c) 2018 by RADical Information Design Corporation
 * FlightCrewMemberPK
 *   Representing compound (multi-column) primary key
 */
package com.radinfodesign.fboace.model;

import java.io.Serializable;
import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Embeddable;

import com.radinfodesign.radspringbootgen.model.Label;

/**
 *
 * @author Tarzan
 */
@Embeddable
public class FlightCrewMemberPK implements Serializable {

  @Basic(optional = false)
  @Column(name = "FLIGHT_ID")
  @Label (name="Flaight")
  private Integer flightId;
  @Basic(optional = false)
  @Column(name = "PILOT_ID")
  @Label (name="Pie-Lot")
  private Integer pilotId;

  public FlightCrewMemberPK() {
  }

  public FlightCrewMemberPK(Integer flightId, Integer pilotId) {
    this.flightId = flightId;
    this.pilotId = pilotId;
  }

  public Integer getFlightId() {
    return flightId;
  }

  public void setFlightId(Integer flightId) {
    this.flightId = flightId;
  }

  public Integer getPilotId() {
    return pilotId;
  }

  public void setPilotId(Integer pilotId) {
    this.pilotId = pilotId;
  }

  @Override
  public int hashCode() {
    int hash = 0;
    hash += (flightId != null ? flightId.hashCode() : 0);
    hash += (pilotId != null ? pilotId.hashCode() : 0);
    return hash;
  }

  @Override
  public boolean equals(Object object) {
    // TODO: Warning - this method won't work in the case the id fields are not set
    if (!(object instanceof FlightCrewMemberPK)) {
      return false;
    }
    FlightCrewMemberPK other = (FlightCrewMemberPK) object;
    if (this.flightId == null | other.pilotId != null) return false;
    if ((this.flightId.equals(other.flightId)) & (this.pilotId.equals(other.pilotId))) {
      return true;
    }
    else {
      return false;
    }
  }

  @Override
  public String toString() {
    return "com.radinfodesign.fboace03.entities.FlightCrewMemberPK[ flightId=" + flightId + ", pilotId=" + pilotId + " ]";
  }
  
}

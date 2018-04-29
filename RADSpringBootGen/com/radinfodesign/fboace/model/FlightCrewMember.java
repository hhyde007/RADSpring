/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.radinfodesign.fboace.model;

import java.io.Serializable;
import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;
import javax.xml.bind.annotation.XmlRootElement;

/**
 *
 * @author Tarzan
 */
@Entity
@Table(name = "FLIGHT_CREW_MEMBER")
@XmlRootElement
public class FlightCrewMember implements Serializable {

  private static final long serialVersionUID = 1L;
  @EmbeddedId
  protected FlightCrewMemberPK flightCrewMemberPK;
  @Column(name = "NOTES")
  private String notes;
  @JoinColumn(name = "FLIGHT_ID", referencedColumnName = "FLIGHT_ID", insertable = false, updatable = false)
  @ManyToOne(optional = false)
  @Label (name="Flight")
  private Flight flight;
  @JoinColumn(name = "PILOT_ID", referencedColumnName = "PILOT_ID", insertable = false, updatable = false)
  @ManyToOne(optional = false)
  @Label (name="Pilot")
  private Pilot pilot;

  public FlightCrewMember() {
  }

  public FlightCrewMember(FlightCrewMemberPK flightCrewMemberPK) {
    this.flightCrewMemberPK = flightCrewMemberPK;
  }

  public FlightCrewMember(Flight flight, Pilot pilot) {
    this.flightCrewMemberPK = new FlightCrewMemberPK(flight.getFlightId(), pilot.getPilotId());
    this.flight = flight;
    this.pilot = pilot;
  }

  public FlightCrewMember(Integer flightId, Integer pilotId) {
	    this.flightCrewMemberPK = new FlightCrewMemberPK(flightId, pilotId);
  }

  public FlightCrewMemberPK getFlightCrewMemberPK() {
    return flightCrewMemberPK;
  }

  public void setFlightCrewMemberPK(FlightCrewMemberPK flightCrewMemberPK) {
    this.flightCrewMemberPK = flightCrewMemberPK;
  }

  public String getNotes() {
    return notes;
  }

  public void setNotes(String notes) {
    this.notes = notes;
  }

  public Flight getFlight() {
    return flight;
  }

  public Integer getFlightId() {
	    return this.flight!=null?flight.getFlightId():null;
  }

  public void setFlight(Flight flight) {
    this.flight = flight;
  }

  public Pilot getPilot() {
    return pilot;
  }
  public Integer getPilotId() {
	    return this.pilot!=null?pilot.getPilotId():null;
  }

  public void setPilot(Pilot pilot) {
    this.pilot = pilot;
  }

  @Override
  public int hashCode() {
    int hash = 0;
    hash += (flightCrewMemberPK != null ? flightCrewMemberPK.hashCode() : 0);
    return hash;
  }

  @Override
  public boolean equals(Object object) {
    // TODO: Warning - this method won't work in the case the id fields are not set
    if (!(object instanceof FlightCrewMember)) {
      return false;
    }
    FlightCrewMember other = (FlightCrewMember) object;
    if ((this.flightCrewMemberPK == null && other.flightCrewMemberPK != null) || (this.flightCrewMemberPK != null && !this.flightCrewMemberPK.equals(other.flightCrewMemberPK))) {
      return false;
    }
    return true;
  }

  @Override
  public String toString() {
    if (this.getPilotId() != null && this.getFlightId() != null) {
      return this.pilot.getLastName()+ ", " + this.pilot.getFirstName() + " crew member for flight " + this.flight.getShortName();
    }
    else return ("New/blank Flight Crew Member Record");
  }
  
}

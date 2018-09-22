/*
 * Sample application model entity class for RADSpringBootGen
 * Copyright(c) 2018 by RADical Information Design Corporation
 * Flight
 */
package com.radinfodesign.radspringbootgen.fboace.model;

import java.io.Serializable;
import java.util.Collection;
import java.time.LocalDateTime;
import javax.persistence.Basic;
import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.OneToMany;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlTransient;

import com.radinfodesign.radspringbootgen.model.Label;

/**
 *
 * @author Tarzan
 */
@Entity
@Table(name = "FLIGHT")
@XmlRootElement
public class Flight implements Serializable {

  private static final long serialVersionUID = 1L;
  @Id
  @Basic(optional = false)
  @Column(name = "FLIGHT_ID")
  @GeneratedValue(generator="InvSeq")
  @SequenceGenerator(name="InvSeq", sequenceName="FLIGHT_PK_SEQ")
  private Integer flightId;
  
  @Basic(optional = false)
  @Column(name = "SHORT_NAME")
  private String shortName;
  @Column(name = "LONG_NAME")
  private String longName;
  @Column(name = "DEPARTURE_DATE_TIME")
  private LocalDateTime departureDateTime;
  @Column(name = "ARRIVAL_DATE_TIME")
  private LocalDateTime arrivalDateTime;
  @Column(name = "NOTES")
  private String notes;
  @JoinColumn(name = "AIRCRAFT_ID", referencedColumnName = "AIRCRAFT_ID")
  @ManyToOne(optional = false)
  @Label (name="Aircraft")
  private Aircraft aircraft;
  @JoinColumn(name = "AIRPORT_ID_DEPARTURE", referencedColumnName = "AIRPORT_ID")
  @ManyToOne
  @Label (name="Departure Airport")
  private Airport airportDeparture;
  @JoinColumn(name = "AIRPORT_ID_DESTINATION", referencedColumnName = "AIRPORT_ID")
  @ManyToOne
  @Label (name="Destination Airport")
  private Airport airportDestination;
  @OneToMany(cascade = CascadeType.PERSIST, mappedBy = "flight")
  private Collection<FlightCrewMember> flightCrewMemberCollection;

  public Flight() {
  }

  public Flight(Integer flightId) {
    this.flightId = flightId;
  }

  public Flight(Integer flightId, String shortName) {
    this.flightId = flightId;
    this.shortName = shortName;
  }

  public Integer getFlightId() {
	    return flightId;
	  }

  public Integer getId() {
	    return flightId;
	  }

  public void setFlightId(Integer flightId) {
    this.flightId = flightId;
  }

  public String getShortName() {
    return shortName;
  }

  public void setShortName(String shortName) {
    this.shortName = shortName;
  }

  public String getLongName() {
    return longName;
  }

  public void setLongName(String longName) {
    this.longName = longName;
  }

  public LocalDateTime getDepartureDateTime() {
    return departureDateTime;
  }

  public void setDepartureDateTime(LocalDateTime departureDateTime) {
    this.departureDateTime = departureDateTime;
  }

  public LocalDateTime getArrivalDateTime() {
    return arrivalDateTime;
  }

  public void setArrivalDateTime(LocalDateTime arrivalDateTime) {
    this.arrivalDateTime = arrivalDateTime;
  }

  public String getNotes() {
    return notes;
  }

  public void setNotes(String notes) {
    this.notes = notes;
  }

  @XmlTransient
  @Label (name="Flight Crew Member")
  public Collection<FlightCrewMember> getFlightCrewMemberCollection() {
    return flightCrewMemberCollection;
  }

  public void setFlightCrewMemberCollection(Collection<FlightCrewMember> flightCrewMemberCollection) {
    this.flightCrewMemberCollection = flightCrewMemberCollection;
  }

  public Aircraft getAircraft() {
    return aircraft;
  }

  public Integer getAircraftId() {
    return this.aircraft==null?null:this.aircraft.getAircraftId();
  }

  public void setAircraft(Aircraft aircraft) {
    this.aircraft = aircraft;
  }

  public Airport getAirportDeparture() {
    return airportDeparture;
  }

  public Integer getAirportIdDeparture() {
    return airportDeparture==null?null:airportDeparture.getId();
  }

  public void setAirportDeparture(Airport airportDeparture) {
    this.airportDeparture = airportDeparture;
  }

  public Airport getAirportDestination() {
    return airportDestination;
  }

  public Integer getAirportIdDestination() {
    return airportDestination==null?null:airportDestination.getId();
  }

  public void setAirportDestination(Airport airportDestination) {
    this.airportDestination = airportDestination;
  }

  @Override
  public int hashCode() {
    int hash = 0;
    hash += (flightId != null ? flightId.hashCode() : 0);
    return hash;
  }

  @Override
  public boolean equals(Object object) {
    if (!(object instanceof Flight)) {
      return false;
    }
    Flight other = (Flight) object;
    if ((this.flightId == null && other.flightId != null) 
        || (this.flightId != null && !this.flightId.equals(other.flightId))) {
      return false;
    }
    return true;
  }

  @Override
  public String toString() {
    return this.shortName;
  }
  
}

/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package com.radinfodesign.fboace.model;

import java.io.Serializable;
import java.util.Collection;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlTransient;

/**
 *
 * @author Tarzan
 */
@Entity
@Table(name = "AIRPORT")
@XmlRootElement
public class Airport implements Serializable {

  private static final long serialVersionUID = 1L;
  // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
  @Id
  @Basic(optional = false)
  @Column(name = "AIRPORT_ID")
  @GeneratedValue(generator="InvSeq")
  @SequenceGenerator(name="InvSeq", sequenceName="AIRPORT_PK_SEQ")
  private Integer airportId;
  @Label (name = "Name")
  @Basic(optional = false)
  @Column(name = "SHORT_NAME")
  private String shortName;
  @Label (name = "IATA Code")
  @Basic(optional = false)
  @Column(name = "IATA_CODE")
  private String iataCode;
  @Column(name = "DESCRIPTION")
  private String description;
  @Column(name = "PORT_TYPE")
  private String portType;
  @Label (name="Flights as Departure")
  @ExcludeEditFromParentModule
  @OneToMany(mappedBy = "airportIdDeparture")
  private Collection<Flight> flightDepartureCollection;
  @Label (name="Flights as Destination")
  @ExcludeEditFromParentModule
  @OneToMany(mappedBy = "airportIdDestination")
  private Collection<Flight> flightDestinationCollection;

  public Airport() {
  }

  public Airport(Integer airportId) {
    this.airportId = airportId;
  }

  public Airport(Integer airportId, String shortName, String iataCode) {
    this.airportId = airportId;
    this.shortName = shortName;
    this.iataCode = iataCode;
  }

  public Integer getAirportId() {
	    return airportId;
	  }

  public Integer getId() {
	    return airportId;
	  }

  public void setAirportId(Integer airportId) {
    this.airportId = airportId;
  }

  public String getShortName() {
    return shortName;
  }

  public void setShortName(String shortName) {
    this.shortName = shortName;
  }

  public String getIataCode() {
    return iataCode;
  }

  public void setIataCode(String iataCode) {
    this.iataCode = iataCode;
  }

  public String getDescription() {
    return description;
  }

  public void setDescription(String description) {
    this.description = description;
  }

  public String getPortType() {
    return portType;
  }

  public void setPortType(String portType) {
    this.portType = portType;
  }

  @XmlTransient
  public Collection<Flight> getFlightDepartureCollection() {
    return flightDepartureCollection;
  }

  public void setFlightDepartureCollection(Collection<Flight> flightDepartureCollection) {
    this.flightDepartureCollection = flightDepartureCollection;
  }

  @XmlTransient
  public Collection<Flight> getFlightDestinationCollection() {
	    return flightDestinationCollection;
	  }

  public void setFlightDestinationCollection(Collection<Flight> flightDestinationCollection) {
    this.flightDestinationCollection = flightDestinationCollection;
  }

  @Override
  public int hashCode() {
    int hash = 0;
    hash += (airportId != null ? airportId.hashCode() : 0);
    return hash;
  }

  @Override
  public boolean equals(Object object) {
    // TODO: Warning - this method won't work in the case the id fields are not set
    if (!(object instanceof Airport)) {
      return false;
    }
    Airport other = (Airport) object;
    if ((this.airportId == null && other.airportId != null) || (this.airportId != null && !this.airportId.equals(other.airportId))) {
      return false;
    }
    return true;
  }

  @Override
  public String toString() {
    return this.iataCode + ": " + this.shortName;
//    return "com.radinfodesign.fboace02.entities.Airport[ airportId=" + airportId + " ]";
  }
  
}

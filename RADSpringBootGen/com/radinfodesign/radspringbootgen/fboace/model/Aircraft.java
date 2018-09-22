/*
 * Sample application model entity class for RADSpringBootGen
 * Copyright(c) 2018 by RADical Information Design Corporation
 * Aircraft
 */
package com.radinfodesign.radspringbootgen.fboace.model;

import java.io.Serializable;
import java.util.Collection;
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
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlTransient;

import com.radinfodesign.radspringbootgen.model.ExcludeFromParentModule;
import com.radinfodesign.radspringbootgen.model.Label;


/**
 *
 * @author Tarzan
 */
@Entity
@Table(name = "AIRCRAFT")
@XmlRootElement 
public class Aircraft implements Serializable {

  private static final long serialVersionUID = 1L;
  // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
  @Id
  @Basic(optional = false)
  @Column(name = "AIRCRAFT_ID")
  @GeneratedValue(generator="InvSeq")
  @SequenceGenerator(name="InvSeq", sequenceName="AIRCRAFT_PK_SEQ")
  private Integer aircraftId;
  @Basic(optional = false)
  @Column(name = "SHORT_NAME")
  private String shortName;
  @Basic(optional = false)
  @Column(name = "LONG_NAME") 
  private String longName;
  @Column(name = "DESCRIPTION")
  private String description;
  @Column(name = "NOTES")
  private String notes;
  @Label (name="Aircraft Type")
  @JoinColumn(name = "AIRCRAFT_TYPE_ID", referencedColumnName = "AIRCRAFT_TYPE_ID")
  @ManyToOne(optional = false)
  private AircraftType aircraftType;
  @Label (name = "Flights scheduled for this Aircraft")
  @ExcludeFromParentModule
  @OneToMany(cascade = CascadeType.ALL, mappedBy = "aircraft")
  private Collection<Flight> flightCollection;

  public Aircraft() {
  }

  public Aircraft(Integer aircraftId) {
    this.aircraftId = aircraftId;
  }

  public Aircraft(Integer aircraftId, String shortName, String longName) {
    this.aircraftId = aircraftId;
    this.shortName = shortName;
    this.longName = longName;
  }

  public Integer getAircraftId() {
    return aircraftId;
  }

  public Integer getId() { return aircraftId; }

  public void setAircraftId(Integer aircraftId) {
    this.aircraftId = aircraftId;
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

  public String getDescription() {
    return description;
  }

  public void setDescription(String description) {
    this.description = description;
  }

  public String getNotes() {
    return notes;
  }

  public void setNotes(String notes) {
    this.notes = notes;
  }

  public AircraftType getAircraftType() {
    return aircraftType;
  }

  public Integer getAircraftTypeId() {
    return aircraftType==null?null:aircraftType.getId();
  }

  public void setAircraftType(AircraftType aircraftType) {
    this.aircraftType = aircraftType;
  }

  @XmlTransient
  public Collection<Flight> getFlightCollection() {
    return flightCollection;
  }

  public void setFlightCollection(Collection<Flight> flightCollection) {
    this.flightCollection = flightCollection;
  }

  @Override
  public int hashCode() {
    int hash = 0;
    hash += (aircraftId != null ? aircraftId.hashCode() : 0);
    return hash;
  }

  @Override
  public boolean equals(Object object) {
    // TODO: Warning - this method won't work in the case the id fields are not set
    if (!(object instanceof Aircraft)) {
      return false;
    }
    Aircraft other = (Aircraft) object;
    if ((this.aircraftId == null && other.aircraftId != null) || (this.aircraftId != null && !this.aircraftId.equals(other.aircraftId))) {
      return false;
    }
    return true;
  }

  @Override
  public String toString() {
    return (this.getAircraftType()!=null?this.getAircraftType().getShortName() + ": " + this.shortName:this.shortName);
  }
  
}

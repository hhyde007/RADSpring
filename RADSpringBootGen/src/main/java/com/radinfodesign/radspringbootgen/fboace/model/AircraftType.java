/*
 * Sample application model entity class for RADSpringBootGen
 * Copyright(c) 2018 by RADical Information Design Corporation
 * AircraftType
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
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
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
@Table(name = "AIRCRAFT_TYPE")
@XmlRootElement
public class AircraftType implements Serializable {

  private static final long serialVersionUID = 1L;
  // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
  @Id
  @Basic(optional = false)
  @Column(name = "AIRCRAFT_TYPE_ID")
  @GeneratedValue(generator="InvSeq")
  @SequenceGenerator(name="InvSeq", sequenceName="AIRCRAFT_TYPE_PK_SEQ")
  private Integer aircraftTypeId;
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
  @OneToMany(cascade = CascadeType.ALL, mappedBy = "aircraftType")
  private Collection<Aircraft> aircraftCollection;
  @OneToMany(cascade = CascadeType.ALL, mappedBy = "aircraftType")
  private Collection<PilotCertification> pilotCertificationCollection;

  public AircraftType() {
  }

  public AircraftType(Integer aircraftTypeId) {
    this.aircraftTypeId = aircraftTypeId;
  }

  public AircraftType(Integer aircraftTypeId, String shortName, String longName) {
    this.aircraftTypeId = aircraftTypeId;
    this.shortName = shortName;
    this.longName = longName;
  }

  public Integer getAircraftTypeId() {
	    return aircraftTypeId;
	  }

  public Integer getId() {
	    return aircraftTypeId;
	  }

  public void setAircraftTypeId(Integer aircraftTypeId) {
    this.aircraftTypeId = aircraftTypeId;
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

  @XmlTransient
  public Collection<Aircraft> getAircraftCollection() {
    return aircraftCollection;
  }

  public void setAircraftCollection(Collection<Aircraft> aircraftCollection) {
    this.aircraftCollection = aircraftCollection;
  }
  

  @XmlTransient
  public Collection<PilotCertification> getPilotCertificationCollection() {
    return pilotCertificationCollection;
  }

  public void setPilotCertificationCollection(Collection<PilotCertification> pilotCertificationCollection) {
    this.pilotCertificationCollection = pilotCertificationCollection;
  }
  
  @Override
  public int hashCode() {
    int hash = 0;
    hash += (aircraftTypeId != null ? aircraftTypeId.hashCode() : 0);
    return hash;
  }

  @Override
  public boolean equals(Object object) {
    // TODO: Warning - this method won't work in the case the id fields are not set
    if (!(object instanceof AircraftType)) {
      return false;
    }
    AircraftType other = (AircraftType) object;
    if ((this.aircraftTypeId == null && other.aircraftTypeId != null) || (this.aircraftTypeId != null && !this.aircraftTypeId.equals(other.aircraftTypeId))) {
      return false;
    }
    return true;
  }

  @Override
  public String toString() {
    return this.shortName + ": " + this.longName;
  }
  
}

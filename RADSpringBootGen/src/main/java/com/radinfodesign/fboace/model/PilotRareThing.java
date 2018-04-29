/*
 * Sample application model entity class for RADSpringBootGen
 * Copyright(c) 2018 by RADical Information Design Corporation
 * PilotRareThing
 *  Child of Pilot in @OneToOne relationship
 *  (Couldn't think of a better real-world example, hence the name.)
 */
package com.radinfodesign.fboace.model;

import java.io.Serializable;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.Id;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.Table;
import javax.xml.bind.annotation.XmlRootElement;

/**
 *
 * @author Tarzan
 */
@Entity
@Table(name = "VW_PILOT_RARE_THING")
@XmlRootElement
public class PilotRareThing implements Serializable {

  private static final long serialVersionUID = 1L;
  // @Max(value=?)  @Min(value=?)//if you know range of your decimal fields consider using these annotations to enforce field validation
  @Id
  @Basic(optional = false)
  @Column(name="PILOT_ID")
  private Integer pilotId;  
  
//  @OneToOne(cascade = CascadeType.PERSIST, mappedBy = "pilotRareThing")

//  @OneToOne
//  @MapsId
  @JoinColumn(name = "PILOT_ID", referencedColumnName = "PILOT_ID", insertable = false, updatable = false)
  @ManyToOne(optional = false)
  private Pilot pilot;
  
  @Basic(optional = false)
  @Column(name = "SHORT_NAME")
  private String shortName;
  @Column(name = "LONG_NAME")
  private String longName;
  @Column(name = "NOTES")
  private String notes;

  public PilotRareThing() {
  }

  public PilotRareThing(Integer pilotId) {
    this.pilotId = pilotId;
  }

  public PilotRareThing(Integer pilotId, String shortName, String longName) {
    this.pilotId = pilotId;
    this.shortName = shortName;
    this.longName = longName;
  }

  public Pilot getPilot() {
    return pilot;
  }

  public void setPilot(Pilot pilot) {
    this.pilot = pilot;
    this.pilotId=pilot.getPilotId();
  }

  public Integer getPilotId() {
	    return pilotId;
	  }

  public Integer getId() {
	    return pilotId;
	  }

  public void setPilotId(Integer pilotId) {
    this.pilotId = pilotId;
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


  public String getNotes() {
    return notes;
  }

  public void setNotes(String notes) {
    this.notes = notes;
  }

  @Override
  public int hashCode() {
    int hash = 0;
    hash += (pilotId != null ? pilotId.hashCode() : 0);
    return hash;
  }

  @Override
  public boolean equals(Object object) {
    // TODO: Warning - this method won't work in the case the id fields are not set
    if (!(object instanceof PilotRareThing)) {
      return false;
    }
    PilotRareThing other = (PilotRareThing) object;
    if ((this.pilotId == null && other.pilotId != null) || (this.pilotId != null && !this.pilotId.equals(other.pilotId))) {
      return false;
    }
    return true;
  }

  @Override
  public String toString() {
    return this.shortName;
//    return "com.radinfodesign.fboace02.entities.PilotRareThing[ pilotId=" + pilotId + " ]";
  }
  
}

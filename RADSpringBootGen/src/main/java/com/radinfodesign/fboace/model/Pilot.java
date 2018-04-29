/*
 * Sample application model entity class for RADSpringBootGen
 * Copyright(c) 2018 by RADical Information Design Corporation
 * Pilot
 */
package com.radinfodesign.fboace.model;

import java.io.Serializable;
import java.time.LocalDate;
import java.util.Collection;

import javax.persistence.Basic;
import javax.persistence.CascadeType;
//import javax.persistence.CascadeType;
import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.Id;
import javax.persistence.OneToMany;
import javax.persistence.OneToOne;
import javax.persistence.SequenceGenerator;
import javax.persistence.Table;
import javax.xml.bind.annotation.XmlRootElement;
import javax.xml.bind.annotation.XmlTransient;

/**
 *
 * @author Tarzan
 */
@Entity
@Table(name = "PILOT")
@XmlRootElement
public class Pilot implements Serializable {

  private static final long serialVersionUID = 1L;

  @Id
  @Basic(optional = false)
  @Column(name = "PILOT_ID")
  @GeneratedValue(generator="InvSeq")
  @SequenceGenerator(name="InvSeq", sequenceName="PILOT_PK_SEQ")
  private Integer pilotId;
  
  @Basic(optional = false)
  @Column(name = "LAST_NAME")
  private String lastName;
  @Basic(optional = false)
  @Column(name = "FIRST_NAME")
  private String firstName;
  @Column(name = "MIDDLE_INITIAL")
  private String middleInitial;
  @Basic(optional = false)
  @Column(name = "NATIONAL_ID_NUMBER")
  private String nationalIdNumber;
  @Basic(optional = false)
  @Column(name = "BIRTHDATE")
  private LocalDate birthdate;
  @Column(name = "NOTES")
  private String notes;
  @OneToMany(mappedBy = "pilot")
  private Collection<PilotCertification> pilotCertificationCollection;
  @OneToMany(mappedBy = "pilot")
  private Collection<FlightCrewMember> flightCrewMemberCollection;
  
  @OneToMany(mappedBy = "pilot")
  private Collection<PilotRareThing> pilotRareThingCollection;

//  @OneToOne(cascade = CascadeType.PERSIST, mappedBy = "pilot")
//  @OneToMany(cascade = CascadeType.PERSIST, mappedBy = "pilot")
//  private PilotRareThing pilotRareThing;

  public Pilot() {
  }

  public Pilot(Integer pilotId) {
    this.pilotId = pilotId;
  }

  public Pilot(Integer pilotId, String lastName, String firstName, String nationalIdNumber, LocalDate birthdate) {
    this.pilotId = pilotId;
    this.lastName = lastName;
    this.firstName = firstName;
    this.nationalIdNumber = nationalIdNumber;
    this.birthdate = birthdate;
  }

  public Integer getPilotId() {
    return pilotId;
  }

  public Integer getId() { return pilotId; }

  public void setPilotId(Integer pilotId) {
    this.pilotId = pilotId;
  }

//  public PilotRareThing getPilotRareThing() {
//    return pilotRareThing;
//  }
//
//  public void setPilotRareThing(PilotRareThing pilotRareThing) {
//    this.pilotRareThing = pilotRareThing;
//  }

  public Collection<PilotRareThing> getPilotRareThingCollection() {
    return pilotRareThingCollection;
  }

  public void setPilotRareThingCollection(Collection<PilotRareThing> pilotRareThingCollection) {
    this.pilotRareThingCollection = pilotRareThingCollection;
  }

  public String getLastName() {
    return lastName;
  }

  public void setLastName(String lastName) {
    this.lastName = lastName;
  }

  public String getFirstName() {
    return firstName;
  }

  public void setFirstName(String firstName) {
    this.firstName = firstName;
  }

  public String getMiddleInitial() {
    return middleInitial;
  }

  public void setMiddleInitial(String middleInitial) {
    this.middleInitial = middleInitial;
  }

  public String getNationalIdNumber() {
    return nationalIdNumber;
  }

  public void setNationalIdNumber(String nationalIdNumber) {
    this.nationalIdNumber = nationalIdNumber;
  }

  public LocalDate getBirthdate() {
    return birthdate;
  }

  public void setBirthdate(LocalDate birthdate) {
    this.birthdate = birthdate;
  }

  public String getNotes() {
    return notes;
  }

  public void setNotes(String notes) {
    this.notes = notes;
  }

  @XmlTransient
  public Collection<FlightCrewMember> getFlightCrewMemberCollection() {
    return flightCrewMemberCollection;
  }

  public void setFlightCrewMemberCollection(Collection<FlightCrewMember> flightCrewMemberCollection) {
    this.flightCrewMemberCollection = flightCrewMemberCollection;
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
    hash += (pilotId != null ? pilotId.hashCode() : 0);
    return hash;
  }

  @Override
  public boolean equals(Object object) {
    // TODO: Warning - this method won't work in the case the id fields are not set
    if (!(object instanceof Pilot)) {
      return false;
    }
    Pilot other = (Pilot) object;
    if ((this.pilotId == null && other.pilotId != null) || (this.pilotId != null && !this.pilotId.equals(other.pilotId))) {
      return false;
    }
    return true;
  }

  @Override
  public String toString() {
	String certs = "";
	for (PilotCertification certification: getPilotCertificationCollection()) {
	  if (certification.getAircraftType() != null) { // THIS CONDITION SHOULD NOT REQUIRE TESTING!!!
	    certs += certification.getAircraftType().getShortName() + ", ";
	  }
	}
	certs = (certs.length()>1?certs.substring(0, certs.length()-2):certs);  
    return this.lastName + ", " + this.firstName + ": " + certs;
  }
    
}

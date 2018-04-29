/*
 * Sample application model entity class for RADSpringBootGen
 * Copyright(c) 2018 by RADical Information Design Corporation
 * FlightCrewMember
 *   Associative entity resolving many-to-many relationship between Pilot and AircraftType
 */
package com.radinfodesign.fboace.model;

import java.io.Serializable;
import java.time.LocalDate;

import javax.persistence.Basic;
import javax.persistence.Column;
import javax.persistence.EmbeddedId;
import javax.persistence.Entity;
import javax.persistence.JoinColumn;
import javax.persistence.ManyToOne;
import javax.persistence.NamedQueries;
import javax.persistence.NamedQuery;
import javax.persistence.Table;
import javax.persistence.Temporal;
import javax.persistence.TemporalType;
import javax.xml.bind.annotation.XmlRootElement;

/**
 *
 * @author Tarzan
 */
@Entity
@Table(name = "PILOT_CERTIFICATION")
@XmlRootElement
public class PilotCertification implements Serializable {

  private static final long serialVersionUID = 1L;
  @EmbeddedId
  protected PilotCertificationPK pilotCertificationPK;
  @Basic(optional = false)
  @Column(name = "CERTIFICATION_NUMBER")
  private String certificationNumber;
  @Basic(optional = false)
  @Column(name = "VALID_FROM_DATE")
  private LocalDate validFromDate;
  @Basic(optional = false)
  @Column(name = "EXPIRATION_DATE")
  private LocalDate expirationDate;
  @Column(name = "NOTES")
  private String notes;
  
  @JoinColumn(name = "PILOT_ID", referencedColumnName = "PILOT_ID", insertable = false, updatable = false)
  @ManyToOne(optional = false)
  private Pilot pilot;

  @JoinColumn(name = "AIRCRAFT_TYPE_ID", referencedColumnName = "AIRCRAFT_TYPE_ID", insertable = false, updatable = false)  
  @ManyToOne(optional = false)
  private AircraftType aircraftType;

  public PilotCertification() {
  }

  public PilotCertification(PilotCertificationPK pilotCertificationPK) {
    this.pilotCertificationPK = pilotCertificationPK;
  }

  public PilotCertification(PilotCertificationPK pilotCertificationPK, String certificationNumber, LocalDate validFromDate, LocalDate expirationDate) {
    this.pilotCertificationPK = pilotCertificationPK;
    this.certificationNumber = certificationNumber;
    this.validFromDate = validFromDate;
    this.expirationDate = expirationDate;
  }

  public PilotCertification(Integer pilotId, Integer aircraftTypeId) {
	    this.pilotCertificationPK = new PilotCertificationPK(pilotId, aircraftTypeId);
	  }

  public PilotCertification(Pilot pilot, AircraftType aircraftType) {
	    this.pilotCertificationPK = new PilotCertificationPK(pilot.getPilotId(), aircraftType.getAircraftTypeId());
	    this.pilot = pilot;
	    this.aircraftType = aircraftType;
	  }

  public PilotCertificationPK getPilotCertificationPK() {
    return pilotCertificationPK;
  }

  public void setPilotCertificationPK(PilotCertificationPK pilotCertificationPK) {
    this.pilotCertificationPK = pilotCertificationPK;
  }

  public String getCertificationNumber() {
    return certificationNumber;
  }

  public void setCertificationNumber(String certificationNumber) {
    this.certificationNumber = certificationNumber;
  }

  public LocalDate getValidFromDate() {
    return validFromDate;
  }

  public void setValidFromDate(LocalDate validFromDate) {
    this.validFromDate = validFromDate;
  }

  public LocalDate getExpirationDate() {
    return expirationDate;
  }

  public void setExpirationDate(LocalDate expirationDate) {
    this.expirationDate = expirationDate;
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

  public void setAircraftType(AircraftType aircraftType) {
    this.aircraftType = aircraftType;
  }

  public Pilot getPilot() {
    return pilot;
  }

  public void setPilot(Pilot pilot) {
    this.pilot = pilot;
  }
  
//  public String getValidFromDate_toDateString() {
//    return "to_date(" validFromDate.g;
//  }
//
//  public LocalDate getExpirationDate() {
//    return expirationDate;
//  }

  
  @Override
  public int hashCode() {
    int hash = 0;
    hash += (pilotCertificationPK != null ? pilotCertificationPK.hashCode() : 0);
    return hash;
  }

  @Override
  public boolean equals(Object object) {
    // TODO: Warning - this method won't work in the case the id fields are not set
    if (!(object instanceof PilotCertification)) {
      return false;
    }
    PilotCertification other = (PilotCertification) object;
    if (this.pilotCertificationPK == null || other.pilotCertificationPK == null) {
      return false;
    }
    else if (this.pilotCertificationPK.getPilotId().equals(other.pilotCertificationPK.getPilotId())
            && this.pilotCertificationPK.getAircraftTypeId().equals(other.pilotCertificationPK.getAircraftTypeId())) {
      return true;
    }
    else {
      return false;
    }
  }

  @Override
  public String toString() {
    if (this.pilot != null && this.aircraftType != null) {
      return this.pilot.getLastName()+ ", " + this.pilot.getFirstName() + " is certified in Aircraft Type " + this.aircraftType.getShortName();
    }
    else return ("New/blank Pilot Certification Record");
  }
  
}

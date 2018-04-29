/* 
 * Copyright 2018 by RADical Information Design Corporation
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
*/
package com.radinfodesign.fboace.dao;
import static java.lang.System.out;

import java.time.LocalDate;
import java.util.Collection;

import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;

import com.radinfodesign.fboace.model.AircraftType;
import com.radinfodesign.fboace.model.PilotCertification;
import com.radinfodesign.fboace.model.Pilot;
import com.radinfodesign.fboace.model.PilotCertification;
import com.radinfodesign.fboace.model.PilotCertificationPK;
import com.radinfodesign.radspringbootgen.util.DateConverter;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeParseException;

public interface PilotCertificationRepository extends CrudRepository<PilotCertification, Integer> {
	PilotCertification findOneByPilotCertificationPK(PilotCertificationPK pk);
	PilotCertification findOneByPilotAndAircraftType(Pilot pilot, AircraftType aircraftType);
	  Collection<PilotCertification> findByPilot(Pilot pilot);
 
	  @Modifying
	  @Query(value="INSERT INTO Pilot_Certification (pilot_Id, aircraft_type_id, CERTIFICATION_NUMBER, VALID_FROM_DATE, EXPIRATION_DATE, notes) "
	      + "VALUES (:pilotId, :aircraftTypeId, :certification_number, :validFromDate, :expirationDate, :notes)", nativeQuery=true)
	  int insertPilotCertification(@Param("pilotId") Integer pilotId, @Param("aircraftTypeId") Integer aircraftTypeId
	                             , @Param("certification_number") String certification_number
//                               , @Param("validFromDate") String validFromDate
//                               , @Param("expirationDate") String expirationDate
                               , @Param("validFromDate") java.sql.Date validFromDate
                               , @Param("expirationDate") java.sql.Date expirationDate
	                             , @Param("notes") String notes);
	  
	  default int insertPilotCertification (PilotCertification pilotCertification) {
//      String validFromDate_toDateString = pilotCertification.getValidFromDate().format(DateTimeFormatter.ISO_LOCAL_DATE);
//      validFromDate_toDateString = "to_date('" + validFromDate_toDateString + "', 'yyyy-mm-dd')";
//      String expirationDate_toDateString = pilotCertification.getExpirationDate().format(DateTimeFormatter.ISO_LOCAL_DATE);
//      expirationDate_toDateString = "to_date('" + expirationDate_toDateString + "', 'yyyy-mm-dd')";
	    DateTimeFormatter  formatter= DateTimeFormatter.ofPattern("dd-MMM-yyyy"); // Default ORACLE date format
      String validFromDate_toDateString = pilotCertification.getValidFromDate().format(formatter);
      String expirationDate_toDateString = pilotCertification.getExpirationDate().format(formatter);
      out.println("validFromDate_toDateString = " + validFromDate_toDateString);
      out.println("expirationDate_toDateString = " + expirationDate_toDateString);
      
	    return insertPilotCertification ( pilotCertification.getPilot().getPilotId()
	                                    , pilotCertification.getAircraftType().getAircraftTypeId()
	                                    , pilotCertification.getCertificationNumber()
                                      , new DateConverter().convertToDatabaseColumn(pilotCertification.getValidFromDate())
                                      , new DateConverter().convertToDatabaseColumn(pilotCertification.getExpirationDate())
//                                      , pilotCertification.getValidFromDate()
//	                                    , validFromDate_toDateString
//	                                    , expirationDate_toDateString
	                                    , pilotCertification.getNotes()
	                                    );
	  }

}

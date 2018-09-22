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
package com.radinfodesign.radspringbootgen.fboace.dao;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;
import org.springframework.stereotype.Repository;

import com.radinfodesign.radspringbootgen.fboace.model.Pilot;

@Repository
//public interface PilotRepository extends CrudRepository<Pilot, Integer> {
public interface PilotRepository extends JpaRepository<Pilot, Integer> {
  List<Pilot> findAllByOrderByLastNameAscFirstNameAsc(); 
  
  default List<Pilot> findAllInDefaultOrder () {
    return findAllByOrderByLastNameAscFirstNameAsc();
  }
  
  // DEFINE VIEWS IN DATABASE, CALL WITH SIMPLER SEMANTICS HERE.
  @Modifying
  @Query( value="select distinct p.* "
      + "from pilot p "
      + "WHERE not exists ( select pc.pilot_id "
                          + "from pilot_certification pc "
                          + "where pc.pilot_id = p.pilot_id "
                          + "  and pc.aircraft_Type_Id = :aircraftTypeId ) "
                          + "order by p.LAST_NAME, p.FIRST_NAME, p.MIDDLE_INITIAL "
        , nativeQuery=true
        )
  List<Pilot> selectQualifiedPilotsByAircraftTypeId(@Param("aircraftTypeId") Integer aircraftTypeId);
  
  @Modifying
  //@Query( value="select distinct p.PILOT_ID, p.LAST_NAME, p.FIRST_NAME, p.MIDDLE_INITIAL, p.NATIONAL_ID_NUMBER, p.BIRTHDATE, p.NOTES "
  @Query( value="select distinct p.* "
                + "from pilot p "
                + "join pilot_certification pc on pc.pilot_id = p.pilot_id "
                + "join aircraft_type at on at.aircraft_type_id = pc.aircraft_type_id "
                + "join aircraft ac on ac.aircraft_type_id = at.aircraft_type_id "
                + "join flight fl on ac.aircraft_id = fl.aircraft_id "
//                + "where ac.aircraft_type_id = :aircraftTypeId "
                + "where fl.flight_id = :flightId "
                + "order by p.LAST_NAME, p.FIRST_NAME, p.MIDDLE_INITIAL "
        , nativeQuery=true
        )
  List<Pilot> selectQualifiedPilotsByFlightId(@Param("flightId") Integer flightId);
  
//  List<Pilot> selectQualifiedPilots(@Param("aircraftTypeId") Integer aircraftTypeId);

//  default List<Pilot> selectQualifiedPilots(Flight flight) {
//    if (flight.getAircraftId() != null) {
//      return selectQualifiedPilots(flight.getAircraftId().getAircraftTypeId().getAircraftTypeId());
//    }
//    else return findAllInDefaultOrder();
//  }

//  @Modifying
////  @Query( value="select p.PILOT_ID, p.LAST_NAME, p.FIRST_NAME, p.MIDDLE_INITIAL, p.NATIONAL_ID_NUMBER, p.BIRTHDATE, p.NOTES "
//  @Query( value="select p.* from pilot p order by p.LAST_NAME, p.FIRST_NAME, p.MIDDLE_INITIAL "
//        , nativeQuery=true
//        )
//  List<Pilot> selectAllPilots();
  
}

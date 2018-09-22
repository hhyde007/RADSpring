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

import java.util.Collection;

import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;

import com.radinfodesign.radspringbootgen.fboace.model.Flight;
import com.radinfodesign.radspringbootgen.fboace.model.FlightCrewMember;
import com.radinfodesign.radspringbootgen.fboace.model.FlightCrewMemberPK;
import com.radinfodesign.radspringbootgen.fboace.model.Pilot;

public interface FlightCrewMemberRepository extends CrudRepository<FlightCrewMember, Integer> {
  FlightCrewMember findOneByFlightCrewMemberPK(FlightCrewMemberPK pk);
  FlightCrewMember findOneByFlightAndPilot(Flight flight, Pilot pilot);
//  FlightCrewMember findOneByFlightIdAndPilotId(Integer flightId, Integer pilotId);
  Collection<FlightCrewMember> findByFlight(Flight flight);
//  default Collection<FlightCrewMember> findByFlightId(Integer flightId) {
// }
  
  @Modifying
  @Query(value="INSERT INTO Flight_Crew_Member (flight_Id, pilot_Id, notes) VALUES (:flightId, :pilotId, :notes)", nativeQuery=true)
  int insertFlightCrewMember(@Param("flightId") Integer flightId, @Param("pilotId") Integer pilotId, @Param("notes") String notes);
  
  default int insertFlightCrewMember (FlightCrewMember flightCrewMember) {
    return insertFlightCrewMember (flightCrewMember.getFlightId(), flightCrewMember.getPilotId(), flightCrewMember.getNotes());
  }


} 

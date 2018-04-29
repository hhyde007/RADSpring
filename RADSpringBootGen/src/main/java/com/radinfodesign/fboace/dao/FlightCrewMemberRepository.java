package com.radinfodesign.fboace.dao;

import java.util.Collection;

import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;

import com.radinfodesign.fboace.model.Flight;
import com.radinfodesign.fboace.model.FlightCrewMember;
import com.radinfodesign.fboace.model.FlightCrewMemberPK;
import com.radinfodesign.fboace.model.Pilot;

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

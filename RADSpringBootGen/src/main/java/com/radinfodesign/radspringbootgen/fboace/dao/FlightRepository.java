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

import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;

import com.radinfodesign.radspringbootgen.fboace.model.Flight;

public interface FlightRepository extends CrudRepository<Flight, Integer> {
  List<Flight> findAllByOrderByDepartureDateTimeDescShortNameAsc();

  
  default List<Flight> findAllInDefaultOrder() {
    return findAllByOrderByDepartureDateTimeDescShortNameAsc();
  }
  
  @Modifying
  //@Query( value="select distinct p.PILOT_ID, p.LAST_NAME, p.FIRST_NAME, p.MIDDLE_INITIAL, p.NATIONAL_ID_NUMBER, p.BIRTHDATE, p.NOTES "
  @Query( value="select distinct fl.* "
                + "from flight fl "
                + "join aircraft ac on ac.aircraft_id = fl.aircraft_id "
                + "join pilot_certification pc on pc.aircraft_type_id = ac.aircraft_type_id "
              + "where pc.pilot_id = :pilotId "
                + "order by fl.departure_date_time desc "
        , nativeQuery=true
        )
  List<Flight> selectQualifiedFlightsByPilotId(@Param("pilotId") Integer pilotId);

//  default List<Flght> selectQualifiedFlights(Pilot pilot) {
//    if (flight.getAircraftId() != null) {
//      return selectQualifiedFlights(flight.getAircraftId().getAircraftTypeId().getAircraftTypeId());
//    }
//    else return findAllInDefaultOrder();
//  }

  

  
}

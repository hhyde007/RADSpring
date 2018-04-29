package com.radinfodesign.fboace.dao;

import java.util.List;

import org.springframework.data.jpa.repository.Modifying;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.CrudRepository;
import org.springframework.data.repository.query.Param;

import com.radinfodesign.fboace.model.AircraftType;

public interface AircraftTypeRepository extends CrudRepository<AircraftType, Integer> {
  
	AircraftType findByShortName(String name);     
	
  List<AircraftType> findAllByOrderByShortName();
  
  default List<AircraftType> findAllInDefaultOrder () {
    return findAllByOrderByShortName();
  }

  @Modifying
  //@Query( value="select distinct p.PILOT_ID, p.LAST_NAME, p.FIRST_NAME, p.MIDDLE_INITIAL, p.NATIONAL_ID_NUMBER, p.BIRTHDATE, p.NOTES "
  @Query( value="select distinct at.* "
                + "from aircraft_type at "
                + "WHERE not exists ( select pc.aircraft_type_id "
                                    + "from pilot_certification pc "
                                    + "where pc.aircraft_type_id = at.aircraft_type_id "
                                    + "  and pc.pilot_id = :pilotId ) "
                + "order by at.SHORT_NAME "
        , nativeQuery=true
        )
  List<AircraftType> selectQualifiedAircraftTypesByPilotId(@Param("pilotId") Integer pilotId);

}

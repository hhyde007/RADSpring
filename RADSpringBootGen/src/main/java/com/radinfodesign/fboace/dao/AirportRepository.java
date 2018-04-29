package com.radinfodesign.fboace.dao;

import java.util.List;

import org.springframework.data.domain.Sort;
import org.springframework.data.repository.CrudRepository;

import com.radinfodesign.fboace.model.Airport;

public interface AirportRepository extends CrudRepository<Airport, Integer> {
//  List<Airport> findAllOrderByCode(Sort sort);
  List<Airport> findAllByOrderByIataCode();
  default List<Airport> findAllInDefaultOrder() {
    return findAllByOrderByIataCode();
  }  
  
}
 
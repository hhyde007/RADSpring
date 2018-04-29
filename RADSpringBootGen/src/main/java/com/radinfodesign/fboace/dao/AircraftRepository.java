package com.radinfodesign.fboace.dao;

import java.util.List;

import org.springframework.data.repository.CrudRepository;

import com.radinfodesign.fboace.model.Aircraft;


public interface AircraftRepository extends CrudRepository<Aircraft, Integer> {
  
  Aircraft findByShortName(String name); 
  
  List<Aircraft> findAllByOrderByShortName();
  
  default List<Aircraft> findAllInDefaultOrder () {
    return findAllByOrderByShortName();
  }
    

}

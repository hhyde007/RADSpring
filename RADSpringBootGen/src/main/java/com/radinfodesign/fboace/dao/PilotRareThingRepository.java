package com.radinfodesign.fboace.dao;

import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import com.radinfodesign.fboace.model.Pilot;
import com.radinfodesign.fboace.model.PilotRareThing;

@Repository
public interface PilotRareThingRepository extends JpaRepository<PilotRareThing, Integer> {
  List<PilotRareThing> findAllByOrderByShortName(); 
  
  default List<PilotRareThing> findAllInDefaultOrder () {
    return findAllByOrderByShortName();
  }
  
}

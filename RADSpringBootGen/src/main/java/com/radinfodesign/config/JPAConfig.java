package com.radinfodesign.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.orm.jpa.JpaTransactionManager;
import org.springframework.transaction.PlatformTransactionManager;
import org.springframework.transaction.annotation.EnableTransactionManagement;

@Configuration
@EnableTransactionManagement
public class JPAConfig {
  
  @Bean
  public PlatformTransactionManager transactionManager() {
    JpaTransactionManager manager = new JpaTransactionManager(); 
//    manager.setEntityManagerFactory(entityManagerFactoryBean.getObject());  
    return manager;
  }

}



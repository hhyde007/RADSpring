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
package com.radinfodesign.radspringbootgen;

import java.io.IOException;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

/**
 * Main Spring Boot Launch application for RADSpringBootGen
 * The main launch vehicle for the generation system is 
 * radspringbootgen.util/GenJavaComponents
 *
 * @author Howard Hyde
 * 
 */
@SpringBootApplication
public class RADSpringBootGenApplication {
  
	public static void main(String[] args) throws IOException {
		SpringApplication.run(RADSpringBootGenApplication.class, args);
	}
}
     
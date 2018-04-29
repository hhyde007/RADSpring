package com.radinfodesign.radspringbootgen.controller;


import static java.lang.System.out;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;


@Controller
@RequestMapping("")
public class RootWebController {


  @GetMapping(value="")
  public String listEntities (Model model) {
    return "/app/index";
  }

}

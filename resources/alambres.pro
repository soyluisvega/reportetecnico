/*Modifique el ejemplo de magnetostatics del tutorial, los archivos .geo, .step y .pro tienen el mismo nombre, 
o sea,  alambre.geo alambre.step alambre.pro etc.
*/


Group {
  // Physical regions:

  IndIzquierdo    = Region[ {101,103,105,107,109,111,113,115,117,119} ];

  IndDerecho    = Region[ {102, 104,106,108,110,112,114,116,118,120} ];

  Ind = Region [{IndIzquierdo,IndDerecho}];


  Air    = Region[ 201 ];

  Surface_Inf = Region[ 1001 ];

  Vol_Mag     = Region[ {Air, Ind} ];
  Vol_S_Mag   = Region[ Ind ];
  Sur_Dir_Mag = Region[ {Surface_Inf} ];
  Sur_Neu_Mag = Region[ {} ]; // empty
}


Function {
  mu0 = 4.e-7 * Pi;

  nu [ Region[{Air, Ind}] ]  = 1. / mu0;

  Current = DefineNumber[0.01, Name "Model parameters/Current",
			 Help "Current injected in coil [A]"];

  NbTurns = 1000 ; // number of turns in the coil

  js_fct[ IndIzquierdo ] = NbTurns*Current/SurfaceArea[];

  js_fct[ IndDerecho ] = -NbTurns*Current/SurfaceArea[];

}

Constraint {
  { Name Dirichlet_a_Mag;
    Case {
      { Region Sur_Dir_Mag ; Value 0.; }
    }
  }
  { Name SourceCurrentDensityZ;
    Case {
      { Region Vol_S_Mag ; Value js_fct[]; }
    }
  }
}


Group {
  Dom_Hcurl_a_Mag_2D = Region[ {Vol_Mag, Sur_Neu_Mag} ];
}

FunctionSpace {
  { Name Hcurl_a_Mag_2D; Type Form1P; // Magnetic vector potential a
    BasisFunction {
      { Name se; NameOfCoef ae; Function BF_PerpendicularEdge;
        Support Dom_Hcurl_a_Mag_2D ; Entity NodesOf[ All ]; }
    }
    Constraint {
      { NameOfCoef ae; EntityType NodesOf;
        NameOfConstraint Dirichlet_a_Mag; }
    }
  }

  { Name Hregion_j_Mag_2D; Type Vector; // Electric current density js
    BasisFunction {
      { Name sr; NameOfCoef jsr; Function BF_RegionZ;
        Support Vol_S_Mag; Entity Vol_S_Mag; }
    }
    Constraint {
      { NameOfCoef jsr; EntityType Region;
        NameOfConstraint SourceCurrentDensityZ; }
    }
  }

}

Jacobian {
  { Name Vol ;
    Case {
           { Region All ; Jacobian Vol ; }
    }
  }
}

Integration {
  { Name Int ;
    Case { { Type Gauss ;
             Case { { GeoElement Triangle    ; NumberOfPoints  4 ; }
                    { GeoElement Quadrangle  ; NumberOfPoints  4 ; }
	}
      }
    }
  }
}


Formulation {
  { Name Magnetostatics_a_2D; Type FemEquation;
    Quantity {
      { Name a ; Type Local; NameOfSpace Hcurl_a_Mag_2D; }
      { Name js; Type Local; NameOfSpace Hregion_j_Mag_2D; }
    }
    Equation {
      // all terms on the left-hand side (hence the "-" sign in front of
      // Dof{js}):
      Integral { [ nu[] * Dof{d a} , {d a} ];
        In Vol_Mag; Jacobian Vol; Integration Int; }
      Integral { [ -Dof{js} , {a} ];
        In Vol_S_Mag; Jacobian Vol; Integration Int; }
    }
  }
}

Resolution {
  { Name MagSta_a;
    System {
      { Name Sys_Mag; NameOfFormulation Magnetostatics_a_2D; }
    }
    Operation {
      Generate[Sys_Mag]; Solve[Sys_Mag]; SaveSolution[Sys_Mag];
    }
  }
}

PostProcessing {
  { Name MagSta_a_2D; NameOfFormulation Magnetostatics_a_2D;
    Quantity {
      { Name a;
        Value {
          Term { [ {a} ]; In Dom_Hcurl_a_Mag_2D; Jacobian Vol; }
        }
      }
      { Name az;
        Value {
          Term { [ CompZ[{a}] ]; In Dom_Hcurl_a_Mag_2D; Jacobian Vol; }
        }
      }
      { Name b;
        Value {
          Term { [ {d a} ]; In Dom_Hcurl_a_Mag_2D; Jacobian Vol; }
        }
      }
      { Name h;
        Value {
          Term { [ nu[] * {d a} ]; In Dom_Hcurl_a_Mag_2D; Jacobian Vol; }
        }
      }
      { Name js;
        Value {
          Term { [ {js} ]; In Dom_Hcurl_a_Mag_2D; Jacobian Vol; }
        }
      }
    }
  }
}


PostOperation {

  { Name Map_a; NameOfPostProcessing MagSta_a_2D;
    Operation {
      Echo[ Str["l=PostProcessing.NbViews-1;",
		"View[l].IntervalsType = 1;",
		"View[l].NbIso = 40;"],
	    File "tmp.geo", LastTimeStepOnly] ;
      Print[ a, OnElementsOf Dom_Hcurl_a_Mag_2D, File "a.pos" ];
      Print[ js, OnElementsOf Dom_Hcurl_a_Mag_2D, File "js.pos" ];
      Print[ az, OnElementsOf Dom_Hcurl_a_Mag_2D, File "az.pos" ];
      Print[ b, OnElementsOf Dom_Hcurl_a_Mag_2D, File "b.pos" ];
    }
  }
}

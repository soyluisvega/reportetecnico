Group{
  Vol_Ele += Region[39]; 
}
Include "C:\local\onelab-Windows64\templates\Lib_Materials.pro";
Function {
  epsr[Region[39]] = Air_relative_dielectric_permittivity;
}
Constraint { { Name ElectricScalarPotential; Case { { Region Region[37]; Value 1000; } { Region Region[38]; Value -1000; } } } }
Constraint { { Name GlobalElectricPotential; Case { } } }
Constraint { { Name GlobalElectricCharge; Case { } } }
Include "C:\local\onelab-Windows64\templates\Lib_Electrostatics_v.pro";

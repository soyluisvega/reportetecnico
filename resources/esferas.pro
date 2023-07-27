Group{
  Vol_Ele += Region[21]; 
}
Include "C:\local\onelab-Windows64\templates\Lib_Materials.pro";
Function {
  epsr[Region[21]] = Air_relative_dielectric_permittivity;
}
Constraint { { Name ElectricScalarPotential; Case { { Region Region[19]; Value 1000; } { Region Region[20]; Value 1000; } } } }
Constraint { { Name GlobalElectricPotential; Case { } } }
Constraint { { Name GlobalElectricCharge; Case { } } }
Include "C:\local\onelab-Windows64\templates\Lib_Electrostatics_v.pro";

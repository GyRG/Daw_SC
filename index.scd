
//Grupos
Require("Arquitectura/Arquitectura");

//Super clase módulo y fábrica de módulos finales
Require("Arquitectura/Fabrica_Modulos.scd");


//Fábrica de sntes
Require("Sintes/Sintes.scd");
//Percusiones
Require("Sintes/Percusiones/EfectosPercusiones.scd");
Require("Sintes/Percusiones/Percusiones.scd");
//Todas las percusiones

//Pads
Require("Sintes/Pads/EfectosPads.scd");
Require("Sintes/Pads/Pads.scd");
//Todos los pads

//Bajos
Require("Sintes/Bajos/EfectosBajos.scd");
Require("Sintes/Bajos/Bajos.scd");

//Modulares
Require("Sintes/Modulares/EfectosModulares.scd");
Require("Sintes/Modulares/Modulares.scd");

//Samples
Require("Sintes/Samplers/EfectosSamplers.scd");
Require("Sintes/Samplers/Samplers.scd");

//Externos


//Efectos Centrales
Require("EfectosCentrales/EfectosCentrales.scd");


s.queryAllNodes(queryControls:true);
s.scope(50);

this.inspect;

s.quit;

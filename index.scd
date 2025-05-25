
//groups
Require("Arquitectura/Arquitectura");
Require("MaquinaDelTiempo/index.scd");
Require("Performance/Fijos.scd");




s.queryAllNodes(queryControls:true);
s.scope(63);

this.inspect;

s.quit;
s.meter;
s.plotTree;

s.quit;
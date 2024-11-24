(//Arquitectura
~groups = nil;
s.freeAll;
s.newAllocators;
s.boot;

s.waitForBoot({
<<<<<<< HEAD
	// s.scope(50);
	// s.plotTree;
//Grupo Master
~grupoMaster = Group.tail(s.defaultGroup);
=======
		~groups = IdentityDictionary.with(*[
			\DAC -> IdentityDictionary.new,
			\FX -> IdentityDictionary.new,
			\SYNTHS -> IdentityDictionary.new
		]);
>>>>>>> desarrollo

	~dac = IdentityDictionary.new;
	~groups[\DAC].add(\instanciada-> false);
	~groups[\FX].add(\instanciada-> false);
	~groups[\SYNTHS].add(\instanciada-> false);

	Require("Fabrica_Modulos.scd");
	Require("../MasterNodes/Final_DAC");
}
)
)

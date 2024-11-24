(//Arquitectura
~groups = nil;
s.freeAll;
s.newAllocators;
s.boot;

s.waitForBoot({
		~groups = IdentityDictionary.with(*[
			\DAC -> IdentityDictionary.new,
			\FX -> IdentityDictionary.new,
			\SYNTHS -> IdentityDictionary.new
		]);

	~dac = IdentityDictionary.new;
	~groups[\DAC].add(\instanciada-> false);
	~groups[\FX].add(\instanciada-> false);
	~groups[\SYNTHS].add(\instanciada-> false);

	Require("Fabrica_Modulos.scd");
	Require("../MasterNodes/Final_DAC");
}
)
)

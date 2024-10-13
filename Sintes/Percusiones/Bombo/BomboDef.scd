(// BomboDef
s.waitForBoot({
if(~outletBomboPre==[~busBomboFx],
	{
		~noduloBomboPre.free;
	},{
		//Buses provenientes de cada uno de los sintes procesados por sus respectivos efectos
		~busBombo = Bus.audio(s,2);
});¨


// Conexiones
// Lets para ingresar todas las instancias del synthdef bombo
~inletBomboPre = [
	~busBombo
];
//Salidas del nódulo dedicado a recoger la señal de cada uno de los nodos del bombo
~outletBomboPre = [
	~busBomboFx
];

// Definición del módulo
//Mezcla de la agrupación de sintes
~createDevice.value(\noduloBomboPre,{
	|in,env|
	var input;
	input = in;
	input;
},nil,2,
~inletBomboPre,
~outletBomboPre
);

	s.sync;
//Instanciar nódulo Pre efectos del conjunto de sintes
~noduloBomboPre = Synth(\noduloBomboPre,
		[\gate,1,\wet,1],
		target:~grupoBombo,
		addAction:\addToHead
	);
	s.sync;
});
)

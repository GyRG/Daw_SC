:::mermaid
sequenceDiagram 
    box rgb(0,155,155) External
        participant G1 as Guitarra 1
        participant G2 as Guitarra 2
        participant M as MicroFreak
        participant V as Voz
    end
    box rgb(155,155,155) Drums
        participant K as Kick
        participant S as Snare
        participant H as Hh
        participant T as Tomb
        participant R as Ride
    end 
    box rgb(155,0,155) Bass
        participant B as Sub
    end 
    box rgb(155,155,0) Internal Synths
        participant P as Pad
    end

    rect rgba(100,200,20,0.47) 
    
        activate P
        activate H
        Note over G1,P: La Hoja cae
        
        Note over P,H: Introduce atmòsfera, clima càlido, humedo
        rect rgb(0,0,0,0.5)
            par P to H 
                Note over P: Atmòsfera de ambiente, acordes largos 
            and
                Note over H: Ataque y decay lentos, <br> sonido de colisiones de polvo, <br> añadir delay y reverb  
            end    
        end

        rect rgb(0,0,0,0.5)
            Note over M,G1: Añade colores armònicos
            activate M
                Note over M: Arpegio sobre acordes FM cristalino

            activate G1 
                Note over G1: Melodìa notas prolongadas primeros 3 registros
        end 

        rect rgb(0,0,0,0.5)
            activate G2
            activate K
            activate B
            par G2 to K
                Note over G2: Riff Con distorsiòn <br> acordes de 3 a 6 notas simultaneas ocasionalmente
            and 
                Note over K: Kick estruendoso intervalos prolongados marcando pulso
            and 
                Note over B: Se sincroniza el beat del kick con el bajo 
            end 
        end

            deactivate B
            deactivate K
            
            deactivate M
            deactivate G1
        end
        deactivate P
        deactivate H

    rect rgb(20,100,200) 
    loop Un pulso fluye a la tierra
        activate K
        activate H
        activate S
            Note over K: continues playing a heart beat in 4/4
            Note over H: gives metrical strucure with randomness
            Note over S: starts playing each 5/4
        deactivate K
        deactivate H
        deactivate S
    end
    end 

    rect rgb(200,100,20) 
    loop La estrella proyecta un ocaso
            
        activate K
        activate T
            Note over K: continues playing a heart beat in 4/4
            Note over T: gives metrical strucure with randomness
        deactivate K
        deactivate T
    end
    end

    

    

:::

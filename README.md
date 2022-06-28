# Infraestructura

# Circuitos


## Ingreso de palabra. 

El componente ingreso de palabra tiene el siguiente funcionamiento:

Agrupamos el ingreso de las palabras en 3 grupos, estos son: “Operación”, “Input_1”, “Input_2”, cada uno de 3 bits.

Operación corresponde a ABC y los bits corresponden de la siguiente manera en sus posiciones (2, 1, 0)=(A, B, C).

Input_1 corresponde a DEF y los bits se interpretan de la siguiente manera en sus posiciones (2, 1, 0)=(D, E, F).

Input_2 corresponde a GHI y los bits se interpretan de la siguiente manera en sus posiciones (2, 1, 0)=(G, H, I).


## Control de la máquina

En nuestro circuito lo denominamos CS (chip select) y también lo utilizamos como control dentro de cada uno de los componentes.

De esta forma controlamos los outputs de cada componente para que no colisionen las salidas en las operaciones. De esta forma la máquina puede realizar una sola operación por vez, para lograr esto usamos un decodificador el cual se encarga de mapear el input de las operaciones con cada componente separado


## Memoria Interna

La memoria usa los flipflop tipo D del sistema, con esto generamos un componente que maneja una memoria individual y luego agrupamos 8 de estos para tener todos los slots..

Generamos un componente agrupando 3 flipflops tipo D de esta forma tenemos un slot de memoria que maneja los 3 bits que necesitamos, luego agrupamos 8 copias de esos slots y los routeamos con un decodificador que recibe la posición de los inputs globales. Además de eso tenemos controles de lectura y escritura para evitar que se ejecuten ambas operaciones al mismo tiempo.

Se maneja el reseteo de todas las posiciones de memoria a través de un único pulso, de forma que se resetean todas las posiciones al mismo tiempo o ninguna a no ser que se sobreescriba la posición con el valor 000.

El pasaje de escritura y lectura funciona siempre y cuando se realice un pulso de bajada en los tres bits que marcan la operación, es decir, si se está escribiendo en la memoria y luego se quiere pasar a leer lo que se escribió, debe realizar un pulso de bajada en la entrada “Operación”, luego un pulso de subida y otro de bajada para poder ver los cambios actualizados en las salidas. 

Dejamos como una mejora a futuro la incorporación de un clock el cual genera un pulso en forma periódica y se encarga de corregir este problema.


## Banderas

La bandera de CarryOut de la operación 010 se une a través de una compuerta AND junto al ChipSelect, para que solo se encienda cuando la operación está seleccionada.

La bandera de Overflow Flag se enciende cuando existe overflow en la operación 3 y cuando el resultado es negativo en la operación 8.

El componente Zero Flag se activa cuando la operación 010 o 111 tienen resultados 000. Asumimos que estas eran las únicas operaciones aritméticas a las que teníamos que aplicar esta flag. Este circuito se realizó en un componente aparte para mayor prolijidad y entendimiento. De esta forma estamos escuchando la operación activa pero solo enviamos datos en caso de ser necesario. Dentro del componente hay otro componente que se encarga de validar que el resultado sea 000. 

Para el componente de Empty_Word_Flag usamos el componente EsCero para validar si cada uno de ellos es efectivamente 000 y con que exista al menos una posición de memoria con ese valor nos sirve, por lo tanto para validar esto agrupamos todos los componentes con una compuerta OR.

El componente de la Full Memory Flag está en todo momento escuchando el estado de la memoria para tener un funcionamiento correcto. A modo de prolijidad generamos un componente que maneja la operación de validar que todos todos los inputs son 111 y juntamos ese resultado con una compuerta AND ya que necesitamos que todas las memorias cumplan con este estado.


## Salida.

Elegimos como salida 3 LED que se encargarán de interpretar los resultados obtenidos por las operaciones cuando sea necesario 


## Registro interno.

La máquina que creamos tiene la capacidad de almacenar 8 palabras de 3 bits, y también realizar diferentes operaciones según los valores ABC ingresados por el usuario. 

También nos permite ver diferentes situaciones que se dan mientras se almacena información y si se llena o existe algún espacio vacío para guardar información. 


## Conclusión

Para cada una de las operaciones realizamos un componente que se encargue de manera individual de cada operación y a su vez, a algunas de estas operaciones se les agregó circuitos adicionales que dividieran el problema en pequeños problemas más fáciles de resolver. Gracias al buen funcionamiento de todos los componentes que se diseñaron para armar la máquina, es que se pueden realizar diferentes operaciones de más alta complejidad y al mismo tiempo obtener información de la misma en tiempo real. 


### Componentes del sistema


<table>
  <tr>
   <td>Operación
   </td>
   <td>Componente
   </td>
   <td>Funcionalidad
   </td>
  </tr>
  <tr>
   <td>ABC=000
   </td>
   <td>Op000_Write
   </td>
   <td>Operación
   </td>
  </tr>
  <tr>
   <td>ABC=001
   </td>
   <td>Op001_Read
   </td>
   <td>Operación
   </td>
  </tr>
  <tr>
   <td>ABC=010
   </td>
   <td>Op010_Sum
   </td>
   <td>Operación
   </td>
  </tr>
  <tr>
   <td>ABC=011
   </td>
   <td>Op011_F1
   </td>
   <td>Operación
   </td>
  </tr>
  <tr>
   <td>ABC=100
   </td>
   <td>Op100_Reset
   </td>
   <td>Operación
   </td>
  </tr>
  <tr>
   <td>ABC=101
   </td>
   <td>Op101_F2
   </td>
   <td>Operación
   </td>
  </tr>
  <tr>
   <td>ABC=110
   </td>
   <td>Op110_CA2
   </td>
   <td>Operación
   </td>
  </tr>
  <tr>
   <td>ABC=111
   </td>
   <td>Op111_Resta
   </td>
   <td>Operación
   </td>
  </tr>
  <tr>
   <td>Memoria
   </td>
   <td>Sis_Memoria
   </td>
   <td>Sistema
   </td>
  </tr>
  <tr>
   <td>Ingreso palabra
   </td>
   <td>Sis_IngresoPalabra
   </td>
   <td>Sistema
   </td>
  </tr>
  <tr>
   <td>Flip Flop 3bits
   </td>
   <td>Aux_TresBitFlipFlop
   </td>
   <td>Auxiliar
   </td>
  </tr>
  <tr>
   <td>Input es cero (3 bits)
   </td>
   <td>Aux_EsCero
   </td>
   <td>Auxiliar
   </td>
  </tr>
  <tr>
   <td>Input es siete (3 bits)
   </td>
   <td>Aux_EsSiete
   </td>
   <td>Auxiliar
   </td>
  </tr>
  <tr>
   <td>Zero flag Manejador
   </td>
   <td>Aux_ZeroHandler
   </td>
   <td>Auxiliar
   </td>
  </tr>
  <tr>
   <td>Detecta la memoria llena
   </td>
   <td>Aux_FullMemory
   </td>
   <td>Auxiliar
   </td>
  </tr>
  <tr>
   <td>Detecta si hay palabra vacía
   </td>
   <td>Aux_EmptyWord
   </td>
   <td>Auxiliar
   </td>
  </tr>
  <tr>
   <td>Flip Flop - D
   </td>
   <td>Flip Flop D Logisim
   </td>
   <td>Nativo
   </td>
  </tr>
</table>


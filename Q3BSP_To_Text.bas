#Include "Q3Loader.bas"


	Dim As TMapQ3  lMap 
	
	If Command="" Then Print "Falta indicar el fichero de mapa":Sleep:End
 
	readMap(Command, lMap) 

	Dim As Integer lFile = fopen("_salida.txt", "w+")
	
	debugInformations(lMap, lFile) 
	fclose(lFile) 


	freeMap(lMap) 
	

# PARCIAL 1 HPC

##### Estudiantes:
- Cristian Ciro
- Oscar Preciado

#### Objetivos:
1) Construir un programa que calcule la multiplicación (flotante) de matrices de cualquier tamaño A[M x N] y B[N x L] en CUDA usando tiles.

2) Evaluar el desempeño del programa construido comparándolo con la versión secuencial del mismo en CPU.

3) Se debe entregar un repositorio en Github por equipo de trabajo que contenga el código de ambas implementaciones, documentación sobre el código donde se explique detalladamente lo que se hace y en un documento en Markdown donde se especifiquen gráficas de tiempos y gráficas de aceleración, se debe tener un apartado de conclusiones del trabajo realizado.

#### Resultados:

Los tamaños escogidos para las tablas fueron:
![alt text](https://github.com/OscarPreciado/HPC/blob/master/Parcial1/promedio.png)

Los tiempos de la CPU frente a la GPU fueron:
![alt text](https://github.com/OscarPreciado/HPC/blob/master/Parcial1/tiempo.png)

La aceleracion de la CPU frente a la GPU fueron:
![alt text](https://github.com/OscarPreciado/HPC/blob/master/Parcial1/aceleracion.png)

Datos obtenidos:

- Matriz1 20x20 Matriz 2 20x10   
Ciclo numero 1  
Tiempo en CPU: 0.0000170000  
Tiempo en GPU: 0.0000550000  
Ciclo numero 2  
Tiempo en CPU: 0.0000160000  
Tiempo en GPU: 0.0000380000  
Ciclo numero 3  
Tiempo en CPU: 0.0000160000  
Tiempo en GPU: 0.0000370000  
Ciclo numero 4  
Tiempo en CPU: 0.0000160000  
Tiempo en GPU: 0.0000360000  
Ciclo numero 5  
Tiempo en CPU: 0.0000160000  
Tiempo en GPU: 0.0000360000  

- Matriz 1 50x50 Matriz2 50x30  
Ciclo numero 1  
Tiempo en CPU: 0.0003090000  
Tiempo en GPU: 0.0002300000  
Ciclo numero 2  
Tiempo en CPU: 0.0003090000  
Tiempo en GPU: 0.0002130000  
Ciclo numero 3  
Tiempo en CPU: 0.0003090000  
Tiempo en GPU: 0.0002120000  
Ciclo numero 4  
Tiempo en CPU: 0.0003080000  
Tiempo en GPU: 0.0002130000  
Ciclo numero 5  
Tiempo en CPU: 0.0003080000  
Tiempo en GPU: 0.0002120000  

-Matriz 1 100x100 Matriz 2 100x50  

Ciclo numero 1  
Tiempo en CPU: 0.0020530000  
Tiempo en GPU: 0.0012960000  
Ciclo numero 2  
Tiempo en CPU: 0.0020490000  
Tiempo en GPU: 0.0012760000  
Ciclo numero 3  
Tiempo en CPU: 0.0020520000  
Tiempo en GPU: 0.0012740000  
Ciclo numero 4  
Tiempo en CPU: 0.0020510000  
Tiempo en GPU: 0.0012760000  
Ciclo numero 5  
Tiempo en CPU: 0.0020530000  
Tiempo en GPU: 0.001276000  

- Matriz1 500x300 Matriz2 300x100  

Ciclo numero 1  
Tiempo en CPU: 0.0615470000  
Tiempo en GPU: 0.0368210000  
Ciclo numero 2  
Tiempo en CPU: 0.0618420000  
Tiempo en GPU: 0.0367630000  
Ciclo numero 3  
Tiempo en CPU: 0.0615110000  
Tiempo en GPU: 0.0367430000  
Ciclo numero 4  
Tiempo en CPU: 0.0615020000  
Tiempo en GPU: 0.0367520000  
Ciclo numero 5  
Tiempo en CPU: 0.0615230000  
Tiempo en GPU: 0.0367640000  

- Matriz 1 1000x1000 Matriz2 1000x1000  

Ciclo numero 1  
Tiempo en CPU: 5.6908960000  
Tiempo en GPU: 0.1392650000  
Ciclo numero 2  
Tiempo en CPU: 5.6901750000  
Tiempo en GPU: 0.1387620000  
Ciclo numero 3  
Tiempo en CPU: 5.6934840000  
Tiempo en GPU: 0.1387870000  
Ciclo numero 4  
Tiempo en CPU: 4.1856190000  
Tiempo en GPU: 0.1362160000  
Ciclo numero 5  
Tiempo en CPU: 4.1385550000  
Tiempo en GPU: 0.1255580000  

#### Conclusiones:
- Cuando se manejan matrices de tamaños pequeños o medianos, la diferencia en tiempo y aceleracion de la CPU frente a la GPU no es significativa.
- Cuando se manejan matrices de tamaños grandes o enormes, la diferencia en tiempo y aceleracion de la CPU frente a la GPU es muy significativa.
- Con base en los resultados se concluye que el desepeño de la GPU es superior frente a la CPU frente a matrices de gran tamaño.

# PARCIAL 1 HPC

##### Estudaintes:
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

#### Concluciones:
- Cuando se manejan matrices de tamaños pequeños o medianos, la diferencia en tiempo y aceleracion de la CPU frente a la GPU no es significativa.
- Cuando se manejan matrices de tamaños grandes o enormes, la diferencia en tiempo y aceleracion de la CPU frente a la GPU es muy significativa.
- Con base en los resultados se concluye que el desepeño de la GPU es superior frente a la CPU frente a matrices de gran tamaño.

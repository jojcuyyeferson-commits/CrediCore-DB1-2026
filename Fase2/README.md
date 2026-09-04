# CrediCore — Fase 2: Ingesta y Reportes

Proyecto de Base de Datos I. Esta carpeta contiene los archivos de la Fase 2,
organizados para revisión y ejecución.

## Entorno
- SQL Server 2022
- Docker
- Ubuntu 26.04 LTS
- DBeaver

## Scripts
1. `01_Vehiculos_1500_ERROR.sql` — demuestra intencionalmente el error 10738.
2. `02_Vehiculos_1500_CORREGIDO.sql` — carga real de 1,500 vehículos dividida en batches con `GO`.
3. `03_Clientes_500_EXCEL.sql` — 500 INSERT generados desde Excel mediante `CONCATENAR`.
4. `04_Creditos_BULK_INSERT.sql` — `BULK INSERT` hacia staging y transformación hacia `Operaciones.Creditos`.
5. `05_Reportes_Inteligencia.sql` — `SUM`, `AVG`, `COUNT`, `GROUP BY`, `HAVING`, `MAX` y `MIN`.

## Archivo plano
`creditos_2000.txt` contiene los 2,000 registros usados en la práctica.
También se incluye `creditos_2000_muestra_10_lineas.txt`, que corresponde a la
muestra de 10 líneas solicitada para GitHub.

## Resultados comprobados
- 1,500 vehículos.
- 500 clientes.
- 2,000 créditos.
- Riesgo acumulado: `SUM` + `AVG`.
- Concentración vehicular: `COUNT` + `HAVING > 50`.
- Extremos: `MAX` + `MIN`.

## Nota sobre BULK INSERT
La ruta `/tmp/import/creditos_2000.txt` es la ruta dentro del contenedor
`sqlserver2022`. En el procedimiento realizado, el archivo se transfirió desde
Windows/VirtualBox Shared Folder a Ubuntu y luego al contenedor Docker.

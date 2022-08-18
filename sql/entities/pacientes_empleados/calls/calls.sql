--SELECT VIEW de pacientes - empleados 
SELECT *
FROM vw_pacientes_empleados;

--SELECT FUNCTION para ver los empleados encargados de un paciente
SELECT *
FROM fn_paciente_empleados(1);

--SELECT FUNCTION para ver los pacientes encargados a un empleado
SELECT *
FROM fn_empleado_pacientes(1);

--CALL SP Insert Pacientes_Empleados
CALL sp_pac_emp_insert(
        1,
        1
    );

--CALL SP Update Pacientes_Empleados
CALL sp_pac_emp_update(
        5,
        1
    );

--CALL SP Delete Pacientes_Empleados
CALL sp_pac_emp_delete(
        1,
        1
    );
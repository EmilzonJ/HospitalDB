SELECT * FROM vw_departamentos_empleados;

--SELECT FUNCTION para ver los empleados de un departamento
SELECT * FROM fn_departamento_empleados(1);


--CALL SP Insert Departamentos_Empleados
CALL sp_dep_emp_insert(
        1,
        1
    );

--CALL SP Update Departamentos_Empleados
CALL sp_dep_emp_update(
        5,
        1
    );

--CALL SP Delete Departamentos_Empleados
CALL sp_dep_emp_delete(
        1,
        1
    );
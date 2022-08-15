--CALL SP Insert Diagnostico
CALL sp_diagnosticos_insert(
        1, 
        '2022-07-11', 
        '2022-07-12', 
        'El médico examinó el brazo en busca de dolor ligero, hinchazón, deformidad o una herida abierta. 
        Después de analizar los síntomas y cómo se lesionó el paciente, el médico solicitó radiografías 
        para determinar la ubicación y el grado de la fractura.', 
        'Quebradura de brazo.', 
        '2022-07-12'
    );

--CALL SP Update Diagnostico
CALL sp_diagnosticos_update(
        1, 
        '2022-07-11', 
        '2022-07-12', 
        '', 
        'Dolor de cabeza.', 
        '2022-07-12'
    );

--CALL SP Delete Diagnostico
CALL sp_diagnosticos_delete(1);
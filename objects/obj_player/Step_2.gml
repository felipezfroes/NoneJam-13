//==================================================
// MOVIMENTO NORMAL
//==================================================

// Durante o retrocesso, a posição do player já é
// controlada diretamente pelo histórico.
if (!retrocedendo_forcado)
{
    move_and_collide(
        velh,
        velv,
        obj_colisor
    );
}


//==================================================
// PROFUNDIDADE
//==================================================

scr_atualizar_profundidade(
    id,
    -1
);


//==================================================
// REGISTRAR HISTÓRICO TEMPORAL
//==================================================

// A posição precisa ser registrada depois do
// move_and_collide, pois esta é a posição final
// realmente ocupada pelo player neste frame.
if (!retrocedendo_forcado)
{
    registrar_historico_temporal();
}
maquina_estados();


//==================================================
// LOCALIZAR TIME MANAGER
//==================================================

if (!instance_exists(time_manager))
{
    time_manager = instance_find(obj_time_manager, 0);

    if (instance_exists(time_manager))
    {
        (time_manager).registrar_player(id);
    }
}


//==================================================
// REINICIAR TESTE
//==================================================

if (keyboard_check_pressed(ord("R")))
{
    room_restart();
    exit;
}


//==================================================
// SISTEMA TEMPORAL
//==================================================

if (instance_exists(time_manager))
{
    // Congela o player depois da conclusão.
    if ((time_manager).vitoria)
    {
        input_h = 0;
        input_v = 0;

        velh = 0;
        velv = 0;

        exit;
    }

    // Grava os comandos enquanto ainda não existe eco.
    (time_manager).gravar_comando(
        input_h,
        input_v
    );

    // Encerra a gravação e cria o eco.
    if (
        !(time_manager).eco_criado
        && keyboard_check_pressed(vk_space)
    )
    {
        (time_manager).criar_eco_teste();
    }
}

//==================================================
// EMPURRAR CAIXA
//==================================================

if (keyboard_check_pressed(ord("E")))
{
    var _caixa = instance_nearest(
        x,
        y,
        obj_box
    );

    if (instance_exists(_caixa))
    {
        (_caixa).empurrar(id);
    }
}
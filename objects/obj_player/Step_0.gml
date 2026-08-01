maquina_estados();


// Procura e registra o gerenciador temporal.
if (!instance_exists(time_manager))
{
    time_manager = instance_find(obj_time_manager, 0);

    if (instance_exists(time_manager))
    {
        (time_manager).registrar_player(id);
    }
}


// Envia o comando atual ao gerenciador.
if (instance_exists(time_manager))
{
    (time_manager).gravar_comando(
        input_h,
        input_v
    );

    // Tecla temporária usada apenas para testar a reprodução.
    if (keyboard_check_pressed(vk_space))
    {
        (time_manager).criar_eco_teste();
    }
}


// Reinicia rapidamente o protótipo.
if (keyboard_check_pressed(ord("R")))
{
    room_restart();
}
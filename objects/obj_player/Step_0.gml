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


// Reinicia rapidamente o protótipo.
if (keyboard_check_pressed(ord("R")))
{
    room_restart();
    exit;
}


if (instance_exists(time_manager))
{
    // Depois da vitória o jogador fica congelado até reiniciar.
    if ((time_manager).vitoria)
    {
        input_h = 0;
        input_v = 0;
        velh = 0;
        velv = 0;
        exit;
    }

    // Envia o comando atual ao gerenciador.
    (time_manager).gravar_comando(
        input_h,
        input_v
    );

    // Encerra a gravação, cria o eco e retorna o player ao início.
    if (!(time_manager).eco_criado && keyboard_check_pressed(vk_space))
    {
        (time_manager).criar_eco_teste();
    }

    // Depois da ramificação, E move a caixa entre a posição segura e o caminho do eco.
    if ((time_manager).eco_criado && keyboard_check_pressed(ord("E")))
    {
        var _caixa = instance_nearest(x, y, obj_box);

        if (instance_exists(_caixa))
        {
            var _distancia = point_distance(x, y, (_caixa).x, (_caixa).y);

            if (_distancia <= 96)
            {
                (_caixa).alternar_posicao();
            }
        }
    }
}
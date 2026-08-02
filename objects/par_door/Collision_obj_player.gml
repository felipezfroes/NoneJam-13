if (!aberta)
{
    exit;
}

switch (acao)
{
    // Porta interna da própria fase.
    case DoorAction.passagem:
    {
        break;
    }

    // Saída para outra room.
    case DoorAction.trocar_sala:
    {
        if (sala_destino != noone)
        {
            room_goto(sala_destino);
        }

        break;
    }

    // Final do protótipo.
    case DoorAction.concluir_jogo:
    {
        var _time_manager = instance_find(
            obj_time_manager,
            0
        );

        if (instance_exists(_time_manager))
        {
            (_time_manager).concluir_mvp();
        }

        break;
    }
}
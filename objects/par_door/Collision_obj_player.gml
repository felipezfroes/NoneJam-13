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

    case DoorAction.trocar_sala:
    {
        if (sala_destino == noone)
        {
            break;
        }
    
        var _manager = instance_find(
            obj_time_manager,
            0
        );
    
        if (instance_exists(_manager))
        {
            (_manager).iniciar_transicao_room(
                sala_destino
            );
        }
        else
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
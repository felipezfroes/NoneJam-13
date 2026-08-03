//==================================================
// REINICIAR SALA
//==================================================

if (keyboard_check_pressed(ord("R")))
{
    room_restart();
    exit;
}


//==================================================
// INVULNERABILIDADE
//==================================================

if (invulneravel_frames > 0)
{
    invulneravel_frames--;
}


//==================================================
// RETROCESSO FORÇADO
//==================================================

// Enquanto está retrocedendo, não executa:
// - controles;
// - gravação do eco;
// - interação com caixa;
// - movimento normal.
if (atualizar_retrocesso_forcado())
{
    exit;
}


//==================================================
// MOVIMENTO E ESTADOS
//==================================================

maquina_estados();


//==================================================
// LOCALIZAR TIME MANAGER
//==================================================

if (!instance_exists(time_manager))
{
    time_manager = instance_find(
        obj_time_manager,
        0
    );

    if (instance_exists(time_manager))
    {
        (time_manager).registrar_player(id);
    }
}


//==================================================
// SISTEMA TEMPORAL
//==================================================

if (instance_exists(time_manager))
{
    // Congela depois da conclusão da fase.
    if ((time_manager).vitoria)
    {
        input_h = 0;
        input_v = 0;

        velh = 0;
        velv = 0;

        exit;
    }

    if ((time_manager).permite_eco)
    {
        (time_manager).gravar_comando(
            input_h,
            input_v
        );

        if (
            !(time_manager).eco_criado
            && keyboard_check_pressed(vk_space)
        )
        {
            (time_manager).criar_eco_teste();
        }
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
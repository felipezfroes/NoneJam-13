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
// BLOQUEAR DURANTE TRANSIÇÃO OU FINAL
//==================================================

if (instance_exists(time_manager))
{
    if (
        (time_manager).transicao_estado
            != TransitionState.jogando
        || (time_manager).vitoria
    )
    {
        input_h = 0;
        input_v = 0;

        velh = 0;
        velv = 0;

        estado =
            PlayerEstados.parado;

        atualizar_sprite_direcao();

        exit;
    }
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

if (atualizar_retrocesso_forcado())
{
    // O histórico também restaura a direção,
    // então atualizamos o sprite durante o rewind.
    atualizar_sprite_direcao();

    exit;
}


//==================================================
// MOVIMENTO E ESTADOS
//==================================================

maquina_estados();

atualizar_sprite_direcao();


//==================================================
// SISTEMA TEMPORAL
//==================================================

if (instance_exists(time_manager))
{
    if ((time_manager).permite_eco)
    {
        (time_manager).gravar_comando(
            input_h,
            input_v
        );

        if (
            !(time_manager).eco_criado
            && keyboard_check_pressed(
                vk_space
            )
        )
        {
            (time_manager).
                criar_eco_teste();
        }
    }
}


//==================================================
// EMPURRAR CAIXA
//==================================================

if (
    keyboard_check_pressed(
        ord("E")
    )
)
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
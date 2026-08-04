//==================================================
// REINICIAR
//==================================================

if (
    transicao_estado
    == TransitionState.jogando
    && keyboard_check_pressed(ord("R"))
)
{
    room_restart();
    exit;
}


//==================================================
// TEMPO VISUAL
//==================================================

transicao_tempo++;


//==================================================
// ANIMAR AMPULHETA
//==================================================

if (
    transicao_estado
    != TransitionState.jogando
)
{
    var _frames_ampulheta =
        sprite_get_number(
            spr_boss_hourglass_transition
        );

    if (_frames_ampulheta > 0)
    {
        transicao_ampulheta_frame +=
            transicao_ampulheta_velocidade;

        transicao_ampulheta_frame =
            transicao_ampulheta_frame
            mod _frames_ampulheta;
    }
}


//==================================================
// ENTRANDO NA ROOM
//==================================================

if (
    transicao_estado
    == TransitionState.entrando
)
{
    transicao_alpha -=
        transicao_velocidade_entrada;

    if (transicao_alpha <= 0)
    {
        transicao_alpha = 0;

        transicao_estado =
            TransitionState.jogando;
    }

    exit;
}


//==================================================
// SAINDO DA ROOM
//==================================================

if (
    transicao_estado
    == TransitionState.saindo
)
{
    transicao_alpha +=
        transicao_velocidade_saida;

    if (
        transicao_alpha >= 1
        && !transicao_trocou_room
    )
    {
        transicao_alpha = 1;
        transicao_trocou_room = true;

        if (transicao_room_destino != -1)
        {
            room_goto(
                transicao_room_destino
            );
        }
    }

    exit;
}
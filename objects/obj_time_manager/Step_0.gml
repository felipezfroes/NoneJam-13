//==================================================
// REINICIAR
//==================================================

if (
    transicao_estado
        == TransitionState.jogando
    && keyboard_check_pressed(
        ord("R")
    )
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
// ENTRADA DA ROOM — 30 FRAMES
//==================================================

if (
    transicao_estado
    == TransitionState.entrando
)
{
    transicao_contador++;

    var _progresso_entrada =
        clamp(
            transicao_contador
            / transicao_frames_entrada,
            0,
            1
        );

    transicao_alpha =
        1 - _progresso_entrada;


    if (
        transicao_contador
        >= transicao_frames_entrada
    )
    {
        transicao_contador = 0;
        transicao_alpha = 0;

        transicao_estado =
            TransitionState.jogando;
    }

    exit;
}


//==================================================
// SAÍDA DA ROOM — 30 FRAMES
//==================================================

if (
    transicao_estado
    == TransitionState.saindo
)
{
    transicao_contador++;

    var _progresso_saida =
        clamp(
            transicao_contador
            / transicao_frames_saida,
            0,
            1
        );

    transicao_alpha =
        _progresso_saida;


    if (
        transicao_contador
            >= transicao_frames_saida
        && !transicao_trocou_room
    )
    {
        transicao_alpha = 1;
        transicao_trocou_room = true;

        if (
            transicao_room_destino
            != -1
        )
        {
            room_goto(
                transicao_room_destino
            );
        }
        else
        {
            // Segurança: retorna à gameplay
            // caso o destino seja inválido.
            transicao_estado =
                TransitionState.jogando;

            transicao_alpha = 0;
            transicao_contador = 0;
        }
    }

    exit;
}
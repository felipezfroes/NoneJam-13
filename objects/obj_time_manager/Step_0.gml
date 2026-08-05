//==================================================
// TELA FINAL DO JOGO
//==================================================

if (
    room == rm_boss
    && vitoria
)
{
    tela_final_tempo++;

    // Fade de aproximadamente meio segundo.
    tela_final_alpha = min(
        1,
        tela_final_alpha + 1 / 30
    );


    //==================================================
    // ACEITAR INPUT DEPOIS DA ENTRADA
    //==================================================

    if (
        tela_final_tempo
        >= tela_final_delay_input
    )
    {
        // Voltar ao começo. Depois, basta alterar
        // tela_final_room_destino para rm_menu.
        if (
            keyboard_check_pressed(
                vk_enter
            )
        )
        {
            audio_stop_sound(
                snd_victory
            );

            // Precisa ser falso para que o Step volte
            // a processar a transição nos próximos frames.
            vitoria = false;

            tela_final_alpha = 0;
            tela_final_tempo = 0;

            iniciar_transicao_room(
                tela_final_room_destino
            );

            exit;
        }


        // Encerrar o jogo.
        if (
            keyboard_check_pressed(
                vk_escape
            )
        )
        {
            game_end();
            exit;
        }
    }


    // Impede que o restante do Step processe
    // reinício ou transições normais.
    exit;
}

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

//==================================================
// TELA FINAL
//==================================================

if (
    room == rm_boss
    && vitoria
)
{
    if (keyboard_check_pressed(vk_enter))
    {
        audio_stop_all();
        room_goto(rm_tuto_temporal);
    }

    if (keyboard_check_pressed(vk_escape))
    {
        game_end();
    }

    exit;
}
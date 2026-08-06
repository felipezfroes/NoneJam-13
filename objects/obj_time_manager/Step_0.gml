//==================================================
// TELA FINAL DO JOGO
//==================================================

if (
    room == rm_boss
    && vitoria
)
{
    tela_final_tempo++;

    tela_final_alpha =
        min(
            1,
            tela_final_alpha
            + 1 / 30
        );


    //==================================================
    // DIMENSÕES
    //==================================================

    var _final_gui_width =
        display_get_gui_width();

    var _final_gui_height =
        display_get_gui_height();

    tela_final_botao_x =
        floor(
            _final_gui_width
            * 0.5
        );


    // Interface menor usa escala 2.
    // Interface maior mantém a escala 3 do menu.
    tela_final_escala_base_atual =
        _final_gui_height < 320
        ? 2
        : 3;

    tela_final_botao_inicio_y =
        floor(
            _final_gui_height
            * (
                _final_gui_height < 320
                ? 0.67
                : 0.72
            )
        );

    tela_final_botao_espaco =
        max(
            38,
            floor(
                _final_gui_height
                * 0.12
            )
        );


    //==================================================
    // FADE DE SAÍDA
    //==================================================

    if (tela_final_saida_ativa)
    {
        tela_final_saida_contador++;

        tela_final_saida_alpha =
            clamp(
                tela_final_saida_contador
                / tela_final_saida_frames,
                0,
                1
            );

        window_set_cursor(
            cr_default
        );


        if (
            tela_final_saida_contador
            >= tela_final_saida_frames
        )
        {
            audio_stop_sound(
                snd_victory
            );

            switch (
                tela_final_acao_pendente
            )
            {
                case "menu":
                {
                    room_goto(
                        rm_menu
                    );

                    break;
                }

                case "sair":
                {
                    game_end();
                    break;
                }
            }
        }

        exit;
    }


    //==================================================
    // MOUSE
    //==================================================

    var _final_mouse_x =
        device_mouse_x_to_gui(0);

    var _final_mouse_y =
        device_mouse_y_to_gui(0);

    var _final_mouse_moveu =
        abs(
            _final_mouse_x
            - tela_final_mouse_x_anterior
        )
        > 0.5
        ||
        abs(
            _final_mouse_y
            - tela_final_mouse_y_anterior
        )
        > 0.5;

    if (_final_mouse_moveu)
    {
        tela_final_usando_mouse =
            true;
    }


    //==================================================
    // HOVER DOS BOTÕES
    //==================================================

    tela_final_hover_index = -1;

    var _final_botao_largura =
        sprite_get_width(
            spr_button
        )
        * tela_final_escala_base_atual;

    var _final_botao_altura =
        sprite_get_height(
            spr_button
        )
        * tela_final_escala_base_atual;


    for (
        var _i = 0;
        _i < array_length(
            tela_final_opcoes
        );
        _i++
    )
    {
        var _botao_y =
            tela_final_botao_inicio_y
            + _i
            * tela_final_botao_espaco;

        var _hover =
            point_in_rectangle(
                _final_mouse_x,
                _final_mouse_y,

                tela_final_botao_x
                    - _final_botao_largura
                    * 0.54,

                _botao_y
                    - _final_botao_altura
                    * 0.60,

                tela_final_botao_x
                    + _final_botao_largura
                    * 0.54,

                _botao_y
                    + _final_botao_altura
                    * 0.60
            );

        if (_hover)
        {
            tela_final_hover_index =
                _i;
        }
    }


    //==================================================
    // MOUSE ASSUME A SELEÇÃO
    //==================================================

    if (
        tela_final_usando_mouse
        && tela_final_hover_index >= 0
    )
    {
        tela_final_mudar_selecao(
            tela_final_hover_index
        );
    }


    //==================================================
    // TECLADO
    //==================================================

    var _final_baixo =
        keyboard_check_pressed(
            vk_down
        )
        ||
        keyboard_check_pressed(
            ord("S")
        );

    var _final_cima =
        keyboard_check_pressed(
            vk_up
        )
        ||
        keyboard_check_pressed(
            ord("W")
        );

    var _final_movimento =
        _final_baixo
        - _final_cima;

    if (_final_movimento != 0)
    {
        tela_final_usando_mouse =
            false;

        tela_final_mudar_selecao(
            tela_final_selecao
            + sign(
                _final_movimento
            )
        );
    }


    //==================================================
    // CONFIRMAR
    //==================================================

    var _final_confirmar = false;

    if (
        tela_final_tempo
        >= tela_final_delay_input
    )
    {
        if (
            mouse_check_button_pressed(
                mb_left
            )
            && tela_final_hover_index >= 0
        )
        {
            tela_final_usando_mouse =
                true;

            tela_final_mudar_selecao(
                tela_final_hover_index
            );

            _final_confirmar =
                true;
        }


        if (
            keyboard_check_pressed(
                vk_enter
            )
            ||
            keyboard_check_pressed(
                vk_space
            )
        )
        {
            _final_confirmar =
                true;
        }


        if (
            keyboard_check_pressed(
                vk_escape
            )
        )
        {
            tela_final_iniciar_acao(
                "sair"
            );

            exit;
        }
    }


    if (_final_confirmar)
    {
        switch (
            tela_final_selecao
        )
        {
            case 0:
            {
                tela_final_iniciar_acao(
                    "menu"
                );

                break;
            }

            case 1:
            {
                tela_final_iniciar_acao(
                    "sair"
                );

                break;
            }
        }
    }


    //==================================================
    // ANIMAÇÃO VISUAL
    //==================================================

    for (
        var _i = 0;
        _i < array_length(
            tela_final_opcoes
        );
        _i++
    )
    {
        var _selecionado =
            _i
            == tela_final_selecao;

        var _hover =
            _i
            == tela_final_hover_index;

        var _escala_alvo = 1;
        var _brilho_alvo = 0;


        if (_selecionado)
        {
            _escala_alvo = 1.045;
            _brilho_alvo = 1;
        }
        else if (_hover)
        {
            _escala_alvo = 1.02;
            _brilho_alvo = 0.45;
        }


        tela_final_botao_escala[_i] =
            lerp(
                tela_final_botao_escala[
                    _i
                ],

                _escala_alvo,
                0.20
            );

        tela_final_botao_brilho[_i] =
            lerp(
                tela_final_botao_brilho[
                    _i
                ],

                _brilho_alvo,
                0.17
            );
    }


    //==================================================
    // CURSOR
    //==================================================

    window_set_cursor(
        tela_final_hover_index >= 0
        ? cr_handpoint
        : cr_default
    );


    tela_final_mouse_x_anterior =
        _final_mouse_x;

    tela_final_mouse_y_anterior =
        _final_mouse_y;


    // Impede reinício e gameplay.
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
var _tela_final_ativa =
    room == rm_boss
    && vitoria;

var _esconder_interface =
    transicao_estado
    == TransitionState.saindo
    && transicao_alpha >= 0.35;

var _gui_x = 16;
var _gui_y = 16;

var escala = 2;

var _barra_largura = (sprite_get_width(spr_record_bar) * 2) - 4 * escala;
var _barra_altura = 10;

var _progresso = clamp(
    frame_gravacao / max_frames,
    0,
    1
);

draw_set_halign(fa_left);
draw_set_valign(fa_top);

draw_set_font(fnt_01);

draw_set_alpha(1);
draw_set_color(c_white);

//==================================================
// HUD DE GAMEPLAY
//==================================================

if (
    !_esconder_interface
    && !_tela_final_ativa
)
{
    var _gui_width =
        display_get_gui_width();

    var _gui_height =
        display_get_gui_height();


    //==================================================
    // CONFIGURAÇÃO
    //==================================================

    var _hud_x = 10;
    var _hud_y = 10;

    var _hud_largura =
        min(
            185,
            _gui_width - 20
        );

    var _hud_padding = 8;

    var _linha_altura = 17;

    var _cor_fundo =
        make_color_rgb(
            4,
            12,
            18
        );

    var _cor_borda =
        make_color_rgb(
            52,
            105,
            119
        );


    draw_set_font(fnt_texto);

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);


    //==================================================
    // DEFINIR CONTEÚDO
    //==================================================

    var _titulo =
        "OBJETIVO";

    var _linha_1 = "";
    var _linha_2 = "";

    var _mostrar_estado_eco =
        false;


    switch (room)
    {
        case rm_tuto_temporal:
        {
            _linha_1 =
                "Alcance a saída.";

            _linha_2 =
                !eco_criado
                ? "ESPAÇO: criar eco"
                : "O eco repete seu caminho.";

            break;
        }


        case rm_tuto_caixa:
        {
            _linha_1 =
                "Ative as placas.";

            _linha_2 =
                "E: mover a caixa";

            _mostrar_estado_eco =
                true;

            break;
        }


        case rm_3:
        {
            _linha_1 =
                "Abra o caminho.";

            _linha_2 =
                "Combine eco e caixa.";

            _mostrar_estado_eco =
                true;

            break;
        }


        case rm_boss:
        {
            _titulo =
                "CONFRONTO";

            _linha_1 =
                "Rebata o projétil.";

            _linha_2 =
                "E: mover a caixa";

            break;
        }


        default:
        {
            _linha_1 =
                texto_objetivo;

            _linha_2 =
                "R: reiniciar";

            break;
        }
    }


    //==================================================
    // ALTURA DO PAINEL
    //==================================================

    var _painel_altura =
        63;

    if (_mostrar_estado_eco)
    {
        _painel_altura +=
            _linha_altura;
    }


    //==================================================
    // TEXTO
    //==================================================

    var _texto_x =
        _hud_x
        + _hud_padding;

    var _texto_y =
        _hud_y
        + 7;


    draw_set_color(c_aqua);
    draw_set_alpha(0.92);

    draw_text(
        _texto_x,
        _texto_y,
        _titulo
    );


    draw_set_color(c_white);
    draw_set_alpha(0.92);

    draw_text(
        _texto_x,
        _texto_y
            + _linha_altura,

        _linha_1
    );


    draw_set_color(c_white);
    draw_set_alpha(0.63);

    draw_text(
        _texto_x,
        _texto_y
            + _linha_altura * 2,

        _linha_2
    );


    //==================================================
    // ESTADO DO ECO
    //==================================================

    if (_mostrar_estado_eco)
    {
        var _texto_eco =
            "ECO: não criado";

        var _cor_eco =
            make_color_rgb(
                150,
                165,
                170
            );


        if (eco_criado)
        {
            _texto_eco =
                "ECO: reproduzindo";

            _cor_eco =
                c_aqua;


            var _eco =
                instance_find(
                    obj_echo,
                    0
                );

            if (
                instance_exists(_eco)
                && (_eco).finalizado
            )
            {
                _texto_eco =
                    "ECO: finalizado";

                _cor_eco =
                    make_color_rgb(
                        110,
                        170,
                        182
                    );
            }
        }


        draw_set_color(_cor_eco);
        draw_set_alpha(0.82);

        draw_text(
            _texto_x,
            _texto_y
                + _linha_altura * 3,

            _texto_eco
        );
    }


    //==================================================
    // BARRA TEMPORAL À DIREITA
    //==================================================

    if (
        mostrar_barra_temporal
        && !eco_criado
        && room != rm_boss
    )
    {
        var _spr_wid = sprite_get_width(spr_record_bar);
        var _barra_width = _spr_wid * escala - 8;
        var _barra_height = 8;

        var _barra_x =
            _gui_width
            - _barra_width
            - 20;

        var _barra_y = 14;

        var _progresso =
            clamp(
                frame_gravacao
                / max_frames,
                0,
                1
            );


        // Título.
        draw_set_halign(fa_right);

        draw_set_color(c_white);
        draw_set_alpha(0.58);

        draw_text(
            _gui_width - 10,
            _barra_y,
            "MEMÓRIA TEMPORAL"
        );


        // Fundo.
        _barra_y += 38;

        draw_set_color(
            make_color_rgb(
                4,
                12,
                18
            )
        );

        draw_set_alpha(0.88);
        
        draw_sprite_ext(spr_record_bar, 0, _barra_x, _barra_y, escala,escala, 0,c_white,1);


        // Preenchimento.
        draw_set_color(c_aqua);
        draw_set_alpha(0.88);

        draw_rectangle(
            _barra_x + 1,
            _barra_y + 1,

            _barra_x
                + 1
                + (
                    _barra_width - 2
                )
                * _progresso,

            _barra_y
                + _barra_height
                - 1,

            false
        );

        // Tempo.
        draw_set_color(c_white);
        draw_set_alpha(0.50);

        draw_text(
            _gui_width - 10,
            _barra_y + 13,

            string(
                floor(
                    frame_gravacao
                    / 60
                )
            )
            + " / 15 s"
        );
    }


    //==================================================
    // CONTROLE FIXO NO RODAPÉ
    //==================================================

    draw_set_halign(fa_left);
    draw_set_valign(fa_bottom);

    draw_set_color(c_white);
    draw_set_alpha(0.40);

    draw_text(
        10,
        _gui_height - 8,
        "R: REINICIAR"
    );


    //==================================================
    // RESTAURAR
    //==================================================

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    draw_set_alpha(1);
    draw_set_color(c_white);
}

//==================================================
// TELA FINAL
//==================================================

if (_tela_final_ativa)
{
    var _final_gui_width =
        display_get_gui_width();

    var _final_gui_height =
        display_get_gui_height();

    var _final_centro_x =
        floor(
            _final_gui_width
            * 0.5
        );

    var _final_alpha =
        tela_final_alpha;


    //==================================================
    // FUNDO PRETO
    //==================================================

    draw_set_color(c_black);
    draw_set_alpha(_final_alpha);

    draw_rectangle(
        0,
        0,
        _final_gui_width,
        _final_gui_height,
        false
    );


    //==================================================
    // GRADIENTE DO MENU
    //==================================================

    draw_set_alpha(_final_alpha);

    draw_rectangle_colour(
        0,
        0,
        _final_gui_width,
        _final_gui_height,

        make_color_rgb(
            3,
            10,
            16
        ),

        make_color_rgb(
            3,
            10,
            16
        ),

        make_color_rgb(
            7,
            18,
            27
        ),

        make_color_rgb(
            7,
            18,
            27
        ),

        false
    );


    //==================================================
    // RELÓGIO AO FUNDO
    //==================================================

    var _final_relogio_x =
        _final_centro_x;

    var _final_relogio_y =
        floor(
            _final_gui_height
            * 0.22
        );

    var _final_relogio_raio =
        min(
            _final_gui_width * 0.22,
            _final_gui_height * 0.21
        );


    draw_set_color(c_aqua);
    draw_set_alpha(
        _final_alpha * 0.05
    );

    draw_circle(
        _final_relogio_x,
        _final_relogio_y,
        _final_relogio_raio,
        true
    );


    for (
        var _i = 0;
        _i < 12;
        _i++
    )
    {
        var _angulo =
            _i * 30 - 90;

        var _x1 =
            _final_relogio_x
            + lengthdir_x(
                _final_relogio_raio - 7,
                _angulo
            );

        var _y1 =
            _final_relogio_y
            + lengthdir_y(
                _final_relogio_raio - 7,
                _angulo
            );

        var _x2 =
            _final_relogio_x
            + lengthdir_x(
                _final_relogio_raio,
                _angulo
            );

        var _y2 =
            _final_relogio_y
            + lengthdir_y(
                _final_relogio_raio,
                _angulo
            );


        draw_line(
            floor(_x1),
            floor(_y1),
            floor(_x2),
            floor(_y2)
        );
    }


    var _final_ponteiro =
        -90
        + tela_final_tempo
        * 0.22;

    draw_set_alpha(
        _final_alpha * 0.08
    );

    draw_line(
        _final_relogio_x,
        _final_relogio_y,

        floor(
            _final_relogio_x
            + lengthdir_x(
                _final_relogio_raio
                * 0.55,

                _final_ponteiro
            )
        ),

        floor(
            _final_relogio_y
            + lengthdir_y(
                _final_relogio_raio
                * 0.55,

                _final_ponteiro
            )
        )
    );


    //==================================================
    // PARTÍCULAS TEMPORAIS
    //==================================================

    for (
        var _i = 0;
        _i < 16;
        _i++
    )
    {
        var _px = floor(
            (
                _i * 83
                + tela_final_tempo
                * 0.22
            )
            mod _final_gui_width
        );

        var _py = floor(
            24
            + (
                _i * 47
            )
            mod (
                _final_gui_height - 48
            )
        );

        var _particula_alpha =
            0.05
            + (
                sin(
                    tela_final_tempo
                    * 0.035
                    + _i
                )
                * 0.5
                + 0.5
            )
            * 0.17;


        draw_set_color(c_aqua);

        draw_set_alpha(
            _final_alpha
            * _particula_alpha
        );

        draw_rectangle(
            _px,
            _py,
            _px + 2,
            _py + 2,
            false
        );
    }


    //==================================================
    // LOGO
    //==================================================

    if (sprite_exists(spr_logo_menu))
    {
        var _final_logo =
            spr_logo_menu;

        var _final_logo_width =
            sprite_get_width(
                _final_logo
            );

        var _final_logo_height =
            sprite_get_height(
                _final_logo
            );

        var _final_logo_scale =
            min(
                (
                    _final_gui_width
                    * 0.58
                )
                / _final_logo_width,

                (
                    _final_gui_height
                    * 0.27
                )
                / _final_logo_height
            );

        _final_logo_scale =
            min(
                1.8,
                _final_logo_scale
            );


        var _final_logo_center_y =
            floor(
                _final_gui_height
                * 0.22
            )
            + round(
                sin(
                    tela_final_tempo
                    * 0.035
                )
                * 2
            );

        var _final_logo_origin_x =
            sprite_get_xoffset(
                _final_logo
            );

        var _final_logo_origin_y =
            sprite_get_yoffset(
                _final_logo
            );

        var _final_logo_x =
            floor(
                _final_centro_x
                + (
                    _final_logo_origin_x
                    - _final_logo_width
                    * 0.5
                )
                * _final_logo_scale
            );

        var _final_logo_y =
            floor(
                _final_logo_center_y
                + (
                    _final_logo_origin_y
                    - _final_logo_height
                    * 0.5
                )
                * _final_logo_scale
            );


        // Eco da logo.
        draw_sprite_ext(
            _final_logo,
            0,

            _final_logo_x + 2,
            _final_logo_y + 2,

            _final_logo_scale,
            _final_logo_scale,

            0,
            c_aqua,
            _final_alpha * 0.18
        );


        // Logo principal.
        draw_sprite_ext(
            _final_logo,
            0,

            _final_logo_x,
            _final_logo_y,

            _final_logo_scale,
            _final_logo_scale,

            0,
            c_white,
            _final_alpha
        );
    }


    //==================================================
    // MENSAGEM DE VITÓRIA
    //==================================================

    draw_set_font(fnt_texto);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);


    draw_set_color(c_aqua);
    draw_set_alpha(_final_alpha);

    draw_text_transformed(
        _final_centro_x,
        floor(
            _final_gui_height
            * 0.48
        ),

        "VOCÊ QUEBROU O CICLO",

        1.35,
        1.35,
        0
    );


    draw_set_color(c_white);
    draw_set_alpha(
        _final_alpha * 0.78
    );

    draw_text(
        _final_centro_x,
        floor(
            _final_gui_height
            * 0.55
        ),

        "A corrente temporal foi rompida."
    );


    draw_set_color(c_aqua);
    draw_set_alpha(
        _final_alpha * 0.65
    );

    draw_text(
        _final_centro_x,
        floor(
            _final_gui_height
            * 0.60
        ),

        "Mas toda consequência deixa um eco."
    );


    //==================================================
    // LINHA DECORATIVA
    //==================================================

    var _final_linha_y =
        floor(
            _final_gui_height
            * 0.64
        );

    draw_set_color(c_aqua);
    draw_set_alpha(
        _final_alpha * 0.22
    );

    draw_line(
        _final_centro_x - 72,
        _final_linha_y,
        _final_centro_x - 18,
        _final_linha_y
    );

    draw_line(
        _final_centro_x + 18,
        _final_linha_y,
        _final_centro_x + 72,
        _final_linha_y
    );

    draw_rectangle(
        _final_centro_x - 2,
        _final_linha_y - 2,
        _final_centro_x + 2,
        _final_linha_y + 2,
        false
    );


    //==================================================
    // BOTÕES
    //==================================================

    if (
        tela_final_tempo
        >= tela_final_delay_input
    )
    {
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

            var _botao_y =
                tela_final_botao_inicio_y
                + _i
                * tela_final_botao_espaco;

            var _escala_botao =
                tela_final_escala_base_atual
                * tela_final_botao_escala[
                    _i
                ];

            var _largura_visual =
                sprite_get_width(
                    spr_button
                )
                * _escala_botao;

            var _pulso_botao =
                sin(
                    tela_final_tempo
                    * 0.10
                )
                * 0.5
                + 0.5;


            //==================================================
            // ECO DO BOTÃO
            //==================================================

            if (
                tela_final_botao_brilho[
                    _i
                ]
                > 0.01
            )
            {
                var _alpha_eco =
                    (
                        0.10
                        + _pulso_botao
                        * 0.14
                    )
                    * tela_final_botao_brilho[
                        _i
                    ];

                draw_sprite_ext(
                    spr_button,
                    0,

                    tela_final_botao_x + 2,
                    _botao_y + 2,

                    _escala_botao,
                    _escala_botao,

                    0,
                    c_aqua,

                    _final_alpha
                    * _alpha_eco
                );
            }


            //==================================================
            // SPRITE DO BOTÃO
            //==================================================

            draw_sprite_ext(
                spr_button,
                0,

                tela_final_botao_x,
                _botao_y,

                _escala_botao,
                _escala_botao,

                0,
                c_white,

                _final_alpha
                * (
                    _selecionado
                    ? 1
                    : 0.78
                )
            );


            //==================================================
            // MARCADORES
            //==================================================

            if (_selecionado)
            {
                var _escala_indicador =
                    _final_gui_height < 320
                    ? 1
                    : 2;

                var _movimento =
                    round(
                        _pulso_botao
                        * 3
                    );

                var _distancia =
                    _largura_visual
                    * 0.5
                    + 13
                    + _movimento;

                var _alpha_indicador =
                    0.75
                    + _pulso_botao
                    * 0.25;


                draw_sprite_ext(
                    spr_indicador,
                    0,

                    tela_final_botao_x
                        - _distancia,

                    _botao_y,

                    _escala_indicador,
                    _escala_indicador,

                    0,
                    c_aqua,

                    _final_alpha
                    * _alpha_indicador
                );


                draw_sprite_ext(
                    spr_indicador,
                    0,

                    tela_final_botao_x
                        + _distancia,

                    _botao_y,

                    -_escala_indicador,
                    _escala_indicador,

                    0,
                    c_aqua,

                    _final_alpha
                    * _alpha_indicador
                );
            }


            //==================================================
            // TEXTO DO BOTÃO
            //==================================================

            var _escala_texto =
                _selecionado
                ? 1.30
                : 1.22;


            if (_selecionado)
            {
                draw_set_color(c_aqua);

                draw_set_alpha(
                    _final_alpha
                    * 0.32
                );

                draw_text_transformed(
                    tela_final_botao_x + 1,
                    _botao_y + 1,

                    tela_final_opcoes[_i],

                    _escala_texto,
                    _escala_texto,
                    0
                );
            }


            draw_set_color(c_white);

            draw_set_alpha(
                _final_alpha
                * (
                    _selecionado
                    ? 1
                    : 0.80
                )
            );

            draw_text_transformed(
                tela_final_botao_x,
                _botao_y,

                tela_final_opcoes[_i],

                _escala_texto,
                _escala_texto,
                0
            );
        }
    }


    //==================================================
    // CRÉDITOS
    //==================================================

    draw_set_color(c_white);

    draw_set_alpha(
        _final_alpha * 0.40
    );

    draw_text(
        _final_centro_x,
        _final_gui_height - 17,

        "FELIPE ZOTARELI FROES  •  NONeJAM 13"
    );


    //==================================================
    // VINHETA
    //==================================================

    draw_set_color(c_black);
    draw_set_alpha(
        _final_alpha * 0.10
    );

    draw_rectangle(
        0,
        0,
        _final_gui_width,
        12,
        false
    );

    draw_rectangle(
        0,
        _final_gui_height - 12,
        _final_gui_width,
        _final_gui_height,
        false
    );

    draw_rectangle(
        0,
        0,
        12,
        _final_gui_height,
        false
    );

    draw_rectangle(
        _final_gui_width - 12,
        0,
        _final_gui_width,
        _final_gui_height,
        false
    );


    //==================================================
    // FADE DE SAÍDA
    //==================================================

    if (tela_final_saida_alpha > 0)
    {
        draw_set_color(c_black);

        draw_set_alpha(
            tela_final_saida_alpha
        );

        draw_rectangle(
            0,
            0,
            _final_gui_width,
            _final_gui_height,
            false
        );
    }


    //==================================================
    // RESTAURAR
    //==================================================

    draw_set_halign(fa_left);
    draw_set_valign(fa_top);

    draw_set_alpha(1);
    draw_set_color(c_white);
}

//==================================================
// TRANSIÇÃO ENTRE ROOMS
//==================================================

if (transicao_alpha > 0)
{
    var _gui_width =
        display_get_gui_width();

    var _gui_height =
        display_get_gui_height();

    var _centro_x =
        floor(_gui_width * 0.5);

    var _centro_y =
        floor(_gui_height * 0.5);


    //==================================================
    // FUNDO
    //==================================================

    draw_set_colour(c_black);
    draw_set_alpha(transicao_alpha);

    draw_rectangle(
        0,
        0,
        _gui_width,
        _gui_height,
        false
    );


    //==================================================
    // BLOCOS PIXELADOS AO REDOR
    //==================================================

    var _pulso =
        0.5
        + sin(transicao_tempo * 0.3)
        * 0.5;

    var _efeito_alpha =
        transicao_alpha
        * (0.18 + _pulso * 0.12);

    draw_set_colour(c_aqua);
    draw_set_alpha(_efeito_alpha);

    var _distancia =
        42 + round(_pulso * 5);

    // Esquerda.
    draw_rectangle(
        _centro_x - _distancia - 12,
        _centro_y - 2,
        _centro_x - _distancia,
        _centro_y + 2,
        false
    );

    // Direita.
    draw_rectangle(
        _centro_x + _distancia,
        _centro_y - 2,
        _centro_x + _distancia + 12,
        _centro_y + 2,
        false
    );

    // Cima.
    draw_rectangle(
        _centro_x - 2,
        _centro_y - _distancia - 12,
        _centro_x + 2,
        _centro_y - _distancia,
        false
    );

    // Baixo.
    draw_rectangle(
        _centro_x - 2,
        _centro_y + _distancia,
        _centro_x + 2,
        _centro_y + _distancia + 12,
        false
    );


    //==================================================
    // CENTRALIZAÇÃO VISUAL DA AMPULHETA
    //==================================================

    if (
        sprite_exists(
            spr_boss_hourglass_transition
        )
    )
    {
        var _sprite =
            spr_boss_hourglass_transition;

        var _escala =
            transicao_ampulheta_escala;

        var _largura =
            sprite_get_width(_sprite);

        var _altura =
            sprite_get_height(_sprite);

        var _origem_x =
            sprite_get_xoffset(_sprite);

        var _origem_y =
            sprite_get_yoffset(_sprite);


        // Compensa qualquer origem configurada no sprite.
        var _draw_x = floor(
            _centro_x
            + (
                _origem_x
                - _largura * 0.5
            )
            * _escala
        );

        var _draw_y = floor(
            _centro_y
            + (
                _origem_y
                - _altura * 0.5
            )
            * _escala
        );

        var _frame =
            floor(
                transicao_ampulheta_frame
            );


        // Sombra ciana pixelada.
        draw_sprite_ext(
            _sprite,
            _frame,
            _draw_x + 2,
            _draw_y + 2,
            _escala,
            _escala,
            0,
            c_aqua,
            transicao_alpha * 0.32
        );

        // Ampulheta principal.
        draw_sprite_ext(
            _sprite,
            _frame,
            _draw_x,
            _draw_y,
            _escala,
            _escala,
            0,
            c_white,
            transicao_alpha
        );
    }


    //==================================================
    // RESTAURAR DRAW
    //==================================================

    draw_set_alpha(1);
    draw_set_colour(c_white);
}
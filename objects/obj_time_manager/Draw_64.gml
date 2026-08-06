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
// TEXTO DO ESTADO
//==================================================

if (
    !_esconder_interface
    && !_tela_final_ativa
)
{
    if (vitoria)
    {
        draw_text(
            _gui_x,
            _gui_y,
            "MVP CONCLUIDO!"
            + "\nO eco abriu a porta."
            + "\nR: reiniciar o teste"
        );
    }
    else if (!eco_criado)
    {
        draw_text(
            _gui_x,
            _gui_y,
            "OBJETIVO: alcance a porta"
            + "\n2. SPACE: eco."
            + "\nR: reiniciar"
        );
    }
    else
    {
        var _estado_eco = "ECO: reproduzindo";
    
        var _eco = instance_find(obj_echo, 0);
    
        if (instance_exists(_eco))
        {
            if ((_eco).finalizado)
            {
                _estado_eco = "ECO: gravacao finalizada";
            }
        }
    
        draw_text(
            _gui_x,
            _gui_y,
            "Use o eco para ativar a placa."
            + "\nE perto da caixa: alterar o caminho."
            + "\n" + _estado_eco
            + "\nR: reiniciar"
        );
    }
    
    
    //==================================================
    // BARRA DE GRAVAÇÃO
    //==================================================
    
    var _barra_y = _gui_y + 76;
    
    draw_set_color(c_black);
    
    draw_sprite_ext(spr_record_bar, 0, _gui_x, _barra_y, escala,escala, 0,c_white,1);
    
    draw_set_color(c_aqua);
    
    draw_rectangle(
        _gui_x,
        _barra_y,
        _gui_x + (_barra_largura * _progresso),
        _barra_y + _barra_altura,
        false
    );
    
    draw_set_color(c_white);
    
    draw_text(
        _gui_x,
        _barra_y + 14,
        "Gravacao: "
        + string(floor(frame_gravacao / 60))
        + "s / 15s"
    );
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

    draw_set_font(fnt_01);

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
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
    var _gui_width =
        display_get_gui_width();

    var _gui_height =
        display_get_gui_height();

    var _centro_x =
        floor(_gui_width * 0.5);

    var _centro_y =
        floor(_gui_height * 0.5);

    var _alpha =
        tela_final_alpha;


    //==================================================
    // FUNDO ESCURECIDO
    //==================================================

    draw_set_color(c_black);
    draw_set_alpha(_alpha * 0.90);

    draw_rectangle(
        0,
        0,
        _gui_width,
        _gui_height,
        false
    );


    //==================================================
    // PAINEL CENTRAL
    //==================================================

    var _painel_esquerda =
        _centro_x - 190;

    var _painel_direita =
        _centro_x + 190;

    var _painel_cima =
        _centro_y - 135;

    var _painel_baixo =
        _centro_y + 135;

    draw_set_color(
        make_color_rgb(
            7,
            20,
            30
        )
    );

    draw_set_alpha(_alpha * 0.92);

    draw_rectangle(
        _painel_esquerda,
        _painel_cima,
        _painel_direita,
        _painel_baixo,
        false
    );


    // Contorno ciano.
    draw_set_color(c_aqua);
    draw_set_alpha(_alpha * 0.65);

    draw_rectangle(
        _painel_esquerda,
        _painel_cima,
        _painel_direita,
        _painel_baixo,
        true
    );


    //==================================================
    // PARTÍCULAS PIXELADAS
    //==================================================

    draw_set_color(c_aqua);

    for (var _i = 0; _i < 12; _i++)
    {
        var _angulo =
            _i * 30
            + tela_final_tempo * 0.45;

        var _distancia =
            148
            + sin(
                tela_final_tempo * 0.05
                + _i
            )
            * 7;

        var _px = floor(
            _centro_x
            + lengthdir_x(
                _distancia,
                _angulo
            )
        );

        var _py = floor(
            _centro_y
            + lengthdir_y(
                _distancia * 0.72,
                _angulo
            )
        );

        var _particula_alpha =
            0.25
            + (
                sin(
                    tela_final_tempo * 0.08
                    + _i
                )
                * 0.5
                + 0.5
            )
            * 0.45;

        draw_set_alpha(
            _alpha
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
    // AMPULHETA
    //==================================================

    if (
        sprite_exists(
            spr_boss_hourglass_transition
        )
    )
    {
        var _sprite =
            spr_boss_hourglass_transition;

        var _escala = 3;

        var _largura =
            sprite_get_width(_sprite);

        var _altura =
            sprite_get_height(_sprite);

        var _origem_x =
            sprite_get_xoffset(_sprite);

        var _origem_y =
            sprite_get_yoffset(_sprite);

        var _ampulheta_centro_y =
            _centro_y - 87;

        var _draw_x = floor(
            _centro_x
            + (
                _origem_x
                - _largura * 0.5
            )
            * _escala
        );

        var _draw_y = floor(
            _ampulheta_centro_y
            + (
                _origem_y
                - _altura * 0.5
            )
            * _escala
        );

        var _total_frames =
            sprite_get_number(_sprite);

        var _frame = 0;

        if (_total_frames > 0)
        {
            _frame = floor(
                tela_final_tempo * 0.24
            )
            mod _total_frames;
        }


        // Sombra ciana.
        draw_sprite_ext(
            _sprite,
            _frame,
            _draw_x + 2,
            _draw_y + 2,
            _escala,
            _escala,
            0,
            c_aqua,
            _alpha * 0.35
        );

        // Sprite principal.
        draw_sprite_ext(
            _sprite,
            _frame,
            _draw_x,
            _draw_y,
            _escala,
            _escala,
            0,
            c_white,
            _alpha
        );
    }


    //==================================================
    // TEXTOS
    //==================================================

    draw_set_font(fnt_01);

    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    draw_set_color(c_white);
    draw_set_alpha(_alpha);

    draw_text_transformed(
        _centro_x,
        _centro_y - 26,
        "O RELÓGIO DAS\nCONSEQUÊNCIAS",
        2,
        2,
        0
    );


    draw_set_color(c_aqua);

    draw_text(
        _centro_x,
        _centro_y + 31,
        "A corrente temporal foi quebrada."
    );


    draw_set_color(c_white);
    draw_set_alpha(_alpha * 0.82);

    draw_text(
        _centro_x,
        _centro_y + 52,
        "Mas toda consequência deixa um eco."
    );


    //==================================================
    // OPÇÕES
    //==================================================

    if (
        tela_final_tempo
        >= tela_final_delay_input
    )
    {
        var _piscar =
            0.68
            + (
                sin(
                    tela_final_tempo
                    * 0.10
                )
                * 0.5
                + 0.5
            )
            * 0.32;

        draw_set_color(c_white);
        draw_set_alpha(
            _alpha * _piscar
        );

        draw_text(
            _centro_x,
            _centro_y + 88,
            "ENTER — JOGAR NOVAMENTE"
        );

        draw_set_alpha(
            _alpha * 0.62
        );

        draw_text(
            _centro_x,
            _centro_y + 106,
            "ESC — SAIR"
        );
    }


    //==================================================
    // CRÉDITOS CURTOS
    //==================================================

    draw_set_color(c_white);
    draw_set_alpha(_alpha * 0.48);

    draw_text(
        _centro_x,
        _painel_baixo - 13,
        "Felipe Zotareli Froes • NoNeJam 13"
    );


    //==================================================
    // RESTAURAR DRAW
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
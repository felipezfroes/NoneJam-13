//==================================================
// GUI
//==================================================

var _gui_width = display_get_gui_width();
var _gui_height = display_get_gui_height();

var _centro_x = floor(_gui_width * 0.5);
var _centro_y = floor(_gui_height * 0.5);


//==================================================
// FUNDO EM GRADIENTE
//==================================================

draw_set_alpha(1);

draw_rectangle_colour(
    0,
    0,
    _gui_width,
    _gui_height,

    make_color_rgb(3, 10, 16),
    make_color_rgb(3, 10, 16),

    make_color_rgb(7, 18, 27),
    make_color_rgb(7, 18, 27),

    false
);


//==================================================
// RELÓGIO DE FUNDO
//==================================================

var _relogio_x = _centro_x;
var _relogio_y = 118;
var _relogio_raio = 98;

draw_set_color(c_aqua);
draw_set_alpha(0.05);

draw_circle(
    _relogio_x,
    _relogio_y,
    _relogio_raio,
    true
);

for (var _i = 0; _i < 12; _i++)
{
    var _ang = _i * 30 - 90;

    var _x1 = _relogio_x + lengthdir_x(_relogio_raio - 7, _ang);
    var _y1 = _relogio_y + lengthdir_y(_relogio_raio - 7, _ang);

    var _x2 = _relogio_x + lengthdir_x(_relogio_raio, _ang);
    var _y2 = _relogio_y + lengthdir_y(_relogio_raio, _ang);

    draw_line(
        floor(_x1), floor(_y1),
        floor(_x2), floor(_y2)
    );
}

var _ang_ponteiro = -90 + menu_tempo * 0.35;

draw_set_alpha(0.08);

draw_line(
    _relogio_x,
    _relogio_y,
    floor(_relogio_x + lengthdir_x(54, _ang_ponteiro)),
    floor(_relogio_y + lengthdir_y(54, _ang_ponteiro))
);


//==================================================
// PARTÍCULAS PIXELADAS
//==================================================

for (var _i = 0; _i < 14; _i++)
{
    var _px = floor(((_i * 83) + menu_tempo * 0.25) mod _gui_width);
    var _py = floor(28 + ((_i * 41) mod (_gui_height - 56)));

    var _a =
        0.05
        + ((sin(menu_tempo * 0.03 + _i) * 0.5 + 0.5) * 0.18);

    draw_set_color(c_aqua);
    draw_set_alpha(_a);

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
    var _logo = spr_logo_menu;

    var _lw = sprite_get_width(_logo);
    var _lh = sprite_get_height(_logo);

    var _max_w = _gui_width * 0.68;
    var _max_h = 142;

    var _escala_logo = min(
        _max_w / _lw,
        _max_h / _lh
    );

    var _logo_centro_y = 120 + round(sin(menu_tempo * 0.035) * 3);

    var _ox = sprite_get_xoffset(_logo);
    var _oy = sprite_get_yoffset(_logo);

    var _draw_x = floor(
        _centro_x + (_ox - _lw * 0.5) * _escala_logo
    );

    var _draw_y = floor(
        _logo_centro_y + (_oy - _lh * 0.5) * _escala_logo
    );

    // Eco / glow sutil
    draw_sprite_ext(
        _logo,
        0,
        _draw_x + 2,
        _draw_y + 2,
        _escala_logo,
        _escala_logo,
        0,
        c_aqua,
        0.18
    );

    // Principal
    draw_sprite_ext(
        _logo,
        0,
        _draw_x,
        _draw_y,
        _escala_logo,
        _escala_logo,
        0,
        c_white,
        1
    );
}


//==================================================
// FRASE TEMÁTICA
//==================================================

draw_set_font(fnt_01);
draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_set_color(c_aqua);
draw_set_alpha(0.62);

draw_text(
    _centro_x,
    220,
    "SEUS PASSOS DEIXAM ECOS"
);

//==================================================
// BOTÕES COM SPRITES
//==================================================

draw_set_font(fnt_01);

draw_set_halign(fa_center);
draw_set_valign(fa_middle);


for (
    var _i = 0;
    _i < array_length(botoes);
    _i++
)
{
    var _botao =
        botoes[_i];

    if (!instance_exists(_botao))
    {
        continue;
    }


    //==================================================
    // CONFIGURAÇÃO
    //==================================================

    var _sprite =
        (_botao).sprite_botao;

    var _escala =
        (_botao).escala_base
        * (_botao).escala_visual;

    var _largura_visual =
        sprite_get_width(_sprite)
        * _escala;

    var _pulso =
        sin(menu_tempo * 0.10)
        * 0.5
        + 0.5;


    // Usa o segundo frame como selecionado,
    // caso o sprite possua mais de um frame.
    var _frame = 0;

    if (
        (_botao).selecionado
        && sprite_get_number(_sprite) > 1
    )
    {
        _frame = 1;
    }


    //==================================================
    // ECO CIANO ATRÁS DO BOTÃO
    //==================================================

    if ((_botao).brilho_visual > 0.01)
    {
        var _alpha_eco =
            (
                0.10
                + _pulso * 0.14
            )
            * (_botao).brilho_visual;

        draw_sprite_ext(
            _sprite,
            _frame,

            floor((_botao).gui_x + 2),
            floor((_botao).gui_y + 2),

            _escala,
            _escala,

            0,
            c_aqua,
            _alpha_eco
        );
    }


    //==================================================
    // BOTÃO PRINCIPAL
    //==================================================

    var _cor_botao =
        c_white;

    var _alpha_botao =
        0.78;

    if ((_botao).selecionado)
    {
        _cor_botao = c_white;
        _alpha_botao = 1;
    }
    else if ((_botao).hover)
    {
        _cor_botao =
            make_color_rgb(
                220,
                245,
                250
            );

        _alpha_botao = 0.92;
    }


    draw_sprite_ext(
        _sprite,
        _frame,

        floor((_botao).gui_x),
        floor((_botao).gui_y),

        _escala,
        _escala,

        0,
        _cor_botao,
        _alpha_botao
    );


    //==================================================
    // MARCADORES
    //==================================================

    if ((_botao).selecionado)
    {
        var _escala_indicador =
            2;

        var _movimento_indicador =
            round(_pulso * 3);

        var _distancia_indicador =
            _largura_visual * 0.5
            + 13
            + _movimento_indicador;

        var _alpha_indicador =
            0.75
            + _pulso * 0.25;


        // Marcador esquerdo apontando para o botão.
        draw_sprite_ext(
            spr_indicador,
            0,

            floor(
                (_botao).gui_x
                - _distancia_indicador
            ),

            floor((_botao).gui_y),

            _escala_indicador,
            _escala_indicador,

            0,
            c_aqua,
            _alpha_indicador
        );


        // Marcador direito espelhado.
        draw_sprite_ext(
            spr_indicador,
            0,

            floor(
                (_botao).gui_x
                + _distancia_indicador
            ),

            floor((_botao).gui_y),

            -_escala_indicador,
            _escala_indicador,

            0,
            c_aqua,
            _alpha_indicador
        );
    }


    //==================================================
    // TEXTO DO BOTÃO
    //==================================================

    var _escala_texto =
        (_botao).selecionado
        ? 1.38
        : 1.30;

    var _cor_texto =
        (_botao).selecionado
        ? c_white
        : make_color_rgb(
            215,
            222,
            224
        );


    // Pequena sombra ciana.
    if ((_botao).selecionado)
    {
        draw_set_color(c_aqua);
        draw_set_alpha(0.32);

        draw_text_transformed(
            floor((_botao).gui_x + 1),
            floor((_botao).gui_y + 1),

            (_botao).texto,

            _escala_texto,
            _escala_texto,
            0
        );
    }


    draw_set_color(_cor_texto);
    draw_set_alpha(1);

    draw_text_transformed(
        floor((_botao).gui_x),
        floor((_botao).gui_y),

        (_botao).texto,

        _escala_texto,
        _escala_texto,
        0
    );
}


//==================================================
// RODAPÉ
//==================================================

draw_set_halign(fa_center);
draw_set_valign(fa_middle);

draw_set_color(c_white);
draw_set_alpha(0.52);

draw_text(
    _centro_x,
    _gui_height - 17,
    "W/S OU SETAS  •  ENTER OU CLIQUE"
);


//==================================================
// VINHETA LEVE
//==================================================

draw_set_color(c_black);
draw_set_alpha(0.10);

draw_rectangle(0, 0, _gui_width, 12, false);
draw_rectangle(0, _gui_height - 12, _gui_width, _gui_height, false);
draw_rectangle(0, 0, 12, _gui_height, false);
draw_rectangle(_gui_width - 12, 0, _gui_width, _gui_height, false);


//==================================================
// TRANSIÇÃO
//==================================================

if (transicao_alpha > 0)
{
    draw_set_color(c_black);
    draw_set_alpha(transicao_alpha);

    draw_rectangle(
        0,
        0,
        _gui_width,
        _gui_height,
        false
    );
}


//==================================================
// INTRO
//==================================================

if (intro_alpha > 0)
{
    draw_set_color(c_black);
    draw_set_alpha(intro_alpha);

    draw_rectangle(
        0,
        0,
        _gui_width,
        _gui_height,
        false
    );
}


//==================================================
// RESTAURAR DRAW
//==================================================

draw_set_halign(fa_left);
draw_set_valign(fa_top);
draw_set_alpha(1);
draw_set_color(c_white);
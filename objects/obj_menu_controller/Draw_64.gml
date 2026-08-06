//==================================================
// TAMANHO DA GUI
//==================================================

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

draw_set_alpha(1);

draw_set_color(
    make_color_rgb(
        4,
        10,
        16
    )
);

draw_rectangle(
    0,
    0,
    _gui_width,
    _gui_height,
    false
);


//==================================================
// PEQUENOS PIXELS TEMPORAIS
//==================================================

draw_set_color(c_aqua);

for (var _i = 0; _i < 12; _i++)
{
    var _px = floor(
        (
            _i * 79
            + menu_tempo * 0.18
        )
        mod _gui_width
    );

    var _py = floor(
        28
        + (
            _i * 47
        )
        mod (_gui_height - 56)
    );

    var _alpha_pixel =
        0.08
        + (
            sin(
                menu_tempo * 0.04
                + _i
            )
            * 0.5
            + 0.5
        )
        * 0.17;

    draw_set_alpha(
        _alpha_pixel
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
    var _logo =
        spr_logo_menu;

    var _logo_width =
        sprite_get_width(_logo);

    var _logo_height =
        sprite_get_height(_logo);

    var _max_width =
        _gui_width * 0.78;

    var _max_height =
        _gui_height * 0.38;

    var _logo_scale = min(
        _max_width
            / _logo_width,

        _max_height
            / _logo_height
    );

    // Não amplia além do tamanho original.
    _logo_scale = min(
        1.8,
        _logo_scale
    );

    var _logo_center_y =
        floor(_gui_height * 0.28);

    var _origin_x =
        sprite_get_xoffset(_logo);

    var _origin_y =
        sprite_get_yoffset(_logo);

    var _draw_x = floor(
        _centro_x
        + (
            _origin_x
            - _logo_width * 0.5
        )
        * _logo_scale
    );

    var _draw_y = floor(
        _logo_center_y
        + (
            _origin_y
            - _logo_height * 0.5
        )
        * _logo_scale
    );

    var _pulso =
        0.25
        + (
            sin(
                menu_tempo * 0.04
            )
            * 0.5
            + 0.5
        )
        * 0.18;


    // Eco ciano.
    draw_sprite_ext(
        _logo,
        0,

        _draw_x + 2,
        _draw_y + 2,

        _logo_scale,
        _logo_scale,

        0,
        c_aqua,
        _pulso
    );


    // Logo principal.
    draw_sprite_ext(
        _logo,
        0,

        _draw_x,
        _draw_y,

        _logo_scale,
        _logo_scale,

        0,
        c_white,
        1
    );
}


//==================================================
// BOTÕES
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

    var _escala =
        (_botao).escala_visual;

    var _largura =
        round(
            (_botao).largura
            * _escala
        );

    var _altura =
        round(
            (_botao).altura
            * _escala
        );

    var _x1 =
        floor(
            (_botao).gui_x
            - _largura * 0.5
        );

    var _x2 =
        floor(
            (_botao).gui_x
            + _largura * 0.5
        );

    var _y1 =
        floor(
            (_botao).gui_y
            - _altura * 0.5
        );

    var _y2 =
        floor(
            (_botao).gui_y
            + _altura * 0.5
        );


    //==================================================
    // FUNDO DO BOTÃO
    //==================================================

    
    draw_sprite_ext(spr_button, 0, (_x1 + _x2)/2,(_y1 + _y2)/2, _escala * 3,_escala * 3,0,c_white,image_alpha);
    
    draw_set_color(
        make_color_rgb(
            8,
            22,
            31
        )
    );




    //==================================================
    // MARCADORES LATERAIS
    //==================================================

    if ((_botao).selecionado)
    {
        draw_set_color(c_aqua);
        draw_set_alpha(0.9);
        
        draw_sprite_ext(spr_indicador, 0, _x1 - 4, (_botao).gui_y + 2, _escala * 2,_escala * 2,0,c_white,image_alpha);
        
        draw_sprite_ext(spr_indicador, 0, _x2 + 4, (_botao).gui_y - 2,-(_escala * 2), _escala * 2,0,c_white,image_alpha);
    }


    //==================================================
    // TEXTO
    //==================================================

    draw_set_color(c_white);
    draw_set_alpha(1);

    draw_text_transformed(
        (_botao).gui_x,
        (_botao).gui_y,

        (_botao).texto,

        1.35,
        1.35,
        0
    );
}


//==================================================
// INSTRUÇÕES
//==================================================

draw_set_color(c_white);
draw_set_alpha(0.48);

draw_text(
    _centro_x,
    _gui_height - 29,

    "W/S OU SETAS • ENTER OU CLIQUE"
);


//==================================================
// TRANSIÇÃO
//==================================================

if (transicao_alpha > 0)
{
    draw_set_color(c_black);
    draw_set_alpha(
        transicao_alpha
    );

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
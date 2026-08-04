//==================================================
// PROMPT DA TECLA
//==================================================

var _player = instance_find(obj_player, 0);

if (pode_mostrar_prompt(_player))
{
    var _frame =
        (current_time div 180)
        mod sprite_get_number(spr_prompt_e_8x8);

    var _offset_y =
        -15 + round(sin(current_time * 0.01));

    draw_sprite(
        spr_prompt_e_8x8,
        _frame,
        x + 4,
        y + _offset_y
    );
}

//==================================================
// SHAKE
//==================================================

var _shake_x = 0;
var _shake_y = 0;

if (shake_timer > 0)
{
    _shake_x = irandom_range(
        -shake_forca,
        shake_forca
    );

    _shake_y = irandom_range(
        -shake_forca,
        shake_forca
    );
}


//==================================================
// COR
//==================================================

var _cor = c_white;

if (flash_timer > 0)
{
    _cor = c_aqua;
}


//==================================================
// DESENHAR CAIXA
//==================================================

draw_sprite_ext(
    sprite_index,
    image_index,
    x + draw_offset_x + _shake_x,
    y + draw_offset_y + _shake_y,
    escala_visual_x,
    escala_visual_y,
    angulo_visual,
    _cor,
    image_alpha
);


//==================================================
// PARTÍCULAS
//==================================================

for (
    var _i = 0;
    _i < array_length(poeira);
    _i++
)
{
    var _particula = poeira[_i];

    var _alpha = clamp(
        _particula.vida / 18,
        0,
        1
    );

    draw_set_alpha(
        _alpha * 0.6
    );

    draw_set_colour(
        c_white
    );

    draw_rectangle(
        _particula.x,
        _particula.y,
        _particula.x
            + _particula.tamanho,
        _particula.y
            + _particula.tamanho,
        false
    );
}

draw_set_alpha(1);
draw_set_colour(c_white);
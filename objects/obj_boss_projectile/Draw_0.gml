//==================================================
// RASTRO
//==================================================

for (
    var _i = 3;
    _i >= 0;
    _i--
)
{
    var _alpha =
        (4 - _i)
        / 4
        * 0.18;

    var _escala =
        escala_visual
        * (0.45 + _i * 0.08);

    draw_sprite_ext(
        sprite_index,
        image_index,
        rastro_x[_i],
        rastro_y[_i],
        _escala,
        _escala,
        image_angle,
        image_blend,
        _alpha
    );
}


//==================================================
// PROJÉTIL PRINCIPAL
//==================================================

draw_sprite_ext(
    sprite_index,
    image_index,
    x,
    y,
    escala_visual,
    escala_visual,
    image_angle,
    image_blend,
    image_alpha
);
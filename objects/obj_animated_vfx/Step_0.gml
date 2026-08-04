//==================================================
// ROTAÇÃO
//==================================================

image_angle += rotacao_vel;


//==================================================
// PROGRESSO
//==================================================

var _total_frames = max(
    1,
    sprite_get_number(sprite_index)
);

var _progresso = clamp(
    image_index / _total_frames,
    0,
    1
);


//==================================================
// ESCALA
//==================================================

var _escala = lerp(
    escala_inicial,
    escala_final,
    _progresso
);

image_xscale = _escala;
image_yscale = _escala;


//==================================================
// FADE FINAL
//==================================================

if (
    fade_final
    && _progresso >= fade_inicio_frame
)
{
    var _fade_progresso =
        (_progresso - fade_inicio_frame)
        / max(
            0.01,
            1 - fade_inicio_frame
        );

    image_alpha =
        1 - _fade_progresso;
}
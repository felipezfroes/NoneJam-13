//==================================================
// PROFUNDIDADE
//==================================================

scr_atualizar_profundidade(
    id,
    0
);


//==================================================
// INTERPOLAÇÃO DO MOVIMENTO VISUAL
//==================================================

draw_offset_x = lerp(
    draw_offset_x,
    0,
    0.35
);

draw_offset_y = lerp(
    draw_offset_y,
    0,
    0.35
);

if (abs(draw_offset_x) < 0.1)
{
    draw_offset_x = 0;
}

if (abs(draw_offset_y) < 0.1)
{
    draw_offset_y = 0;
}


//==================================================
// ESCALA E ROTAÇÃO
//==================================================

escala_visual_x = lerp(
    escala_visual_x,
    1,
    0.25
);

escala_visual_y = lerp(
    escala_visual_y,
    1,
    0.25
);

angulo_visual = lerp(
    angulo_visual,
    0,
    0.25
);


//==================================================
// FLASH
//==================================================

if (flash_timer > 0)
{
    flash_timer--;
}


//==================================================
// SHAKE DE BLOQUEIO
//==================================================

if (shake_timer > 0)
{
    shake_timer--;
}
else
{
    shake_forca = 0;
}


//==================================================
// ATUALIZAR POEIRA
//==================================================

for (
    var _i = array_length(poeira) - 1;
    _i >= 0;
    _i--
)
{
    var _particula = poeira[_i];

    _particula.x +=
        _particula.vel_x;

    _particula.y +=
        _particula.vel_y;

    _particula.vel_x *= 0.92;
    _particula.vel_y *= 0.92;

    _particula.vida--;

    poeira[_i] = _particula;

    if (_particula.vida <= 0)
    {
        array_delete(
            poeira,
            _i,
            1
        );
    }
}
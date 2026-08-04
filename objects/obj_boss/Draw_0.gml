//==================================================
// LINHA DE AVISO
//==================================================

if (estado == BossState.carregando)
{
    draw_set_alpha(0.55);
    draw_set_colour(c_aqua);

    switch (ataque_atual)
    {
        case BossAttack.principal:
        {
            for (
                var _y = y + 30;
                _y < 240;
                _y += 12
            )
            {
                draw_sprite(spr_boss_aviso_principal, 0, x, _y);
            }

            break;
        }

        case BossAttack.cruz:
        {
            
            draw_sprite(spr_boss_aviso_cruz, 0,ataque_alvo_x, ataque_alvo_y);

            break;
        }

        case BossAttack.diagonal:
        {
            // Primeira onda.
            draw_line(
                x,
                y + 20,
                x - 100,
                235
            );
        
            draw_line(
                x,
                y + 20,
                x,
                235
            );
        
            draw_line(
                x,
                y + 20,
                x + 100,
                235
            );
        
            // Pequenas marcas indicando que haverá
            // uma segunda onda deslocada.
            draw_circle(
                x - 24,
                y + 24,
                3,
                true
            );
        
            draw_circle(
                x + 24,
                y + 24,
                3,
                true
            );
        
            break;
        }

        case BossAttack.orbes:
        {
            draw_circle(
                144,
                80,
                8,
                true
            );

            draw_circle(
                400,
                80,
                8,
                true
            );

            draw_circle(
                144,
                208,
                8,
                true
            );

            draw_circle(
                400,
                208,
                8,
                true
            );

            break;
        }
    }

    draw_set_alpha(1);
    draw_set_colour(c_white);
}


//==================================================
// DESENHAR BOSS
//==================================================

draw_sprite_ext(
    sprite_index,
    image_index,
    x + draw_offset_x,
    y
        + idle_offset_y
        + draw_offset_y,
    escala_x_visual,
    escala_y_visual,
    image_angle,
    cor_visual,
    image_alpha
);
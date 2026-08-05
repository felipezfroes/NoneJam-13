//==================================================
// LINHA DE AVISO
//==================================================

if (estado == BossState.carregando)
{
    draw_set_alpha(0.55);
    draw_set_colour(c_aqua);
    
    //==================================================
    // ANEL TEMPORAL
    //==================================================
    
    var _progresso =
        1
        - timer
        / max(
            1,
            tempo_carregamento
        );
    
    var _raio =
        lerp(
            20,
            8,
            _progresso
        );
    
    draw_set_alpha(
        0.25 + _progresso * 0.35
    );
    
    draw_circle(
        x + 8,
        y + idle_offset_y,
        _raio,
        true
    );
    
    draw_set_alpha(0.55);

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
                x + 8,
                y + 20,
                x - 100,
                235
            );
        
            draw_line(
                x +8,
                y + 20,
                x,
                235
            );
        
            draw_line(
                x + 8,
                y + 20,
                x + 100,
                235
            );
        
            // Pequenas marcas indicando que haverá
            // uma segunda onda deslocada.
            draw_circle(
                x - 16,
                y + 24,
                3,
                true
            );
        
            draw_circle(
                x + 32,
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
// ONDA DE MUDANÇA DE FASE
//==================================================

if (fase_efeito_timer > 0)
{
    var _progresso =
        1 - fase_efeito_timer / fase_efeito_duracao;

    var _escala =
        1 + sin(_progresso * pi) * 0.12;

    draw_sprite_ext(
        sprite_index,
        image_index,
        x + draw_offset_x,
        y + idle_offset_y + draw_offset_y,
        escala_x_visual * _escala,
        escala_y_visual * _escala,
        image_angle,
        c_aqua,
        0.35
    );
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

//==================================================
// ONDA QUADRADA DE DESTRUIÇÃO
//==================================================

if (derrota_onda_timer > 0)
{
    var _progresso =
        1
        - derrota_onda_timer
        / derrota_onda_duracao;

    var _tamanho =
        round(
            lerp(
                8,
                58,
                _progresso
            )
        );

    var _alpha =
        1 - _progresso;

    var _centro_x = floor(x);
    var _centro_y = floor(
        y + idle_offset_y
    );

    draw_set_colour(c_aqua);
    draw_set_alpha(_alpha * 0.8);

    draw_rectangle(
        _centro_x - _tamanho,
        _centro_y - _tamanho,
        _centro_x + _tamanho,
        _centro_y + _tamanho,
        true
    );

    var _interno =
        max(
            1,
            _tamanho - 5
        );

    draw_set_colour(c_white);
    draw_set_alpha(_alpha * 0.45);

    draw_rectangle(
        _centro_x - _interno,
        _centro_y - _interno,
        _centro_x + _interno,
        _centro_y + _interno,
        true
    );
}


//==================================================
// PARTÍCULAS PIXELADAS
//==================================================

for (
    var _i = 0;
    _i < array_length(
        derrota_particulas
    );
    _i++
)
{
    var _particula =
        derrota_particulas[_i];

    var _alpha =
        clamp(
            _particula.vida
            / _particula.vida_max,
            0,
            1
        );

    var _px =
        floor(_particula.x);

    var _py =
        floor(_particula.y);

    var _tamanho =
        _particula.tamanho;

    draw_set_colour(
        _particula.cor
    );

    draw_set_alpha(_alpha);

    draw_rectangle(
        _px,
        _py,
        _px + _tamanho - 1,
        _py + _tamanho - 1,
        false
    );
}


//==================================================
// RESTAURAR DRAW
//==================================================

draw_set_alpha(1);
draw_set_colour(c_white);
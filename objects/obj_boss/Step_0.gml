//==================================================
// ESTADOS
//==================================================

maquina_de_estado();

//==================================================
// SEGUNDA ONDA DIAGONAL
//==================================================

if (onda_diagonal_ativa)
{
    onda_diagonal_timer--;

    if (onda_diagonal_timer <= 0)
    {
        onda_diagonal_ativa = false;

        var _vel = 4;

        if (fase == 3)
        {
            _vel = 4.4;
        }

        // Nasce deslocado para fechar os espaços
        // deixados pela primeira onda.
        criar_projetil(
            x - 24,
            y + 24,
            lengthdir_x(_vel, 250),
            lengthdir_y(_vel, 250),
            false,
            false,
            0
        );

        criar_projetil(
            x + 24,
            y + 24,
            lengthdir_x(_vel, 290),
            lengthdir_y(_vel, 290),
            false,
            false,
            0
        );
    }
}

//==================================================
// IDLE
//==================================================

idle_tempo += 0.05;

// Movimento somente visual.
// A posição de colisão real não muda.
idle_offset_y =
    round(
        sin(idle_tempo)
        * 2
    );


//==================================================
// ESCALA VOLTANDO AO NORMAL
//==================================================

escala_x_visual = lerp(
    escala_x_visual,
    1,
    0.18
);

escala_y_visual = lerp(
    escala_y_visual,
    1,
    0.18
);


//==================================================
// EFEITO DE CARREGAMENTO
//==================================================

if (estado == BossState.carregando)
{
    var _progresso =
        1
        - timer
        / max(
            1,
            tempo_carregamento
        );

    escala_x_visual =
        1 + sin(current_time * 0.02)
        * 0.025;

    escala_y_visual =
        1 + sin(current_time * 0.02)
        * 0.025;

    cor_visual =
        merge_colour(
            c_white,
            c_aqua,
            _progresso
        );
}
else if (
    estado != BossState.derrotado
)
{
    cor_visual = c_white;
}


//==================================================
// FLASH
//==================================================

if (flash_timer > 0)
{
    flash_timer--;

    cor_visual = c_white;
}


//==================================================
// SHAKE
//==================================================

if (shake_timer > 0)
{
    shake_timer--;

    draw_offset_x =
        irandom_range(
            -shake_forca,
            shake_forca
        );

    draw_offset_y =
        irandom_range(
            -shake_forca,
            shake_forca
        );
}
else
{
    draw_offset_x = 0;
    draw_offset_y = 0;
}
//==================================================
// MOVIMENTO
//==================================================

vel = 2;

velh = 0;
velv = 0;


//==================================================
// GRAVAÇÃO
//==================================================

comandos_h = [];
comandos_v = [];

direcoes_x = [];
direcoes_y = [];

frame_reproducao = 0;

reproduzindo = false;
finalizado = false;


//==================================================
// DIREÇÃO INICIAL
//==================================================

direcao_olhar_x = 0;
direcao_olhar_y = 1;


// Mantém a colisão estável mesmo trocando sprites.
mask_index =
    spr_player_idle_down;


//==================================================
// ATUALIZAR SPRITE PELA DIREÇÃO GRAVADA
//==================================================

atualizar_sprite_direcao = function()
{
    var _novo_sprite =
        spr_player_idle_down;

    var _escala_x = 1;


    // Cima.
    if (direcao_olhar_y < 0)
    {
        _novo_sprite =
            spr_player_idle_up;
    }

    // Baixo.
    else if (direcao_olhar_y > 0)
    {
        _novo_sprite =
            spr_player_idle_down;
    }

    // Horizontal.
    else if (direcao_olhar_x != 0)
    {
        _novo_sprite =
            spr_player_idle_side;

        // Sprite original olhando para a direita.
        _escala_x =
            direcao_olhar_x < 0
            ? -1
            : 1;
    }


    if (sprite_index != _novo_sprite)
    {
        sprite_index =
            _novo_sprite;

        image_index = 0;
    }


    image_xscale =
        _escala_x;

    image_yscale = 1;
};


//==================================================
// APARÊNCIA DO ECO
//==================================================

cor_eco =
    make_colour_rgb(
        0,
        220,
        255
    );

image_alpha = 0.75;
image_blend = cor_eco;


//==================================================
// RASTRO
//==================================================

vfx_intervalo = 8;
vfx_timer = 0;


//==================================================
// VISUAL INICIAL
//==================================================

atualizar_sprite_direcao();
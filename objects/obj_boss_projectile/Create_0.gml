//==================================================
// MOVIMENTO
//==================================================

vel_x = 0;
vel_y = 4;


//==================================================
// TIPO E ESTADO
//==================================================

refletido = false;

pode_danificar_boss = false;

pode_multiplicar = false;
geracao = 0;

reacao_grace = 10;
reacao_processada = false;

ignorar_player_frames = 4;


//==================================================
// TEMPO DE VIDA
//==================================================

tempo_vida = 240;


//==================================================
// REFLEXÃO
//==================================================

cooldown_reflexao = 0;


//==================================================
// ENUM DOS TIPOS VISUAIS
//==================================================

enum ProjectileType
{
    normal,
    principal,
    chain
}

tipo_tiro = ProjectileType.normal;


//==================================================
// VISUAL
//==================================================

image_speed = 0.25;
image_blend = c_white;

escala_visual = 1;

trail_sprite = noone;
trail_alpha = 0.45;
trail_scale = 1;
trail_intervalo = 2;
trail_timer = 0;


//==================================================
// APLICAR VISUAL
//==================================================

aplicar_visual = function()
{
    if (refletido)
    {
        sprite_index = spr_boss_proj_main;
        trail_sprite = spr_boss_aviso_principal;

        image_blend = c_aqua;

        trail_alpha = 0.55;
        trail_scale = 1.0;

        return;
    }

    switch (tipo_tiro)
    {
        case ProjectileType.principal:
        {
            sprite_index = spr_boss_proj_main;
            trail_sprite = spr_boss_aviso_principal;

            image_blend = c_white;

            trail_alpha = 0.50;
            trail_scale = 1.0;
            break;
        }

        case ProjectileType.chain:
        {
            sprite_index = spr_boss_proj_chain;
            trail_sprite = spr_boss_aviso_principal;

            image_blend = c_white;

            trail_alpha = 0.42;
            trail_scale = 0.95;
            break;
        }

        default:
        {
            sprite_index = spr_boss_proj_normal;
            trail_sprite = spr_boss_aviso_principal;

            image_blend = c_white;

            trail_alpha = 0.35;
            trail_scale = 0.85;
            break;
        }
    }
};
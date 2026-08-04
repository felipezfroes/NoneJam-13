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
// REAÇÃO EM CADEIA
//==================================================

reacao_grupo = -1;

reacao_alvo_x = x;
reacao_alvo_y = y;

reacao_disparada = false;


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

reacao_disparada = false;

executar_reacao_em_cadeia = function(
    _reacao_x,
    _reacao_y,
    _grupo
)
{
    if (reacao_disparada)
    {
        return;
    }

    reacao_disparada = true;


    //==================================================
    // MARCAR E DESTRUIR O PAR
    //==================================================

    with (obj_boss_projectile)
    {
        if (
            pode_multiplicar
            && geracao == 0
            && reacao_grupo == _grupo
        )
        {
            reacao_disparada = true;
        }
    }


    //==================================================
    // VFX
    //==================================================

    var _efeito = instance_create_depth(
        _reacao_x,
        _reacao_y,
        depth + 2,
        obj_animated_vfx
    );

    (_efeito).sprite_index =
        spr_boss_aviso_principal;

    (_efeito).image_speed = 0.28;
    (_efeito).image_blend = c_aqua;

    (_efeito).escala_inicial = 0.7;
    (_efeito).escala_final = 1.25;

    (_efeito).fade_inicio_frame = 0.55;


    //==================================================
    // CRIAR FILHOS
    //==================================================

    var _boss = instance_find(
        obj_boss,
        0
    );

    if (instance_exists(_boss))
    {
        var _vel =
            ((_boss).fase >= 3)
            ? 2.15
            : 1.85;

        var _direcoes =
        [
            225,
            270,
            315
        ];

        for (
            var _i = 0;
            _i < array_length(_direcoes);
            _i++
        )
        {
            if (
                instance_number(
                    obj_boss_projectile
                )
                >= (_boss).maximo_projeteis
            )
            {
                break;
            }

            var _dir =
                _direcoes[_i];

            var _filho =
                instance_create_depth(
                    _reacao_x,
                    _reacao_y,
                    depth,
                    obj_boss_projectile
                );

            (_filho).vel_x =
                lengthdir_x(
                    _vel,
                    _dir
                );

            (_filho).vel_y =
                lengthdir_y(
                    _vel,
                    _dir
                );

            (_filho).geracao = 1;

            (_filho).pode_multiplicar =
                false;

            (_filho).pode_danificar_boss =
                false;

            (_filho).reacao_grace = 12;

            (_filho).tipo_tiro =
                ProjectileType.chain;

            (_filho).aplicar_visual();
        }
    }


    //==================================================
    // REMOVER PROJÉTEIS DO GRUPO
    //==================================================

    with (obj_boss_projectile)
    {
        if (
            pode_multiplicar
            && geracao == 0
            && reacao_grupo == _grupo
        )
        {
            instance_destroy();
        }
    }
};
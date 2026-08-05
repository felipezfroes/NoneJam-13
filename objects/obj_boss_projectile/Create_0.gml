//==================================================
// TIPOS DE PROJÉTIL
//==================================================

enum ProjectileType
{
    normal,
    principal,
    chain
}


//==================================================
// MOVIMENTO
//==================================================

vel_x = 0;
vel_y = 4;


//==================================================
// COMPORTAMENTO
//==================================================

refletido = false;

pode_danificar_boss = false;
pode_multiplicar = false;

geracao = 0;

ignorar_player_frames = 4;
cooldown_reflexao = 0;

tempo_vida = 240;


//==================================================
// REAÇÃO EM CADEIA
//==================================================

reacao_grupo = -1;

reacao_alvo_x = x;
reacao_alvo_y = y;

reacao_grace = 2;
reacao_disparada = false;


//==================================================
// VISUAL
//==================================================

tipo_tiro = ProjectileType.normal;

image_speed = 0.25;
image_blend = c_white;
image_alpha = 1;

// Mantém a colisão igual para todos os tiros.
// O tiro principal pode parecer maior sem ficar
// injustamente maior em colisão.
mask_index = spr_boss_proj_normal;

escala_visual = 1;


//==================================================
// RASTRO
//==================================================

trail_sprite = spr_boss_proj_normal;

trail_alpha = 0.12;
trail_scale = 0.42;

trail_intervalo = 4;
trail_timer = 0;


//==================================================
// APLICAR VISUAL DO TIPO
//==================================================

aplicar_visual = function()
{
    switch (tipo_tiro)
    {
        case ProjectileType.principal:
        {
            sprite_index =
                spr_boss_proj_main;

            trail_alpha = 0.24;
            trail_scale = 0.58;
            trail_intervalo = 2;

            break;
        }


        case ProjectileType.chain:
        {
            sprite_index =
                spr_boss_proj_chain;

            trail_alpha = 0.20;
            trail_scale = 0.50;
            trail_intervalo = 3;

            break;
        }


        default:
        {
            sprite_index =
                spr_boss_proj_normal;

            trail_alpha = 0.12;
            trail_scale = 0.42;
            trail_intervalo = 4;

            break;
        }
    }


    // O rastro utiliza o próprio formato do tiro.
    trail_sprite = sprite_index;


    if (refletido)
    {
        image_blend = c_aqua;

        trail_alpha = max(
            trail_alpha,
            0.32
        );

        trail_scale += 0.08;
        trail_intervalo = 1;
    }
    else
    {
        image_blend = c_white;
    }
};


//==================================================
// CRIAR VFX SIMPLES
//==================================================

criar_vfx_simples = function(
    _sprite,
    _x,
    _y,
    _alpha,
    _escala,
    _cor
)
{
    var _vfx = instance_create_depth(
        _x,
        _y,
        depth + 1,
        obj_projectile_trail_vfx
    );

    (_vfx).sprite_index = _sprite;
    (_vfx).image_index = 0;
    (_vfx).image_speed = 0;

    (_vfx).image_alpha = _alpha;
    (_vfx).image_blend = _cor;

    (_vfx).image_xscale = _escala;
    (_vfx).image_yscale = _escala;

    return _vfx;
};


//==================================================
// VFX DA REAÇÃO
//==================================================

criar_vfx_reacao = function(
    _reacao_x,
    _reacao_y
)
{
    repeat (6)
    {
        var _direcao = irandom(359);

        var _distancia =
            random_range(1, 5);

        criar_vfx_simples(
            spr_boss_proj_chain,

            _reacao_x
                + lengthdir_x(
                    _distancia,
                    _direcao
                ),

            _reacao_y
                + lengthdir_y(
                    _distancia,
                    _direcao
                ),

            random_range(0.25, 0.5),
            random_range(0.45, 0.8),
            c_aqua
        );
    }
};


//==================================================
// EXECUTAR REAÇÃO EM CADEIA
//==================================================

executar_reacao_em_cadeia = function(
    _reacao_x,
    _reacao_y,
    _grupo
)
{
    if (reacao_disparada)
    {
        return false;
    }


    //==================================================
    // CONFIRMAR QUE O PAR AINDA EXISTE
    //==================================================

    var _par_existe = false;

    var _quantidade =
        instance_number(
            obj_boss_projectile
        );

    for (
        var _i = 0;
        _i < _quantidade;
        _i++
    )
    {
        var _outro =
            instance_find(
                obj_boss_projectile,
                _i
            );

        if (
            instance_exists(_outro)
            && _outro != id
            && (_outro).pode_multiplicar
            && !(_outro).refletido
            && (_outro).geracao == 0
            && (_outro).reacao_grupo == _grupo
        )
        {
            _par_existe = true;
            break;
        }
    }


    // Se o outro tiro foi destruído ou refletido,
    // este continua normalmente sem multiplicar.
    if (!_par_existe)
    {
        pode_multiplicar = false;
        reacao_grupo = -1;

        return false;
    }


    reacao_disparada = true;
    
    scr_play_sfx(
        snd_chain,
        0.66,
        0.96,
        1.04,
        8
    );


    //==================================================
    // REMOVER O PAR
    //==================================================

    var _origem_id = id;

    with (obj_boss_projectile)
    {
        if (
            id != _origem_id
            && pode_multiplicar
            && !refletido
            && geracao == 0
            && reacao_grupo == _grupo
        )
        {
            reacao_disparada = true;
            instance_destroy();
        }
    }


    //==================================================
    // EFEITO VISUAL
    //==================================================

    criar_vfx_reacao(
        _reacao_x,
        _reacao_y
    );


    //==================================================
    // CONFIGURAÇÃO DOS FILHOS
    //==================================================

    var _boss =
        instance_find(
            obj_boss,
            0
        );

    var _velocidade_filhos = 1.85;
    var _limite_projeteis = 10;

    if (instance_exists(_boss))
    {
        _limite_projeteis =
            (_boss).maximo_projeteis;

        if ((_boss).fase >= 3)
        {
            _velocidade_filhos = 2.1;
        }
    }


    // O projétil atual será removido no final.
    var _projeteis_atuais =
        instance_number(
            obj_boss_projectile
        );

    var _espacos_disponiveis = max(
        0,
        _limite_projeteis
        - (_projeteis_atuais - 1)
    );

    var _quantidade_filhos = min(
        3,
        _espacos_disponiveis
    );

    var _direcoes =
    [
        225,
        270,
        315
    ];


    //==================================================
    // CRIAR FILHOS
    //==================================================

    for (
        var _i = 0;
        _i < _quantidade_filhos;
        _i++
    )
    {
        var _direcao =
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
                _velocidade_filhos,
                _direcao
            );

        (_filho).vel_y =
            lengthdir_y(
                _velocidade_filhos,
                _direcao
            );

        (_filho).geracao = 1;

        (_filho).pode_multiplicar =
            false;

        (_filho).pode_danificar_boss =
            false;

        (_filho).reacao_grupo = -1;
        (_filho).reacao_disparada = true;

        (_filho).ignorar_player_frames = 2;
        (_filho).tempo_vida = 120;

        (_filho).tipo_tiro =
            ProjectileType.chain;

        (_filho).aplicar_visual();

        (_filho).image_blend =
            c_aqua;
    }


    instance_destroy();

    return true;
};


//==================================================
// PROCESSAR IMPACTO NO PLAYER
//==================================================

processar_impacto_player = function(
    _player
)
{
    if (!instance_exists(_player))
    {
        return false;
    }


    // Tiro refletido não pune o player.
    if (refletido)
    {
        instance_destroy();
        return true;
    }


    // Não atinge novamente durante retrocesso
    // ou invulnerabilidade.
    if (
        (_player).retrocedendo_forcado
        || (_player).invulneravel_frames > 0
    )
    {
        instance_destroy();
        return true;
    }


    var _iniciou =
        (_player).
            iniciar_retrocesso_forcado(
                (_player).
                    retrocesso_frames_impacto
            );


    if (!_iniciou)
    {
        instance_destroy();
        return true;
    }
    
    scr_play_sfx(
        snd_temporal_burst,
        0.64,
        0.62,
        0.72,
        8
    );


    //==================================================
    // PAUSAR O BOSS
    //==================================================

    var _boss =
        instance_find(
            obj_boss,
            0
        );

    if (instance_exists(_boss))
    {
        if (
            (_boss).estado
                != BossState.atingido
            && (_boss).estado
                != BossState.movendo
            && (_boss).estado
                != BossState.derrotado
        )
        {
            (_boss).estado =
                BossState.esperando;

            (_boss).timer = 60;
        }

        if (
            variable_instance_exists(
                _boss,
                "onda_diagonal_ativa"
            )
        )
        {
            (_boss).onda_diagonal_ativa =
                false;
        }
    }


    //==================================================
    // LIMPAR A ARENA
    //==================================================

    with (obj_boss_orb)
    {
        instance_destroy();
    }

    with (obj_boss_projectile)
    {
        instance_destroy();
    }


    return true;
};


// Aplica uma aparência válida mesmo quando algum
// projétil for criado sem configuração externa.
aplicar_visual();
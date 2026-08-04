//==================================================
// PULSO VISUAL
//==================================================

pulso += 0.15;

raio =
    5
    + sin(pulso)
    * 2;


//==================================================
// CONTAGEM
//==================================================

timer--;

if (timer > 0)
{
    exit;
}


//==================================================
// VALIDAR BOSS
//==================================================

if (!instance_exists(boss_id))
{
    instance_destroy();
    exit;
}


//==================================================
// CRIAR PROJÉTIL
//==================================================

if (
    instance_number(
        obj_boss_projectile
    )
    < (boss_id).maximo_projeteis
)
{
    var _tiro = instance_create_depth(
        x,
        y,
        depth,
        obj_boss_projectile
    );

    (_tiro).vel_x =
        vel_x_saida;

    (_tiro).vel_y =
        vel_y_saida;

    (_tiro).pode_multiplicar =
        true;

    (_tiro).pode_danificar_boss =
        false;

    (_tiro).geracao = 0;

    (_tiro).reacao_grace = 2;

    (_tiro).reacao_grupo =
        reacao_grupo;

    (_tiro).reacao_alvo_x =
        reacao_alvo_x;

    (_tiro).reacao_alvo_y =
        reacao_alvo_y;

    (_tiro).tipo_tiro =
        ProjectileType.chain;

    (_tiro).aplicar_visual();
}


instance_destroy();
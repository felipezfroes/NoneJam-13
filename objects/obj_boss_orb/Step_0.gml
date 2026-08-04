//==================================================
// ANIMAÇÃO
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
// CRIAR PROJÉTIL
//==================================================

if (!instance_exists(boss_id))
{
    instance_destroy();
    exit;
}

if (
    instance_number(obj_boss_projectile)
    < (boss_id).maximo_projeteis
)
{
    var _tiro = instance_create_depth(
        x,
        y,
        depth,
        obj_boss_projectile
    );

    (_tiro).vel_x = 0;

    (_tiro).vel_y =
        2.5
        * direcao_vertical;

    (_tiro).pode_multiplicar = true;
    (_tiro).pode_danificar_boss = false;

    (_tiro).geracao = 0;
    (_tiro).reacao_grace = 12;

    (_tiro).image_blend = c_white;
}

instance_destroy();
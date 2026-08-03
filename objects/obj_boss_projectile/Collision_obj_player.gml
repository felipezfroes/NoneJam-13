//==================================================
// PROJÉTIL REFLETIDO NÃO PUNE O PLAYER
//==================================================

if (refletido)
{
    instance_destroy();
    exit;
}


//==================================================
// PLAYER JÁ ESTÁ PROTEGIDO
//==================================================

if (
    (other).retrocedendo_forcado
    || (other).invulneravel_frames > 0
)
{
    instance_destroy();
    exit;
}


//==================================================
// INICIAR RETROCESSO
//==================================================

var _iniciou =
    (other).iniciar_retrocesso_forcado(
        (other).retrocesso_frames_impacto
    );

if (!_iniciou)
{
    instance_destroy();
    exit;
}


//==================================================
// REMOVER OUTROS PROJÉTEIS
//==================================================

// Evita que outro tiro atinja o player
// durante o retrocesso.
with (obj_boss_projectile)
{
    instance_destroy();
}


//==================================================
// DAR TEMPO AO PLAYER
//==================================================

var _boss = instance_find(
    obj_boss,
    0
);

if (instance_exists(_boss))
{
    if (
        (_boss).estado != BossState.atingido
        && (_boss).estado != BossState.movendo
        && (_boss).estado != BossState.derrotado
    )
    {
        (_boss).estado =
            BossState.esperando;

        (_boss).timer = 90;
    }
}
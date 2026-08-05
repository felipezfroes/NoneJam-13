//==================================================
// SOMENTE TIRO REFLETIDO
//==================================================

if (!(other).refletido)
{
    exit;
}


//==================================================
// SOMENTE O TIRO PRINCIPAL CAUSA DANO
//==================================================

if (!(other).pode_danificar_boss)
{
    with (other)
    {
        instance_destroy();
    }

    exit;
}


//==================================================
// INVULNERABILIDADE
//==================================================

if (invulneravel)
{
    with (other)
    {
        instance_destroy();
    }

    exit;
}


//==================================================
// DANO
//==================================================

vida--;

scr_play_sfx(
    snd_boss_hit,
    0.76,
    0.88,
    0.96,
    9
);

invulneravel = true;

estado = BossState.atingido;
timer = 45;

flash_timer = 10;

shake_timer = 20;
shake_forca = 3;

escala_x_visual = 1.14;
escala_y_visual = 0.86;

with (obj_boss_projectile)
{
    instance_destroy();
}

with (obj_boss_orb)
{
    instance_destroy();
}
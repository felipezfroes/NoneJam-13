if (!(other).refletido)
{
    exit;
}

if (invulneravel)
{
    exit; 
}

vida--;

invulneravel = true;

estado = BossState.atingido;
timer = 45;

with (other)
{
    instance_destroy();
}
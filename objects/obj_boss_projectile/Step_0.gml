if (cooldown_reflexao > 0)
{
    cooldown_reflexao--;
}

x += vel_x;
y += vel_y;


//==================================================
// COLISÃO COM A CAIXA
//==================================================

var _caixa = instance_place(
    x,
    y,
    obj_box
);

if (
    _caixa != noone
    && cooldown_reflexao <= 0
)
{
    vel_y = -abs(vel_y);

    refletido = true;
    cooldown_reflexao = 6;

    image_blend = c_aqua;

    // Retira o projétil de dentro da caixa.
    y += vel_y;

    exit;
}


//==================================================
// ESCUDO FECHADO
//==================================================

if (place_meeting(x, y, obj_door_blocker))
{
    instance_destroy();
    exit;
}


//==================================================
// PAREDES
//==================================================

var _colisor = instance_place(
    x,
    y,
    obj_colisor
);

if (_colisor != noone)
{
    instance_destroy();
    exit;
}
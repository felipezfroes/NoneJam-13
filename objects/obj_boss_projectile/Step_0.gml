//==================================================
// COOLDOWN DE REFLEXÃO
//==================================================

if (cooldown_reflexao > 0)
{
    cooldown_reflexao--;
}


//==================================================
// GUARDAR POSIÇÃO ANTERIOR
//==================================================

var _x_anterior = x;
var _y_anterior = y;


//==================================================
// MOVIMENTO
//==================================================

x += vel_x;
y += vel_y;


//==================================================
// COLISÃO COM O PLAYER
//==================================================

// collision_line impede que um projétil rápido
// atravesse o player entre um frame e outro.
var _player = collision_line(
    _x_anterior,
    _y_anterior,
    x,
    y,
    obj_player,
    false,
    true
);

// Segurança adicional caso já esteja sobreposto.
if (_player == noone)
{
    _player = instance_place(
        x,
        y,
        obj_player
    );
}

if (_player != noone)
{
    // Projétil refletido não volta o jogador no tempo.
    if (refletido)
    {
        instance_destroy();
        exit;
    }

    var _iniciou =
        (_player).iniciar_retrocesso_forcado(
            (_player).retrocesso_frames_impacto
        );

    // Debug temporário.
    show_debug_message(
        "PROJETIL ATINGIU PLAYER | historico: "
        + string((_player).historico_total)
        + " | iniciou: "
        + string(_iniciou)
    );

    if (_iniciou)
    {
        // Fazer o boss aguardar a recuperação.
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

        // Destruir todos os tiros para evitar
        // novo impacto durante a animação.
        with (obj_boss_projectile)
        {
            instance_destroy();
        }

        exit;
    }

    // Não havia histórico suficiente.
    instance_destroy();
    exit;
}


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

    // Tirar o projétil de dentro da caixa.
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
// PAREDES E OUTROS COLISORES
//==================================================

// Essa verificação precisa ficar depois da caixa,
// porque obj_box herda de obj_colisor.
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


//==================================================
// FORA DA ROOM
//==================================================

if (
    x < -32
    || x > room_width + 32
    || y < -32
    || y > room_height + 32
)
{
    instance_destroy();
}
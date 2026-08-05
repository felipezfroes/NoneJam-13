//==================================================
// CONFIGURAÇÃO
//==================================================

// Placas e portas com o mesmo canal ficam conectadas.
canal = 0;

// Comportamento ao atravessar a porta.
acao = DoorAction.passagem;

// Utilizado apenas quando acao == trocar_sala.
sala_destino = noone;


//==================================================
// ESTADO
//==================================================

aberta = false;
bloqueador_id = noone;

image_speed = 0;


//==================================================
// CRIAR BLOQUEADOR
//==================================================

criar_bloqueador = function()
{
    if (instance_exists(bloqueador_id))
    {
        return;
    }

    // Guardar as propriedades visuais/máscara da porta.
    var _sprite = sprite_index;
    var _mask = mask_index;

    var _xscale = image_xscale;
    var _yscale = image_yscale;
    var _angle = image_angle;

    bloqueador_id = instance_create_depth(
        x,
        y,
        0,
        obj_door_blocker
    );

    // O bloqueador será invisível, mas usará
    // a mesma máscara da porta.
    (bloqueador_id).sprite_index = _sprite;
    (bloqueador_id).mask_index = _mask;

    (bloqueador_id).image_index = 0;
    (bloqueador_id).image_speed = 0;

    (bloqueador_id).image_xscale = _xscale;
    (bloqueador_id).image_yscale = _yscale;
    (bloqueador_id).image_angle = _angle;

    (bloqueador_id).visible = false;
};


//==================================================
// REMOVER BLOQUEADOR
//==================================================

remover_bloqueador = function()
{
    if (instance_exists(bloqueador_id))
    {
        instance_destroy(bloqueador_id);
    }

    bloqueador_id = noone;
};


//==================================================
// ALTERAR ESTADO
//==================================================

definir_aberta = function(_novo_estado)
{
    if (aberta == _novo_estado)
    {
        // Segurança: uma porta fechada sempre precisa
        // possuir seu bloqueador.
        if (!aberta && !instance_exists(bloqueador_id))
        {
            criar_bloqueador();
        }

        return;
    }

    aberta = _novo_estado;
    
    //==================================================
    // SOM DA PORTA
    //==================================================
    
    if (aberta)
    {
        remover_bloqueador();
        
        scr_play_sfx(
            snd_door_open,
            0.48,
            0.96,
            1.02,
            4
        );
    }
    else
    {
        criar_bloqueador();
        
        scr_play_sfx(
            snd_door_close,
            0.42,
            0.94,
            1.00,
            4
        );
    }
};


//==================================================
// ESTADO INICIAL
//==================================================

criar_bloqueador();
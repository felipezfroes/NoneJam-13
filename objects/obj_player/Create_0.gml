vel = 2;

velh = 0;
velv = 0;

direita  = false;
esquerda = false;
cima     = false;
baixo    = false;

input_h = 0;
input_v = 0;

time_manager = noone;

// Direção inicial em que o player está olhando.
direcao_olhar_x = 0;
direcao_olhar_y = 1;

enum PlayerEstados
{
    parado,
    andando
}

estado = PlayerEstados.parado;


controles = function()
{
    direita =
        keyboard_check(vk_right)
        or keyboard_check(ord("D"));

    esquerda =
        keyboard_check(vk_left)
        or keyboard_check(ord("A"));

    cima =
        keyboard_check(vk_up)
        or keyboard_check(ord("W"));

    baixo =
        keyboard_check(vk_down)
        or keyboard_check(ord("S"));

    input_h = direita - esquerda;
    input_v = baixo - cima;

    // DIREÇÃO EM QUE O PLAYER ESTÁ OLHANDO
    
    // Movimento exclusivamente horizontal.
    if (input_h != 0 && input_v == 0)
    {
        direcao_olhar_x = sign(input_h);
        direcao_olhar_y = 0;
    }
    // Movimento exclusivamente vertical.
    else if (input_v != 0 && input_h == 0)
    {
        direcao_olhar_x = 0;
        direcao_olhar_y = sign(input_v);
    }
    // Em movimento diagonal, mantém a última direção cardinal.
    
    scr_actor_apply_input(
        input_h,
        input_v,
        vel
    );
};


maquina_estados = function()
{
    controles();

    if (input_h == 0 && input_v == 0)
    {
        estado = PlayerEstados.parado;
    }
    else
    {
        estado = PlayerEstados.andando;
    }
};

//==================================================
// HISTÓRICO TEMPORAL DO PLAYER
//==================================================

// Dois segundos em 60 FPS.
historico_maximo = 120;

// O tiro tenta devolver 1,5 segundo.
retrocesso_frames_impacto = 90;

// Quantos registros são percorridos por frame.
// Dois deixa o retrocesso rápido, mas ainda legível.
retrocesso_velocidade = 2;

historico_x = array_create(
    historico_maximo,
    x
);

historico_y = array_create(
    historico_maximo,
    y
);

historico_direcao_x = array_create(
    historico_maximo,
    direcao_olhar_x
);

historico_direcao_y = array_create(
    historico_maximo,
    direcao_olhar_y
);

historico_indice = 0;
historico_total = 0;


//==================================================
// ESTADO DO RETROCESSO
//==================================================

retrocedendo_forcado = false;

retrocesso_cursor = 0;
retrocesso_restante = 0;

retrocesso_vfx_timer = 0;

invulneravel_frames = 0;


//==================================================
// LIMPAR HISTÓRICO
//==================================================

limpar_historico_temporal = function()
{
    historico_indice = 0;
    historico_total = 0;

    // Guarda a posição atual como primeiro registro.
    historico_x[0] = x;
    historico_y[0] = y;

    historico_direcao_x[0] =
        direcao_olhar_x;

    historico_direcao_y[0] =
        direcao_olhar_y;

    historico_indice = 1;
    historico_total = 1;
};


//==================================================
// REGISTRAR POSIÇÃO
//==================================================

registrar_historico_temporal = function()
{
    if (retrocedendo_forcado)
    {
        return;
    }

    historico_x[historico_indice] = x;
    historico_y[historico_indice] = y;

    historico_direcao_x[historico_indice] =
        direcao_olhar_x;

    historico_direcao_y[historico_indice] =
        direcao_olhar_y;

    historico_indice =
        (
            historico_indice
            + 1
        )
        mod historico_maximo;

    historico_total = min(
        historico_total + 1,
        historico_maximo
    );
};


//==================================================
// INICIAR RETROCESSO
//==================================================

//==================================================
// INICIAR RETROCESSO FORÇADO
//==================================================

iniciar_retrocesso_forcado = function(_frames)
{
    // Já está sofrendo o efeito.
    if (retrocedendo_forcado)
    {
        return false;
    }

    // Período de proteção após outro impacto.
    if (invulneravel_frames > 0)
    {
        return false;
    }

    // Precisa existir mais de uma posição registrada.
    if (historico_total <= 1)
    {
        return false;
    }

    retrocedendo_forcado = true;

    // Não utiliza mais posições do que realmente existem.
    retrocesso_restante = min(
        _frames,
        historico_total - 1
    );

    // historico_indice sempre aponta para o próximo
    // espaço vazio do histórico circular.
    retrocesso_cursor =
        (
            historico_indice
            - 1
            + historico_maximo
        )
        mod historico_maximo;

    retrocesso_vfx_timer = 0;

    input_h = 0;
    input_v = 0;

    velh = 0;
    velv = 0;

    estado = PlayerEstados.parado;

    image_blend = c_aqua;

    return true;
};

//==================================================
// ATUALIZAR RETROCESSO
//==================================================

//==================================================
// ATUALIZAR RETROCESSO FORÇADO
//==================================================

atualizar_retrocesso_forcado = function()
{
    if (!retrocedendo_forcado)
    {
        return false;
    }

    // Bloquear todo movimento normal.
    input_h = 0;
    input_v = 0;

    velh = 0;
    velv = 0;

    estado = PlayerEstados.parado;


    //==================================================
    // PERCORRER O HISTÓRICO AO CONTRÁRIO
    //==================================================

    repeat (retrocesso_velocidade)
    {
        if (retrocesso_restante <= 0)
        {
            break;
        }

        var _novo_x =
            historico_x[retrocesso_cursor];

        var _novo_y =
            historico_y[retrocesso_cursor];


        //==================================================
        // NÃO ATRAVESSAR OBJETOS QUE ESTÃO NO PRESENTE
        //==================================================

        if (
            place_meeting(
                _novo_x,
                _novo_y,
                obj_colisor
            )
        )
        {
            retrocesso_restante = 0;
            break;
        }


        //==================================================
        // APLICAR POSIÇÃO ANTIGA
        //==================================================

        x = _novo_x;
        y = _novo_y;

        direcao_olhar_x =
            historico_direcao_x[
                retrocesso_cursor
            ];

        direcao_olhar_y =
            historico_direcao_y[
                retrocesso_cursor
            ];


        // Ir para o registro anterior.
        retrocesso_cursor =
            (
                retrocesso_cursor
                - 1
                + historico_maximo
            )
            mod historico_maximo;

        retrocesso_restante--;
    }


    //==================================================
    // RASTRO VISUAL
    //==================================================

    retrocesso_vfx_timer++;

    if (retrocesso_vfx_timer >= 4)
    {
        retrocesso_vfx_timer = 0;

        var _vfx = instance_create_depth(
            x,
            y,
            depth + 2,
            obj_echo_vfx
        );

        (_vfx).sprite_index = sprite_index;
        (_vfx).image_index = image_index;
        (_vfx).image_speed = 0;

        (_vfx).image_xscale = image_xscale;
        (_vfx).image_yscale = image_yscale;
        (_vfx).image_angle = image_angle;

        (_vfx).image_blend = c_aqua;
        (_vfx).image_alpha = 0.55;
    }


    //==================================================
    // ENCERRAR RETROCESSO
    //==================================================

    if (retrocesso_restante <= 0)
    {
        retrocedendo_forcado = false;

        image_blend = c_white;

        input_h = 0;
        input_v = 0;

        velh = 0;
        velv = 0;

        // Meio segundo de proteção.
        invulneravel_frames = 30;

        // Começa um histórico novo nesta posição.
        limpar_historico_temporal();
    }

    return true;
};

//==================================================
// ESTADO INICIAL
//==================================================

limpar_historico_temporal();
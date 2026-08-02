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
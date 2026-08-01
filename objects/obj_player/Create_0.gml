vel = 2;
velh = 0;
velv = 0;

direita     = noone;
esquerda    = noone;
cima        = noone;
baixo       = noone;

enum PlayerEstados
{
    parado,
    andando,
}

estado = PlayerEstados.parado;

controles = function()
{
    direita     = keyboard_check(vk_right) or keyboard_check(ord("D"));
    esquerda    = keyboard_check(vk_left) or keyboard_check(ord("A"));
    cima        = keyboard_check(vk_up) or keyboard_check(ord("W"));
    baixo       = keyboard_check(vk_down) or keyboard_check(ord("S"));
    
    //velh = (direita - esquerda) * vel;
    //velv = (baixo - cima) * vel;
    var dir = point_direction(0,0, direita - esquerda, baixo - cima);
    
    if (direita xor esquerda or baixo xor cima)
    {
        velh = lengthdir_x(vel, dir);
        velv = lengthdir_y(vel, dir);
        
    }
    else {
        velh = 0;
        velv = 0;
    }
}

maquina_estados = function() 
{
    switch (estado) 
    {
    	case PlayerEstados.parado: 
        {
            controles();
            if (direita xor esquerda or cima xor baixo)
            {
                estado = PlayerEstados.andando;
            }
            break;
        }
            
        case PlayerEstados.andando: 
        {
            controles();
            if (velh == 0 and velv == 0)
            {
                estado = PlayerEstados.parado
            }
            
            break;
        }  
    }
}
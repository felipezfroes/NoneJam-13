enum BossState
{
    dormindo,
    esperando,
    carregando,
    disparando,
    atingido,
    movendo,
    derrotado
}

vida = 2;

estado = BossState.esperando;
timer = 0;

fase = 1;

alvo_x = x;

intervalo_disparo = 120;
tempo_carregamento = 45;

ativado = false;
invulneravel = false;

image_speed = 0;

disparar = function()
{
    var _tiro = instance_create_depth(
        x,
        y + 24,
        depth - 1,
        obj_boss_projectile
    );

    (_tiro).vel_x = 0;
    (_tiro).vel_y = 4;

    (_tiro).refletido = false;
};

maquina_de_estado = function ()
{
    switch (estado)
   {
       case BossState.dormindo:
       {
           // Espera o jogador entrar na arena.
           break;
       }
   
       case BossState.esperando:
       {
           timer--;
   
           if (timer <= 0)
           {
               estado = BossState.carregando;
               timer = tempo_carregamento;
           }
   
           break;
       }
   
       case BossState.carregando:
       {
           timer--;
   
           if (timer <= 0)
           {
               estado = BossState.disparando;
           }
   
           break;
       }
   
       case BossState.disparando:
       {
           disparar();
   
           estado = BossState.esperando;
           timer = intervalo_disparo;
   
           break;
       }
   
       case BossState.atingido:
       {
           timer--;
   
           if (timer <= 0)
           {
               if (vida <= 0)
               {
                   estado = BossState.derrotado;
               }
               else
               {
                   alvo_x = 240;
                   estado = BossState.movendo;
               }
           }
   
           break;
       }
   
       case BossState.movendo:
       {
           x = lerp(x, alvo_x, 0.12);
   
           if (abs(x - alvo_x) < 1)
           {
               x = alvo_x;
   
               invulneravel = false;
   
               estado = BossState.esperando;
               timer = 60;
           }
   
           break;
       }
   
       case BossState.derrotado:
       {
           // Animação e conclusão.
           break;
       }
   }
}
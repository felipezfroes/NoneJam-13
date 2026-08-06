//==================================================
// IDENTIFICAÇÃO
//==================================================

texto = "BOTÃO";
acao = "";

menu_index = 0;


//==================================================
// POSIÇÃO NA GUI
//==================================================

gui_x = 0;
gui_y = 0;


//==================================================
// SPRITE E ESCALA
//==================================================

sprite_botao = spr_button;

// Escala inteira principal para preservar o pixel art.
escala_base = 2;

// Multiplicador suave usado no hover e na seleção.
escala_visual = 1;


//==================================================
// ÁREA DE INTERAÇÃO
//==================================================

largura =
    sprite_get_width(sprite_botao)
    * escala_base;

altura =
    sprite_get_height(sprite_botao)
    * escala_base;


//==================================================
// ESTADO
//==================================================

selecionado = false;
hover = false;

brilho_visual = 0;
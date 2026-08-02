vel = 2;

velh = 0;
velv = 0;

comandos_h = [];
comandos_v = [];

frame_reproducao = 0;

reproduzindo = false;
finalizado = false;

//==================================================
// APARÊNCIA DO ECO
//==================================================

cor_eco = make_colour_rgb(0, 220, 255);

image_alpha = 0.75;
image_blend = cor_eco;


//==================================================
// RASTRO
//==================================================

// Um VFX a cada 8 Steps.
// Como o eco anda 2 pixels por Step,
// isso gera aproximadamente 16 pixels entre rastros.
vfx_intervalo = 8;
vfx_timer = 0;

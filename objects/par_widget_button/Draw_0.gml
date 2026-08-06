var spr_w = sprite_get_width(sprite_index) * image_xscale;
var spr_h = sprite_get_height(sprite_index) * image_yscale;


draw_self();
if (selec)
{
    var txt = name;

    draw_set_font(fnt_pixel);
    draw_set_halign(fa_center);
    draw_set_valign(fa_middle);

    var txt_scale = 1;
    var txt_w = string_width(txt) * txt_scale;
    var txt_h = string_height(txt) * txt_scale;

    // posição do tooltip
    var tip_x = x;
    var tip_y = y - (spr_h / 2) - 15;

    // margem interna do fundo
    var pad_x = 4;
    var pad_y = 4;

    // fundo
    draw_set_alpha(0.85);
    draw_set_color(make_colour_rgb(20, 20, 25));

    draw_rectangle(
        tip_x - txt_w / 2 - pad_x,
        tip_y - txt_h / 2 - pad_y,
        tip_x + txt_w / 2 + pad_x,
        tip_y + txt_h / 2 + pad_y,
        false
    );

    // borda
    draw_set_alpha(1);
    draw_set_color(make_colour_rgb(90, 90, 100));

    draw_rectangle(
        tip_x - txt_w / 2 - pad_x,
        tip_y - txt_h / 2 - pad_y,
        tip_x + txt_w / 2 + pad_x,
        tip_y + txt_h / 2 + pad_y,
        true
    );

    // texto
    draw_set_color(c_white);
    draw_text_transformed(tip_x, tip_y, txt, txt_scale, txt_scale, 0);

    draw_set_font(-1);
    draw_set_halign(fa_left);
    draw_set_valign(fa_top);
    draw_set_alpha(1);
    draw_set_color(c_white);
}
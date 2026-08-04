image_alpha -= fade_speed;

image_xscale += grow_speed;
image_yscale += grow_speed;

if (image_alpha <= 0)
{
    instance_destroy();
}
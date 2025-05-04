const std = @import("std");
const a = @import("allegro5.zig").allegro;
const a5 = @import("allegro5.zig");




const Collider = @import("./collision.zig").Collider;

const Paddle = struct {
    x:f32,
    y:f32,
    vx:f32,
    vy:f32,
    w:i32,
    h:i32,
    score: i32,
    speed:f32,
    collider:Collider
};

const Ball = struct {
    x:f32,
    y:f32,
    vx:f32,
    vy:f32,
    w:f32,
    h:f32,
    speed:f32,
    collider: Collider
};



var pads: [2]Paddle = undefined;
var ball:Ball = undefined;

var game_text: ?*a.ALLEGRO_FONT = null;



const GameState = enum(i32){
    Waiting,
    Running,
    EndRound,
    NewGame
};

var pongState: GameState = GameState.Waiting;
var rand: std.Random = undefined;

pub fn pong_start(rnd:std.Random) void {
    rand = rnd;
}

pub fn pong_init() void {


    if(game_text == null){
        game_text = a.al_create_builtin_font();
        //defer a.al_destroy_font(game_text);
    }

    const dsp_height = @as(f32, @floatFromInt(a.al_get_display_height(a.al_get_current_display())) );
    const dsp_width = @as(f32, @floatFromInt(a.al_get_display_width(a.al_get_current_display())));

    
    pads[0].h = 70;
    pads[0].w = 20;
    pads[0].x = 10;
    pads[0].y = @divExact(dsp_height, 2) - @as(f32, @floatFromInt(pads[0].h));
    pads[0].score = 0;
    pads[0].speed = 6.0;
    pads[0].vx = 0;
    pads[0].vy = 0;


    pads[1].h = 70;
    pads[1].w = 20;
    pads[1].x = dsp_width -  @as(f32, @floatFromInt(pads[1].w)) - 10;
    pads[1].y = @divExact(dsp_height, 2) -  @as(f32, @floatFromInt(pads[0].h));
    pads[1].score = 0;
    pads[1].speed = 6.0;
    pads[1].vx = 0;
    pads[1].vy = 0;

    ball.x = @divExact(dsp_width, 2) - ball.w;
    ball.y = @divExact(dsp_height, 2) - ball.h;
    ball.w = 10;
    ball.h = 10;
    ball.speed = 6.0;
    ball.vx = 1 * ball.speed;
    ball.vy = 1 * ball.speed;


}

fn pong_controls() void {
    
   const dsp_height = @as(f32, @floatFromInt(a.al_get_display_height(a.al_get_current_display())) );
   //const dsp_width = @as(f32, @floatFromInt(a.al_get_display_width(a.al_get_current_display())));

    //update colliders
    pads[0].collider = Collider.FromFloat(pads[0].x, pads[0].y, @as(f32, @floatFromInt(pads[0].w)), @as(f32, @floatFromInt(pads[0].h)));
    pads[1].collider = Collider.FromFloat(pads[1].x, pads[1].y, @as(f32, @floatFromInt(pads[1].w)), @as(f32, @floatFromInt(pads[1].h)));
    ball.collider    = Collider.FromFloat(ball.x, ball.y, ball.w, ball.h);

    if(a5.a5_is_key_pressed(a5.AllegroKeys.KEY_W)){
        pads[0].vy = -1.0 * pads[0].speed;
    }else  if(a5.a5_is_key_pressed(a5.AllegroKeys.KEY_S)){
        pads[0].vy = 1.0 * pads[0].speed;
    }else {
         pads[0].vy = 0;
    }


    if(a5.a5_is_key_pressed(a5.AllegroKeys.KEY_UP)){
        pads[1].vy = -1.0 * pads[1].speed;
    }else  if(a5.a5_is_key_pressed(a5.AllegroKeys.KEY_DOWN)){
        pads[1].vy = 1.0 * pads[1].speed;
    }else {
         pads[1].vy = 0;
    }



    if(pads[0].y > dsp_height - @as(f32, @floatFromInt(pads[0].h)) - 1){
        pads[0].vy = 0;
        pads[0].y =  dsp_height - @as(f32, @floatFromInt(pads[0].h)) - 1;
    }

    if(pads[0].y < 0){
        pads[0].vy = 0;
        pads[0].y = 0;
    }

    if(pads[0].collider.CollidesWith(ball.collider)){
        ball.vx *= -1;
    }

    if(pads[1].collider.CollidesWith(ball.collider)){
        ball.vx *= -1;
    }

    pads[0].x += pads[0].vx;
    pads[0].y += pads[0].vy; 

    
    pads[1].x += pads[1].vx;
    pads[1].y += pads[1].vy; 
}   

pub fn pong_update() void {

    const dsp_height = @as(f32, @floatFromInt(a.al_get_display_height(a.al_get_current_display())) );
    const dsp_width = @as(f32, @floatFromInt(a.al_get_display_width(a.al_get_current_display())));

    const ball_w = ball.w;
    const ball_h = ball.h;


    switch (pongState) {

        GameState.NewGame => {
            pong_init();
            pads[0].score = 0;
            pads[1].score = 0;
            pongState = GameState.Waiting;
        },

        GameState.Waiting => {
                ball.x = @divExact(dsp_width , 2) - ball.w;
                ball.y = @divExact(dsp_height , 2) - ball.h;

                if(a5.a5_is_key_released(a5.AllegroKeys.KEY_SPACE)){
                    pongState = GameState.Running;
                }
        },

        GameState.Running => {
            if(ball.x + ball_w > dsp_width - 10){
                    //ball.vx = -1.0 * ball.speed;
                    pads[0].score += 10;
                    pongState = GameState.EndRound;
            }

            if(ball.x + ball_w < ball_w) {
                //ball.vx = 1.0 * ball.speed;
                pads[1].score += 10;
                pongState = GameState.EndRound;
            }

            if(ball.y + ball.h > dsp_height - 10) {
                ball.vy = -1.0 * ball.speed;
            }

            if(ball.y + ball_h < ball_h) {
                ball.vy = 1.0 * ball.speed;
            }

            ball.x += ball.vx;
            ball.y += ball.vy;

            pong_controls();
        },
        GameState.EndRound => {
            ball.x = @divExact(dsp_width , 2) - ball.w;
            ball.y = @divExact(dsp_height , 2) - ball.h;
            const rx = rand.intRangeAtMost(i32, 0, 100);
            const ry = rand.intRangeAtMost(i32, 0, 100);
            if(rx > 50){
                ball.vx = -1 * ball.speed;
            }else {
                ball.vx = 1 * ball.speed;
            }

            if(ry > 50){
                ball.vx = -1 * ball.speed;
            }else {
                ball.vx = 1 * ball.speed;
            }
            
            pongState = GameState.Running;
        }
    }

}

pub fn pong_render() void {
    const dsp_height = @as(f32, @floatFromInt(a.al_get_display_height(a.al_get_current_display())) );
    const dsp_width = @as(f32, @floatFromInt(a.al_get_display_width(a.al_get_current_display())));

    //background
    a.al_draw_line(@divExact(dsp_width, 2) , 0, @divExact(dsp_width, 2),dsp_height, a.al_map_rgb(255, 255, 255), 1.0);
    a.al_draw_circle(@divExact(dsp_width, 2), @divExact(dsp_height, 2), 65, a.al_map_rgb(255, 255, 255), 1.0);

    switch(pongState){
        GameState.EndRound => {},
        GameState.NewGame => {
            
            //pad 0
            a.al_draw_filled_rectangle(pads[0].x, pads[0].y, pads[0].x + @as(f32, @floatFromInt(pads[0].w)), pads[0].y + @as(f32, @floatFromInt( pads[0].h)) , a.al_map_rgb(255, 255, 255));   
            //pad 1
            a.al_draw_filled_rectangle(pads[1].x, pads[1].y, pads[1].x + @as(f32, @floatFromInt(pads[1].w)), pads[1].y + @as(f32, @floatFromInt( pads[1].h)) , a.al_map_rgb(255, 255, 255));   

            //ball
            a.al_draw_filled_circle(ball.x, ball.y, ball.w, a.al_map_rgb(255, 255, 255));

        },
        GameState.Waiting => {
            const text:[*c]const u8 = "Press SPACE To Play ZigPONG!";
            const text_size = a.al_get_text_width(game_text, text);
            a.al_draw_text(game_text, a.al_map_rgb(255, 255, 255), (dsp_width / 2) - @as(f32, @floatFromInt(text_size))  , dsp_height / 2 , 0, text);
            //pad 0
            a.al_draw_filled_rectangle(pads[0].x, pads[0].y, pads[0].x + @as(f32, @floatFromInt(pads[0].w)), pads[0].y + @as(f32, @floatFromInt( pads[0].h)) , a.al_map_rgb(255, 255, 255));   
            //pad 1
            a.al_draw_filled_rectangle(pads[1].x, pads[1].y, pads[1].x + @as(f32, @floatFromInt(pads[1].w)), pads[1].y + @as(f32, @floatFromInt( pads[1].h)) , a.al_map_rgb(255, 255, 255));   

            //ball
            a.al_draw_filled_circle(ball.x, ball.y, ball.w, a.al_map_rgb(255, 255, 255));

        },

        GameState.Running => {

            //a.al_draw_text(game_text, a.al_map_rgb(255, 255, 255), dsp_width / 2 - 100 , 25, 0, format_p1);
            //a.al_draw_text(game_text, a.al_map_rgb(255, 255, 255), dsp_width / 2 + (dsp_width / 2) - 100 , 25, 0, format_p2.ptr);
            
            //pad 0
            a.al_draw_filled_rectangle(pads[0].x, pads[0].y, pads[0].x + @as(f32, @floatFromInt(pads[0].w)), pads[0].y + @as(f32, @floatFromInt( pads[0].h)) , a.al_map_rgb(255, 255, 255));   
            //pad 1
            a.al_draw_filled_rectangle(pads[1].x, pads[1].y, pads[1].x + @as(f32, @floatFromInt(pads[1].w)), pads[1].y + @as(f32, @floatFromInt( pads[1].h)) , a.al_map_rgb(255, 255, 255));   

            //ball
            a.al_draw_filled_circle(ball.x, ball.y, ball.w, a.al_map_rgb(255, 255, 255));
        }
    }



}
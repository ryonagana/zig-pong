const std = @import("std");

const expect = std.testing.expect;

const a5 = @import("./allegro5.zig");
const a = @import("./allegro5.zig").allegro;
const pong = @import("./pong.zig");

var main_window: a5.a5_window = undefined;

pub fn main() !void {
    
    const seed=  @as(u64, @intCast(std.time.milliTimestamp()));
    var prng = std.Random.Xoshiro256.init(seed);
    const rand = prng.random();
    
    //arena allocation for fast allocations
    var arena = std.heap.ArenaAllocator.init(std.heap.page_allocator);
    defer arena.deinit();
  
    a5.a5_init();
    
    main_window = a5.a5_window.init(800, 600, true, false, "Test Zig!", 0);
    defer a.al_destroy_display(main_window.display);
    defer a.al_destroy_event_queue(main_window.queue);
    defer a.al_destroy_timer(main_window.timer);
    defer a.al_destroy_bitmap(main_window.screen);

    pong.pong_start(rand);
    pong.pong_init();

    while(!main_window.window_closed){
        var e: a.ALLEGRO_EVENT = undefined;
        
  
        if(main_window.redraw and a.al_is_event_queue_empty(main_window.queue)){
            main_window.redraw = true;
            a.al_set_clipping_rectangle(0, 0, main_window.width, main_window.height);
            a.al_clear_to_color(a.al_map_rgb(0, 0, 0));
            pong.pong_render();
            a.al_flip_display();
        }

        while(!a.al_is_event_queue_empty(main_window.queue)){
            a.al_wait_for_event(main_window.queue, &e);

            if(e.type == a.ALLEGRO_EVENT_DISPLAY_CLOSE){
                main_window.window_closed = true;
            }

            if(e.type == a.ALLEGRO_EVENT_TIMER){
                pong.pong_update();
                main_window.redraw = true;  
            }

            a5.a5_keyboard_poll_events(&e);
        }


        // if(a5.a5_fps_timer_end() < (1.0 / a5.FPS)){
           
        //     var buf:[255]u8 = undefined;
        //     const fps_counter = @mod(fps, @as(i64, @intFromFloat(a5.FPS)));

        //     const msg  = try std.fmt.bufPrintZ(&buf, "FPS: {any}", .{fps_counter});
        //     main_window.redraw = true;
        //     a.al_set_window_title(main_window.display, msg);
        //     a.al_rest((1.0 / a5.FPS) - a5.a5_fps_timer_end());
        // }
    }


}


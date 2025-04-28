const std = @import("std");

pub const allegro = @cImport({
    @cInclude("allegro5/allegro.h");
    @cInclude("allegro5/allegro_image.h");
    @cInclude("allegro5/allegro_font.h");
    @cInclude("allegro5/allegro_ttf.h");
    @cInclude("allegro5/allegro_primitives.h");
    @cInclude("allegro5/allegro_native_dialog.h");

});

const allegro_keys = @import("allegro5_keys.zig");

pub const FPS:f64 = 60.0;
pub const FPS_CLOCK: f64  = 1.0 / FPS; 


pub const ALLEGRO_EVENT_QUEUE = allegro.ALLEGRO_EVENT_QUEUE;

const KeyStateFlags = enum(i32) {
    KeyPressed  =  0x2,
    KeyReleased =  0x4
};

var a5_keys:[allegro.ALLEGRO_KEY_MAX]i32 = undefined;


pub const AllegroError = error {
    AllegroInitFailed,
    AllegroKeyboardFailed,
    AllegroMouseFailed,

    //Addons
    AllegroAddonImageFailed,
    AllegroAddonFontFailed,
    AllegroAddonTTFFailed,
    AllegroAddonPrimitivesFailed,
    AllegroAddonNativeDialogFailed,

};

pub const a5_window = struct  {
    display: ?*allegro.ALLEGRO_DISPLAY,
    queue:  ?*allegro.ALLEGRO_EVENT_QUEUE,
    timer:  ?*allegro.ALLEGRO_TIMER,
    screen: ?*allegro.ALLEGRO_BITMAP,
    window_closed : bool,
    width: i32,
    height: i32,
    redraw: bool,

    pub fn init(width: i32, height: i32, enable_vsync : bool, fullscreen: bool, title: [*c]const u8, flags: i32) a5_window {
        
        var display_flags:i32 = flags | allegro.ALLEGRO_WINDOWED;
        
        var window: a5_window = .{
            .display = null,
            .queue = null,
            .timer = null,
            .screen = null,
            .window_closed = false,
            .width = 0,
            .height = 0,
            .redraw = true
        };



        if(fullscreen){
            display_flags &= ~allegro.ALLEGRO_WINDOWED;
            display_flags |= allegro.ALLEGRO_FULLSCREEN_WINDOW;
        }

        if(enable_vsync) {
            const option: i32 = if (enable_vsync)  2 else 1; 
            allegro.al_set_new_display_option(allegro.ALLEGRO_VSYNC,  option , allegro.ALLEGRO_SUGGEST);
        }

        allegro.al_set_new_display_flags(display_flags);


        window.display = allegro.al_create_display(width , height);

        if(window.display == null){
            std.debug.print("Allegro Display Error!\n", .{});
        }

        allegro.al_set_new_window_title(title);

        window.queue = allegro.al_create_event_queue();

        if(window.queue == null){
            std.debug.print("Allegro Event Queue Error!\n", .{});
        }


        window.timer = allegro.al_create_timer(FPS_CLOCK);

        if(window.timer == null){
            std.debug.print("Allegro Timer Failed!\n", .{});
        }

        window.screen = allegro.al_create_bitmap(@intCast(width), @intCast(height));

        if(window.screen == null){
            std.debug.print("Allegro Screen Buffer Failed!\n", .{});
        }

        window.register_events();

        allegro.al_start_timer(window.timer);

        window.redraw = false;
        window.window_closed = false;

        window.width = width;
        window.height = height;

        return window;

    }

    pub fn register_events(self: a5_window) void {
        allegro.al_register_event_source(self.queue, allegro.al_get_display_event_source(self.display));
        allegro.al_register_event_source(self.queue, allegro.al_get_keyboard_event_source());
        allegro.al_register_event_source(self.queue, allegro.al_get_mouse_event_source());
        allegro.al_register_event_source(self.queue, allegro.al_get_timer_event_source(self.timer));
    }

    pub fn shutdown(self: a5_window) void {
        if(self.display != null) allegro.al_destroy_display(self.display);
        if(self.queue != null) allegro.al_destroy_event_queue(self.queue);
        if(self.timer != null) allegro.al_destroy_timer(self.timer);
        if(self.screen != null) allegro.al_destroy_bitmap(self.screen);
    }
};



pub fn a5_init() void {
    
    const init_everything = a5_init_allegro();

    if(init_everything) |_| {
         std.debug.print("Allegro Loaded Successfully!\n", .{});
    }else |err| {
        switch (err) {
            AllegroError.AllegroAddonNativeDialogFailed => std.debug.print("Allegro Addon Native Dialog Failed!\n", .{}),
            AllegroError.AllegroAddonPrimitivesFailed => std.debug.print("Allegro Addon Primitives Failed!\n", .{}),
            AllegroError.AllegroInitFailed => std.debug.print("Allegro Init Failed!\n", .{}),
            AllegroError.AllegroKeyboardFailed => std.debug.print("Allegro Keyboard Install Failed\n", .{}),
            AllegroError.AllegroMouseFailed => std.debug.print("Allegro Mouse Failed!\n", .{}),
            AllegroError.AllegroAddonImageFailed => std.debug.print("Allegro Image Addon Failed\n", .{}),
            AllegroError.AllegroAddonFontFailed => std.debug.print("Allegro Font Addon Failed\n", .{}),
            AllegroError.AllegroAddonTTFFailed => std.debug.print("Allegro TTF Addon Failed\n", .{}),
        }
    }
}

fn a5_init_allegro() AllegroError!void {
    if(!allegro.al_init()){
        return AllegroError.AllegroInitFailed;
    }



    if(!allegro.al_install_keyboard()){
        return AllegroError.AllegroKeyboardFailed;
    }



    if(!allegro.al_install_mouse()){
        return AllegroError.AllegroMouseFailed;
    }


    if(!allegro.al_init_primitives_addon()){
        return AllegroError.AllegroAddonPrimitivesFailed;
    }


    if(!allegro.al_init_native_dialog_addon()){
        return AllegroError.AllegroAddonNativeDialogFailed;
    }



    if(!allegro.al_init_image_addon()){
        return AllegroError.AllegroAddonImageFailed;
    }

   @memset(&a5_keys,0);


    return;
}

pub fn a5_is_key_pressed(key: allegro_keys.AllegroKeys) bool {

    if(key  > allegro.ALLEGRO_KEY_MAX or key < 0){
        return false;
    }

    const pressed: i32 = a5_keys[key];
    return (pressed & KeyStateFlags.KeyPressed) and !(pressed & KeyStateFlags.KeyReleased);
}

pub fn a5_is_key_released(key: allegro_keys.AllegroKeys) bool {
    
    if(key  > allegro.ALLEGRO_KEY_MAX or key < 0){
        return false;
    }

    const released: i32 = a5_keys[key];
    return (released & KeyStateFlags.KeyReleased) and !(released & KeyStateFlags.KeyPressed);
}



pub fn a5_keyboard_poll_events(e:*allegro.ALLEGRO_EVENT) void {

    
    switch(e.type){
        allegro.ALLEGRO_EVENT_KEY_UP => {
            const keycode =  @as(usize, @intCast(e.keyboard.keycode));
            const _pressed_mask = ~@intFromEnum(KeyStateFlags.KeyPressed);
            const _unpressed_mask = @intFromEnum(KeyStateFlags.KeyReleased);

            a5_keys[keycode] &= _pressed_mask;
            a5_keys[keycode] |= _unpressed_mask;

        },

        allegro.ALLEGRO_EVENT_KEY_DOWN => {
            const keycode =  @as(usize, @intCast(e.keyboard.keycode));
            const _pressed_mask = @intFromEnum(KeyStateFlags.KeyPressed);
            const _unpressed_mask = ~@intFromEnum(KeyStateFlags.KeyReleased);

            
            a5_keys[keycode] |=  _pressed_mask;
            a5_keys[keycode] &=  _unpressed_mask;
        },

        else => {
                
            for(&a5_keys) |*key| {
                const keypressed = ~@intFromEnum(KeyStateFlags.KeyReleased);
                key.* |= keypressed; 
            }
        }
    }


}

test "keys has correct size" {
    const sz =   @sizeOf(i32) * a5_keys.len;
    return std.testing.expect(sz == 908);
}

test "Test Allegro Pointers Is initializing" {
    a5_init();
    const win: a5_window =  a5_window.init(320, 200, true, false, "Test", 0);

    defer allegro.al_destroy_display(win.display);
    defer allegro.al_destroy_event_queue(win.queue);
    defer allegro.al_destroy_timer(win.timer);
    defer allegro.al_destroy_bitmap(win.screen);
    
    return std.testing.expect(win.display != null and win.queue != null and win.timer != null and win.screen != null);
}
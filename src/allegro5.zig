const std = @import("std");

pub const allegro = @cImport({
    @cInclude("allegro5/allegro.h");
    @cInclude("allegro5/allegro_image.h");
    @cInclude("allegro5/allegro_font.h");
    @cInclude("allegro5/allegro_ttf.h");
    @cInclude("allegro5/allegro_primitives.h");
    @cInclude("allegro5/allegro_native_dialog.h");

    @cInclude("allegro5/allegro_audio.h");
    @cInclude("allegro5/allegro_acodec.h");

});

const a = allegro; 

pub const AllegroKeys = enum(i32) {
    KEY_Q = a.ALLEGRO_KEY_Q,
    KEY_W = a.ALLEGRO_KEY_W,
    KEY_E = a.ALLEGRO_KEY_E,
    KEY_R = a.ALLEGRO_KEY_R,
    KEY_T = a.ALLEGRO_KEY_T,
    KEY_Y = a.ALLEGRO_KEY_Y,
    KEY_U = a.ALLEGRO_KEY_U,
    KEY_I = a.ALLEGRO_KEY_I,
    KEY_O = a.ALLEGRO_KEY_O,
    KEY_P = a.ALLEGRO_KEY_P,
    KEY_A = a.ALLEGRO_KEY_A,
    KEY_S = a.ALLEGRO_KEY_S,
    KEY_D = a.ALLEGRO_KEY_D,
    KEY_F = a.ALLEGRO_KEY_F,
    KEY_G = a.ALLEGRO_KEY_G,
    KEY_H = a.ALLEGRO_KEY_H,
    KEY_J = a.ALLEGRO_KEY_J,
    KEY_K = a.ALLEGRO_KEY_K,
    KEY_L = a.ALLEGRO_KEY_L,
    KEY_Z = a.ALLEGRO_KEY_Z,
    KEY_X = a.ALLEGRO_KEY_X,
    KEY_C = a.ALLEGRO_KEY_C,
    KEY_V = a.ALLEGRO_KEY_V,
    KEY_B = a.ALLEGRO_KEY_B,
    KEY_N = a.ALLEGRO_KEY_N,
    KEY_M = a.ALLEGRO_KEY_M,
    KEY_1 = a.ALLEGRO_KEY_1,
    KEY_2 = a.ALLEGRO_KEY_2,
    KEY_3 = a.ALLEGRO_KEY_3,
    KEY_4 = a.ALLEGRO_KEY_4,
    KEY_5 = a.ALLEGRO_KEY_5,
    KEY_6 = a.ALLEGRO_KEY_6,
    KEY_7 = a.ALLEGRO_KEY_7,
    KEY_8 = a.ALLEGRO_KEY_8,
    KEY_9 = a.ALLEGRO_KEY_9,
    KEY_0 = a.ALLEGRO_KEY_0,

    //modifiers
    KEY_LCTRL = a.ALLEGRO_KEY_LCTRL,
    KEY_RCTRL = a.ALLEGRO_KEY_RCTRL,
    KEY_LWIN = a.ALLEGRO_KEY_LWIN,
    KEY_RWIN = a.ALLEGRO_KEY_RWIN,
    KEY_LSHIFT = a.ALLEGRO_KEY_LSHIFT,
    KEY_RSHIFT = a.ALLEGRO_KEY_RSHIFT,
    KEY_ALTGR = a.ALLEGRO_KEY_ALTGR,
    KEY_ALT = a.ALLEGRO_KEY_ALT,

    //outro
    KEY_TAB = a.ALLEGRO_KEY_TAB,
    KEY_CAPSLOCK = a.ALLEGRO_KEY_CAPSLOCK,
    KEY_ESC = a.ALLEGRO_KEY_ESCAPE,
    KEY_SPACE = a.ALLEGRO_KEY_SPACE,
    KEY_BACKSPACE = a.ALLEGRO_KEY_BACKSPACE,

    KEY_MINUS = a.ALLEGRO_KEY_MINUS,
    KEY_EQUAL = a.ALLEGRO_KEY_EQUALS,
    KEY_SINGLE_QUOTE = a.ALLEGRO_KEY_QUOTE,
    KEY_COMMA = a.ALLEGRO_KEY_COMMA,

    //F-keys
    KEY_F1 = a.ALLEGRO_KEY_F1,
    KEY_F2 = a.ALLEGRO_KEY_F2,
    KEY_F3 = a.ALLEGRO_KEY_F3,
    KEY_F4 = a.ALLEGRO_KEY_F4,
    KEY_F5 = a.ALLEGRO_KEY_F5,
    KEY_F6 = a.ALLEGRO_KEY_F6,
    KEY_F7 = a.ALLEGRO_KEY_F7,
    KEY_F8 = a.ALLEGRO_KEY_F8,
    KEY_F9 = a.ALLEGRO_KEY_F9,
    KEY_F10 = a.ALLEGRO_KEY_F10,
    KEY_F11 = a.ALLEGRO_KEY_F11,
    KEY_F12 = a.ALLEGRO_KEY_F12,
    
    KEY_PRINTSCR = a.ALLEGRO_KEY_PRINTSCREEN,
    KEY_SCROLLLOCK = a.ALLEGRO_KEY_SCROLLLOCK,
    KEY_PAUSE = a.ALLEGRO_KEY_PAUSE,

    KEY_INS = a.ALLEGRO_KEY_INSERT,
    KEY_HOME = a.ALLEGRO_KEY_HOME,
    KEY_PGUP = a.ALLEGRO_KEY_PGUP,
    KEY_DELETE = a.ALLEGRO_KEY_DELETE,
    KEY_END = a.ALLEGRO_KEY_END,
    KEY_PGDN = a.ALLEGRO_KEY_PGDN,

    //ARROWS
    KEY_UP = a.ALLEGRO_KEY_UP,
    KEY_DOWN = a.ALLEGRO_KEY_DOWN,
    KEY_LEFT = a.ALLEGRO_KEY_LEFT,
    KEY_RIGHT = a.ALLEGRO_KEY_RIGHT,
};


pub const FPS:f64 = 60.0;
pub const FPS_CLOCK: f64  = 1.0 / FPS; 


pub const ALLEGRO_EVENT_QUEUE = allegro.ALLEGRO_EVENT_QUEUE;

const KeyStateFlags = enum(i32) {
    KeyPressed  =  0x2,
    KeyReleased =  0x4
};

var a5_keys:[allegro.ALLEGRO_KEY_MAX]i32 = undefined;

pub const A5_SFX = struct {
    sample: ?*allegro.ALLEGRO_SAMPLE,
    sample_instance: ?*allegro.ALLEGRO_SAMPLE_INSTANCE
};

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


var a5_mixer: ?*allegro.ALLEGRO_MIXER = null;
var a5_voice: ?*allegro.ALLEGRO_VOICE = null;


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


pub fn a5_init_sound(reserve_samples:i32 ) void {
    if(!allegro.al_install_audio()){
        std.debug.print("Allegro Audio Failed!\n", .{});
    }

    if(!allegro.al_init_acodec_addon()){
        std.debug.print("Allegro Audio Codec Failed!\n", .{});
    }

    if(!allegro.al_reserve_samples(reserve_samples)){
        std.debug.print("Allegro Reserve Samples Failed!\n", .{});
    }

    a5_mixer = allegro.al_create_mixer(44100, allegro.ALLEGRO_AUDIO_DEPTH_INT16, allegro.ALLEGRO_CHANNEL_CONF_2);
    if(a5_mixer == null){
        std.debug.print("Allegro Mixer Failed!\n", .{});
    }
    
    a5_voice = allegro.al_create_voice(44100, allegro.ALLEGRO_AUDIO_DEPTH_FLOAT32, allegro.ALLEGRO_CHANNEL_CONF_2);
    
    if(a5_voice == null){
        std.debug.print("Allegro Voice Failed!\n", .{});
    }
    if(!allegro.al_attach_mixer_to_voice(a5_mixer, a5_voice)){
        std.debug.print("Allegro Attach Mixer To Voice Failed!\n", .{});
    }
    if(!allegro.al_set_default_mixer(a5_mixer)){
        std.debug.print("Allegro Set Default Mixer Failed!\n", .{});
    }

}

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

pub fn a5_is_key_pressed(key: AllegroKeys) bool {

    if(@intFromEnum(key)  > a.ALLEGRO_KEY_MAX or @intFromEnum(key) < 0){
        return false;
    }

    const index = @as(usize, @intCast(@intFromEnum(key)));
    const pressed: i32 = a5_keys[index];
   
    return (
            pressed & @intFromEnum(KeyStateFlags.KeyPressed) != 0
            and (pressed & @intFromEnum(KeyStateFlags.KeyReleased)) == 0
           );
   }

pub fn a5_is_key_released(key: AllegroKeys) bool {
    
    if(@intFromEnum(key)  > a.ALLEGRO_KEY_MAX or @intFromEnum(key) < 0){
        return false;
    }

    const index = @as(usize, @intCast(@intFromEnum(key)));
    const pressed: i32 = a5_keys[index];
   
    return (
            pressed & @intFromEnum(KeyStateFlags.KeyPressed) == 0
            and (pressed & @intFromEnum(KeyStateFlags.KeyReleased)) != 0
           );
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
                const keypressed = key.* & ~@intFromEnum(KeyStateFlags.KeyReleased);
                key.* |= keypressed; 
            }
        }
    }


}

pub fn a5_load_sample(path: [*c]const u8) A5_SFX {
    
    if(path == null){
        std.debug.print("Allegro Sample Path is Null!\n", .{});
        return .{
            .sample = null,
            .sample_instance = null
        };
    }
    
    const sample = allegro.al_load_sample(path);
    const inst = allegro.al_create_sample_instance(sample);
    


    if(sample == null){
        std.debug.print("Allegro Load Sample Failed!\n", .{});
        return .{
            .sample = null,
            .sample_instance = null
        };
    }

    if(inst == null){
        std.debug.print("Allegro Create Sample Instance Failed!\n", .{});
        return .{
            .sample = null,
            .sample_instance = null
        };
    }

    const sfx:A5_SFX = .{
        .sample = sample,
        .sample_instance = inst
    };

    return sfx;
}

pub fn a5_play_sample(sfx: *A5_SFX, volume:f32, pan:f32, speed:f32, mode:a.ALLEGRO_PLAYMODE ) void {
    if(sfx.sample == null){
        std.debug.print("Allegro Sample is Null!\n", .{});
        return;
    }

    if(sfx.sample_instance == null){
        std.debug.print("Allegro Sample Instance is Null!\n", .{});
        return;
    }


    a.al_set_sample_instance_gain(sfx.*.sample_instance, volume);
    a.al_set_sample_instance_pan(sfx.*.sample_instance, pan);
    a.al_set_sample_instance_speed(sfx.*.sample_instance, speed);
    a.al_set_sample_instance_playmode(sfx.*.sample_instance, mode);
    a.al_play_sample_instance(sfx.*.sample_instance);
}
pub fn a5_stop_sample(sfx: *A5_SFX) void {
    if(sfx.sample == null){
        std.debug.print("Allegro Sample is Null!\n", .{});
        return;
    }

    if(sfx.sample_instance == null){
        std.debug.print("Allegro Sample Instance is Null!\n", .{});
        return;
    }

    allegro.al_set_sample_instance_playing(sfx.sample_instance, false);
    allegro.al_stop_sample_instance(sfx.sample_instance);
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
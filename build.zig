const std = @import("std");
const LazyPath = std.Build.LazyPath;




pub fn build(b: *std.Build) void {


        
        const target = b.standardTargetOptions(.{});
        const optimize = b.standardOptimizeOption(.{});



        
        const exe  = b.addExecutable(.{
            .name = "pong",
            .target =  target,
            .optimize = optimize,
            .root_source_file =  b.path("src/main.zig"),            
            
         
            
        });


        const test_step = b.step("test", "Run Tests");
        const os = target.result.os.tag;
        

        const tests = b.addTest(.{
            .root_source_file = b.path("src/main.zig"),
            .target = target,
            .optimize = optimize

        });

        const allegro5_tests = b.addTest(.{
            .root_source_file = b.path("src/allegro5.zig"),
            .target = target,
            .optimize = optimize
        });
        
        switch(os){
            .windows =>{
                //TODO Build tests for windows


            },

            .linux => {
                tests.linkLibC();
                // tests.linkSystemLibrary("allegro_main");
                // tests.linkSystemLibrary("allegro-5");
                // tests.linkSystemLibrary("allegro_primitives-5");
                // tests.linkSystemLibrary("allegro_font-5");
                // tests.linkSystemLibrary("allegro_ttf-5");
                // tests.linkSystemLibrary("allegro_dialog-5");
                // tests.linkSystemLibrary("allegro_image-5");


                allegro5_tests.linkLibC();
                allegro5_tests.linkSystemLibrary("allegro_main");
                allegro5_tests.linkSystemLibrary("allegro-5");
                allegro5_tests.linkSystemLibrary("allegro_primitives-5");
                allegro5_tests.linkSystemLibrary("allegro_font-5");
                allegro5_tests.linkSystemLibrary("allegro_ttf-5");
                allegro5_tests.linkSystemLibrary("allegro_dialog-5");
                allegro5_tests.linkSystemLibrary("allegro_image-5");


            },

            else => std.debug.print("Not Supported", .{})
        }

        const run_tests = b.addRunArtifact(tests);
        test_step.dependOn(&run_tests.step);

        const run_allegro_tests = b.addRunArtifact(allegro5_tests);
        test_step.dependOn(&run_allegro_tests.step);


        exe.linkLibC();
        //exe.linkLibCpp();
        exe.linkSystemLibrary("allegro_main");
        exe.linkSystemLibrary("allegro-5");
        exe.linkSystemLibrary("allegro_primitives-5");
        exe.linkSystemLibrary("allegro_font-5");
        exe.linkSystemLibrary("allegro_ttf-5");
        exe.linkSystemLibrary("allegro_dialog-5");
        exe.linkSystemLibrary("allegro_image-5");
        exe.linkSystemLibrary("allegro_audio-5");
        exe.linkSystemLibrary("allegro_acodec-5");
       


        b.installArtifact(exe);
}
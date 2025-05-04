const std = @import("std");

pub const Collider = struct {
    x: i32,
    y: i32,
    w: i32,
    h: i32,

    pub fn FromFloat(x: f32, y: f32, w: f32, h: f32) Collider {
        return .{
            .x = @as(i32, @intFromFloat(x + 0.5)),
            .y = @as(i32, @intFromFloat(y + 0.5)),
            .w = @as(i32, @intFromFloat(w)),
            .h = @as(i32, @intFromFloat(h)),
        };
    }

    pub fn CollidesWith(a:Collider, b:Collider) bool {
        return (
            a.x < b.x + b.w and
            a.x + a.w > b.x and
            a.y < b.y + b.h and
            a.y + a.h > b.y
        );
    }
};
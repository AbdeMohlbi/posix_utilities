const std = @import("std");
const expectEqual = std.testing.expectEqual;
const yesCommand = @import("commands/yes.zig");
const yes = yesCommand.yes;

const CommandFn = *const fn (std.process.Init, []const [:0]const u8) anyerror!void;
pub const Command = struct { version: *const [5:0]u8, help: []const u8, run: CommandFn };

pub const commands = std.StaticStringMap(Command).initComptime(.{yes});

comptime {
    for (commands.values()) |command| {
        if (command.version.len == 0) {
            @compileError("Command version cannot be empty");
        }

        if (command.help.len == 0) {
            @compileError("Command help cannot be empty");
        }
    }
}

test "commands" {
    try expectEqual(1, commands.values().len);
}

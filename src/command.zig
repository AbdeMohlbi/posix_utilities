const std = @import("std");
const expect = std.testing.expect;
const expectEqual = std.testing.expectEqual;
const yes = @import("commands/yes.zig");

const CommandFn = *const fn (std.process.Init, []const [:0]const u8) anyerror!void;
const Command = struct { version: *const [5:0]u8, help: []const u8, run: CommandFn };

pub const commands = std.StaticStringMap(Command).initComptime(.{
    .{
        "yes",
        // help was copied form https://linux.die.net/man/1/yes
        Command{ .version = "0.0.1", .help = "output a string repeatedly until killed", .run = yes.yesCommand },
    },
});

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

test "yesCommand" {
    const command = commands.get("yes") orelse return error.CommandNotFound;
    try expectEqual(Command{ .version = "0.0.1", .help = "output a string repeatedly until killed", .run = yes.yesCommand }, command);
}

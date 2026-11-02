const std = @import("std");
const expectEqual = std.testing.expectEqual;
const yesCommand = @import("commands/yes.zig");
const yes = yesCommand.yes;
const listCommand = @import("commands/list.zig");
const list = listCommand.list;

const CommandFn = *const fn (std.process.Init, []const [:0]const u8) anyerror!void;
pub const Command = struct { version: *const [5:0]u8, help: []const u8, run: CommandFn };

pub const commands = std.StaticStringMap(Command).initComptime(.{ yes, list });

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
    try expectEqual(2, commands.values().len);
}

test "yesCommand" {
    const command = commands.get("yes") orelse return error.CommandNotFound;
    try expectEqual(Command{ .version = "0.0.1", .help = "output a string repeatedly until killed", .run = yesCommand.yesCommand }, command);
}

test "listCommand" {
    const command = commands.get("list") orelse return error.CommandNotFound;
    try expectEqual(Command{ .version = "0.0.1", .help = "list all the avilable commands", .run = listCommand.listCommand }, command);
}

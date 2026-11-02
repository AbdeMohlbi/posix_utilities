const std = @import("std");
const mem = @import("std").mem;
const Command = @import("../command.zig").Command;
const expectEqual = std.testing.expectEqual;

pub const yes = .{
    "yes",
    // help was copied form https://linux.die.net/man/1/yes
    Command{ .version = "0.0.1", .help = "output a string repeatedly until killed", .run = yesCommand },
};

pub fn yesCommand(init: std.process.Init, args: []const [:0]const u8) !void {
    // meaning that it was invoked by ./bin yes
    if (args.len == 2) {
        while (true) {
            std.debug.print("y\n", .{});
        }
    }

    // if the first argument is --help
    if (std.mem.eql(u8, args[2], "--help")) {
        std.log.info("{s}\n", .{yes.@"1".help});
        return;
    }
    // if the first argument is --version
    if (std.mem.eql(u8, args[2], "--version")) {
        std.log.info("yes command version {s}\n", .{yes.@"1".version});
        return;
    }

    // the first argument is the executable name and should be ignored
    const argumentsInOneLine = mem.join(init.arena.allocator(), " ", args[1..]) catch "";

    while (true) {
        std.debug.print("{s}\n", .{argumentsInOneLine});
    }
}

test "yesCommand" {
    const command = Command.commands.get("yes") orelse return error.CommandNotFound;
    try expectEqual(Command{ .version = "0.0.1", .help = "output a string repeatedly until killed", .run = yesCommand.yesCommand }, command);
}

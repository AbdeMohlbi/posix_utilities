const std = @import("std");
const mem = @import("std").mem;

pub fn yesCommand(init: std.process.Init, args: []const [:0]const u8) !void {
    // the first argument is the executable name and should be ignored
    const argumentsInOneLine = mem.join(init.arena.allocator(), " ", args[1..]) catch "";

    while (true) {
        std.debug.print("{s}\n", .{argumentsInOneLine});
    }
}

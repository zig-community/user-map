const std = @import("std");

pub fn main() anyerror!void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    var source_files = try std.fs.cwd().openDir("people", .{ .iterate = true });
    defer source_files.close();

    var string_buffer = std.ArrayList(u8).init(gpa.allocator());
    defer string_buffer.deinit();

    var writer = string_buffer.writer();

    try writer.writeAll("[");

    var first = true;
    var iter = source_files.iterate();
    while (try iter.next()) |entry| {
        if (entry.kind != .File)
            return error.InvalidFile;

        var arena = std.heap.ArenaAllocator.init(gpa.allocator());
        defer arena.deinit();

        var contents = try source_files.readFileAlloc(arena.allocator(), entry.name, 1024);
        defer arena.allocator().free(contents);

        var parser = std.json.Parser.init(arena.allocator(), false);
        defer parser.deinit();

        var tree = try parser.parse(contents);
        defer tree.deinit();

        defer first = false;
        if (!first) {
            try writer.writeAll(",");
        }

        try tree.root.jsonStringify(.{}, writer);
    }
    try writer.writeAll("]");

    try std.fs.cwd().writeFile("website/users.json", string_buffer.items);
}

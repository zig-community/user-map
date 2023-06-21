const std = @import("std");

pub fn main() anyerror!void {
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();

    var source_files = try std.fs.cwd().openIterableDir("people", .{});
    defer source_files.close();

    var string_buffer = std.ArrayList(u8).init(gpa.allocator());
    defer string_buffer.deinit();

    var writer = string_buffer.writer();

    try writer.writeAll("[");

    var first = true;
    var iter = source_files.iterate();
    while (try iter.next()) |entry| {
        if (entry.kind != .file)
            return error.InvalidFile;

        errdefer |e| std.log.err("failed to parse {s}: {!}", .{ entry.name, e });

        var arena = std.heap.ArenaAllocator.init(gpa.allocator());
        defer arena.deinit();

        var contents = try source_files.dir.readFileAlloc(arena.allocator(), entry.name, 1024);
        defer arena.allocator().free(contents);

        var parsed = try std.json.parseFromSlice(std.json.Value, arena.allocator(), contents, .{});
        defer parsed.deinit();

        defer first = false;
        if (!first) {
            try writer.writeAll(",");
        }

        try parsed.value.jsonStringify(.{}, writer);
    }
    try writer.writeAll("]");

    try std.fs.cwd().writeFile("website/users.json", string_buffer.items);
}

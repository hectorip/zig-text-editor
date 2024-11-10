const std = @import("std");
const Editor = @import("editor.zig").Editor;

pub fn main() !void {
    // Inicializamos el allocator
    var gpa = std.heap.GeneralPurposeAllocator(.{}){};
    defer _ = gpa.deinit();
    const allocator = gpa.allocator();

    // Creamos una instancia del editor
    var editor = Editor.init(allocator);
    defer editor.deinit();

    // Cambiamos al modo inserción
    editor.switchMode(.insert);
    // Insertamos algunos caracteres
    try editor.insertChar('H');
    try editor.insertChar('o');
    try editor.insertChar('l');
    try editor.insertChar('a');

    // Imprimimos el contenido
    const stdout = std.io.getStdOut().writer();
    try stdout.print("Contenido: {s}\n", .{editor.getContent()});

    // Movemos el cursor y eliminamos caracteres
    editor.moveCursor(-1);
    editor.deleteChar();

    // Imprimimos el contenido actualizado
    try stdout.print("Contenido después de eliminar: {s}\n", .{editor.getContent()});
}

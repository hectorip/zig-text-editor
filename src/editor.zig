// Importamos la biblioteca estándar y definimos un alias para el Allocator
const std = @import("std");
const Allocator = std.mem.Allocator;

// Definimos la estructura principal del Editor
pub const Editor = struct {
    // Buffer que almacena el texto como una lista de caracteres
    buffer: std.ArrayList(u8),
    // Posición actual del cursor en el texto
    cursor_pos: usize,
    // Modo actual del editor (normal o inserción)
    mode: Mode,

    // Enumeración que define los modos disponibles del editor
    pub const Mode = enum {
        normal,  // Modo para navegar y comandos
        insert,  // Modo para insertar texto
    };

    // Inicializa una nueva instancia del editor
    pub fn init(allocator: Allocator) Editor {
        return .{
            .buffer = std.ArrayList(u8).init(allocator),
            .cursor_pos = 0,
            .mode = .normal,
        };
    }

    // Libera la memoria utilizada por el editor
    pub fn deinit(self: *Editor) void {
        self.buffer.deinit();
    }

    // Inserta un carácter en la posición actual del cursor
    // Solo funciona en modo inserción
    pub fn insertChar(self: *Editor, char: u8) !void {
        if (self.mode != .insert) return;
        try self.buffer.insert(self.cursor_pos, char);
        self.cursor_pos += 1;
    }

    // Elimina el carácter anterior a la posición del cursor
    pub fn deleteChar(self: *Editor) void {
        if (self.cursor_pos > 0) {
            _ = self.buffer.orderedRemove(self.cursor_pos - 1);
            self.cursor_pos -= 1;
        }
    }

    // Mueve el cursor una cantidad determinada de posiciones
    // El offset puede ser positivo (derecha) o negativo (izquierda)
    pub fn moveCursor(self: *Editor, offset: isize) void {
        const new_pos = @as(isize, @intCast(self.cursor_pos)) + offset;
        if (new_pos >= 0 and new_pos <= @as(isize, @intCast(self.buffer.items.len))) {
            self.cursor_pos = @intCast(new_pos);
        }
    }

    // Cambia entre los modos normal e inserción
    pub fn switchMode(self: *Editor, new_mode: Mode) void {
        self.mode = new_mode;
    }

    // Devuelve el contenido actual del buffer como una slice de bytes
    pub fn getContent(self: Editor) []const u8 {
        return self.buffer.items;
    }
};


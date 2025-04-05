import std.io;

// Formatter for u8 (8-bit unsigned integer)
fn format_u8(u8 value) {
    return std::format("{:d}, 0x{:X}", value, value);
};

// Formatter for u16 (16-bit unsigned integer)
fn format_u16(u16 value) {
    return std::format("{:d}, 0x{:X}", value, value);
};

// Formatter for u16 (16-bit unsigned integer)
fn format_u24(u24 value) {
    return std::format("{:d}, 0x{:X}", value, value);
};

// Formatter for u32 (32-bit unsigned integer)
fn format_u32(u32 value) {
    return std::format("{:d}, 0x{:X}", value, value);
};

// Formatter for u64 (64-bit unsigned integer)
fn format_u64(u64 value) {
    return std::format("{:d}, 0x{:X}", value, value);
};

// Formatter for u128 (128-bit unsigned integer)
fn format_u128(u128 value) {
    return std::format("{:d}, 0x{:X}", value, value);
};

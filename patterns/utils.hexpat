import std.io;
import std.math;


// Both decimal and hex

fn decimal_hex(auto value) {
    return std::format("{:d}, 0x{:X}", value, value);
};

// Only hex

fn hex(auto value){
    return std::format("0x{:X}", value);
};

// Cluster negative format

fn negative_size(auto val){
    if(val < 0x80) return std::format("{:d} clusters", val);
    
    s64 value = val;
    u64 bytes = std::math::pow(2, std::math::abs(value - 256));
    return std::format("{:d} bytes", bytes);
};

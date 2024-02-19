use errors;
use fmt;
use os;

export fn main() void = {
	fmt::printfln("Hostname: {}", os::hostname())!;
	fmt::printfln("Kernel: {} {}", os::sysname(), os::release())!;
	fmt::printfln("Architecture: {}", os::machine())!;
	let cpu_count = match (os::cpucount()) {
	case let cpu_count: size =>
		yield cpu_count;
	case errors::error =>
		fmt::fatalf("Error reading CPU count");
	};
	fmt::printfln("Cores: {}", cpu_count)!;
};

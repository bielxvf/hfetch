use bufio;
use errors;
use fmt;
use fs;
use io;
use os;
use strconv;
use strings;

export fn main() void = {

	// user@host
	let address: str = match (os::getenv("USER")) {
	case let username: str =>
		yield strings::concat(username, "@", os::hostname());
	case void =>
		fmt::fatalf("Error reading env variable 'USER'");
	};
	fmt::printfln(address)!;

	// Kernel version
	fmt::printfln("Kernel: {} {}", os::sysname(), os::release())!;

	// Uptime
	const proc_uptime: io::file = match (os::open("/proc/uptime")) {
	case let file: io::file =>
		yield file;
	case let error: fs::error =>
		fmt::fatalf("Error opening '/proc/uptime': {}", fs::strerror(error));
	};
	defer io::close(proc_uptime)!;

	let rdbuf: [os::BUFSZ]u8 = [0...];
	let proc_uptime = &bufio::init(proc_uptime, rdbuf, []);
	let buf: [1]u8 = [0];
	for (!(io::read(proc_uptime, buf)! is io::EOF)) void;

	let uptime_str: str = "";
	let i = 0z;
	for (i < len(rdbuf); i += 2) {
		uptime_str = strings::concat(uptime_str, strconv::u8tos(rdbuf[i]*10 + rdbuf[i+1]));
	};
	fmt::printfln("Uptime: {}", uptime_str)!;

	// x86_64, etc
	fmt::printfln("Architecture: {}", os::machine())!;

	// Cores
	let cpu_count = match (os::cpucount()) {
	case let cpu_count: size =>
		yield cpu_count;
	case errors::error =>
		fmt::fatalf("Error reading CPU count");
	};
	fmt::printfln("Cores: {}", cpu_count)!;
};

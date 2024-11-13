import 'dart:io';

const ACCESS_TOKEN_KEY = 'ACCESS_TOKEN';
const REFRESH_TOKEN_KEY = 'REFRESH_TOKEN';

// localhost 에뮬레이터 기준
final emulatorIp = 'https://www.dpubad.com';
// final emulatorIp = 'https://41a0-116-36-82-239.ngrok-free.app';
// localhost 시뮬레이터 기준
final simulatorIp = 'https://4532-116-36-82-239.ngrok-free.app';
// final simulatorIp = 'https://f400-116-36-82-239.ngrok-free.app';

final ip = Platform.isIOS ? simulatorIp : emulatorIp;


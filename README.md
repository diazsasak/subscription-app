# subscription_app

Simple flutter app that use json-server as mock API and GetX as bloc implementation.

Reference:
- https://github.com/jonataslaw/getx

## Getting Started

- Please clone the server and follow installation instruction at https://github.com/diazsasak/json-server
- install json-server globally "npm install -g json-server"
- Navigate to project directory and run the server with "json-server db.json --routes routes.json --watch db.json --host 0.0.0.0"
- Set server address to your local IP address at server_address.dart. If you're using android emulator you can use IP 10.0.2.2:3000
- Before build and run on iOS, please run "pod install" in ios/ directory

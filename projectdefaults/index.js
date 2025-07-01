const timestamp = () => `[${new Date().toISOString()}]`;

console.log(`${timestamp()} Info  | Server installed. You can now upload your files!`);
console.log(`${timestamp()} Info  | Waiting for files... The server will remain idle until it is properly configured.`);

process.stdin.resume();

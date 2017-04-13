const spawn = require('child_process').spawn;

function runTests() {
  var test = spawn('npm test', [], { shell: true, stdio: 'inherit' });

  if (test.stdout) {
    test.stdout.on('data', (data) => {
      console.log(`stdout: ${data}`);
    });
  }

  if (test.stderr) {
    test.stderr.on('data', (data) => {
      console.log(`stderr: ${data}`);
    });
  }

  test.on('close', (code) => {
    console.log(`tests complete with code ${code}`);
  });
}

module.exports = {
  runTests
}

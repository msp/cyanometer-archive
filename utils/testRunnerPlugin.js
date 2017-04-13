const runTests = require('./testRunner.js').runTests;

function TestRunnerPlugin() {};

TestRunnerPlugin.prototype.apply = function (compiler) {
    compiler.plugin("done", function() {
      runTests();
    });
}

module.exports = {
  TestRunnerPlugin
}

const watch = require('nodewatch');
const runTests = require('./testRunner.js').runTests;

watch
  .add('./src', true)
  .add('./tests/Main.elm')
  .add('./tests/Tests.elm')
  .add('./tests/StringUtilsTests.elm')
  .add('./tests/DateUtilsTests.elm')
  .add('./tests/ViewTests.elm')
  .add('./utils', true)
  .onChange(function(file, prev, curr, action) {
    console.log(file+' changed.. '+action);
    runTests();
  });

runTests();

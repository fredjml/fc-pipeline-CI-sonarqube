const { add } = require("./calculator");

function hello() {
  return `Hello CI with SonarQube: 2 + 3 = ${add(2, 3)}`;
}

/* istanbul ignore next */
if (require.main === module) {
  console.log(hello());
}

module.exports = {
  hello
};

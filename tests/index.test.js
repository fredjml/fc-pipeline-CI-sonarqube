const { hello } = require("../src");

describe("hello", () => {
  it("returns the application message", () => {
    expect(hello()).toBe("Hello CI with SonarQube: 2 + 3 = 5");
  });
});

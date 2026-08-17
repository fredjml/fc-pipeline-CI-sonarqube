const { add, subtract, multiply, divide } = require("../src/calculator");

describe("calculator", () => {
  it("adds two numbers", () => {
    expect(add(2, 3)).toBe(5);
  });

  it("subtracts two numbers", () => {
    expect(subtract(10, 4)).toBe(6);
  });

  it("multiplies two numbers", () => {
    expect(multiply(6, 7)).toBe(42);
  });

  it("divides two numbers", () => {
    expect(divide(20, 5)).toBe(4);
  });

  it("rejects division by zero", () => {
    expect(() => divide(20, 0)).toThrow("Division by zero is not allowed");
  });
});

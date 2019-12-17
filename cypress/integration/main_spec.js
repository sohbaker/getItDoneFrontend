describe("To Do List Application", () => {
    it("displays the home page", () => {
      cy.visit("/").contains("Welcome to To Do List");
    });
});

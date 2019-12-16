describe("To Do List Application", () => {
    it("displays the home page", () => {
      cy.visit("/").contains("Welcome to To Do List");
    });

    it ("allows a user to create a new TODO", () => {
        cy.visit("/");

        cy
            .get('input[name="todo"]')
            .type("drink water")
            .should("have.value", "drink water");

        cy.get("form").submit();
    });
});

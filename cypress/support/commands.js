Cypress.Commands.add('resetBackend', () => {
    cy.request({url: "http://localhost:8080/reset", method: "POST"});
});

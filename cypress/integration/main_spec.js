describe('To Do List Application', () => {
    beforeEach(() => {
        cy.request({url: "http://localhost:8080/reset", method: "POST"});
    });

    context('When the home page is first opened', () => {
        it('displays the welcome message', () => {
            cy.visit('/').contains('To Do List');
        });

        it('focuses on the input field for a new todo', () => {
            cy.visit('/');
            cy
                .get('.new-todo-item').focus()
                .should('have.class', 'new-todo-item')
        });
    });

    context('Fetching TODOs', () => {
        it ("displays current todo items", () => {
            cy.visit('/');

            cy.get('.todo-list').find('tr').should('have.length', 1)
        });
    });

    context('Creating TODOs', () => {
        it ("allows a user to create multiple TODOs", () => {
            cy.visit('/');

            cy
                .get('.new-todo-item')
                .type('sip cocktail')
                .should('have.value', 'sip cocktail');

            cy.get('button').click();

            cy.get('.todo-list td')
                .should('contain', 'sip cocktail');

            cy
                .get('.new-todo-item')
                .type('go for a walk')
                .should('have.value', 'go for a walk');

            cy.get('button').click();

            cy.get('.todo-list td')
                .should('contain', 'go for a walk')
        });
    });
});

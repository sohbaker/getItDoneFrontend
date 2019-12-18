describe('To Do List Application', () => {
    context('When the home page is first opened', () => {
        it('displays the welcome message', () => {
            cy.visit('/').contains('To Do List');
        });
    })

    context('Adding TODOs', () => {
        it ('allows a user to add a new TODO', () => {
            cy.visit('/')
            cy
                .get('.new-todo-item')
                .type('drink water')
                .should('have.value', 'drink water')

            cy.get('button').click()

            cy
                .get('.all-entries')
                .should('contain', 'drink water')
        });

       it ("allows a user to add multiple TODOs", () => {
            cy.visit('/')

            cy
                .get('.new-todo-item')
                .type('drink water')
                .should('have.value', 'drink water')

            cy.get('button').click()

            cy.get('.todo-list li')
                .eq(0)
                .find('label')
                .should('contain', 'drink water')

            cy
                .get('.new-todo-item')
                .type('go for a walk')
                .should('have.value', 'go for a walk')

            cy.get('button').click()

            cy.get('.todo-list li')
                .eq(1)
                .find('label')
                .should('contain', 'go for a walk')
       });
    })
});

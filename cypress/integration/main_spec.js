describe('My First Test', function() {
  it('Does not do much!', function() {
    expect(true).to.equal(true)
  })
})

  context("Visit the homepage", () => {
    it("displays the home page", () => {
      cy.visit("http://localhost:63271").contains("Welcome to To Do List");
    });
  });

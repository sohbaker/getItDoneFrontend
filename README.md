# To Do List 

## Getting Started
1. Assuming that you have [npm](https://www.npmjs.com/) - `npm install` to install dependencies
2. Start the server, using Parcel: `npm run dev`

    * Note: if the specified port is unavailable Parcel will automatically select a different one. Check the output to the terminal once the server is started and update the `"baseUrl"` in `cypress.json`.  
    * Note: to specify a port of your choosing, change `parcel public/index.html -p <port-number>` in `package.json` and update the `"baseUrl"` in `cypress.json`.  

3. Run the Cypress tests: `npm run cy:open`
___
## Objectives

A CRUD application which enables the following actions:
- [x] Create TODOs
- [x] Read/retrieve a list of all the stored TODOs
- [ ] Update a TODO
- [ ] Delete a TODO
- [ ] Filter TODOs by active or completed
- [ ] Bonus: Record the time they were created and completed
- [ ] Bonus: Save TODOs to `localStorage`

## Steps
- [x] As a User/Cypress I can interact with a front-end TDL application
- [x] As a User/Cypress I can interact with a TDL Application running via SpringBoot API
- [x] As a User/Cypress I can interact with a TDL Application running via SpringBoot API, accessing TODOs stored in an H2 database

### Tools
- [x] use [Elm](https://elm-lang.org/)
- [x] use [Cypress](https://www.cypress.io/) E2E testing framework
- [x] use [Parcel](https://parceljs.org/) web application bundler
- [x] use [Kotlin](https://kotlinlang.org/)
- [x] use [SpringBoot](https://spring.io/projects/spring-boot) API
- [x] use [Hibernate](https://hibernate.org/) ORM
    - [x]  use [H2](https://www.h2database.com/html/main.html) database

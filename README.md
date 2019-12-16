# To Do List 

## Objectives
A CRUD application which enables the following actions:
- Create TODOs 
- Read/retrieve a list of all the stored TODOs
- Update a TODO 
- Delete a TODO
- Filter TODOs by active or completed 
- Bonus: Record the time they were created and completed
- Bonus: Save TODOs to `localStorage` 

## Steps
- [ ] As a User/Cypress I can interact with a front-end TDL application
- [ ] As a User/Cypress I can interact with a TDL Application running via SpringBoot API 
- [ ] As a User/Cypress I can interact with a TDL Application running via SpringBoot API, accessing TODOs stored in an H2 database 

## Getting Started
1. Assuming that you have [npm](https://www.npmjs.com/) - `npm install` to install dependencies  
2. Start the server, using Parcel: 
```yarn dev```  
*Note: if the specified port is unavailable Parcel will automatically select a different one. Check the output to the terminal once the server is started and update the `"baseUrl"` in `cypress.json`.*  
*Note: to specify a port of your choosing, change `parcel public/index.html -p <port-number>` in `package.json` and update the `"baseUrl"` in `cypress.json`.*  
3. Run the Cypress tests: 
```npm run cy:open```
___
### Tools
- [x] use [Cypress](https://www.cypress.io/) E2E testing framework
- [x] use [Parcel](https://parceljs.org/) web application bundler
- [ ] use [Kotlin](https://kotlinlang.org/)
- [ ] use [SpringBoot](https://spring.io/projects/spring-boot) API
- [ ] use [Hibernate](https://hibernate.org/) ORM
    - [ ]  use [H2](https://www.h2database.com/html/main.html) database

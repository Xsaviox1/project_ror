# Survey API Application

## Overview
The Survey Application allows users to create and manage surveys, gathering valuable feedback on various topics. Key features include:
- **GraphQL API** for efficient data queries.
- **RSpec** for comprehensive testing.
- **PostgreSQL** for data persistence.

## Requirements
- **Dynamic Survey Creation**: Users can add, edit, and delete questions with multiple input types (radio buttons, checkboxes, text fields).
- **User Roles**:
  - **Survey Admins**: Define and conduct surveys.
  - **Survey Players**: Complete surveys without administrative access.

## Installation
1. Clone the repository:
   ```bash
   git clone https://github.com/Xsaviox1/project_ror.git
2. Navigate to the project directory:
   ```bash
   cd project_ror
3. Install dependencies:
   ```bash
   bundle install
4. Set up the database:
   ```bash
   rails db:create
   rails db:migrate
5. Start the server:
   ```bash
   rails s
  
## Database
Make sure that your database configuration in config/database.yml is correct. If you are using PostgreSQL, verify that the password for the database user is set correctly. An example database configuration might look like this:
```database
default: &default
  adapter: postgresql
  encoding: unicode
  user: your_username
  password: your_password
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>


development:
  <<: *default
  database: survey
  
test:
  <<: *default
  database: survey
```
If you want, you can also perform a simple data population to better understand how it works through the seed:
```bash
rails db:seed
```
## Usage
You can start using the application via localhost:
```link
http://localhost:3000/
```
Or Access the API endpoints through Postman. For GraphQL, visit:
```link
http://localhost:3000/graphiql
```
## Mutations and Queries
1. Fetch a Specific Survey
This query retrieves information for a specific survey based on its ID, including the questions and options for each question.
```graphql
{
  survey(id: 1) {
    title
    questions {
      id
      content
      questionType
      options {
        id
        content
      }
    }
  }
}
```

2. List All Surveys
This query returns a list of all surveys created in the system.
```graphql
{
  surveys {
    id
    title
    amtQuestions
    questions {
      id
      content
    }
  }
}

```

3. Create a New Survey
This mutation allows you to create a new survey, defining the title, number of questions and the body of the survey.
```graphql
mutation {
        createSurvey(input: {
          name: "Sávio12",
          title: "Survey Title",
          amtQuestions: 3,
          contents: [
            "What is your favorite color?",
            "What is your favorite food?",
            "What is your favorite hobby?"
          ],
          questionTypes: ["multiple", "unique", "short"],
          options: [["Red", "Blue", "Green", "Pink", "Gray"], ["Pizza", "Sushi"], []],
          amtOptions: [3, 2, 0]
        }) {
          user {
            name
          }
          survey {
            id
            title
            amtQuestions
          }
          questions {
            id
            content
            questionType
          }
          errors
        }
      }
```

4. Create a New User
This mutation allows the creation of a new user with a specified name, password, and role ("admin" or "player").
```graphql
mutation {
  createUser(input: { 
    name: "NewUser", 
    password: "password123", 
    role: "player" 
  }) {
    user {
      id
      name
      role
    }
    errors
  }
}

```

5. Login
This mutation logs in an existing user and returns a token, which can be used for authorization in further requests.
```graphql
mutation {
  login(input: { 
    name: "NewUser", 
    password: "password123" 
  }) {
    token
    errors
  }
}

```
When performing protected mutations (such as edit or delete), you will need to send the JWT token in the request header. Below is an example of how the header should be formatted:
```headers
{Authorization: Bearer <token>}
```
There are many other mutations, but I recommend checking them in the **test session**.

## Tests
The test suite covers all the major queries and mutations, providing a comprehensive understanding of how the application works. A total of 20 tests have been implemented to ensure the reliability and correctness of the system. Additionally, the project has been configured to work with SimpleCov, allowing for code coverage tracking to ensure that your tests cover as much of the codebase as possible.
You can run the tests with the following simple command:
```bash
rspec
```
After running the tests, SimpleCov generates a report in the coverage folder, helping identify untested areas of the code.

## Creator
José Sávio Gomes Nascimento

To learn more about me and my work, check out my portfolio: [josesavio.site](http://josesavio.site)

**Thanks for the challenge!**

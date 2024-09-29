user1 = User.create({
    name: "Sávio",
    role: "admin",
    password: "12345"
})

user2 = User.create({
    name: "Maria",
    role: "player",
    password: "abcde"
})


survey1 = Survey.create({
    user: user1, 
    titulo: "Pesquisa sobre Tecnologia",
    amt_questions: 2,
    status: "aberta"
})

survey2 = Survey.create({
    user: user2, 
    titulo: "Pesquisa sobre Música",
    amt_questions: 3,
    status: "fechada"
})


question1 = Question.create({
    survey: survey1,  
    content: "Qual sua linguagem de programação favorita?",
    question_type: "aberta"
})

question2 = Question.create({
    survey: survey1,  
    content: "Você prefere front-end ou back-end?",
    question_type: "escolha"
})

response1 = Response.create({
    user: user2,  
    content: "Eu gosto de Python"
})

response2 = Response.create({
    user: user2,   
    content: "Prefiro back-end"
})
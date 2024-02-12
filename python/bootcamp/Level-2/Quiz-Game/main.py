from question_model import Question, QuizBrain
from data import question_data

question_bank = []
for question in question_data:
    question_text = question['text']
    question_answer = question['answer']
    new_question = Question(question_text, question_answer)
    question_bank.append(new_question)

        
for question in question_bank:
    main_question = QuizBrain(question)
    print(main_question)
    
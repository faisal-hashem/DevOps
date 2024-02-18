from data import question_data
from question_model import Initialize_Question
from quiz_brain import QuizBrain

question_bank = []
for i in question_data:
    question = i["text"]
    answer = i["answer"]
    full_line = Initialize_Question(question, answer)
    question_bank.append(full_line)
    
quiz = QuizBrain(question_bank)

while quiz.check_question():
    quiz.next_question()
    
quiz.final_score()
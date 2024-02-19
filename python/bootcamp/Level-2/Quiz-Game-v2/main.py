from data import question_data
from question_model import QuestionList
from quiz_brain import QuizBrain


question_bank = []
for i in question_data:
    question = i['question']
    answer = i['correct_answer']
    difficulty = i['difficulty']
    category = i['category']
    full_question = QuestionList(question, answer, difficulty, category)
    question_bank.append(full_question)

quiz = QuizBrain(question_bank)

while quiz.check():
    quiz.next_question()

quiz.final_score()
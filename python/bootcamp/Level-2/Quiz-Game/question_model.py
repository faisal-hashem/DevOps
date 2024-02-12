class Question:
    def __init__(self, q_text, q_answer):
        self.text = q_text
        self.answer = q_answer 
        
class QuizBrain:
    def __init__(self, question_list):
        question_number = 0
        question_number += 1
        return f"Q.{question_number}: {question_list}. (True/False)"
        
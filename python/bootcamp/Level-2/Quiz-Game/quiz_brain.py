class QuizBrain:
    def __init__(self, question_list):
        question_number = 0
        for question in question_list:
            question_number += 1
            print(f"Q.{question_number}: {question_list}. (True/False)")

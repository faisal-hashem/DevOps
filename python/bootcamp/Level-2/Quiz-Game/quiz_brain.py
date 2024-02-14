class QuizBrain:
    def __init__(self, q_list):
        self.question_number = 0
        self.question_list = q_list

    def process_question(self):
        for question in self.question_list:
            self.question_number += 1
            print(f"Q{str(self.question_number)}: {
                  question.text} (True/False)")

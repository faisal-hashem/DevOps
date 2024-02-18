class QuizBrain:
    def __init__(self, q_list):
        self.question_number = 0
        self.correct_score = 0
        self.question_list = q_list
    
    def next_question(self):
        for question in self.question_list:
            self.question_number += 1
            response = input(f"Q{str(self.question_number)}. {question.text} (True/False): ")
            if response.lower() == question.answer.lower():
                print("You got it right!")
                self.correct_score += 1
            else:
                print("That's wrong.")
            print(f"The correct answer was {question.answer}")
            print(f"The current score is: {self.correct_score}/{self.question_number}")

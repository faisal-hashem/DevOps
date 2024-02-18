class QuizBrain:
    def __init__(self, question_list):
        self.list_of_questions = question_list
        self.question_number = 0
        self.score = 0
    
    def check_question(self):
        return self.question_number < len(self.list_of_questions)
        
    def next_question(self):
        for i in self.list_of_questions:
            self.question_number += 1
            ask = input(f'Q: {self.question_number} - {i.question}? (True/False): ')
            self.validate_question(ask.lower(), i.answer.lower())
    
    def validate_question(self, user_response, correct_answer):
        if user_response == correct_answer:
            self.score += 1
            print("You got it right.")
        else:
            print("You got it wrong.")
        print(f"The correct answer was: {correct_answer}")
        print(f"Your current score: {self.score}/{self.question_number}")

    def final_score(self):
        print(f"Final score: {self.score}/{self.question_number}")
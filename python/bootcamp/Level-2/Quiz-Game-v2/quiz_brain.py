class QuizBrain:
    def __init__(self, question_list):
        self.list_of_question = question_list
        self.question_number = 0
        self.score = 0
    
    def check(self):
        return self.question_number < len(self.list_of_question)
        
    def next_question(self):
        for i in self.list_of_question:
            self.question_number += 1
            response = input(f"Q.{self.question_number}: {i.question} \n Difficulty: {i.difficulty} \n Category: {i.category} \n (True/False): ")
            self.validate_question(response, i.answer)
            
    def validate_question(self, response, correct_answer):
        if response.lower() == correct_answer.lower():
            self.score += 1
            print("\n")
            print("You got it right.")
        else:
            print("You got it wrong.")
        print(f"Current Score: {self.score}/{self.question_number}")
        print(f"Correct Answer: {correct_answer}")
        print("\n")
    
    def final_score(self):
        print(f"Final Score: {self.score}/{self.question_number}")
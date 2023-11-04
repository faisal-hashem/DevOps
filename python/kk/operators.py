#and statements : false takes priority
#or statements : true takes priority

#bitwise operators :
# & is the bitwise AND operator and false takes priority
# | is the bitwise OR operator and true takes priority
# bitwise OR gives 1 if either of the bits are 1. and 0 if both of the bits are 0.
# bits are 2^0, 2^1, 2^2, 2^3, 2^4
# ^ is the bitwise XOR operator and false takes priority. true and false returns ture.
    # true and true returns false and false and false returns false
    
# negation: ~ is the bitwise NOT operator and true takes priority. false returns true and true returns false.
'''
#bit shifting: >> is the bitwise right shift operator
print(22 // 2) = print(22 >> 1)
print(22 // 4) = print(22 >> 2)
print(22 * 2 ) = print(22 << 1)
print(22 * 4 ) = print(22 << 2)

#1
a = 20
b = 5
print(a & b) 
00010100 = 20
00000101 = 5

answer: 
00000100 = 4

#2
print(5^11)

00000101 = 5
00001011 = 11
00001110 = 14

#3
a = 20
b = 5
print(a | b) 
00010100 = 20
00000101 = 5

answer: 
00010101 = 21

200 = 00000000
128 + 64 + 8 = 200

print(~200) 

'''
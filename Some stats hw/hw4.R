#hw 4 question 1
plot(vap,voters)
f1<-lm(voters~vap)
summary(f1)
f2<-lm(vap~voters)
summary(f2)
#question 2
plot(TurnoutRate,sequence)
f3<-lm(TurnoutRate~sequence)
summary(f3)
f4<-lm(sequence~TurnoutRate)
summary(f4)
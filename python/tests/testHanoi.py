m = 10;
class Hanoi:
    def Hanoi(self):
        self.moveTower(5,"A","B","C")

    def moveTower(self, height,fromPole, toPole, withPole):
        if height >= 1:
            self.moveTower(height - 1,fromPole,withPole,toPole)
            self.moveDisk(fromPole,toPole)
            self.moveTower(height - 1,withPole,toPole,fromPole)

    def moveDisk(self, fp,tp):
        print("moving disk from ",fp," to ",tp, "\n")

a = Hanoi()

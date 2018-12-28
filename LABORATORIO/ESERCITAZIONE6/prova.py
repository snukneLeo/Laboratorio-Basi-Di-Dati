#define method to write
def writesomething(string, file):
    f.write(string + "\n")

#define method to read
def readsomething(readfile):
    f = open(readfile,"r")
    allText = f.read()
    print(allText, sep=' ')


filename = input("Inserisci il nome del file: ")
f = open(filename,"a")
something = input("Inserisci il testo da scrivere: ")

filename = input("Inserisci il nome del file da leggere: ")
writesomething(something,filename)
f.close() #serve per chiudere e leggere le modifiche
readsomething(filename)

class Animal():
    def __init__(self,name):
        self.name = name

class Dog(Animal):
    def say(self):
        print("io sono: " + self.name)

d = Dog("pippo")
d.say()

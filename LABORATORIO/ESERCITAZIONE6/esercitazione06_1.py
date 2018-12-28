import csv
import re
pattern = re.compile("^\d{2,2}/\d{2,2}/\d{4,4}$")
def creaDict(data,voce,importo):
    if not isinstance(data,str) or not pattern.match(data):
        print("Date is not format dd/mm/aaaa")
        exit()
    return { "data":data , "voce":voce, "importo":float(importo) }

tabella = list()
tabella.append(creaDict("24/02/2016", "Stipendio", 0.1))
tabella.append(creaDict("24/02/2016", "stipendio Bis", 0.1))
tabella.append(creaDict("24/02/2016", "stipendio Tris", 0.1))
tabella.append(creaDict("27/02/2016", "Affitto", -0.3))

print("=" * 50)
print("| {:10s} | {:<20} | {:>10s} |".format("Data", "Voce", "Importo"))
print("-" * 50)
for riga in tabella:
    print("| {:10s} | {:<20} | {:>10.2f} |".format(riga["data"],riga["voce"], riga["importo"]))

print("=" * 50)

tot = 0.0
for riga in tabella:
    tot += riga["importo"]
print("Sum is: ".format(tot))


nomeFile = "tabellaSpesa.csv"
with open(nomeFile, mode = "w", encoding = "utf-8") as csvFile:
    nomiCampi = ["data","voce","importo"]
    writer = csv.DictWriter(csvFile, fieldnames = nomiCampi)
    writer.writeheader()
    for riga in tabella:
        writer.writerow(riga)

tab1 = list()
with open(nomeFile, mode = "r", encoding = "utf-8") as csvFile:
    reader = csv.DictReader(csvFile)
    for row in reader:
        tab1.append(creaDict(row["data"], row["voce"], row["importo"]))

tot1 = 0
for riga in tab1:
    tot1 += riga["importo"]

if tot == tot1:
    print("I due totali sono uguali!")
else:
    print("Ops... la tabella letta non ha gli stessi dati!")
if tot == 0:
    print("Eureka! :(")
else:
    print("Ops... il totale non è corretto perchè non è 0!")

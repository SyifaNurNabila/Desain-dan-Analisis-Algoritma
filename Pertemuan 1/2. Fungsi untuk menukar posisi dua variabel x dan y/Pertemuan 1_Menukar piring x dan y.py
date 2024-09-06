def tukar_buah(piring1, piring2):
    piring3 = piring1
    piring1 = piring2
    piring2 = piring3
    return piring1, piring2

piring1 = "manggis"
piring2 = "pisang"
piring1, piring2 = tukar_buah(piring1, piring2)

print(f"Piring 1: {piring1}")
print(f"Piring 2: {piring2}")
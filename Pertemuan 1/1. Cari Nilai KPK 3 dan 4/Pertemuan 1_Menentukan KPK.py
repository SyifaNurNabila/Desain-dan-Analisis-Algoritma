def KPK(x, y):
    KPK = max(x, y)
    while True:
        if KPK % x == 0 and KPK % y == 0:
            return KPK
        KPK += max(x, y)
x = 3
y = 4
hasil_KPK = KPK(x, y)
print("KPK dari", x, "dan", y, "adalah", hasil_KPK)
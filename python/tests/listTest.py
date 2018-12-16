a = [[1, 2], [3, 4, 5, [6, 7]]]
i = 0
for element in a:
    i += 1
    if i == 1:
        for j in element:
            print(j)
    if i == 2:
        k = 0
        for l in element:
            k += 1
            if k == 4:
                print("6, 7")
            else:
                print(l)